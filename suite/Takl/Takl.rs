use std::rc::Rc;

#[derive(Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl<A> List<A> {
    fn len(&self) -> usize {
        match self {
            List::Nil => 0,
            List::Cons(_, as_) => 1 + as_.len(),
        }
    }

    fn tail(self) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => panic!("Cannot take tail of empty list"),
            List::Cons(_, as_) => Rc::unwrap_or_clone(as_),
        }
    }

    fn shorterp<B>(&self, other: &List<B>) -> bool {
        match (self, other) {
            (_, List::Nil) => false,
            (List::Nil, _) => true,
            (List::Cons(_, as_), List::Cons(_, bs)) => as_.shorterp(&(*bs)),
        }
    }
}

impl List<u64> {
    fn n(n: u64) -> List<u64> {
        if n == 0 {
            List::Nil
        } else {
            List::Cons(n, Rc::new(List::n(n - 1)))
        }
    }
}

fn mas(x: List<u64>, y: List<u64>, z: List<u64>) -> List<u64> {
    if !y.shorterp(&x) {
        z
    } else {
        mas(
            mas(x.clone().tail(), y.clone(), z.clone()),
            mas(y.clone().tail(), z.clone(), x.clone()),
            mas(z.tail(), x, y),
        )
    }
}

fn main_loop(iters: u64, x: u64, y: u64, z: u64) {
    let res = mas(List::n(x), List::n(y), List::n(z)).len();
    if iters == 1 {
        println!("{res}");
    } else {
        main_loop(iters - 1, x, y, z)
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
    let x = args
        .next()
        .expect("Missing Argument x")
        .parse::<u64>()
        .expect("x must be a number");
    let y = args
        .next()
        .expect("Missing Argument y")
        .parse::<u64>()
        .expect("y must be a number");
    let z = args
        .next()
        .expect("Missing Argument z")
        .parse::<u64>()
        .expect("z must be a number");
    main_loop(iters, x, y, z)
}
