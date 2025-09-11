use std::rc::Rc;

#[derive(Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl List<i64> {
    fn range(i: i64, n: i64) -> List<i64> {
        if i < n {
            List::Cons(i, Rc::new(List::range(i + 1, n)))
        } else {
            List::Nil
        }
    }

    fn sum(self) -> i64 {
        match self {
            List::Nil => 0,
            List::Cons(a, as_) => a + Rc::unwrap_or_clone(as_).sum(),
        }
    }
}

fn main_loop(iters: u64, n: i64) {
    let res = List::range(0, n).sum();
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
