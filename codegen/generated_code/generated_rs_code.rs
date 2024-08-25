
use crate::{layouts::smart_contract_building_blocks::GenFnArgs, utils};

// =============================================================================
// This is a generated file by /codegen. Don't make edits to this file directly.
// This generated code comes from /codegen/codegen.rs
// =============================================================================

#[derive(Debug)]
pub enum DataType {
    None, String, Uint, Bool, AuthorizedAddressArray, IPFSHashArray, Address, AddressArray, ContentAccessLvl
} // TODO: Generate code for this

impl GenFnArgs {
    pub fn data_type(&self) -> String {
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
}
    