use std::fmt::Debug;
use std::collections::HashSet;
use std::hash::Hash;

pub trait UtilsTrait {
    fn trim_off_last_4_chars(input: &mut String) -> &mut String;
    fn lowercase_first_letter(s: &str) -> String;
    fn lowercase_first_letter_of_enum<T: Debug>(modifier: T) -> String;
}
pub fn trim(input: &mut String) -> &mut String {
    if input.len() >= 7 {
        input.drain(0..4);
        input.drain(input.len() - 3..);
    }
    input
}

// todo: get rid of this
    // fn trim_args_ending_with_array(input: &mut String) -> &mut String {
    //     if input.len() >= 7 {
    //         input.drain(0..4);
    //         input.drain(input.len() - 3..);
    //     }
    //     input
    // }
// }

pub fn trim_off_last_4_chars(input: &mut String) -> &mut String {
    if input.len() >= 7 {
        input.drain(input.len() - 5..);
    }
    input
}
pub fn lowercase_first_letter(s: &str) -> String {
    let mut chars: Vec<char> = s.chars().collect();
    chars[0] = chars[0..1].into_iter().map(|c| c.to_ascii_uppercase()).next().unwrap();
    chars.iter().collect()
}

pub fn lowercase_first_letter_of_enum<T: Debug>(item: T) -> String {
    format!(" {:?}", lowercase_first_letter(&format!("{:?}", item)))
}
pub fn merge_and_get_unique_data<T: std::clone::Clone + Eq + Hash>(new_modifiers: &Vec<T>, default_modifiers: Vec<T>) -> Vec<T> {
    let mut default_set: HashSet<T> = default_modifiers.iter().cloned().collect();
    let new_set: HashSet<T> = new_modifiers.iter().cloned().map(|v| v).collect();
    default_set.extend(new_set);
    default_set.into_iter().collect()
}