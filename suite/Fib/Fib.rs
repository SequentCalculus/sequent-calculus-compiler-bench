fn fib(n: i64) -> i64 {
    match n {
        0 => 0,
        1 => 1,
        n => fib(n - 1) + fib(n - 2),
    }
}

fn main_loop(iters: u64, n: i64) {
    let mut res = fib(n);
    for _ in 1..iters {
        res = fib(n);
    }
    println!("{}", res);
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
