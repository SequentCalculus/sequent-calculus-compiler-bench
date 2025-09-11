fn tfib(n: i64, a: i64, b: i64) -> i64 {
    if n == 0 {
        a
    } else {
        tfib(n - 1, a + b, a)
    }
}

fn fib(n: i64) -> i64 {
    tfib(n, 0, 1)
}

fn main_loop(iters: u64, n: i64) {
    let res = fib(n);
    if iters == 1 {
        println!("{res}");
    } else {
        main_loop(iters - 1, n)
    }
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
