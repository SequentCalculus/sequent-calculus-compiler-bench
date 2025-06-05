use std::rc::Rc;

enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

fn replicate(value: i64, n: i64) -> List<i64> {
    let mut list = List::Nil;
    for _ in 0..n {
        list = List::Cons(value, Rc::new(list));
    }
    list
}

fn useless(n: i64) -> i64 {
    let mut i = 0;
    for j in 0..n {
        replicate(0, j);
        i += 1;
    }
    i
}

fn main_loop(iters: u64, n: i64) {
    let mut res = useless(n);
    for _ in 0..=iters {
        res = useless(n);
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
