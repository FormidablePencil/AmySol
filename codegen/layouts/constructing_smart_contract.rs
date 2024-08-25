use std::{fs::File, io::{Result, Write}};

use crate::utils::merge_and_get_unique_data;

use super::smart_contract_building_blocks::{gen_domain_abstract_fns, GenFnData, TypeOfContract};

pub fn gen_code_and_write_to_files(
    contract_name: &str,
    inharet_modules: Option<Vec<&str>>,
    imports: Option<Vec<&str>>,
    gen_fns_data: Vec<GenFnData>,
) -> Result<()> {
    let (abstract_smart_contract, domain_smart_contract) = abstract_and_domain_smart_contracts_gen(
        contract_name,
        if inharet_modules.is_some() {inharet_modules.unwrap()} else {vec![]},
        if imports.is_some() {imports.unwrap()} else {vec![]},
        gen_fns_data,
    );
    let mut res = write_smart_contract(contract_name, TypeOfContract::Abstract, &abstract_smart_contract);
    res = write_smart_contract(contract_name, TypeOfContract::Domain, &domain_smart_contract);
    res
}

pub fn write_smart_contract(name: &str, type_of_contract: TypeOfContract, contents: &str) -> Result<()> {
    let mut file = File::create(get_file_path(name, type_of_contract))?;
    file.write_all(contents.as_bytes())
}

pub fn get_file_path(name: &str, type_of_contract: TypeOfContract) -> String {
    match type_of_contract {
        TypeOfContract::Abstract => format!("C:/Users/formi/Documents/code/amvySol/contracts/abstracts/I{name}.sol"),
        TypeOfContract::Domain => format!("C:/Users/formi/Documents/code/amvySol//contracts/domains/{name}Domain.sol"),
        // TypeOfContract::Manager => todo!(),
        // TypeOfContract::Repository => todo!(),
    }
}

pub fn abstract_and_domain_smart_contracts_gen(
    contract_name: &str,
    inharet_modules: Vec<&str>,
    imports: Vec<&str>,
    gen_fns_data: Vec<GenFnData>,
) -> (String, String) {
    // #region Generate body for both abstract and domain smart contracts
    let mut domain_body_code = String::from("");
    let mut abstract_body_code = String::from("");

    for gen_fn_data in gen_fns_data {
        let (domain_funcs, abstract_func) = &gen_domain_abstract_fns(
                gen_fn_data.name,
                gen_fn_data.args,
                gen_fn_data.code,
                if gen_fn_data.modifiers.is_some() { gen_fn_data.modifiers.unwrap() } else {vec![]},
                gen_fn_data.return_args,
        );
        domain_body_code += domain_funcs;
        abstract_body_code += abstract_func;
    }
    // #endregion

    let amv_abstract = gen_smart_contract_layout(
&format!("I{contract_name}"),
        None,
        None,
        &abstract_body_code,
        TypeOfContract::Abstract
    );

    let amv_domain = gen_smart_contract_layout(
        &format!("{contract_name}Domain"),
        Some(merge_and_get_unique_data(&inharet_modules, vec![&format!("I{contract_name}"), "DebuggingUtils"])),
        Some(merge_and_get_unique_data(&imports, vec![&format!("../managers/{contract_name}Manager.sol")])),
        &domain_body_code, 
        TypeOfContract::Domain
    );

    (amv_abstract, amv_domain)
}

pub fn gen_smart_contract_layout(
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
// This generate code comes from /codegen/codegen.rs
// =============================================================================

{concocted_imports}
{if_abstract}contract {contract_name} {concocted_inharet} {{
    {contract_code}
}}")
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

fn if_abstract(type_of_contract: TypeOfContract) -> String {

    match type_of_contract {
        TypeOfContract::Abstract => {
            String::from("abstract ")
        }
        _ => String::from("")
    }
}