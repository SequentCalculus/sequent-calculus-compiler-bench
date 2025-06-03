use std::rc::Rc;

#[derive(Clone)]
enum List<T> {
    Nil,
    Cons(T, Rc<List<T>>),
}

impl<T> List<T> {
    fn three(self) -> Option<(T, T, T)>
    where
        T: Clone,
    {
        match self {
            List::Nil => None,
            List::Cons(t1, ts1) => match Rc::unwrap_or_clone(ts1) {
                List::Nil => None,
                List::Cons(t2, ts2) => match Rc::unwrap_or_clone(ts2) {
                    List::Nil => None,
                    List::Cons(t3, ts3) => match Rc::unwrap_or_clone(ts3) {
                        List::Nil => Some((t1, t2, t3)),
                        List::Cons(_, _) => None,
                    },
                },
            },
        }
    }

    fn contains(&self, t: &T) -> bool
    where
        T: PartialEq,
    {
        match self {
            List::Nil => false,
            List::Cons(t1, ts) => {
                if t1 == t {
                    true
                } else {
                    ts.contains(t)
                }
            }
        }
    }

    fn all(self, f: impl Fn(T) -> bool) -> bool
    where
        T: Clone,
    {
        match self {
            List::Nil => true,
            List::Cons(t, ts) => {
                if f(t) {
                    Rc::unwrap_or_clone(ts).all(f)
                } else {
                    false
                }
            }
        }
    }

    fn map<U>(self, f: impl Fn(T) -> U) -> List<U>
    where
        T: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(t, ts) => List::Cons(f(t), Rc::new(Rc::unwrap_or_clone(ts).map(f))),
        }
    }
}

impl<T> PartialEq for List<T>
where
    T: PartialEq,
{
    fn eq(&self, other: &List<T>) -> bool {
        match (self, other) {
            (List::Nil, List::Nil) => true,
            (List::Cons(t1, ts1), List::Cons(t2, ts2)) => t1 == t2 && ts1 == ts2,
            _ => false,
        }
    }
}

impl<T> Eq for List<T> where T: Eq {}

impl<T> From<Vec<T>> for List<T> {
    fn from(mut v: Vec<T>) -> List<T> {
        if v.is_empty() {
            return List::Nil;
        }
        let fst = v.remove(0);
        List::Cons(fst, Rc::new(v.into()))
    }
}

#[derive(PartialEq, Eq, Clone, Copy)]
enum Id {
    A,
    B,
    C,
    D,
    X,
    Y,
    Z,
    U,
    W,
    ADD1,
    AND,
    APPEND,
    CONS,
    DIFFERENCE,
    EQUAL,
    F,
    FALSE,
    FOUR,
    IF,
    IMPLIES,
    LENGTH,
    LESSP,
    MEMBER,
    NIL,
    NOT,
    ONE,
    OR,
    PLUS,
    QUOTIENT,
    REMAINDER,
    REVERSE,
    TIMES,
    TRUE,
    TWO,
    ZERO,
    ZEROP,
}

#[derive(Clone)]
enum Term<'a> {
    Var(Id),
    Fun(
        Id,
        Rc<List<Term<'a>>>,
        &'a dyn Fn() -> List<(Term<'a>, Term<'a>)>,
    ),
    ERROR,
}

impl<'a> PartialEq for Term<'a> {
    fn eq(&self, other: &Term<'a>) -> bool {
        match (self, other) {
            (Term::Var(id1), Term::Var(id2)) => id1 == id2,
            (Term::Fun(id1, ts1, _), Term::Fun(id2, ts2, _)) => id1 == id2 && ts1 == ts2,
            _ => false,
        }
    }
}

impl<'a> Eq for Term<'a> {}

fn boyer_a<'a>() -> Term<'a> {
    Term::Var(Id::A)
}

fn boyer_b<'a>() -> Term<'a> {
    Term::Var(Id::B)
}

fn boyer_c<'a>() -> Term<'a> {
    Term::Var(Id::C)
}

fn boyer_d<'a>() -> Term<'a> {
    Term::Var(Id::D)
}

fn boyer_x<'a>() -> Term<'a> {
    Term::Var(Id::X)
}

fn boyer_y<'a>() -> Term<'a> {
    Term::Var(Id::Y)
}

fn boyer_z<'a>() -> Term<'a> {
    Term::Var(Id::Z)
}

fn boyer_u<'a>() -> Term<'a> {
    Term::Var(Id::U)
}

fn boyer_w<'a>() -> Term<'a> {
    Term::Var(Id::W)
}

