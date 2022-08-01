#!/usr/bin/env rust-script

//!
//! ```cargo
//! [dependencies]
//! rand = "0.8.0"
//! ```

use rand::prelude::*;

fn main() {
    println!("\n\n****** This is a Rust script! 🦀🚀 ******\n\n");
    let x: i8 = rand::thread_rng().gen_range(0..100);
    println!("A random number from 0 to 100: {}", x);
    let y: i8 = rand::thread_rng().gen_range(0..100);
    println!("Another random number from 0 to 100: {}", y);

    println!(
        "The subtraction of these two random numbers: {}",
        subtract(x, y)
    );
}

fn subtract(n1: i8, n2: i8) -> i8 {
    n1 - n2
}

#[cfg(test)]
mod tests {
    use crate::subtract;

    #[test]
    fn the_subtraction_works() {
        let expected_result = -35;
        assert_eq!(expected_result, subtract(-10, 25));
    }
}
