fn attempt(i: u64) -> Option<u64> {
    if i == 0 {
        Some(i)
    } else {
        match attempt(i - 1) {
            None => None,
            Some(x) => Some(x + 1),
        }
    }
}

fn main_loop(iters: u64, n: u64) {
    let mut res: i64 = attempt(n).map(|u| u as i64).unwrap_or(-1);
    for _ in 1..iters {
        res = attempt(n).map(|u| u as i64).unwrap_or(-1);
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
