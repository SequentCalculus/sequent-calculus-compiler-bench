// `grow` wraps its argument once more on every recursive call, so the constraint graph grows
// without bound. `Ghost` is never constructed and never matched: it only ever occurs as a type
// annotation on a call chain that is statically present but never taken. `run` performs the
// computation once with recursion depth `i`; `repeat` runs it for i = 1..n.

data Box[V] {
    Wrap(val: V)
}

data Ghost {
    Materialize(n: i64)
}

// Returns no `Ghost`, because `exit` leaves the program first. This keeps `Ghost` uninhabited
// while every definition stays reachable from `main`.
def ghostly(n: i64): Ghost {
    exit n
}

def forward(g: Ghost): Ghost {
    g
}

def sink(g: Ghost): i64 {
    0
}

def grow[C+](n: i64, x: C): i64 {
    if n == 0 {
        0
    } else {
        1 + grow[Box[C]](n - 1, Wrap(x))
    }
}

def run(i: i64): i64 {
    let depth: i64 = grow[i64](i, 0);
    if 1 == 0 {
        sink(forward(ghostly(1)))
    } else {
        depth
    }
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
