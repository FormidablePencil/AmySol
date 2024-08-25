mod layouts;
mod workflows;
mod utils;

use workflows::amv;

fn main() {
    amv::codegen().unwrap();
    println!("Code generated");
}
