mod layouts;
mod workflows;

use workflows::amv;

fn main() {
    // amv::codegen().unwrap();//-
    amv::codegen().unwrap();//+
    println!("Code generated");
}
