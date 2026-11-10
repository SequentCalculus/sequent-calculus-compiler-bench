// Okasaki's nested-type ("polymorphic recursion") binary random-access list: the list is a binary
// counter over "digits" Zero/One, and each successive digit represents a complete pairing-up of
// the previous level's elements. `RList[A]`'s own constructors recurse at `RList[Pair[A]]`, a
// strictly larger type, so `Pair` itself never shows up nested more than once per level, it's
// the *type argument* to `RList` that keeps doubling, exactly the pattern `cons`/`lookup` must
// follow polymorphically to stay well-typed at every depth.

data Pair[A] {
    MkPair(fst: A, snd: A)
}

data RList[A] {
    Nil,
    Zero(rest: RList[Pair[A]]),
    One(x: A, rest: RList[Pair[A]])
}

// Push a new element to the front, structurally identical to incrementing a binary counter:
// an empty or already-vacated digit just takes the new element, while a filled digit carries over
// by pairing the new element with the old one and recursing one level deeper, at `Pair[A]`.
def cons[A+](x: A, l: RList[A]): RList[A] {
    l.case[A] {
        Nil => One(x, Nil),
        Zero(rest) => One(x, rest),
        One(y, rest) => Zero(cons[Pair[A]](MkPair(x, y), rest))
    }
}

// Indexed access, 0 at the front (the most recently `cons`ed element). At a `Zero` digit every
// slot at this level holds a `Pair[A]` covering two real elements, so the index is halved and the
// parity picks the half; at a `One` digit index 0 is the extra element itself, everything else
// shifts by one before the same halving applies to the paired-up rest.
def lookup[A+](i: i64, l: RList[A]): A {
    l.case[A] {
        Nil => exit -1,
        Zero(rest) =>
            lookup[Pair[A]](i / 2, rest).case[A] {
                MkPair(a, b) => if i % 2 == 0 { a } else { b }
            },
        One(x, rest) =>
            if i == 0 {
                x
            } else {
                let j: i64 = i - 1;
                lookup[Pair[A]](j / 2, rest).case[A] {
                    MkPair(a, b) => if j % 2 == 0 { a } else { b }
                }
            }
    }
}

// Pushes k, k + 1, ..., n onto `l`, so the list holds n, n - 1, ..., 1 from front to back.
def build(k: i64, n: i64, l: RList[i64]): RList[i64] {
    if k > n {
        l
    } else {
        build(k + 1, n, cons[i64](k, l))
    }
}

// Adds up the elements at the indices i, i + 1, ..., n - 1.
def sum_lookups(i: i64, n: i64, l: RList[i64], acc: i64): i64 {
    if i == n {
        acc
    } else {
        sum_lookups(i + 1, n, l, acc + lookup[i64](i, l))
    }
}

// One round of the workload: build a list of n elements, then look up every one of them.
def run(n: i64): i64 {
    sum_lookups(0, n, build(1, n, Nil), 0)
}

def main_loop(iters: i64, n: i64): i64 {
    let res: i64 = run(n);
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