fn boyer_false<'a>() -> Term<'a> {
    Term::Fun(Id::FALSE, Rc::new(List::Nil), &|| List::Nil)
}

fn boyer_nil<'a>() -> Term<'a> {
    Term::Fun(Id::NIL, Rc::new(List::Nil), &|| List::Nil)
}

fn boyer_true<'a>() -> Term<'a> {
    Term::Fun(Id::TRUE, Rc::new(List::Nil), &|| List::Nil)
}

fn boyer_zero<'a>() -> Term<'a> {
    Term::Fun(Id::ZERO, Rc::new(List::Nil), &|| List::Nil)
}

fn boyer_one<'a>() -> Term<'a> {
    Term::Fun(Id::ONE, Rc::new(List::Nil), &|| {
        vec![(boyer_one(), boyer_add1(boyer_zero()))].into()
    })
}

fn boyer_two<'a>() -> Term<'a> {
    Term::Fun(Id::TWO, Rc::new(List::Nil), &|| {
        vec![(boyer_two(), boyer_add1(boyer_one()))].into()
    })
}

fn boyer_four<'a>() -> Term<'a> {
    Term::Fun(Id::FOUR, Rc::new(List::Nil), &|| {
        vec![(boyer_four(), boyer_add1(boyer_add1(boyer_two())))].into()
    })
}

fn boyer_add1<'a>(a: Term<'a>) -> Term<'a> {
    Term::Fun(
        Id::ADD1,
        Rc::new(List::Cons(a, Rc::new(List::Nil))),
        &|| List::Nil,
    )
}

fn boyer_if<'a>(a: Term<'a>, b: Term<'a>, c: Term<'a>) -> Term<'a> {
    Term::Fun(Id::IF, Rc::new(vec![a, b, c].into()), &|| {
        vec![(
            boyer_if(
                boyer_if(boyer_x(), boyer_y(), boyer_z()),
                boyer_u(),
                boyer_w(),
            ),
            boyer_if(
                boyer_x(),
                boyer_if(boyer_y(), boyer_u(), boyer_w()),
                boyer_if(boyer_z(), boyer_u(), boyer_w()),
            ),
        )]
        .into()
    })
}

fn boyer_not<'a>(a: Term<'a>) -> Term<'a> {
    Term::Fun(Id::NOT, Rc::new(vec![a].into()), &|| {
        vec![(
            boyer_not(boyer_x()),
            boyer_if(boyer_x(), boyer_true(), boyer_false()),
        )]
        .into()
    })
}

fn boyer_and<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::AND, Rc::new(vec![a, b].into()), &|| {
        vec![(
            boyer_and(boyer_x(), boyer_y()),
            boyer_if(
                boyer_x(),
                boyer_if(boyer_y(), boyer_true(), boyer_false()),
                boyer_false(),
            ),
        )]
        .into()
    })
}

fn boyer_append<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::APPEND, Rc::new(vec![a, b].into()), &|| {
        vec![(
            boyer_append(boyer_append(boyer_x(), boyer_y()), boyer_z()),
            boyer_append(boyer_x(), boyer_append(boyer_y(), boyer_z())),
        )]
        .into()
    })
}

fn boyer_cons<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::CONS, Rc::new(vec![a, b].into()), &|| List::Nil)
}

fn boyer_difference<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::DIFFERENCE, Rc::new(vec![a, b].into()), &|| {
        vec![
            (boyer_difference(boyer_x(), boyer_x()), boyer_zero()),
            (
                boyer_difference(boyer_plus(boyer_x(), boyer_y()), boyer_x()),
                boyer_y(),
            ),
            (
                boyer_difference(boyer_plus(boyer_y(), boyer_x()), boyer_x()),
                boyer_y(),
            ),
            (
                boyer_difference(
                    boyer_plus(boyer_x(), boyer_y()),
                    boyer_plus(boyer_x(), boyer_z()),
                ),
                boyer_difference(boyer_y(), boyer_z()),
            ),
            (
                boyer_difference(
                    boyer_plus(boyer_y(), boyer_plus(boyer_x(), boyer_z())),
                    boyer_x(),
                ),
                boyer_plus(boyer_y(), boyer_z()),
            ),
            (
                boyer_difference(boyer_add1(boyer_plus(boyer_y(), boyer_z())), boyer_z()),
                boyer_add1(boyer_y()),
            ),
            (
                boyer_difference(boyer_add1(boyer_add1(boyer_x())), boyer_two()),
                boyer_x(),
            ),
        ]
        .into()
    })
}

