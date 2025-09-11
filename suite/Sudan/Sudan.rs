fn sudan(n: i64, x: i64, y: i64) -> i64 {
    if n == 0 {
        x + y
    } else if y == 0 {
        x
    } else {
        let inner = sudan(n, x, y - 1);
        sudan(n - 1, inner, inner + y)
    }
}

fn main_loop(iters: u64, n: i64, x: i64, y: i64) {
    let res = sudan(n, x, y);
    if iters == 1 {
        println!("{res}");
    } else {
        main_loop(iters - 1, n, x, y)
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
    let x = args
        .next()
        .expect("Missing Argument x")
        .parse::<i64>()
        .expect("x must be a number");
    let y = args
        .next()
        .expect("Missing Argument y")
        .parse::<i64>()
        .expect("y must be a number");

    main_loop(iters, n, x, y)
}
