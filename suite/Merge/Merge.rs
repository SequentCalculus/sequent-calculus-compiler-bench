use std::rc::Rc;

#[derive(Debug, Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl List<i64> {
    fn head(self) -> i64 {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(x, _) => x,
        }
    }

    fn rev_loop(self, acc: List<i64>) -> List<i64> {
        match self {
            List::Nil => acc,
            List::Cons(p, ps) => Rc::unwrap_or_clone(ps).rev_loop(List::Cons(p, Rc::new(acc))),
        }
    }

    fn rev(self) -> List<i64> {
        self.rev_loop(List::Nil)
    }

    fn tabulate_loop(n: i64, len: i64, acc: List<i64>, f: &impl Fn(i64) -> i64) -> List<i64> {
        if n < len {
            List::tabulate_loop(n + 1, len, List::Cons(f(n), Rc::new(acc)), f)
        } else {
            acc.rev()
        }
    }

    fn tabulate(n: i64, f: &impl Fn(i64) -> i64) -> List<i64> {
        List::tabulate_loop(0, n, List::Nil, f)
    }

    fn merge(self, other: List<i64>) -> List<i64> {
        match self {
            List::Nil => other,
            List::Cons(x1, xs1) => match other {
                List::Nil => List::Cons(x1, xs1),
                List::Cons(x2, xs2) => {
                    if x1 <= x2 {
                        List::Cons(
                            x1,
                            Rc::new(Rc::unwrap_or_clone(xs1).merge(List::Cons(x2, xs2))),
                        )
                    } else {
                        List::Cons(
                            x2,
                            Rc::new(List::Cons(x1, xs1).merge(Rc::unwrap_or_clone(xs2))),
                        )
                    }
                }
            },
        }
    }
}

fn main_loop(iters: u64, l1: List<i64>, l2: List<i64>) {
    let res = l1.clone().merge(l2.clone());
    if iters == 1 {
        println!("{}", res.head());
    } else {
        main_loop(iters - 1, l1, l2)
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
    let l1 = List::tabulate(n, &|x| 2 * x);
    let l2 = List::tabulate(n, &|x| (2 * x) + 1);
    main_loop(iters, l1, l2)
}