fn boyer_equal<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::EQUAL, Rc::new(vec![a, b].into()), &|| {
        vec![
            (
                boyer_equal(boyer_plus(boyer_x(), boyer_y()), boyer_zero()),
                boyer_and(boyer_zerop(boyer_x()), boyer_zerop(boyer_y())),
            ),
            (
                boyer_equal(
                    boyer_plus(boyer_x(), boyer_y()),
                    boyer_plus(boyer_x(), boyer_z()),
                ),
                boyer_equal(boyer_y(), boyer_z()),
            ),
            (
                boyer_equal(boyer_zero(), boyer_difference(boyer_x(), boyer_y())),
                boyer_not(boyer_lessp(boyer_y(), boyer_z())),
            ),
            (
                boyer_equal(boyer_x(), boyer_difference(boyer_x(), boyer_y())),
                boyer_or(boyer_equal(boyer_x(), boyer_zero()), boyer_zerop(boyer_y())),
            ),
            (
                boyer_equal(boyer_x(), boyer_difference(boyer_x(), boyer_y())),
                boyer_or(boyer_equal(boyer_x(), boyer_zero()), boyer_zerop(boyer_y())),
            ),
            (
                boyer_equal(boyer_times(boyer_x(), boyer_y()), boyer_zero()),
                boyer_or(boyer_zerop(boyer_x()), boyer_zerop(boyer_y())),
            ),
            (
                boyer_equal(
                    boyer_append(boyer_x(), boyer_y()),
                    boyer_append(boyer_x(), boyer_z()),
                ),
                boyer_equal(boyer_y(), boyer_z()),
            ),
            (
                boyer_equal(boyer_y(), boyer_times(boyer_x(), boyer_y())),
                boyer_or(
                    boyer_equal(boyer_y(), boyer_zero()),
                    boyer_equal(boyer_x(), boyer_one()),
                ),
            ),
            (
                boyer_equal(boyer_x(), boyer_times(boyer_x(), boyer_y())),
                boyer_or(
                    boyer_equal(boyer_x(), boyer_zero()),
                    boyer_equal(boyer_y(), boyer_one()),
                ),
            ),
            (
                boyer_equal(boyer_times(boyer_x(), boyer_y()), boyer_one()),
                boyer_and(
                    boyer_equal(boyer_x(), boyer_one()),
                    boyer_equal(boyer_y(), boyer_one()),
                ),
            ),
            (
                boyer_equal(
                    boyer_difference(boyer_x(), boyer_y()),
                    boyer_difference(boyer_z(), boyer_y()),
                ),
                boyer_if(
                    boyer_lessp(boyer_x(), boyer_y()),
                    boyer_not(boyer_lessp(boyer_y(), boyer_z())),
                    boyer_if(
                        boyer_lessp(boyer_z(), boyer_y()),
                        boyer_not(boyer_lessp(boyer_y(), boyer_x())),
                        boyer_equal(boyer_x(), boyer_z()),
                    ),
                ),
            ),
            (
                boyer_equal(boyer_lessp(boyer_x(), boyer_y()), boyer_z()),
                boyer_if(
                    boyer_lessp(boyer_x(), boyer_y()),
                    boyer_equal(boyer_true(), boyer_z()),
                    boyer_equal(boyer_false(), boyer_z()),
                ),
            ),
        ]
        .into()
    })
}

fn boyer_f<'a>(a: Term<'a>) -> Term<'a> {
    Term::Fun(Id::F, Rc::new(vec![a].into()), &|| List::Nil)
}

fn boyer_implies<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::IMPLIES, Rc::new(vec![a, b].into()), &|| {
        vec![(
            boyer_implies(boyer_x(), boyer_y()),
            boyer_if(
                boyer_x(),
                boyer_if(boyer_y(), boyer_true(), boyer_false()),
                boyer_true(),
            ),
        )]
        .into()
    })
}

fn boyer_length<'a>(a: Term<'a>) -> Term<'a> {
    Term::Fun(Id::LENGTH, Rc::new(vec![a].into()), &|| {
        vec![
            (
                boyer_length(boyer_reverse(boyer_x())),
                boyer_length(boyer_x()),
            ),
            (
                boyer_length(boyer_cons(
                    boyer_x(),
                    boyer_cons(
                        boyer_y(),
                        boyer_cons(boyer_z(), boyer_cons(boyer_y(), boyer_w())),
                    ),
                )),
                boyer_plus(boyer_four(), boyer_length(boyer_w())),
            ),
        ]
        .into()
    })
}

