use std::rc::Rc;

#[derive(Debug, Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl List<u64> {
    fn tabulate(n: u64, f: &impl Fn(u64) -> u64) -> List<u64> {
        let mut ls = List::Nil;
        for i in 0..=n {
            ls = List::Cons(f(i), Rc::new(ls));
        }
        ls.rev()
    }
}

impl<A> List<A> {
    fn rev_loop(self, acc: List<A>) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => acc,
            List::Cons(a_, as_) => Rc::unwrap_or_clone(as_).rev_loop(List::Cons(a_, Rc::new(acc))),
        }
    }

    fn rev(self) -> List<A>
    where
        A: Clone,
    {
        self.rev_loop(List::Nil)
    }

    fn merge(self, other: List<A>) -> List<A>
    where
        A: PartialOrd + Clone,
    {
        match (self, other) {
            (List::Nil, other) => other,
            (s, List::Nil) => s,
            (List::Cons(x1, xs1), List::Cons(x2, xs2)) if x1 <= x2 => List::Cons(
                x1,
                Rc::new(Rc::unwrap_or_clone(xs1).merge(List::Cons(x2, xs2))),
            ),
            (List::Cons(x1, xs1), List::Cons(x2, xs2)) => List::Cons(
                x2,
                Rc::new(List::Cons(x1, xs1).merge(Rc::unwrap_or_clone(xs2))),
            ),
        }
    }

    fn head(self) -> A {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(a, _) => a,
        }
    }
}

fn main_loop(iters: u64, l1: List<u64>, l2: List<u64>) {
    let mut res = l1.clone().merge(l2.clone());
    for _ in 1..iters {
        res = l1.clone().merge(l2.clone());
    }
    println!("{}", res.head());
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
    let l1 = List::tabulate(n, &|x| 2 * x);
    let l2 = List::tabulate(n, &|x| (2 * x) + 1);
    main_loop(iters, l1, l2)
}
