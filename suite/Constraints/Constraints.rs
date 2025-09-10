use std::rc::Rc;

#[derive(Debug, Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

#[derive(Clone)]
struct Assign {
    varr: i64,
    value: i64,
}

struct CSP {
    vars: i64,
    vals: i64,
    rel: Box<dyn Fn(&Assign, &Assign) -> bool>,
}

#[derive(Clone)]
enum ConflictSet {
    Known(List<i64>),
    Unknown,
}

#[derive(Clone)]
struct Node<T> {
    lab: T,
    children: List<Rc<Node<T>>>,
}

impl<A> List<A> {
    fn map<B>(self, f: &impl Fn(A) -> B) -> List<B>
    where
        A: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(a, as_) => List::Cons(f(a), Rc::new(Rc::unwrap_or_clone(as_).map(f))),
        }
    }

    fn all(&self, f: &impl Fn(&A) -> bool) -> bool {
        match self {
            List::Nil => true,
            List::Cons(a, as_) => {
                if f(a) {
                    as_.all(f)
                } else {
                    false
                }
            }
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

    fn is_empty(&self) -> bool {
        matches!(self, List::Nil)
    }

    fn len(&self) -> usize {
        match self {
            List::Nil => 0,
            List::Cons(_, as_) => 1 + as_.len(),
        }
    }

    fn head(self) -> A {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(a, _) => a,
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

    fn at_index(self, n: usize) -> A
    where
        A: Clone,
    {
        match self {
            List::Nil => panic!("Cannot take {}th element of empty list", n),
            List::Cons(a, as_) => {
                if n == 0 {
                    a
                } else {
                    Rc::unwrap_or_clone(as_).at_index(n - 1)
                }
            }
        }
    }

    fn rev_loop(self, acc: List<A>) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => acc,
            List::Cons(p, ps) => Rc::unwrap_or_clone(ps).rev_loop(List::Cons(p, Rc::new(acc))),
        }
    }

    fn reverse(self) -> List<A>
    where
        A: Clone,
    {
        self.rev_loop(List::Nil)
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

    fn foldl(self, acc: List<A>, f: &impl Fn(List<A>, A) -> List<A>) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => acc,
            List::Cons(h, t) => Rc::unwrap_or_clone(t).foldl(f(acc, h), f),
        }
    }

    fn in_list(&self, a: &A) -> bool
    where
        A: PartialEq,
    {
        match self {
            List::Nil => false,
            List::Cons(a_, as_) => {
                if a_ == a {
                    true
                } else {
                    as_.in_list(a)
                }
            }
        }
    }

    fn not_elem(&self, a: &A) -> bool
    where
        A: PartialEq,
    {
        !self.in_list(a)
    }

    fn nub_by(self, f: impl Fn((A, A)) -> bool) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(h, t) => List::Cons(
                h.clone(),
                Rc::new(
                    Rc::unwrap_or_clone(t)
                        .filter(&|y| !f((h.clone(), y.clone())))
                        .nub_by(f),
                ),
            ),
        }
    }

    fn delete_by(self, x: A, f: impl Fn((A, A)) -> bool) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(y, ys) => {
                if f((x.clone(), y.clone())) {
                    Rc::unwrap_or_clone(ys)
                } else {
                    List::Cons(y, Rc::new(Rc::unwrap_or_clone(ys).delete_by(x, f)))
                }
            }
        }
    }

    fn union_by(self, other: List<A>, f: &impl Fn((A, A)) -> bool) -> List<A>
    where
        A: Clone + PartialEq,
    {
        self.clone().append(
            other
                .nub_by(f)
                .foldl(self, &|acc: List<A>, y| acc.delete_by(y, f)),
        )
    }

    fn union(self, other: List<A>) -> List<A>
    where
        A: Clone + PartialEq,
    {
        self.union_by(other, &|(x, y)| x == y)
    }

    fn zip<B>(self, other: List<B>) -> List<(A, B)>
    where
        A: Clone,
        B: Clone,
    {
        match (self, other) {
            (List::Nil, _) => List::Nil,
            (_, List::Nil) => List::Nil,
            (List::Cons(a, as_), List::Cons(b, bs_)) => List::Cons(
                (a, b),
                Rc::new(Rc::unwrap_or_clone(as_).zip(Rc::unwrap_or_clone(bs_))),
            ),
        }
    }

    fn zip_with<B, C>(self, other: List<B>, f: &impl Fn(A, B) -> C) -> List<C>
    where
        A: Clone,
        B: Clone,
    {
        self.zip(other).map(&|(x, y)| f(x, y))
    }
}