fn boyer_lessp<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::LESSP, Rc::new(vec![a, b].into()), &|| {
        vec![
            (
                boyer_lessp(boyer_remainder(boyer_x(), boyer_y()), boyer_y()),
                boyer_not(boyer_zerop(boyer_y())),
            ),
            (
                boyer_lessp(boyer_quotient(boyer_x(), boyer_y()), boyer_x()),
                boyer_and(
                    boyer_not(boyer_zerop(boyer_x())),
                    boyer_lessp(boyer_one(), boyer_y()),
                ),
            ),
            (
                boyer_lessp(
                    boyer_plus(boyer_x(), boyer_y()),
                    boyer_plus(boyer_x(), boyer_z()),
                ),
                boyer_lessp(boyer_y(), boyer_z()),
            ),
            (
                boyer_lessp(
                    boyer_times(boyer_x(), boyer_z()),
                    boyer_times(boyer_y(), boyer_z()),
                ),
                boyer_and(
                    boyer_not(boyer_zerop(boyer_z())),
                    boyer_lessp(boyer_x(), boyer_y()),
                ),
            ),
            (
                boyer_lessp(boyer_y(), boyer_plus(boyer_x(), boyer_y())),
                boyer_not(boyer_zerop(boyer_x())),
            ),
        ]
        .into()
    })
}

fn boyer_member<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::MEMBER, Rc::new(vec![a, b].into()), &|| {
        vec![
            (
                boyer_member(boyer_x(), boyer_append(boyer_y(), boyer_z())),
                boyer_or(
                    boyer_member(boyer_x(), boyer_y()),
                    boyer_member(boyer_x(), boyer_z()),
                ),
            ),
            (
                boyer_member(boyer_x(), boyer_reverse(boyer_y())),
                boyer_member(boyer_x(), boyer_y()),
            ),
        ]
        .into()
    })
}

fn boyer_or<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::OR, Rc::new(vec![a, b].into()), &|| {
        vec![(
            boyer_or(boyer_x(), boyer_y()),
            boyer_if(
                boyer_x(),
                boyer_true(),
                boyer_if(boyer_y(), boyer_true(), boyer_false()),
            ),
        )]
        .into()
    })
}

fn boyer_plus<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::PLUS, Rc::new(vec![a, b].into()), &|| {
        vec![
            (
                boyer_plus(boyer_plus(boyer_x(), boyer_y()), boyer_z()),
                boyer_plus(boyer_x(), boyer_plus(boyer_y(), boyer_z())),
            ),
            (
                boyer_plus(
                    boyer_remainder(boyer_x(), boyer_y()),
                    boyer_times(boyer_y(), boyer_quotient(boyer_x(), boyer_y())),
                ),
                boyer_x(),
            ),
            (
                boyer_plus(boyer_x(), boyer_add1(boyer_y())),
                boyer_add1(boyer_plus(boyer_x(), boyer_y())),
            ),
        ]
        .into()
    })
}

fn boyer_quotient<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::QUOTIENT, Rc::new(vec![a, b].into()), &|| {
        vec![
            (
                boyer_quotient(
                    boyer_plus(boyer_x(), boyer_plus(boyer_x(), boyer_y())),
                    boyer_two(),
                ),
                boyer_plus(boyer_x(), boyer_quotient(boyer_y(), boyer_two())),
            ),
            (
                boyer_quotient(boyer_times(boyer_y(), boyer_x()), boyer_y()),
                boyer_if(boyer_zerop(boyer_y()), boyer_zero(), boyer_x()),
            ),
        ]
        .into()
    })
}

fn boyer_remainder<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::REMAINDER, Rc::new(vec![a, b].into()), &|| {
        vec![
            (boyer_remainder(boyer_x(), boyer_one()), boyer_zero()),
            (boyer_remainder(boyer_x(), boyer_x()), boyer_zero()),
            (
                boyer_remainder(boyer_times(boyer_x(), boyer_y()), boyer_x()),
                boyer_zero(),
            ),
            (
                boyer_remainder(boyer_times(boyer_x(), boyer_y()), boyer_y()),
                boyer_zero(),
            ),
        ]
        .into()
    })
}

fn boyer_reverse<'a>(a: Term<'a>) -> Term<'a> {
    Term::Fun(Id::REVERSE, Rc::new(vec![a].into()), &|| {
        vec![(
            boyer_reverse(boyer_append(boyer_x(), boyer_y())),
            boyer_append(boyer_reverse(boyer_y()), boyer_reverse(boyer_x())),
        )]
        .into()
    })
}

