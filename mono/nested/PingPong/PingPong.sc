// Growth through mutual recursion: `ping` wraps in `Box`, `pong` wraps in `List`, next to an
// independent self-recursive `nest`.

data Box[A] {
    Wrap(x: A)
}

data List[B] {
    Nil,
    Cons(x: B, xs: List[B])
}

def nest[C+](x: C, n: i64): i64 {
    if n == 0 {
        0
    } else {
        1 + nest[Box[C]](Wrap(x), n - 1)
    }
}

def ping[A+](x: A, n: i64): i64 {
    if n == 0 {
        0
    } else {
        1 + pong[Box[A]](Wrap(x), n - 1)
    }
}

def pong[B+](y: B, n: i64): i64 {
    if n == 0 {
        0
    } else {
        1 + ping[List[B]](Cons(y, Nil), n - 1)
    }
}

def main(): i64 {
    let r1: i64 = nest[i64](123, 3);
    let r2: i64 = ping[i64](123, 3);
    println_i64(r1 + r2);
    0
}