impl<A> List<List<A>>
where
    A: Clone,
{
    fn concat_loop(self, acc: List<A>) -> List<A> {
        match self {
            List::Nil => acc.rev_loop(List::Nil),
            List::Cons(l, ls) => Rc::unwrap_or_clone(ls).concat_loop(l.rev_loop(acc)),
        }
    }

    fn concat(self) -> List<A> {
        self.concat_loop(List::Nil)
    }
}

impl List<i64> {
    pub fn enum_from_to(from: i64, to: i64) -> List<i64> {
        if from <= to {
            List::Cons(from, Rc::new(List::enum_from_to(from + 1, to)))
        } else {
            List::Nil
        }
    }
}

impl<T, A> From<T> for List<A>
where
    T: Iterator<Item = A>,
{
    fn from(it: T) -> List<A> {
        let mut ls = List::Nil;
        for a in it {
            ls = List::Cons(a, Rc::new(ls));
        }
        ls
    }
}

impl<T> Node<T> {
    fn map<U>(self, f: &impl Fn(T) -> U) -> Node<U>
    where
        T: Clone,
    {
        Node {
            lab: f(self.lab),
            children: self
                .children
                .map(&|x| Rc::new(Rc::unwrap_or_clone(x).map(f))),
        }
    }

    fn fold<U>(self, f: &impl Fn(T, List<Node<U>>) -> Node<U>) -> Node<U>
    where
        T: Clone,
    {
        f(
            self.lab,
            self.children.map(&|x| Rc::unwrap_or_clone(x).fold(f)),
        )
    }

    fn filter(self, p: &impl Fn(&T) -> bool) -> Node<T>
    where
        T: Clone,
    {
        let f1 = |a, cs: List<Node<T>>| Node {
            lab: a,
            children: cs.filter(&|x| p(&x.lab)).map(&Rc::new),
        };
        self.fold(&f1)
    }

    fn leaves(self) -> List<T>
    where
        T: Clone,
    {
        match self.children {
            List::Nil => List::Cons(self.lab, Rc::new(List::Nil)),
            _ => self
                .children
                .map(&|x: Rc<Node<T>>| Rc::unwrap_or_clone(x).leaves())
                .concat(),
        }
    }

    fn prune(self, p: &impl Fn(&T) -> bool) -> Node<T>
    where
        T: Clone,
    {
        self.filter(&|x| !(p(x)))
    }
}

fn max_level(s: &List<Assign>) -> i64 {
    match s {
        List::Nil => 0,
        List::Cons(a, _) => a.varr,
    }
}

fn complete(csp: &CSP, s: &List<Assign>) -> bool {
    max_level(s) == csp.vars
}

fn combine(ls: List<(List<Assign>, ConflictSet)>, acc: List<i64>) -> List<i64> {
    match ls {
        List::Nil => acc,
        List::Cons((s, ConflictSet::Known(cs)), css) => {
            if cs.not_elem(&max_level(&s)) {
                cs
            } else {
                combine(Rc::unwrap_or_clone(css), cs.union(acc))
            }
        }
        List::Cons((_, ConflictSet::Unknown), _) => acc,
    }
}

fn init_tree(
    f: &impl Fn(List<Assign>) -> List<List<Assign>>,
    x: List<Assign>,
) -> Node<List<Assign>> {
    let children = f(x.clone()).map(&|y| Rc::new(init_tree(f, y)));
    Node { lab: x, children }
}

fn to_assign(ls: List<i64>, ass: List<Assign>) -> List<List<Assign>> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(j, t1) => List::Cons(
            List::Cons(
                Assign {
                    varr: max_level(&ass) + 1,
                    value: j,
                },
                Rc::new(ass.clone()),
            ),
            Rc::new(to_assign(Rc::unwrap_or_clone(t1), ass)),
        ),
    }
}

fn mk_tree(csp: &CSP) -> Node<List<Assign>> {
    let next = |ss: List<Assign>| {
        if max_level(&ss) < csp.vars {
            to_assign(List::enum_from_to(1, csp.vals), ss)
        } else {
            List::Nil
        }
    };
    init_tree(&next, List::Nil)
}

fn collect_conflict(ls: List<ConflictSet>) -> List<i64> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(ConflictSet::Known(cs), css) => {
            cs.union(collect_conflict(Rc::unwrap_or_clone(css)))
        }
        List::Cons(ConflictSet::Unknown, _) => List::Nil,
    }
}

fn filter_known(
    ls: List<List<ConflictSet>>,
    f: impl Fn(List<ConflictSet>) -> bool,
) -> List<List<ConflictSet>> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(vs, t1) => {
            if vs.all(&known_conflict) {
                List::Cons(vs, Rc::new(filter_known(Rc::unwrap_or_clone(t1), f)))
            } else {
                filter_known(Rc::unwrap_or_clone(t1), f)
            }
        }
    }
}

