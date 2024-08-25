use core::fmt;
use std::{fmt::Debug, hash::Hash};

use crate::utils::{self, merge_and_get_unique_data};

pub enum TypeOfContract {
    Domain, Abstract
    // Manager, Repository,
}

#[derive(Debug, PartialEq, Clone, Eq, Hash)]
pub enum Modifier {
    Public,
    // Private,
    // Internal,
    // External,
    // View,
    SetSender,
    Override,
    WithDebug
}

#[derive(Debug)]
pub enum DataType {
    None, String, Uint, Bool, AuthorizedAddressArray, IPFSHashArray, Address, AddressArray, ContentAccessLvl
}

#[derive(Debug)]
pub enum StorageType {
    Memory, None
}

// todo: do we need this?
trait StorageTypeTrait {
}

#[derive(Debug)]
pub struct GenFnArgs {
    pub data_type: DataType,
    pub storage_type: StorageType,
    pub name: String,
}

pub struct GenFnData<'a> {
    pub name: &'a str,
    pub args: Option<Vec<GenFnArgs>>,
    pub modifiers: Option<Vec<Modifier>>,
    pub code: &'a str,
    pub return_args: Option<Vec<GenFnArgs>>,
}
// TODO: Automated testing for domains

// pub trait GetFnDataArgsTrait {
//     fn data_type(&self) -> &mut String;
//     fn get_data_type(data: &GenFnArgs) -> String;
//     fn get_everything(&self) -> (String, String, String);
// }

pub trait GenFnDataArgsTrait {
    fn default(data_type: DataType, storage_type: StorageType, name: &str) -> GenFnArgs;
    fn storage_type_and_name(storage_type: StorageType, name: &str) -> GenFnArgs;
    fn data_type_and_storage_type(data_type: DataType, storage_type: StorageType) -> GenFnArgs;
    fn data_type_and_name(data_type: DataType, name: &str) -> GenFnArgs;
    fn data_type(data_type: DataType) -> GenFnArgs;
}

impl GenFnDataArgsTrait for GenFnArgs {
    fn default(data_type: DataType, storage_type: StorageType, name: &str) -> GenFnArgs {
        GenFnArgs { storage_type, data_type, name: name.to_string() }
    }
    fn storage_type_and_name(storage_type: StorageType, name: &str) -> GenFnArgs {
        GenFnArgs { data_type: DataType::None, storage_type, name: name.to_string() }
    }
    fn data_type_and_storage_type(data_type: DataType, storage_type: StorageType) -> GenFnArgs {
        GenFnArgs { data_type, storage_type, name: "".to_string() }
    }
    fn data_type_and_name(data_type: DataType, name: &str) -> GenFnArgs {
        GenFnArgs { data_type, storage_type: StorageType::None, name: name.to_string() }
    }
    fn data_type(data_type: DataType) -> GenFnArgs {
        GenFnArgs { data_type, storage_type: StorageType::None, name: "".to_string() }
    }
}

impl std::fmt::Display for DataType {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        // TODO: Probably don't need to lowercase with DataType since case sensitivity may need to be preserved
        write!(fmt, "{:?}", utils::lowercase_first_letter_of_enum(self))
    }
}

impl std::fmt::Display for StorageType {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        write!(fmt, "{:?}", utils::lowercase_first_letter_of_enum(self))
    }
}

impl std::fmt::Display for Modifier {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        write!(fmt, "{:?}", utils::lowercase_first_letter_of_enum(self))
    }
}

impl StorageType {
    fn trim(&self) -> String {
        utils::trim(&mut self.to_string()).to_owned()
    }
}

impl Modifier {
    fn trim(&mut self) -> String {
        utils::lowercase_first_letter_of_enum(utils::trim(&mut self.to_string())).to_owned()
    }
}

impl GenFnArgs {
    fn trim(input: &mut String) -> &mut String {
        utils::trim(input)
    }

    fn data_type(&self) -> String {
        match self.data_type {
            // TODO: Lowercase
            DataType::String |
            DataType::ContentAccessLvl |
            DataType::Bool |
            DataType::Address |
            DataType::Uint => format!("{:?}", Self::trim(&mut utils::lowercase_first_letter_of_enum(&self.data_type))),
            // TODO: Find "Array" If ends with array then replace "Array" with []
            DataType::AddressArray |
            DataType::AuthorizedAddressArray |
            DataType::IPFSHashArray => {
                // covnert everything that ends with Array with [] for instance IPFSHashArray -> IPFSHash[]
                let data_type_unformatted = &mut self.data_type.to_string();
                let data_type_formatted = Self::trim(data_type_unformatted);
                format!("{}[]", utils::trim_off_last_4_chars(data_type_formatted))
            }
            DataType::None => "".to_string(),
        }
    }

    fn storage_type(&self) -> String {
        utils::lowercase_first_letter_of_enum(Self::trim(&mut self.storage_type.to_string()))
    }

    fn formated(&self) -> (String, String, String) {
        (
            self.data_type(),
            self.storage_type(),
            self.name.to_owned(),
        )
    }
}

