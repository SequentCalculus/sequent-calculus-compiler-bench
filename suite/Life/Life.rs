use std::rc::Rc;

#[derive(Clone)]
enum List<T> {
    Nil,
    Cons(T, Rc<List<T>>),
}

impl<T> List<T> {
    fn fold<U>(self, start: U, f: &impl Fn(U, T) -> U) -> U
    where
        T: Clone,
    {
        match self {
            List::Nil => start,
            List::Cons(hd, tl) => Rc::unwrap_or_clone(tl).fold(f(start, hd), f),
        }
    }

    fn revonto(self, y: List<T>) -> List<T>
    where
        T: Clone,
    {
        self.fold(y, &|t, h| List::Cons(h, Rc::new(t)))
    }

    fn collect_accum(self, sofar: List<T>, f: &impl Fn(T) -> List<T>) -> List<T>
    where
        T: Clone,
    {
        match self {
            List::Nil => sofar,
            List::Cons(p, xs) => Rc::unwrap_or_clone(xs).collect_accum(sofar.revonto(f(p)), f),
        }
    }

    fn collect(self, f: &impl Fn(T) -> List<T>) -> List<T>
    where
        T: Clone,
    {
        self.collect_accum(List::Nil, f)
    }

    fn append(self, other: List<T>) -> List<T>
    where
        T: Clone,
    {
        match self {
            List::Nil => other,
            List::Cons(hd, tl) => List::Cons(hd, Rc::new(Rc::unwrap_or_clone(tl).append(other))),
        }
    }

    fn map<U>(self, f: &impl Fn(T) -> U) -> List<U>
    where
        T: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(hd, tl) => List::Cons(f(hd), Rc::new(Rc::unwrap_or_clone(tl).map(f))),
        }
    }

    fn exists(&self, f: &dyn for<'a> Fn(&'a T) -> bool) -> bool {
        match self {
            List::Nil => false,
            List::Cons(hd, tl) => {
                if f(&hd) {
                    true
                } else {
                    tl.exists(f)
                }
            }
        }
    }

    fn len(&self) -> i64 {
        match self {
            List::Nil => 0,
            List::Cons(_, tl) => 1 + tl.len(),
        }
    }

    fn member(&self, t: &T) -> bool
    where
        T: PartialEq,
    {
        self.exists(&|t1| *t == *t1)
    }

    fn filter(self, f: &dyn for<'a> Fn(&'a T) -> bool) -> List<T>
    where
        T: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(hd, tl) => {
                if f(&hd) {
                    List::Cons(hd, Rc::new(Rc::unwrap_or_clone(tl).filter(f)))
                } else {
                    Rc::unwrap_or_clone(tl).filter(f)
                }
            }
        }
    }

    fn diff(self, y: List<T>) -> List<T>
    where
        T: Clone + PartialEq,
    {
        self.filter(&|p| !y.member(&p))
    }
}

struct Gen {
    coordslist: List<(i64, i64)>,
}

impl Gen {
    fn alive(self) -> List<(i64, i64)> {
        self.coordslist
    }

    fn next(self) -> Gen {
        let living = Rc::new(self.alive());
        let living_ = living.clone();
        let living__ = living.clone();

        let is_alive: &dyn for<'a> Fn(&'a (i64, i64)) -> bool = &move |&p| living_.member(&p);
        let live_neighbors = move |p| neighbors(p).filter(is_alive).len();
        let survivors = Rc::unwrap_or_clone(living__).filter(&|&p| twoorthree(live_neighbors(p)));

        let newbrnlist = Rc::unwrap_or_clone(living)
            .collect(&move |p| neighbors(p).filter(&move |&n| !is_alive(&n)));
        let newborn = occurs3(newbrnlist);

        Gen {
            coordslist: survivors.append(newborn),
        }
    }

    fn nth(self, i: i64) -> Gen {
        if i == 0 {
            self
        } else {
            self.next().nth(i - 1)
        }
    }
}

