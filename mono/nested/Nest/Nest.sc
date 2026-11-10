// `nest` wraps its argument once more on every recursive call, so the constraint graph has a
// growing cycle through `Box`. The box `a` built in `main` is never part of that cycle: Type
// Splitting gives it its own copy of `Box`, which stays specialized at `i64`, while only the copy
// used in the recursion is erased.

data Box[A] {
    Wrap(x: A)
}

def nest[A+](x: A, n: i64): i64 {
    if n == 0 {
        0
    } else {
        1 + nest[Box[A]](Wrap(x), n - 1)
    }
}

def main(): i64 {
    let a: Box[i64] = Wrap(1);
    println_i64(nest[Box[i64]](a, 3));
    0
}