fn boyer_times<'a>(a: Term<'a>, b: Term<'a>) -> Term<'a> {
    Term::Fun(Id::TIMES, Rc::new(vec![a, b].into()), &|| {
        vec![
            (
                boyer_times(boyer_x(), boyer_plus(boyer_y(), boyer_z())),
                boyer_plus(
                    boyer_times(boyer_x(), boyer_y()),
                    boyer_times(boyer_x(), boyer_z()),
                ),
            ),
            (
                boyer_times(boyer_times(boyer_x(), boyer_y()), boyer_z()),
                boyer_times(boyer_x(), boyer_times(boyer_y(), boyer_z())),
            ),
            (
                boyer_times(boyer_x(), boyer_difference(boyer_y(), boyer_z())),
                boyer_difference(
                    boyer_times(boyer_y(), boyer_x()),
                    boyer_times(boyer_z(), boyer_x()),
                ),
            ),
            (
                boyer_times(boyer_x(), boyer_add1(boyer_y())),
                boyer_plus(boyer_x(), boyer_times(boyer_x(), boyer_y())),
            ),
        ]
        .into()
    })
}

fn boyer_zerop<'a>(a: Term<'a>) -> Term<'a> {
    Term::Fun(Id::ZEROP, Rc::new(vec![a].into()), &|| {
        vec![(boyer_zerop(boyer_x()), boyer_equal(boyer_x(), boyer_zero()))].into()
    })
}

fn find<'a>(vid: &Id, ls: List<(Id, Term<'a>)>) -> (bool, Term<'a>) {
    match ls {
        List::Nil => (false, Term::ERROR),
        List::Cons((vid2, val2), bs) => {
            if *vid == vid2 {
                (true, val2)
            } else {
                find(vid, Rc::unwrap_or_clone(bs))
            }
        }
    }
}

fn one_way_unify1<'a>(
    t1: Term<'a>,
    t2: Term<'a>,
    subst: List<(Id, Term<'a>)>,
) -> (bool, List<(Id, Term<'a>)>) {
    match t2 {
        Term::Var(vid2) => {
            let (found, v2) = find(&vid2, subst.clone());
            if found {
                (t1 == v2, subst)
            } else {
                (true, List::Cons((vid2, t1), Rc::new(subst)))
            }
        }
        Term::Fun(f2, as2, _) => {
            if let Term::Fun(f1, as1, _) = t1 {
                if f1 == f2 {
                    one_way_unify1_lst(Rc::unwrap_or_clone(as1), Rc::unwrap_or_clone(as2), subst)
                } else {
                    (false, List::Nil)
                }
            } else {
                (false, List::Nil)
            }
        }
        _ => (false, List::Nil),
    }
}

fn one_way_unify1_lst<'a>(
    tts1: List<Term<'a>>,
    tts2: List<Term<'a>>,
    subst: List<(Id, Term<'a>)>,
) -> (bool, List<(Id, Term<'a>)>) {
    match (tts1, tts2) {
        (List::Nil, List::Nil) => (true, subst),
        (List::Nil, _) => (false, subst),
        (_, List::Nil) => (false, subst),
        (List::Cons(t1, tts1), List::Cons(t2, tts2)) => {
            let (hd_ok, subst_) = one_way_unify1(t1, t2, subst);
            let (tl_ok, subst__) =
                one_way_unify1_lst(Rc::unwrap_or_clone(tts1), Rc::unwrap_or_clone(tts2), subst_);
            (hd_ok && tl_ok, subst__)
        }
    }
}

fn one_way_unify<'a>(t1: Term<'a>, t2: Term<'a>) -> (bool, List<(Id, Term<'a>)>) {
    one_way_unify1(t1, t2, List::Nil)
}

fn rewrite_with_lemmas<'a>(t: Term<'a>, lss: List<(Term<'a>, Term<'a>)>) -> Term<'a> {
    match lss {
        List::Nil => t,
        List::Cons((lhs, rhs), lss) => {
            let (unified, subst) = one_way_unify(t.clone(), lhs);
            if unified {
                rewrite(apply_subst(subst, rhs))
            } else {
                rewrite_with_lemmas(t, Rc::unwrap_or_clone(lss))
            }
        }
    }
}

