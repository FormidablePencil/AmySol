use crate::{generated_code::generated_rs_code::DataType, layouts::{constructing_smart_contract::gen_code_and_write_to_files, smart_contract_building_blocks::{ GenFnArgs, GenFnData, GenFnDataArgsTrait, StorageType}}};

pub fn codegen() -> Result<(), std::io::Error> {
    gen_code_and_write_to_files(
        "AMV",
        vec![],
        vec![],
        vec!["../data/AMVData.sol"],
        String::from("
    AMV amv = new AMV();
        "),
        String::from(""),
        vec![
            GenFnData {
                name: "setPrivateIPFSHash",
                args: vec![
                    GenFnArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnArgs::default(DataType::AuthorizedAddressArray, StorageType::Memory, "_authorizedAddresses"),
                ],
                modifiers: vec![],
                code: &"amv.setPrivateIPFSHash",
                return_args: vec![],
            },
            GenFnData {
                name: "getPrivateIPFSHash",
                args: vec![
                    GenFnArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnArgs::default(DataType::AuthorizedAddressArray, StorageType::Memory, "_authorizedAddresses"),
                ],
                modifiers: vec![],
                code: &"amv.getPrivateIPFSHash",
                return_args: vec![
                    GenFnArgs::data_type_and_storage_type(DataType::IPFSHashArray, StorageType::Memory),
                ],
            },
            GenFnData {
                name: "getAllPrivilegedAddressesToIPFSHashes",
                args: vec![
                    GenFnArgs::default(DataType::String, StorageType::Memory, "_hash"),
                ],
                modifiers: vec![],
                code: &"amv.getAllPrivilegedAddressesToIPFSHashes",
                return_args: vec![
                    GenFnArgs::data_type_and_storage_type(DataType::AuthorizedAddressArray, StorageType::Memory),
                ],
            },
            GenFnData {
                name: "revokeAccess",
                args: vec![
                    GenFnArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnArgs::default(DataType::AddressArray, StorageType::Memory, "_users"),
                ],
                modifiers: vec![],
                code: &"amv.revokeAccess",
                return_args: vec![],
            },
            GenFnData {
                name: "changeContentAccessLvl",
                args: vec![
                    GenFnArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnArgs::data_type_and_name(DataType::ContentAccessLvl, "_contentAccess"),
                ],
                modifiers: vec![],
                code: &"amv.changeContentAccessLvl",
                return_args: vec![],
            },
            GenFnData {
                name: "isAuthorized",
                args: vec![
                    GenFnArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnArgs::data_type_and_name(DataType::Address, "_user"),
                ],
                modifiers: vec![],
                code: &"amv.isAuthorized",
                return_args: vec![
                    GenFnArgs::just_data_type(DataType::Bool) 
                ],
            }
        ],
    )
}