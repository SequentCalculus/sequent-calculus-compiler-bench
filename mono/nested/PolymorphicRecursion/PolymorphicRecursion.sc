// Polymorphic recursion through `Nested` together with an existential in `Box` and a
// universally quantified destructor in `Holder`. `run` performs the whole computation once, with
// the list scaled to `i` elements; `repeat` runs it for i = 1..n.

data Nested[A] {
    Base(x: A),
    Grow[E+](tag: E, inner: Nested[Nested[A]])
}

data Bool {
    True,
    False
}

data Box {
    Pack[V+](val: V, tag: i64)
}

data List[D] {
    Nil,
    Cons(x: D, xs: List[D])
}

codata Holder[H] {
    put[S+](val: S, tag: H): H
}

def identity[X+](x: X): X {
    x
}

def sumNested[A+](n: Nested[A]): i64 {
    n.case[A] {
        Base(x) => 1,
        Grow[E](tag, inner) => 1 + sumNested[Nested[A]](inner)
    }
}

def sumList(l: List[i64]): i64 {
    l.case[i64] {
        Nil => 0,
        Cons(x, xs) => x + sumList(xs)
    }
}

def build_list(n: i64, acc: List[i64]): List[i64] {
    if n == 0 {
        acc
    } else {
        build_list(n - 1, Cons(n, acc))
    }
}

def run(i: i64): i64 {
    let inner: Nested[i64] = Base(i);
    let nested: Nested[Nested[i64]] = Base(inner);
    let grown: Nested[i64] = Grow[Bool](True, nested);
    let nestedResult: i64 = sumNested[i64](grown);

    let boxed: Box = Pack[i64](i, 7);
    let boxResult: i64 = boxed.case {
        Pack[V](val, tag) =>
            let discarded: V = identity[V](val);
            tag
    };

    let l: List[i64] = build_list(i, Nil);
    let listResult: i64 = sumList(identity[List[i64]](l));

    let holder: Holder[i64] = new {
        put[S](val, tag) => tag
    };
    let holderResult: i64 = holder.put[i64, Bool](True, 3);

    ((nestedResult + boxResult) + listResult) + holderResult
}

def repeat(i: i64, n: i64, acc: i64): i64 {
    if i > n {
        acc
    } else {
        repeat(i + 1, n, acc + run(i))
    }
}

def main_loop(iters: i64, n: i64): i64 {
    let res: i64 = repeat(1, n, 0);
    if iters == 1 {
        println_i64(res);
        0
    } else {
        main_loop(iters - 1, n)
    }
}

def main(iters: i64, n: i64): i64 {
    main_loop(iters, n)
}
