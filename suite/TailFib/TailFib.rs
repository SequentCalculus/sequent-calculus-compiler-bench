fn tfib(n: u64, a: u64, b: u64) -> u64 {
    if n == 0 {
        a
    } else {
        tfib(n - 1, a + b, a)
    }
}

fn fib(n: u64) -> u64 {
    tfib(n, 0, 1)
}

fn main_loop(iters: u64, n: u64) {
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
        .parse::<u64>()
        .expect("n must be a number");
    main_loop(iters, n)
}
