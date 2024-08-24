use core::fmt;
use std::fs::File;
use std::{collections::HashSet, fmt::Debug, hash::Hash};
use std::io::{Result, Write};

pub fn gen_code_and_write_to_files(
    contract_name: &str,
    inharet_modules: Option<Vec<&str>>,
    imports: Option<Vec<&str>>,
    gen_fns_data: Vec<GenFnData>,
) -> Result<()> {
    let (abstract_smart_contract, domain_smart_contract) = abstract_domain_gen(
        contract_name,
        if inharet_modules.is_some() {inharet_modules.unwrap()} else {vec![]},
        if imports.is_some() {imports.unwrap()} else {vec![]},
        gen_fns_data,
    );
    let mut res = write_file(contract_name, TypeOfContract::Abstract, &abstract_smart_contract);
    res = write_file(contract_name, TypeOfContract::Domain, &domain_smart_contract);
    res
}

pub fn write_file(name: &str, type_of_contract: TypeOfContract, contents: &str) -> Result<()> {
    let mut file = File::create(get_file_path(name, type_of_contract))?;
    file.write_all(contents.as_bytes())
}

pub fn get_file_path(name: &str, type_of_contract: TypeOfContract) -> String {
    match type_of_contract {
        TypeOfContract::Abstract => format!("C:/Users/formi/Documents/code/amvySol/contracts/abstracts/I{name}.sol"),
        TypeOfContract::Domain => format!("C:/Users/formi/Documents/code/amvySol//contracts/domains/{name}Domain.sol"),
        TypeOfContract::Manager => todo!(),
        TypeOfContract::Repository => todo!(),
    }
}

fn inharet(modules: Option<Vec<&str>>) -> String {
    let mut first_iteration = true;
    let mut modules_paths = String::new();
    match modules {
        Some(modules) => {
            for module in modules.iter() { if first_iteration {
                    modules_paths += &format!("is {}", module);
                    first_iteration = false;
                } else {
                    modules_paths += &format!(", {}", module);
                }

            }
            modules_paths
        },
        None => String::from(""),
    }
}

