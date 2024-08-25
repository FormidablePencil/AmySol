use std::{fmt::{self, Debug}, hash::Hash};

use crate::{generated_code::generated_rs_code::DataType, utils::{self, merge_and_get_unique_data}};
// #[allow(unused_variables)]

#[derive(PartialEq)]
pub enum TypeOfContract {
    Domain, Abstract
    // Manager, Repository,
}

#[derive(Debug, PartialEq, Clone, Eq, Hash)]
pub enum Modifier {
    Public,
    Virtual,
    Pure,
    View,
    Payable,
    Default,
    Nonpayable,
    Internal,
    External,
    Private,
    InternalAndPublic,
    InternalAndPrivate,
    InternalAndExternal,
    InternalAndPublicAndPrivate,
    InternalAndPublicAndExternal,
    InternalAndPrivateAndExternal,
    InternalAndPublicAndPrivateAndExternal,
    NonpayableAndPublic,

    // Private,
    // Internal,
    // External,
    // View,
    SetSender,
    Override,
    WithDebug
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
    pub args: Vec<GenFnArgs>,
    pub modifiers: Vec<Modifier>,
    pub code: &'a str,
    pub return_args: Vec<GenFnArgs>,
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
    fn just_data_type(data_type: DataType) -> GenFnArgs;
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
    fn just_data_type(data_type: DataType) -> GenFnArgs {
        GenFnArgs { data_type, storage_type: StorageType::None, name: "".to_string() }
    }
}

impl GenFnArgs {
    pub fn storage_type(&self) -> String {
        // utils::lowercase_first_letter_of_enum(Self::trim())
        self.storage_type.to_string()
    }

    pub fn formated(&self) -> (String, String, String) {
        (
            self.data_type(),
            self.storage_type(),
            self.name.to_owned(),
        )
    }
}

fn gen_modifiers(modifiers: &Vec<Modifier>, type_of_contract: TypeOfContract) -> (String, String) {
    let mut is_with_debug = false;
    let mut mods = String::new();
    let mut debug_args = String::new();

    for modifier in modifiers.into_iter() {
        // let mut first_iteration = true;
        mods += " ";

        match modifier {
            // Modifiers::Private |
            // Modifiers::Internal |
            // Modifiers::External |
            // Modifiers::View |
            Modifier::Virtual |
            Modifier::Public |
            Modifier::Override => {
                mods += &modifier.to_string();
            }
            Modifier::SetSender => {
                mods += &format!("{}()", &modifier.to_string());
            }
            Modifier::WithDebug => {
                is_with_debug = true;
            },
            _ => {
                mods += &modifier.to_string();
            }
        }
    }
    if is_with_debug && type_of_contract == TypeOfContract::Domain {
        if mods.len() != 0 {
            mods += " ";
        }
        // will always make withDebug the last modifier
        mods += &format!("withDebug(_debugging, _debugAddress)");
        debug_args = format!("bool _debugging, address _debugAddress");
    }
    (mods, debug_args)
}

fn gen_fn_body(code: &str, generated_args: &String) -> String {
    format!("return {code}({generated_args});")
}

fn gen_return(return_args: &Vec<GenFnArgs>) -> String {
    if return_args.len() == 0 { return String::from("") }
    let mut args = String::new();
    let mut first_iteration = true;
    for arg in return_args.iter() {
        if first_iteration {
            first_iteration = false;
        } else {
            args += ",";
        }
        args += &format!(" {} {}", arg.data_type, arg.storage_type);
    }
    format!(" returns ({})", args)
}

fn gen_args(args: &Vec<GenFnArgs>, receiving: bool) -> String {
    let mut string_of_args = String::new();
    let mut first_iteration = true;
    for arg in args.iter() {
        let (data_type, storage_type, name) = arg.formated();
        if receiving {
            if first_iteration {
                first_iteration = false;
            } else {
                // add spacing between every argument
                string_of_args += ", ";
            }
            string_of_args += &format!("{} {} {}", data_type, storage_type, name);
        } else {
            if first_iteration {
                first_iteration = false;
            } else {
                string_of_args += ", ";
            }
            string_of_args += &format!("{}", name);
        }
    }
    string_of_args
}

pub fn gen_domain_abstract_fns(
    name: &str,
    args: &Vec<GenFnArgs>,
    code: &str,
    modifiers: &Vec<Modifier>,
    return_args: &Vec<GenFnArgs>
) -> (String, String) {
    (
        gen_domain_funcs(
            name,
            args,
            modifiers,
            code,
            return_args
        ),
        gen_abstract_func(
            name, args, modifiers, return_args
        )
    )
}

pub fn gen_abstract_func(
    name: &str,
    args: &Vec<GenFnArgs>,
    modifiers: &Vec<Modifier>,
    return_args: &Vec<GenFnArgs>
) -> String {
    let generated_args = gen_args(args, true);
    let (mods, debug_args) = gen_modifiers(
        &merge_and_get_unique_data(
            &modifiers,
            vec![Modifier::Public, Modifier::Virtual, Modifier::WithDebug]
        ),
         TypeOfContract::Abstract);
    let debug_args_spacing = if debug_args.len() != 0 {", "} else {""};
    let return_args = gen_return(&return_args);
    format!("
    function {name}(
        {generated_args}{debug_args_spacing}{debug_args}
    ){mods}{return_args};")
}

pub fn gen_domain_funcs(
    name: &str,
    args: &Vec<GenFnArgs>,
    modifiers: &Vec<Modifier>,
    code: &str,
    return_args: &Vec<GenFnArgs>
) -> String {
    let mut reg_and_debug_funcs = gen_func(
        name, &args,
        merge_and_get_unique_data(
            &modifiers,
            vec![Modifier::Public, Modifier::Override, Modifier::SetSender]
        ),
         code, &return_args
    );

    reg_and_debug_funcs += "
";

    reg_and_debug_funcs += &gen_func(
        name, &args,
        merge_and_get_unique_data(
            &modifiers,
            vec![Modifier::Public, Modifier::WithDebug]
        ),
        code, &return_args
    );
    reg_and_debug_funcs
}

pub fn gen_func(
    name: &str,
    args: &Vec<GenFnArgs>,
    modifiers: Vec<Modifier>,
    code: &str,
    return_args: &Vec<GenFnArgs>
) -> String {
    let generated_receiving_args = gen_args(&args, true);
    let generated_inputing_args = gen_args(&args, false);
    let (mods, debug_args) = gen_modifiers(&modifiers, TypeOfContract::Domain);
    let debug_args_spacing = if debug_args.len() != 0 {", "} else {""};
    let generated_code = gen_fn_body(code, &generated_inputing_args);
    let return_args = gen_return(return_args);
    if args.len() > 1 || debug_args.len() > 1 {
        format!("
    function {name}(
        {generated_receiving_args}{debug_args_spacing}{debug_args}
    ){mods} {return_args} {{
        {generated_code}
    }}")
    } else {
        format!("
    function {name}({generated_receiving_args}{debug_args_spacing}{debug_args}){mods} {return_args} {{
        {generated_code}
    }}")
    }
}