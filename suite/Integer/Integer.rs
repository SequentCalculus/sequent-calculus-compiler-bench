use std::rc::Rc;

#[derive(Debug, Clone)]
enum Either<T, U> {
    Left(T),
    Right(U),
}

#[derive(Clone, Debug)]
enum List<T> {
    Nil,
    Cons(T, Rc<List<T>>),
}

impl<T> List<T> {
    fn head(self) -> T {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(t, _) => t,
        }
    }

    fn append(self, other: List<T>) -> List<T>
    where
        T: Clone,
    {
        match self {
            List::Nil => other,
            List::Cons(t1, ts) => List::Cons(t1, Rc::new(Rc::unwrap_or_clone(ts).append(other))),
        }
    }
}

fn enum_from_then_to(from: i64, then: i64, t: i64) -> List<i64> {
    if from <= t {
        List::Cons(from, Rc::new(enum_from_then_to(then, (2 * then) - from, t)))
    } else {
        List::Nil
    }
}

fn apply_op_inner(
    ls: List<i64>,
    a: i64,
    op: &impl Fn(i64, i64) -> Either<i64, bool>,
) -> List<Either<i64, bool>> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(b, t2) => List::Cons(
            op(a, b),
            Rc::new(apply_op_inner(Rc::unwrap_or_clone(t2), a, op)),
        ),
    }
}

fn apply_op(
    ls: List<i64>,
    astart: i64,
    astep: i64,
    alim: i64,
    op: &impl Fn(i64, i64) -> Either<i64, bool>,
) -> List<Either<i64, bool>> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(a, t1) => apply_op_inner(enum_from_then_to(astart, astart + astep, alim), a, op)
            .append(apply_op(Rc::unwrap_or_clone(t1), astart, astep, alim, op)),
    }
}

fn integerbench(
    op: &impl Fn(i64, i64) -> Either<i64, bool>,
    astart: i64,
    astep: i64,
    alim: i64,
) -> List<Either<i64, bool>> {
    apply_op(
        enum_from_then_to(astart, astart + astep, alim),
        astart,
        astep,
        alim,
        op,
    )
}

fn runbench(
    jop: &impl Fn(i64, i64) -> Either<i64, bool>,
    astart: i64,
    astep: i64,
    alim: i64,
) -> List<Either<i64, bool>> {
    let _ = integerbench(jop, astart, astep, alim);
    integerbench(jop, astart, astep, alim)
}

fn runalltests(
    astart: i64,
    astep: i64,
    alim: i64,
    _: i64,
    _: i64,
    _: i64,
) -> List<Either<i64, bool>> {
    let z_add = &|a, b| Either::Left(a + b);
    let z_sub = &|a, b| Either::Left(a - b);
    let z_mul = &|a, b| Either::Left(a * b);
    let z_div = &|a, b| Either::Left(a / b);
    let z_mod = &|a, b| Either::Left(a % b);
    let z_equal = &|a, b| Either::Right(a == b);
    let z_lt = &|a, b| Either::Right(a < b);
    let z_gt = &|a, b| Either::Right(a > b);
    let z_leq = &|a, b| Either::Right(a <= b);
    let z_geq = &|a, b| Either::Right(a >= b);

    let _ = runbench(z_add, astart, astep, alim);
    let _ = runbench(z_sub, astart, astep, alim);
    let _ = runbench(z_mul, astart, astep, alim);
    let _ = runbench(z_div, astart, astep, alim);
    let _ = runbench(z_mod, astart, astep, alim);
    let _ = runbench(z_equal, astart, astep, alim);
    let _ = runbench(z_lt, astart, astep, alim);
    let _ = runbench(z_leq, astart, astep, alim);
    let _ = runbench(z_gt, astart, astep, alim);
    runbench(z_geq, astart, astep, alim)
}

fn test_integer_nofib(n: i64) -> List<Either<i64, bool>> {
    runalltests(-2100000000, n, 2100000000, -2100000000, n, 2100000000)
}

fn print_either(e: Either<i64, bool>) {
    match e {
        Either::Left(i) => println!("{i}"),
        Either::Right(b) => {
            if b {
                println!("11")
            } else {
                println!("00")
            }
        }
    }
}

fn main_loop(iters: u64, n: i64) {
    let mut res = test_integer_nofib(n);
    for _ in 0..iters {
        res = test_integer_nofib(n);
    }
    print_either(res.head());
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
