use workflows::amv;

mod layouts;
mod workflows;
mod utils;
mod generated_code;

fn main() {
    amv::codegen().unwrap();
    // generated_code::gen_rs_code();
    println!("Code generated");
}
