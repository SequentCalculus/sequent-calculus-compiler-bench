use std::rc::Rc;

#[derive(Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl<A> List<A> {
    fn append(self, other: List<A>) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => other,
            List::Cons(a, as_) => List::Cons(a, Rc::new(Rc::unwrap_or_clone(as_).append(other))),
        }
    }

    fn map<B>(self, f: &impl Fn(A) -> B) -> List<B>
    where
        A: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(a, as_) => List::Cons(f(a), Rc::new(Rc::unwrap_or_clone(as_).map(f))),
        }
    }
}

impl List<i64> {
    fn enum_from_to(from: i64, to: i64) -> List<i64> {
        if from <= to {
            List::Cons(from, Rc::new(List::enum_from_to(from + 1, to)))
        } else {
            List::Nil
        }
    }

    fn max(self) -> i64 {
        match self {
            List::Nil => panic!("Empty List"),
            List::Cons(x, xs) => match Rc::unwrap_or_clone(xs) {
                List::Nil => x,
                List::Cons(y, ys) => {
                    if x > y {
                        List::Cons(x, ys).max()
                    } else {
                        List::Cons(y, ys).max()
                    }
                }
            },
        }
    }
}

fn quot_rem(a: i64, b: i64) -> (i64, i64) {
    (a / b, a % b)
}

fn g((u1, u2, u3): (i64, i64, i64), (v1, v2, v3): (i64, i64, i64)) -> (i64, i64, i64) {
    if v3 == 0 {
        (u3, u1, u2)
    } else {
        let (q, r) = quot_rem(u3, v3);
        g((v1, v2, v3), (u1 - (q * v1), u2 - (q * v2), r))
    }
}

fn gcd_e(x: i64, y: i64) -> (i64, i64, i64) {
    if x == 0 {
        (y, 0, 1)
    } else {
        g((1, 0, x), (0, 1, y))
    }
}

fn cartesian_product(p1: List<i64>, m1: List<i64>) -> List<(i64, i64)> {
    match p1 {
        List::Nil => List::Nil,
        List::Cons(h1, t1) => {
            to_pair(h1, m1.clone()).append(cartesian_product(Rc::unwrap_or_clone(t1), m1))
        }
    }
}

fn to_pair(i: i64, l: List<i64>) -> List<(i64, i64)> {
    match l {
        List::Nil => List::Nil,
        List::Cons(j, js) => List::Cons((i, j), Rc::new(to_pair(i, Rc::unwrap_or_clone(js)))),
    }
}

fn test(d: i64) -> i64 {
    let ns: List<i64> = List::enum_from_to(5000, 5000 + d);
    let ms: List<i64> = List::enum_from_to(10000, 10000 + d);
    let tripls: List<(i64, i64, (i64, i64, i64))> =
        cartesian_product(ns, ms).map(&|(x, y)| (x, y, gcd_e(x, y)));
    let rs: List<i64> = tripls.map(&|(_, _, (gg, u, v))| (gg + u + v).abs());
    rs.max()
}

fn test_gcd_nofib(d: i64) -> i64 {
    test(d)
}

fn main_loop(iters: u64, n: i64) {
    let res = test_gcd_nofib(n);
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