fn domain_wipeout(
    _: &CSP,
    t: Node<((List<Assign>, ConflictSet), List<List<ConflictSet>>)>,
) -> Node<(List<Assign>, ConflictSet)> {
    let f8 = |((as_, cs), tbl)| {
        let wiped_domains =
            filter_known(tbl, |vs: List<ConflictSet>| vs.all(&|x| known_conflict(x)));
        let cs_ = if wiped_domains.is_empty() {
            cs
        } else {
            let hd = wiped_domains.head();
            ConflictSet::Known(collect_conflict(hd))
        };
        (as_, cs_)
    };
    t.map(&f8)
}

fn check_complete(csp: &CSP, s: &List<Assign>) -> ConflictSet {
    if complete(csp, s) {
        ConflictSet::Known(List::Nil)
    } else {
        ConflictSet::Unknown
    }
}

fn earliest_inconsistency(csp: &CSP, aas: List<Assign>) -> Option<(i64, i64)> {
    match aas {
        List::Nil => None,
        List::Cons(a, aas_) => match Rc::unwrap_or_clone(aas_)
            .reverse()
            .filter(&|x| !((csp.rel)(&a, x)))
        {
            List::Nil => None,
            List::Cons(b, _) => Some((a.varr, b.varr)),
        },
    }
}

fn lookup_cache(
    csp: &CSP,
    t: Node<(List<Assign>, List<List<ConflictSet>>)>,
) -> Node<((List<Assign>, ConflictSet), List<List<ConflictSet>>)> {
    let f5 = |csp, (as_, tbl): (List<Assign>, List<List<ConflictSet>>)| match as_ {
        List::Nil => ((List::Nil, ConflictSet::Unknown), tbl),
        List::Cons(ref a, _) => {
            let table_entry = tbl.clone().head().at_index((a.value - 1) as usize);
            let cs = match table_entry {
                ConflictSet::Unknown => check_complete(csp, &as_),
                ConflictSet::Known(_) => table_entry.clone(),
            };
            ((as_, cs), tbl)
        }
    };
    t.map(&|x| f5(csp, x))
}

fn cache_checks(
    csp: &CSP,
    tbl: List<List<ConflictSet>>,
    n: Node<List<Assign>>,
) -> Node<(List<Assign>, List<List<ConflictSet>>)> {
    let s = n.lab.clone();
    Node {
        lab: (n.lab, tbl.clone()),
        children: n.children.map(&|x| {
            Rc::new(cache_checks(
                csp,
                fill_table(&s, csp, tbl.clone().tail()),
                Rc::unwrap_or_clone(x),
            ))
        }),
    }
}

fn known_solution(c: &ConflictSet) -> bool {
    match c {
        ConflictSet::Known(cs) => cs.is_empty(),
        ConflictSet::Unknown => false,
    }
}

fn known_conflict(c: &ConflictSet) -> bool {
    match c {
        ConflictSet::Known(cs) => !cs.is_empty(),
        ConflictSet::Unknown => false,
    }
}

fn to_pairs(ls: List<i64>, varrr: i64) -> List<(i64, i64)> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(valll, t2) => List::Cons(
            (varrr, valll),
            Rc::new(to_pairs(Rc::unwrap_or_clone(t2), varrr)),
        ),
    }
}

fn n_pairs(ls: List<i64>, n: i64) -> List<List<(i64, i64)>> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(varrr, t1) => List::Cons(
            to_pairs(List::enum_from_to(1, n), varrr),
            Rc::new(n_pairs(Rc::unwrap_or_clone(t1), n)),
        ),
    }
}

fn fill_table(
    s: &List<Assign>,
    csp: &CSP,
    tbl: List<List<ConflictSet>>,
) -> List<List<ConflictSet>> {
    match s {
        List::Nil => tbl,
        List::Cons(as_, _) => {
            let f4 = |cs, (varr, vall)| match cs {
                ConflictSet::Known(_) => cs,
                ConflictSet::Unknown => {
                    if !(csp.rel)(as_, &Assign { varr, value: vall }) {
                        ConflictSet::Known(List::Cons(
                            as_.varr,
                            Rc::new(List::Cons(varr, Rc::new(List::Nil))),
                        ))
                    } else {
                        cs
                    }
                }
            };
            tbl.zip_with(
                n_pairs(List::enum_from_to(as_.varr + 1, csp.vars), csp.vals),
                &|x, y| x.zip_with(y, &f4),
            )
        }
    }
}

