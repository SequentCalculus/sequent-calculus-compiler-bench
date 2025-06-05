fn odd_abs(n: u64) -> bool {
    if n == 0 {
        false
    } else {
        even_abs(n - 1)
    }
}

fn even_abs(n: u64) -> bool {
    if n == 0 {
        true
    } else {
        odd_abs(n - 1)
    }
}

fn odd(n: i64) -> bool {
    odd_abs(n.abs() as u64)
}

fn even(n: i64) -> bool {
    even_abs(n.abs() as u64)
}

fn main_loop(iters: u64, n: i64) {
    let mut res = even(n) && !odd(n);
    for _ in 1..iters {
        res = even(n) && odd(n);
    }
    println!("{}", if res { 1 } else { 0 });
}

fn main() {
    let mut args = std::env::args();
    args.next();
    let iters = args
        .next()
        .expect("Missing Argument iterations")
        .parse::<u64>()
        .expect("Iterations must be a number");
    let n = args
        .next()
        .expect("Missing Argument n")
        .parse::<i64>()
        .expect("n must be a number");
    main_loop(iters, n)
}
