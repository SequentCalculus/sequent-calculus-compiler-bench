use std::rc::Rc;

#[derive(Debug, Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl List<u64> {
    fn interval(m: u64, n: u64) -> List<u64> {
        if n < m {
            List::Nil
        } else {
            List::Cons(m, Rc::new(List::interval(m + 1, n)))
        }
    }

    fn len(&self) -> usize {
        match self {
            List::Nil => 0,
            List::Cons(_, as_) => 1 + as_.len(),
        }
    }
}

fn remove_multiples(n: u64, l: List<u64>) -> List<u64> {
    match l {
        List::Nil => List::Nil,
        List::Cons(x, xs) => {
            if x % n == 0 {
                remove_multiples(n, Rc::unwrap_or_clone(xs))
            } else {
                List::Cons(x, Rc::new(remove_multiples(n, Rc::unwrap_or_clone(xs))))
            }
        }
    }
}

fn sieve(l: List<u64>) -> List<u64> {
    match l {
        List::Nil => List::Nil,
        List::Cons(x, xs) => List::Cons(
            x,
            Rc::new(sieve(remove_multiples(x, Rc::unwrap_or_clone(xs)))),
        ),
    }
}

fn main_loop(iters: u64, n: u64) {
    let mut res = sieve(List::interval(2, n));
    for _ in 1..iters {
        res = sieve(List::interval(2, n));
    }

    println!("{:?}", res.len());
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
