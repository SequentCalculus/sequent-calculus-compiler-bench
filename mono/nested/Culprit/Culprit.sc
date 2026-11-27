// The declaration parameter `B` of `Culprit` grows without bound through `Culprit[Culprit[B]]`,
// and the constructor `Grow` additionally carries its own existential `E`. `processCulprit` walks
// that polymorphic recursion. `run` performs the computation once; `repeat` runs it for i = 1..n.

data Culprit[B] {
    Done(val: B),
    Grow[E+](hidden: E, next: Culprit[Culprit[B]])
}

def processCulprit[T+](c: Culprit[T]) : i64 {
    c.case[T] {
        Done(x) => 1,
        Grow[X](hidden, n) => processCulprit[Culprit[T]](n)
    }
}

def run(i: i64): i64 {
    let c: Culprit[i64] = Grow[i64](
        i,
        Done(Grow[i64](100, Done(Done(i))))
    );
    processCulprit[i64](c)
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
