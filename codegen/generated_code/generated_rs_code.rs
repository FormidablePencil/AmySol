
use core::fmt;

use crate::{layouts::smart_contract_building_blocks::{GenFnArgs, Modifier, StorageType}, utils};

#[derive(Debug)]
pub enum DataType {
    None, String, Uint, Bool, AuthorizedAddressArray, IPFSHashArray, Address, AddressArray, ContentAccessLvl
}

impl fmt::Display for DataType {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let string = match self {
            DataType::None => todo!(),
            DataType::String => "string",
            DataType::Uint => "uint",
            DataType::Bool => "bool",
            DataType::Address => "address",
            DataType::ContentAccessLvl => "ContentAccessLvl",
            DataType::AuthorizedAddressArray => "AuthorizedAddress[]",
            DataType::IPFSHashArray => "IPFSHash[]",
            DataType::AddressArray => "address[]",
        };
        write!(f, "{}", string)
    }
}

impl std::fmt::Display for StorageType {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        write!(fmt, "{}", 
            match self {
                StorageType::Memory=> "memory",
                StorageType::None => "", 
            }
        )        
    }
}

impl std::fmt::Display for Modifier {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        write!(fmt, "{}", 
            match self {
                Modifier::Pure => "pure",
                Modifier::View => "view",
                Modifier::Payable => "payable",
                Modifier::Default => "default",
                Modifier::Nonpayable => "nonpayable",
                Modifier::Internal => "internal",
                Modifier::External => "external",
                Modifier::Public => "public",
                Modifier::Private => "private",
                Modifier::InternalAndPublic => "internalAndPublic",
                Modifier::InternalAndPrivate => "internalAndPrivate",
                Modifier::InternalAndExternal => "internalAndExternal",
                Modifier::InternalAndPublicAndPrivate => "internalAndPublicAndPrivate",
                Modifier::InternalAndPublicAndExternal => "internalAndPublicAndExternal",
                Modifier::InternalAndPrivateAndExternal => "internalAndPrivateAndExternal",
                Modifier::InternalAndPublicAndPrivateAndExternal => "internalAndPublicAndPrivateAndExternal",
                Modifier::NonpayableAndPublic => "nonpayableAndPublic",
                Modifier::SetSender => "setSender",
                Modifier::Override => "override",
                Modifier::WithDebug => "withDebug",
                Modifier::Virtual => "virtual"
            }
        )
    }
}


impl GenFnArgs {
    pub fn data_type(&self) -> String {
        match self.data_type {
            // TODO: Lowercase
            DataType::String |
            DataType::ContentAccessLvl |
            DataType::Bool |
            DataType::Address |
            // DataType::Uint => format!("{:?}", Self::trim(&mut utils::lowercase_first_letter_of_enum(&self.data_type))),
            DataType::Uint => self.data_type.to_string(),
            // TODO: Find "Array" If ends with array then replace "Array" with []
            DataType::AddressArray |
            DataType::AuthorizedAddressArray |
            DataType::IPFSHashArray => {
                self.data_type.to_string()
                // covnert everything that ends with Array with [] for instance IPFSHashArray -> IPFSHash[]
                // let data_type_unformatted = &mut self.data_type.to_string();
                // let data_type_formatted = Self::trim(data_type_unformatted);
                // format!("{}[]", utils::trim_off_last_4_chars(data_type_formatted))
            }
            DataType::None => "".to_string(),
        }
    }
}
    