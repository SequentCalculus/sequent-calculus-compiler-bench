use std::rc::Rc;

#[derive(Debug, Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl<A> List<A> {
    fn head(self) -> A {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(a, _) => a,
        }
    }

    fn append(self, other: List<A>) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => other,
            List::Cons(a, as_) => List::Cons(a, Rc::new(Rc::unwrap_or_clone(as_).append(other))),
        }
    }

    fn take(self, n: i64) -> List<A>
    where
        A: Clone,
    {
        if n == 0 {
            return List::Nil;
        }

        match self {
            List::Nil => panic!("Cannot take from empty list"),
            List::Cons(a, as_) => List::Cons(a, Rc::new(Rc::unwrap_or_clone(as_).take(n - 1))),
        }
    }

    fn filter(self, f: &impl Fn(&A) -> bool) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(a, as_) => {
                if f(&a) {
                    List::Cons(a, Rc::new(Rc::unwrap_or_clone(as_).filter(f)))
                } else {
                    Rc::unwrap_or_clone(as_).filter(f)
                }
            }
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

fn expand(a: i64, b: i64, c: i64, d: i64, e: i64, f: i64) -> i64 {
    f + 10 * e + 100 * d + 1000 * c + 10000 * b + 100000 * a
}

fn enum_from_to(from: i64, to: i64) -> List<i64> {
    if to >= from {
        List::Cons(from, Rc::new(enum_from_to(from + 1, to)))
    } else {
        List::Nil
    }
}

fn condition(thirywelvn: &List<i64>) -> bool {
    match thirywelvn {
        List::Nil => false,
        List::Cons(t, ts) => match ts.as_ref() {
            List::Nil => false,
            List::Cons(h, hs) => match hs.as_ref() {
                List::Nil => false,
                List::Cons(i, is) => match is.as_ref() {
                    List::Nil => false,
                    List::Cons(r, rs) => match rs.as_ref() {
                        List::Nil => false,
                        List::Cons(y, ys) => match ys.as_ref() {
                            List::Nil => false,
                            List::Cons(w, ws) => match ws.as_ref() {
                                List::Nil => false,
                                List::Cons(e, es) => match es.as_ref() {
                                    List::Nil => false,
                                    List::Cons(l, ls) => match ls.as_ref() {
                                        List::Nil => false,
                                        List::Cons(v, vs) => match vs.as_ref() {
                                            List::Nil => false,
                                            List::Cons(n, ns) => match ns.as_ref() {
                                                List::Nil => {
                                                    expand(*t, *h, *i, *r, *t, *y)
                                                        + (5 * expand(*t, *w, *e, *l, *v, *e))
                                                        == expand(*n, *i, *n, *e, *t, *y)
                                                }
                                                List::Cons(_, _) => false,
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    }
}

fn push_k(p1: List<List<i64>>, k: i64) -> List<List<i64>> {
    match p1 {
        List::Nil => List::Nil,
        List::Cons(h1, t1) => List::Cons(
            List::Cons(k, Rc::new(h1)),
            Rc::new(push_k(Rc::unwrap_or_clone(t1), k)),
        ),
    }
}

fn addj(j: i64, ls: List<i64>) -> List<List<i64>> {
    match ls {
        List::Nil => List::Cons(List::Cons(j, Rc::new(List::Nil)), Rc::new(List::Nil)),
        List::Cons(k, ks) => List::Cons(
            List::Cons(j, Rc::new(List::Cons(k, ks.clone()))),
            Rc::new(push_k(addj(j, Rc::unwrap_or_clone(ks)), k)),
        ),
    }
}

fn addj_ls(p1: List<List<i64>>, j: i64) -> List<List<i64>> {
    match p1 {
        List::Nil => List::Nil,
        List::Cons(pjs, t1) => addj(j, pjs).append(addj_ls(Rc::unwrap_or_clone(t1), j)),
    }
}

fn permutations(ls: List<i64>) -> List<List<i64>> {
    match ls {
        List::Nil => List::Cons(List::Nil, Rc::new(List::Nil)),
        List::Cons(j, ls) => addj_ls(permutations(Rc::unwrap_or_clone(ls)), j),
    }
}

fn test_cryptarithm_nofib(n: i64) -> List<List<List<i64>>> {
    enum_from_to(1, n)
        .map(&|i| permutations(enum_from_to(0, 9 + i).take(10)).filter(&|l| condition(l)))
}

fn main_loop(iters: u64, n: i64) {
    let res = test_cryptarithm_nofib(n);
    if iters == 1 {
        println!("{}", res.head().head().head());
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
        .expect("m must be a number");
    main_loop(iters, n)
}
