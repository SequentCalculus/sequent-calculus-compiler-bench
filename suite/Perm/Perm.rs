use std::rc::Rc;

fn factorial(n: i64) -> i64 {
    if n == 1 {
        1
    } else {
        n * factorial(n - 1)
    }
}

#[derive(Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl<A> List<A> {
    fn tail(&self) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => panic!("Cannot take tail of empty list"),
            List::Cons(_, as_) => Rc::unwrap_or_clone(as_.clone()),
        }
    }

    fn head(self) -> A {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(a, _) => a,
        }
    }

    fn len(&self) -> i64 {
        match self {
            List::Nil => 0,
            List::Cons(_, as_) => 1 + as_.len(),
        }
    }

    fn rev_loop(self, n: i64, y: List<A>) -> List<A>
    where
        A: Clone,
    {
        if n == 0 {
            y
        } else {
            self.tail()
                .rev_loop(n - 1, List::Cons(self.head(), Rc::new(y)))
        }
    }

    fn tail_n(self, n: i64) -> List<A>
    where
        A: Clone,
    {
        if n == 0 {
            self
        } else {
            self.tail().tail_n(n - 1)
        }
    }
}

fn loop_sum(y: List<i64>) -> i64 {
    match y {
        List::Nil => 0,
        List::Cons(i, is_) => i + loop_sum(Rc::unwrap_or_clone(is_)),
    }
}

fn sumlists(x: List<List<i64>>) -> i64 {
    match x {
        List::Nil => 0,
        List::Cons(is_, iss) => loop_sum(is_) + sumlists(Rc::unwrap_or_clone(iss)),
    }
}

impl List<i64> {
    fn loop_one2n(n: i64, p: List<i64>) -> List<i64> {
        if n == 0 {
            p
        } else {
            List::loop_one2n(n - 1, List::Cons(n, Rc::new(p)))
        }
    }

    fn one2n(n: i64) -> List<i64> {
        List::loop_one2n(n, List::Nil)
    }
}

fn f(n: i64, perms: List<List<i64>>, x: List<i64>) -> (List<List<i64>>, List<i64>) {
    let x = x.clone().rev_loop(n, x.tail_n(n));
    let perms = List::Cons(x.clone(), Rc::new(perms));
    (perms, x)
}

fn loop_p(j: i64, perms: List<List<i64>>, x: List<i64>, n: i64) -> (List<List<i64>>, List<i64>) {
    let (mut perms, mut x) = p(n - 1, perms, x);
    for _ in 0..j {
        (perms, x) = p(n - 1, perms, x);
        (perms, x) = f(n, perms, x);
    }
    (perms, x)
}

fn p(n: i64, perms: List<List<i64>>, x: List<i64>) -> (List<List<i64>>, List<i64>) {
    if 1 < n {
        loop_p(n - 1, perms, x, n)
    } else {
        (perms, x)
    }
}

fn permutations(x0: List<i64>) -> List<List<i64>> {
    let (final_perms, _) = p(x0.len(), List::Cons(x0.clone(), Rc::new(List::Nil)), x0);
    final_perms
}

fn loop_work(m: i64, mut perms: List<List<i64>>) -> List<List<i64>> {
    for _ in 0..m {
        perms = permutations(perms.head())
    }
    perms
}
fn run_benchmark(
    work: &impl Fn() -> List<List<i64>>,
    result: &impl Fn(List<List<i64>>) -> bool,
) -> bool {
    result(work())
}

fn perm9(m: i64, n: i64) -> bool {
    run_benchmark(
        &|| loop_work(m, permutations(List::one2n(n))),
        &|result: List<List<i64>>| sumlists(result) == (n * (n + 1)) * (factorial(n) / 2),
    )
}

fn main_loop(iters: u64, m: i64, n: i64) {
    let res = perm9(m, n);
    if iters == 1 {
        if res {
            println!("1")
        } else {
            println!("0")
        }
    } else {
        main_loop(iters - 1, m, n)
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
    let m = args
        .next()
        .expect("Missing Argument n")
        .parse::<i64>()
        .expect("n must be a number");
    let n = args
        .next()
        .expect("Missing Argument n")
        .parse::<i64>()
        .expect("m must be a number");
    main_loop(iters, m, n)
}