fn gen_modifiers(modifiers: &Vec<Modifier>) -> (String, String) {
    let mut is_with_debug = true;
    let mut mods = String::new();
    let mut debug_args = String::new();

    for modifier in modifiers.into_iter() {
        let mut first_iteration = true;

        match modifier {
            // Modifiers::Private |
            // Modifiers::Internal |
            // Modifiers::External |
            // Modifiers::View |
            Modifier::Public |
            Modifier::Override => {
                if first_iteration {
                    mods += " ";
                    first_iteration = false;
                }
                mods += &format!("{}", modifier.clone().trim());
            }
            Modifier::SetSender => {
                mods += &format!(" {}()", modifier.clone().trim());
            }
            Modifier::WithDebug => {
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

fn gen_fn_body(code: &str, generated_args: &String) -> String {
    format!("return {code}({generated_args})")
}

fn gen_return(return_args_opt: &Option<Vec<GenFnArgs>>) -> String {
    match return_args_opt {
        Some(return_args) => {
            let mut args = String::new();
            let mut first_iteration = true;
            for arg in return_args.iter() {
                if first_iteration {
                    args += &format!(" {} {}", arg.data_type(), arg.name);
                    first_iteration = false;
                } else {
                    args += &format!(", {} {}", arg.data_type(), arg.name);
                }
            }
            format!(" returns ({})", args)
        }
        None => String::from("")
    }
}

fn gen_args(args_opt: &Option<Vec<GenFnArgs>>, receiving: bool) -> String {
    let mut string_of_args = String::new();
    let mut first_iteration = true;
    match args_opt {
        Some(args) => {
        for arg in args.iter() {
            let (data_type, storage_type, name) = arg.formated();
            let storage_type = match arg.storage_type {
                StorageType::None => "",
                _ => &format!("{:?}",storage_type) 
            };
            if receiving {
                if first_iteration {
                    // string_of_args += name;
                    string_of_args += &format!("{:} {:?} {:}", data_type, storage_type, name);
                    first_iteration = false;
                } else {
                    string_of_args += &format!("{:} {:?} {:}", data_type, storage_type, name);
                }
            } else {
                if first_iteration {
                    string_of_args += &format!(", {:} {:?} {:}", data_type, storage_type, name);
                    first_iteration = false;
                } else {
                    string_of_args += &format!(", {:} {:?} {:}", data_type, storage_type, name);
                }
            }
        }
        string_of_args
        }
        None => String::from("")
    }
}

pub fn gen_domain_abstract_fns(
    name: &str,
    args: Option<Vec<GenFnArgs>>,
    code: &str,
    modifiers: Vec<Modifier>,
    return_args: Option<Vec<GenFnArgs>>
) -> (String, String) {
    (
        gen_domain_funcs(
            name,
            &args,
            &modifiers,
            code,
            &return_args
        ),
        gen_abstract_func(
            name, &args, &modifiers, &return_args
        )
    )
}

pub fn gen_abstract_func(
    name: &str,
    args: &Option<Vec<GenFnArgs>>,
    modifiers: &Vec<Modifier>,
    return_args: &Option<Vec<GenFnArgs>>
) -> String {
    let generated_args = gen_args(args, true);
    let (mods, debug_args) = gen_modifiers(modifiers);
    let return_args = gen_return(&return_args);
    format!("
    function {name}(
    {generated_args}{debug_args}
    ){mods}{return_args};
    ")
}

pub fn gen_domain_funcs(
    name: &str,
    args: &Option<Vec<GenFnArgs>>,
    modifiers: &Vec<Modifier>,
    code: &str,
    return_args: &Option<Vec<GenFnArgs>>
) -> String {
    let mut reg_and_debug_funcs = function_gen(
        name, &args,
        Some(merge_and_get_unique_data(&modifiers, vec![Modifier::Public, Modifier::Override])),
         code, &return_args
    );

    reg_and_debug_funcs += "
";

    reg_and_debug_funcs += &function_gen(
        name, &args,
        Some(merge_and_get_unique_data(&modifiers, vec![Modifier::Public, Modifier::WithDebug])),
        code, &return_args
    );
    reg_and_debug_funcs
}

pub fn function_gen(
    name: &str,
    args: &Option<Vec<GenFnArgs>>,
    modifiers: Option<Vec<Modifier>>,
    code: &str,
    return_args: &Option<Vec<GenFnArgs>>
) -> String {
    let generated_receiving_args = gen_args(&args, true);
    let generated_inputing_args = gen_args(&args, false);
    let (mods, debug_args) = gen_modifiers(&modifiers.unwrap());
    let generated_code = gen_fn_body(code, &generated_inputing_args);
    let return_args = gen_return(return_args);
    if args.as_ref().map_or(false, |a| a.len() > 2) {
        format!("function {name}(
        {generated_receiving_args}{debug_args}
        ) {mods} {return_args} {{
            {generated_code}
        }}")
    } else {
        format!("function {name}({generated_receiving_args}{debug_args}) {mods} {return_args} {{
            {generated_code}
        }}")
    }
}