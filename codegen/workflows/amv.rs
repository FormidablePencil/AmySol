use crate::layouts::layouts::{gen_code_and_write_to_files, DataType, GenFnData, GenFnDataArgs:: {self}, GenFnDataArgsTrait, StorageType};

pub fn codegen() -> Result<(), std::io::Error> {
    gen_code_and_write_to_files(
        "AMV",
        Some(vec!["IAMV", "DebuggingUtils"]),
        Some(vec!["../managers/AMVManager.sol"]),
        vec![
            GenFnData {
                name: "setPrivateIPFSHash",
                args: Some(vec![
                    GenFnDataArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnDataArgs::default(DataType::AuthorizedAddressArray, StorageType::Memory, "_authorizedAddresses"),
                ]),
                modifiers: None,
                code: &"amv.setPrivateIPFSHash",
                return_args: None
            },
            GenFnData {
                name: "getPrivateIPFSHash",
                args: Some(vec![
                    GenFnDataArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnDataArgs::default(DataType::AuthorizedAddressArray, StorageType::Memory, "_authorizedAddresses"),
                ]),
                modifiers: None,
                code: &"amv.getPrivateIPFSHash",
                return_args: Some(vec![
                    GenFnDataArgs::data_type_and_storage_type(DataType::IPFSHashArray, StorageType::Memory),
                ])
            },
            GenFnData {
                name: "getAllPrivilegedAddressesToIPFSHashes",
                args: Some(vec![
                    GenFnDataArgs::default(DataType::String, StorageType::Memory, "_hash"),
                ]),
                modifiers: None,
                code: &"amv.getAllPrivilegedAddressesToIPFSHashes",
                return_args: Some(vec![
                    GenFnDataArgs::data_type_and_storage_type(DataType::AuthorizedAddressArray, StorageType::Memory),
                ])
            },
            GenFnData {
                name: "revokeAccess",
                args: Some(vec![
                    GenFnDataArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnDataArgs::default(DataType::AddressArray, StorageType::Memory, "_users"),
                ]),
                modifiers: None,
                code: &"amv.revokeAccess",
                return_args: None
            },
            GenFnData {
                name: "changeContentAccessLvl",
                args: Some(vec![
                    GenFnDataArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnDataArgs::data_type_and_name(DataType::ContentAccessLvl, "_contentAccess"),
                ]),
                modifiers: None,
                code: &"amv.changeContentAccessLvl",
                return_args: None
            },
            GenFnData {
                name: "isAuthorized",
                args: Some(vec![
                    GenFnDataArgs::default(DataType::String, StorageType::Memory, "_hash"),
                    GenFnDataArgs::data_type_and_name(DataType::Address, "_user"),
                ]),
                modifiers: None,
                code: &"amv.isAuthorized",
                return_args: Some(vec![
                    GenFnDataArgs::data_type(DataType::Bool) 
                ])
            }
        ],
    )
}