fn rewrite<'a>(t: Term<'a>) -> Term<'a> {
    match t {
        Term::Var(v) => Term::Var(v),
        Term::Fun(f, args, lemmas) => rewrite_with_lemmas(
            Term::Fun(f, Rc::new(Rc::unwrap_or_clone(args).map(rewrite)), lemmas),
            lemmas(),
        ),
        Term::ERROR => Term::ERROR,
    }
}

fn truep<'a>(x: &Term<'a>, l: &List<Term<'a>>) -> bool {
    match x {
        Term::Fun(Id::TRUE, _, _) => true,
        _ => l.contains(x),
    }
}

fn falsep<'a>(x: &Term<'a>, l: &List<Term<'a>>) -> bool {
    match x {
        Term::Fun(Id::FALSE, _, _) => true,
        _ => l.contains(x),
    }
}

fn tautologyp<'a>(x: Term<'a>, true_lst: List<Term<'a>>, false_lst: List<Term<'a>>) -> bool {
    if truep(&x, &true_lst) {
        true
    } else if falsep(&x, &false_lst) {
        false
    } else if let Term::Fun(Id::IF, args, _) = x {
        let (cond, t, e) = match Rc::unwrap_or_clone(args).three() {
            None => return false,
            Some(cs) => cs,
        };

        if truep(&cond, &true_lst) {
            return tautologyp(t, true_lst, false_lst);
        }

        if falsep(&cond, &false_lst) {
            return tautologyp(t, true_lst, false_lst);
        }

        let new_tru = List::Cons(cond.clone(), Rc::new(true_lst.clone()));

        let new_fls = List::Cons(cond, Rc::new(false_lst.clone()));

        tautologyp(t, new_tru, false_lst) && tautologyp(e, true_lst, new_fls)
    } else {
        false
    }
}

fn apply_subst<'a>(subst: List<(Id, Term<'a>)>, t: Term<'a>) -> Term<'a> {
    match t {
        Term::Var(vid) => {
            let (found, value) = find(&vid, subst);
            if found {
                value
            } else {
                Term::Var(vid)
            }
        }
        Term::Fun(f, args, ls) => Term::Fun(
            f,
            Rc::new(Rc::unwrap_or_clone(args).map(|t| apply_subst(subst.clone(), t))),
            ls,
        ),
        Term::ERROR => Term::ERROR,
    }
}

fn tautp<'a>(x: Term<'a>) -> bool {
    tautologyp(rewrite(x), List::Nil, List::Nil)
}

fn test0<'a>(xxxx: Term<'a>) -> bool {
    let subst0 = vec![
        (
            Id::X,
            boyer_f(boyer_plus(
                boyer_plus(boyer_a(), boyer_b()),
                boyer_plus(boyer_c(), boyer_zero()),
            )),
        ),
        (
            Id::Y,
            boyer_f(boyer_times(
                boyer_times(boyer_a(), boyer_b()),
                boyer_plus(boyer_c(), boyer_d()),
            )),
        ),
        (
            Id::Z,
            boyer_f(boyer_reverse(boyer_append(
                boyer_append(boyer_a(), boyer_b()),
                boyer_nil(),
            ))),
        ),
        (
            Id::U,
            boyer_equal(
                boyer_plus(boyer_a(), boyer_b()),
                boyer_difference(boyer_x(), boyer_y()),
            ),
        ),
        (
            Id::W,
            boyer_lessp(
                boyer_remainder(boyer_a(), boyer_b()),
                boyer_member(boyer_a(), boyer_length(boyer_b())),
            ),
        ),
    ]
    .into();
    let theorem = boyer_implies(
        boyer_and(
            boyer_implies(xxxx, boyer_y()),
            boyer_and(
                boyer_implies(boyer_y(), boyer_z()),
                boyer_and(
                    boyer_implies(boyer_z(), boyer_u()),
                    boyer_implies(boyer_u(), boyer_w()),
                ),
            ),
        ),
        boyer_implies(boyer_x(), boyer_w()),
    );
    tautp(apply_subst(subst0, theorem))
}

fn replicate_term<'a>(n: u64, t: Term<'a>) -> List<Term<'a>> {
    if n == 0 {
        List::Nil
    } else {
        List::Cons(t.clone(), Rc::new(replicate_term(n - 1, t)))
    }
}

fn test_boyer_nofib(n: u64) -> bool {
    let ts = replicate_term(n, Term::Var(Id::X));
    ts.all(|t| test0(t))
}

fn main_loop(iters: u64, n: u64) {
    let mut res = test_boyer_nofib(n);
    for _ in 1..iters {
        res = test_boyer_nofib(n)
    }
    println!("{}", if res { 1 } else { -1 });
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
