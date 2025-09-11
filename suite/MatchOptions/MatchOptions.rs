fn attempt(i: i64) -> Option<i64> {
    if i == 0 {
        Some(i)
    } else {
        match attempt(i - 1) {
            None => None,
            Some(x) => Some(x + 1),
        }
    }
}

fn main_loop(iters: u64, n: i64) {
    let res: i64 = match attempt(n) {
        None => -1,
        Some(x) => x,
    };
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
