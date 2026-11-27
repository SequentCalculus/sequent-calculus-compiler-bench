// `run` recurses polymorphically from `T` to `Box[T]` and finally matches on the accumulated box.

data Box[A] {
    Wrap(val: A)
}

def unwrap_or_zero[A+](b: Box[A]): i64 {
    b.case[A] {
        Wrap(x) => 0
    }
}

def run[T+](b: Box[T], n: i64): i64 {
    if n == 0 {
        unwrap_or_zero[T](b)
    } else {
        run[Box[T]](Wrap(b), n - 1)
    }
}

def main(): i64 {
    let b: Box[i64] = Wrap(42);
    let run1: i64 = run[i64](b, 2);
    print_i64(42);
    run[Box[i64]](Wrap(b), 1)
}
