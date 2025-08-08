fn iterate(i: i64, f: impl Fn(i64) -> i64, a: i64) -> i64 {
    let mut res = a;
    for _ in 0..i {
        res = f(res)
    }
    res
}

fn main_loop(iters: u64, n: i64) {
    let res = iterate(n, |x| x + 1, 0);
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