fn neighbors((fst, snd): (i64, i64)) -> List<(i64, i64)> {
    List::Cons(
        (fst - 1, snd - 1),
        Rc::new(List::Cons(
            (fst - 1, snd),
            Rc::new(List::Cons(
                (fst - 1, snd + 1),
                Rc::new(List::Cons(
                    (fst, snd - 1),
                    Rc::new(List::Cons(
                        (fst, snd + 1),
                        Rc::new(List::Cons(
                            (fst + 1, snd - 1),
                            Rc::new(List::Cons(
                                (fst + 1, snd),
                                Rc::new(List::Cons((fst + 1, snd + 1), Rc::new(List::Nil))),
                            )),
                        )),
                    )),
                )),
            )),
        )),
    )
}

fn twoorthree(n: i64) -> bool {
    n == 2 || n == 3
}

fn collect_neighbors(
    xover: List<(i64, i64)>,
    x3: List<(i64, i64)>,
    x2: List<(i64, i64)>,
    x1: List<(i64, i64)>,
    xs: List<(i64, i64)>,
) -> List<(i64, i64)> {
    match xs {
        List::Nil => x3.diff(xover),
        List::Cons(a, x) => {
            if xover.member(&a) {
                collect_neighbors(xover, x3, x2, x1, Rc::unwrap_or_clone(x))
            } else if x3.member(&a) {
                collect_neighbors(
                    List::Cons(a, Rc::new(xover)),
                    x3,
                    x2,
                    x1,
                    Rc::unwrap_or_clone(x),
                )
            } else if x2.member(&a) {
                collect_neighbors(
                    xover,
                    List::Cons(a, Rc::new(x3)),
                    x2,
                    x1,
                    Rc::unwrap_or_clone(x),
                )
            } else if x1.member(&a) {
                collect_neighbors(
                    xover,
                    x3,
                    List::Cons(a, Rc::new(x2)),
                    x1,
                    Rc::unwrap_or_clone(x),
                )
            } else {
                collect_neighbors(
                    xover,
                    x3,
                    x2,
                    List::Cons(a, Rc::new(x1)),
                    Rc::unwrap_or_clone(x),
                )
            }
        }
    }
}

fn occurs3(l: List<(i64, i64)>) -> List<(i64, i64)> {
    collect_neighbors(List::Nil, List::Nil, List::Nil, List::Nil, l)
}

fn gun() -> Gen {
    let r9 = List::Cons(
        (9, 29),
        Rc::new(List::Cons(
            (9, 30),
            Rc::new(List::Cons(
                (9, 31),
                Rc::new(List::Cons((9, 32), Rc::new(List::Nil))),
            )),
        )),
    );
    let r8 = List::Cons(
        (8, 20),
        Rc::new(List::Cons(
            (8, 28),
            Rc::new(List::Cons(
                (8, 29),
                Rc::new(List::Cons(
                    (8, 30),
                    Rc::new(List::Cons(
                        (8, 31),
                        Rc::new(List::Cons(
                            (8, 40),
                            Rc::new(List::Cons((8, 41), Rc::new(r9))),
                        )),
                    )),
                )),
            )),
        )),
    );
    let r7 = List::Cons(
        (7, 19),
        Rc::new(List::Cons(
            (7, 21),
            Rc::new(List::Cons(
                (7, 28),
                Rc::new(List::Cons(
                    (7, 31),
                    Rc::new(List::Cons(
                        (7, 40),
                        Rc::new(List::Cons((7, 41), Rc::new(r8))),
                    )),
                )),
            )),
        )),
    );
    let r6 = List::Cons(
        (6, 7),
        Rc::new(List::Cons(
            (6, 8),
            Rc::new(List::Cons(
                (6, 18),
                Rc::new(List::Cons(
                    (6, 22),
                    Rc::new(List::Cons(
                        (6, 23),
                        Rc::new(List::Cons(
                            (6, 28),
                            Rc::new(List::Cons(
                                (6, 29),
                                Rc::new(List::Cons(
                                    (6, 30),
                                    Rc::new(List::Cons(
                                        (6, 31),
                                        Rc::new(List::Cons((6, 36), Rc::new(r7))),
                                    )),
                                )),
                            )),
                        )),
                    )),
                )),
            )),
        )),
    );
    let r5 = List::Cons(
        (5, 7),
        Rc::new(List::Cons(
            (5, 8),
            Rc::new(List::Cons(
                (5, 18),
                Rc::new(List::Cons(
                    (5, 22),
                    Rc::new(List::Cons(
                        (5, 23),
                        Rc::new(List::Cons(
                            (5, 29),
                            Rc::new(List::Cons(
                                (5, 30),
                                Rc::new(List::Cons(
                                    (5, 31),
                                    Rc::new(List::Cons(
                                        (5, 32),
                                        Rc::new(List::Cons((5, 36), Rc::new(r6))),
                                    )),
                                )),
                            )),
                        )),
                    )),
                )),
            )),
        )),
    );
    let r4 = List::Cons(
        (4, 18),
        Rc::new(List::Cons(
            (4, 22),
            Rc::new(List::Cons(
                (4, 23),
                Rc::new(List::Cons((4, 32), Rc::new(r5))),
            )),
        )),
    );
    let r3 = List::Cons((3, 19), Rc::new(List::Cons((3, 21), Rc::new(r4))));
    let r2 = List::Cons((2, 20), Rc::new(r3));
    Gen { coordslist: r2 }
}