fn concoct_imports(items: Option<Vec<&str>>) -> String {
    match items {
        Some(items) => {
            let mut imports = String::new();
            for item in items.iter() {
                imports += &format!("import '{}';
                ", item);
            }
            imports
        }
        None => String::from(""),
    }
}

pub enum TypeOfContract {
    Domain, Manager, Repository, Abstract
}

fn if_abstract(type_of_contract: TypeOfContract) -> String {
    match type_of_contract {
        TypeOfContract::Abstract => {
            String::from("abstract ")
        }
        _ => String::from("")
    }
}

pub fn smart_contract(
    contract_name: &str,
    inharet_modules: Option<Vec<&str>>,
    imports: Option<Vec<&str>>,
    contract_code: &str,
    type_of_contract: TypeOfContract,
) -> String {
    let concocted_imports = concoct_imports(imports);
    let concocted_inharet = inharet(inharet_modules);
    let if_abstract = if_abstract(type_of_contract);
    format!("
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// =============================================================================
// This is a generated file by /codegen. Don't make edits to this file directly.
// This code generated comes from /codegen/codegen.rs
// =============================================================================

{concocted_imports}
{if_abstract}contract {contract_name} {concocted_inharet} {{
    {contract_code}
}}")
}

#[derive(Debug, PartialEq, Clone, Eq, Hash)]
pub enum Modifiers {
    Public,
    Private,
    Internal,
    External,
    View,
    Override,
    SetSender,
    WithDebug
}

fn gen_modifiers(modifiers: &Vec<Modifiers>) -> (String, String) {
    let mut is_with_debug = true;
    let mut mods = String::new();
    let mut debug_args = String::new();

    for modifier in modifiers.iter() {
        match modifier {
            Modifiers::Public |
            Modifiers::Private |
            Modifiers::Internal |
            Modifiers::External |
            Modifiers::Override |
            Modifiers::View => {
                // TODO: lowercase modifier
                mods += &format!(" {:?}", modifier);
            }
            Modifiers::SetSender => {
                mods += &format!(" setSender()");
            }
            Modifiers::WithDebug => {
                is_with_debug = true;
            },
        }
    }
    if is_with_debug {
        // will always make withDebug last modifier
        mods += &format!(" withDebug(_debugging, _debugAddress)");
        debug_args = format!(", bool _debugging, address _debugAddress");
    }
    (mods, debug_args)
}

fn fn_body_gen(code: &str, generated_args: &String) -> String {
    format!("return {code}({generated_args})")
}

fn gen_return(return_args_opt: &Option<Vec<GenFnDataArgs>>) -> String {
    match return_args_opt {
        Some(return_args) => {
            let mut args = String::new();
            let mut first_iteration = true;
            for arg in return_args.iter() {
                if first_iteration {
                    args += &format!("{} {}", arg.data_type, arg.name);
                    first_iteration = false;
                } else {
                    args += &format!(", {} {}", arg.data_type, arg.name);
                }
            }
            format!("returns ({args})")
        }
        None => String::from("")
    }
}

// TODO: Remove
// impl std::fmt::Display for StorageType {
//     fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
//        write!(fmt, "My name is {} and I'm {} years old.", self, self)
//     }
// }

fn gen_args(args_opt: &Option<Vec<GenFnDataArgs>>, receiving: bool) -> String {
    let mut string_of_args = String::new();
    let mut first_iteration = true;
    match args_opt {
        Some(args) => {
        for arg in args.iter() {
            let GenFnDataArgs { data_type, storage_type, name } = arg;
            let storage_type = match storage_type {
                StorageType::None => "",
                _ => &format!("{:?} ", storage_type) 
            };
            if receiving {
                if first_iteration {
                    string_of_args += &format!("{:} {:?}{:}", data_type, storage_type, name);
                    first_iteration = false;
                } else {
                    string_of_args += name;
                }
            } else {
                if first_iteration {
                    string_of_args += &format!(", {:} {:?}{:}", data_type, storage_type, name);
                    first_iteration = false;
                } else {
                    string_of_args += &format!(", {name}");
                }
            }
        }
        string_of_args
        }
        None => String::from("")
    }
}

// TODO: Remove
// impl std::fmt::Display for StorageType {
//     fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
//        write!(fmt, "My name is {} and I'm {} years old.", self, self)
//     }
// }

impl std::fmt::Display for DataType {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        // TODO: Test this first
        write!(fmt, "My name is {:?} and I'm {:?} years old.", self, self)
    }
}

#[derive(Debug)]
pub enum DataType {
    None, String, Uint, Bool, AuthorizedAddressArray, IPFSHashArray, Address, AddressArray, ContentAccessLvl
}

trait Trait {
    fn get(&self) -> String;
}
impl Trait for DataType {
    fn get(&self) -> String {
        match *self {
            // TODO: Lowercase
            DataType::String |
            DataType::ContentAccessLvl |
            DataType::Bool |
            DataType::Address |
            DataType::Uint => format!("{:?}", self),
            // TODO: Find "Array" If ends with array then replace "Array" with []
            DataType::IPFSHashArray => "IPFSHash[]".to_string(),
            DataType::AddressArray => "AddressHash[]".to_string(),
            DataType::AuthorizedAddressArray => "AuthoirzedAdress[]".to_string(),
            DataType::None => "".to_string(),
        }
    }
}

#[derive(Debug)]
pub enum StorageType {
    Memory, None
}

pub struct GenFnDataArgs {
    pub data_type: DataType,
    pub storage_type: StorageType,
    pub name: String,
}

pub trait GenFnDataArgsTrait {
    fn default(data_type: DataType, storage_type: StorageType, name: &str) -> GenFnDataArgs;
    fn storage_type_and_name(storage_type: StorageType, name: &str) -> GenFnDataArgs;
    fn data_type_and_storage_type(data_type: DataType, storage_type: StorageType) -> GenFnDataArgs;
    fn data_type_and_name(data_type: DataType, name: &str) -> GenFnDataArgs;
    fn data_type(data_type: DataType) -> GenFnDataArgs;
}

impl GenFnDataArgsTrait for GenFnDataArgs {
    fn default(data_type: DataType, storage_type: StorageType, name: &str) -> GenFnDataArgs {
        GenFnDataArgs { storage_type, data_type, name: name.to_string() }
    }
    fn storage_type_and_name(storage_type: StorageType, name: &str) -> GenFnDataArgs {
        GenFnDataArgs { data_type: DataType::None, storage_type, name: name.to_string() }
    }
    fn data_type_and_storage_type(data_type: DataType, storage_type: StorageType) -> GenFnDataArgs {
        GenFnDataArgs { data_type, storage_type, name: "".to_string() }
    }
    fn data_type_and_name(data_type: DataType, name: &str) -> GenFnDataArgs {
        GenFnDataArgs { data_type, storage_type: StorageType::None, name: name.to_string() }
    }
    fn data_type(data_type: DataType) -> GenFnDataArgs {
        GenFnDataArgs { data_type, storage_type: StorageType::None, name: "".to_string() }
    }
}

pub struct GenFnData<'a> {
    pub name: &'a str,
    pub args: Option<Vec<GenFnDataArgs>>,
    pub modifiers: Option<Vec<Modifiers>>,
    pub code: &'a str,
    pub return_args: Option<Vec<GenFnDataArgs>>,
}
// TODO: Automated testing for domains