fn to_unknown(ls: List<i64>) -> List<ConflictSet> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(_, t2) => List::Cons(
            ConflictSet::Unknown,
            Rc::new(to_unknown(Rc::unwrap_or_clone(t2))),
        ),
    }
}

fn n_unknown(ls: List<i64>, n: i64) -> List<List<ConflictSet>> {
    match ls {
        List::Nil => List::Nil,
        List::Cons(_, t1) => List::Cons(
            to_unknown(List::enum_from_to(1, n)),
            Rc::new(n_unknown(Rc::unwrap_or_clone(t1), n)),
        ),
    }
}

fn empty_table(csp: &CSP) -> List<List<ConflictSet>> {
    List::Cons(
        List::Nil,
        Rc::new(n_unknown(List::enum_from_to(1, csp.vars), csp.vals)),
    )
}

fn search(
    labeler: fn(&CSP, Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)>,
    csp: &CSP,
) -> List<List<Assign>> {
    let tree = mk_tree(csp);
    let labeled = labeler(csp, tree);
    let pruned = labeled.prune(&|(_, x)| known_conflict(&x));
    pruned
        .leaves()
        .filter(&|(_, x)| known_solution(x))
        .map(&|(x, _)| x)
}

fn safe(as1: &Assign, as2: &Assign) -> bool {
    (!(as1.value == as2.value)) && (!((as1.varr - as2.varr).abs() == (as1.value - as2.value).abs()))
}

fn queens(n: i64) -> CSP {
    CSP {
        vars: n,
        vals: n,
        rel: Box::new(safe),
    }
}

fn bt(csp: &CSP, t: Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)> {
    let f3 = |s: List<Assign>| {
        (
            s.clone(),
            match earliest_inconsistency(csp, s.clone()) {
                Some((a, b)) => {
                    ConflictSet::Known(List::Cons(a, Rc::new(List::Cons(b, Rc::new(List::Nil)))))
                }
                None => check_complete(csp, &s),
            },
        )
    };
    t.map(&f3)
}

fn bm(csp: &CSP, t: Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)> {
    lookup_cache(csp, cache_checks(csp, empty_table(csp), t)).map(&|(x, _)| x)
}

fn bj(_: &CSP, t: Node<(List<Assign>, ConflictSet)>) -> Node<(List<Assign>, ConflictSet)> {
    let f6 = |lp2, chs: List<Node<(List<Assign>, ConflictSet)>>| match lp2 {
        (a, ConflictSet::Known(cs)) => Node {
            lab: (a, ConflictSet::Known(cs)),
            children: chs.map(&Rc::new),
        },
        (a, ConflictSet::Unknown) => Node {
            lab: (
                a,
                ConflictSet::Known(combine(chs.clone().map(&|n| n.lab.clone()), List::Nil)),
            ),
            children: chs.map(&Rc::new),
        },
    };
    t.fold(&f6)
}

fn bjbt(csp: &CSP, t: Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)> {
    bj(&csp, bt(&csp, t))
}

fn bj_(_: &CSP, t: Node<(List<Assign>, ConflictSet)>) -> Node<(List<Assign>, ConflictSet)> {
    let f7 = |tp2, chs: List<Node<(List<Assign>, ConflictSet)>>| match tp2 {
        (a, ConflictSet::Known(cs)) => Node {
            lab: (a, ConflictSet::Known(cs)),
            children: chs.map(&Rc::new),
        },
        (a, ConflictSet::Unknown) => {
            let cs_ = ConflictSet::Known(combine(chs.clone().map(&|n| n.lab.clone()), List::Nil));
            if known_conflict(&cs_) {
                Node {
                    lab: (a, cs_),
                    children: List::Nil,
                }
            } else {
                Node {
                    lab: (a, cs_),
                    children: chs.map(&Rc::new),
                }
            }
        }
    };
    t.fold(&f7)
}

fn bjbt_(csp: &CSP, t: Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)> {
    bj_(csp, bt(csp, t))
}

fn fc(csp: &CSP, t: Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)> {
    domain_wipeout(
        csp,
        lookup_cache(csp, cache_checks(csp, empty_table(csp), t)),
    )
}

fn try_(
    n: i64,
    algorithm: fn(&CSP, Node<List<Assign>>) -> Node<(List<Assign>, ConflictSet)>,
) -> i64 {
    search(algorithm, &queens(n)).len() as i64
}

fn test_constraints_nofib(n: i64) -> List<i64> {
    [bt, bm, bjbt, bjbt_, fc]
        .map(&|x| try_(n, x))
        .iter()
        .map(|x| *x)
        .into()
}

fn main_loop(iters: u64, n: i64) {
    let res = test_constraints_nofib(n);
    if iters == 1 {
        println!("{}", res.head());
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