fn at_pos(coordslist: List<(i64, i64)>, (fst2, snd2): (i64, i64)) -> List<(i64, i64)> {
    let move_ = move |(fst1, snd1)| (fst1 + fst2, snd1 + snd2);
    coordslist.map(&move_)
}

const CENTER_LINE: i64 = 5;

fn bail() -> List<(i64, i64)> {
    List::Cons(
        (0, 0),
        Rc::new(List::Cons(
            (0, 1),
            Rc::new(List::Cons(
                (1, 0),
                Rc::new(List::Cons((1, 1), Rc::new(List::Nil))),
            )),
        )),
    )
}

fn shuttle() -> List<(i64, i64)> {
    let r4 = List::Cons(
        (4, 1),
        Rc::new(List::Cons(
            (4, 0),
            Rc::new(List::Cons(
                (4, 5),
                Rc::new(List::Cons((4, 6), Rc::new(List::Nil))),
            )),
        )),
    );
    let r3 = List::Cons(
        (3, 2),
        Rc::new(List::Cons((3, 3), Rc::new(List::Cons((3, 4), Rc::new(r4))))),
    );
    let r2 = List::Cons((2, 1), Rc::new(List::Cons((2, 5), Rc::new(r3))));
    let r1 = List::Cons((1, 2), Rc::new(List::Cons((1, 4), Rc::new(r2))));
    List::Cons((0, 3), Rc::new(r1))
}

fn non_steady() -> Gen {
    Gen {
        coordslist: at_pos(bail(), (1, CENTER_LINE))
            .append(at_pos(bail(), (21, CENTER_LINE)))
            .append(at_pos(shuttle(), (6, CENTER_LINE - 2))),
    }
}

fn go_gun() -> Box<dyn Fn(i64) -> Gen> {
    Box::new(|steps| gun().nth(steps))
}

fn go_shuttle() -> Box<dyn Fn(i64) -> Gen> {
    Box::new(|steps| non_steady().nth(steps))
}

fn go_loop(iters: u64, steps: i64, go: Box<dyn Fn(i64) -> Gen>) -> i64 {
    let res = go(steps);
    if iters == 1 {
        res.alive().len() as i64
    } else {
        go_loop(iters - 1, steps, go)
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
    let steps = args
        .next()
        .expect("Missing Argument steps")
        .parse::<i64>()
        .expect("steps must be a number");
    let gun_res = go_loop(iters, steps, go_gun());
    let shuttle_res = go_loop(iters, steps, go_shuttle());
    print!("{}", gun_res);
    println!("{}", shuttle_res);
}