pub fn abstract_domain_gen(
    contract_name: &str,
    inharet_modules: Vec<&str>,
    imports: Vec<&str>,
    gen_fns_data: Vec<GenFnData>,
) -> (String, String) {
    // #region Generate body for both abstract and domain smart contracts
    let mut domain_body_code = String::from("");
    let mut abstract_body_code = String::from("");

    for gen_fn_data in gen_fns_data {
        let (domain_funcs, abstract_func) = &domain_abstract_fn_gen(
                gen_fn_data.name,
                gen_fn_data.args,
                gen_fn_data.code,
                if gen_fn_data.modifiers.is_some() {gen_fn_data.modifiers.unwrap()} else {vec![]},
                gen_fn_data.return_args,
        );
        domain_body_code += domain_funcs;
        abstract_body_code += abstract_func;
    }
    // #endregion

    let amv_abstract = smart_contract(
&format!("I{contract_name}"),
        None,
        None,
        &abstract_body_code,
        TypeOfContract::Abstract
    );

    let amv_domain = smart_contract(
        &format!("{contract_name}Domain"),
        Some(merge_and_get_unique_data(&inharet_modules, vec![&format!("I{contract_name}"), "DebuggingUtils"])),
        Some(merge_and_get_unique_data(&imports, vec![&format!("../managers/{contract_name}Manager.sol")])),
        &domain_body_code, 
        TypeOfContract::Domain
    );

    (amv_abstract, amv_domain)
}

pub fn domain_abstract_fn_gen(
    name: &str,
    args: Option<Vec<GenFnDataArgs>>,
    code: &str,
    modifiers: Vec<Modifiers>,
    return_args: Option<Vec<GenFnDataArgs>>
) -> (String, String) {
    (
        domain_funcs_gen(
            name,
            &args,
            &modifiers,
            code,
            &return_args
        ),
        abstract_func_gen(
            name, &args, &modifiers, &return_args
        )
    )
}

pub fn abstract_func_gen(
    name: &str,
    args: &Option<Vec<GenFnDataArgs>>,
    modifiers: &Vec<Modifiers>,
    return_args: &Option<Vec<GenFnDataArgs>>
) -> String {
    let generated_args = gen_args(args, true);
    let (mods, debug_args) = gen_modifiers(modifiers);
    let return_args = gen_return(&return_args);
    format!("
    function {name}(
    {generated_args}{debug_args}
    ) {mods} {return_args};
    ")
}

fn merge_and_get_unique_data<T: std::clone::Clone + Eq + Hash>(new_modifiers: &Vec<T>, default_modifiers: Vec<T>) -> Vec<T> {
    let mut default_set: HashSet<T> = default_modifiers.iter().cloned().collect();
    let new_set: HashSet<T> = new_modifiers.iter().cloned().map(|v| v).collect();
    default_set.extend(new_set);
    default_set.into_iter().collect()
}

pub fn domain_funcs_gen(
    name: &str,
    args: &Option<Vec<GenFnDataArgs>>,
    modifiers: &Vec<Modifiers>,
    code: &str,
    return_args: &Option<Vec<GenFnDataArgs>>
) -> String {
    let mut reg_and_debug_funcs = function_gen(
        name, &args,
        Some(merge_and_get_unique_data(&modifiers, vec![Modifiers::Public, Modifiers::Override])),
        // &vec![vec![Modifiers::Public, Modifiers::Override], modifiers_opt].concat(),
         code, &return_args
    );

    reg_and_debug_funcs += "
    ";

    reg_and_debug_funcs += &function_gen(
        name, &args,
        Some(merge_and_get_unique_data(&modifiers, vec![Modifiers::Public, Modifiers::WithDebug])),
        code, &return_args
    );
    reg_and_debug_funcs
}

pub fn function_gen(
    name: &str,
    args: &Option<Vec<GenFnDataArgs>>,
    modifiers: Option<Vec<Modifiers>>,
    code: &str,
    return_args: &Option<Vec<GenFnDataArgs>>
) -> String {
    let generated_receiving_args = gen_args(&args, true);
    let generated_inputing_args = gen_args(&args, false);
    let (mods, debug_args) = gen_modifiers(&modifiers.unwrap());
    let generated_code = fn_body_gen(code, &generated_inputing_args);
    let return_args = gen_return(return_args);
    if args.as_ref().map_or(false, |a| a.len() > 2) {
        format!("
        function {name}(
        {generated_receiving_args}{debug_args}
        ) {mods} {return_args} {{
            {generated_code}
        }}
        ")
    } else {
        format!("
        function {name}({generated_receiving_args}{debug_args}) {mods} {return_args} {{
            {generated_code}
        }}
        ")
    }
}