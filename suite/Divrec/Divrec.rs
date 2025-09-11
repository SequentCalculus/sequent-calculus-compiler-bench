use std::rc::Rc;

#[derive(Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl<A> List<A> {
    fn create_n(n: i64) -> List<A>
    where
        A: Default,
    {
        let mut ls = List::Nil;
        for _ in 0..n {
            ls = List::Cons(A::default(), Rc::new(ls));
        }
        ls
    }

    fn len(&self) -> i64 {
        match self {
            List::Nil => 0,
            List::Cons(_, as_) => 1 + as_.len(),
        }
    }
}

fn rec_div2(l: List<()>) -> List<()> {
    match l {
        List::Nil => List::Nil,
        List::Cons(x, xs) => match Rc::unwrap_or_clone(xs) {
            List::Nil => panic!("Cannot divide an odd number by 2"),
            List::Cons(_, ys) => List::Cons(x, Rc::new(rec_div2(Rc::unwrap_or_clone(ys)))),
        },
    }
}

fn main_loop(iters: u64, n: i64) {
    let res = rec_div2(List::create_n(n)).len();
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
