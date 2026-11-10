data List[A] { Nil, Cons(a: A, as: List[A]) }
data Pair[A, B] { Pair(a: A, b: B) }
data Bool { True, False }
data Option[A] { None, Some(a: A) }
codata Fun[A, B] { apply(a: A): B }

def int_max(i1: i64, i2: i64): i64 {
  if i1 < i2 {
    i2
  } else {
    i1
  }
}

def snd[A+, B+](p: Pair[A, B]): B {
  p.case[A, B] {
    Pair(i1, i2) => i2
  }
}

def rev_loop[A+](l1: List[A], l2: List[A]): List[A] {
  l1.case[A] {
    Nil => l2,
    Cons(is, iss) => rev_loop[A](iss, Cons(is, l2))
  }
}

def rev[A+](l: List[A]): List[A] {
  rev_loop[A](l, Nil)
}

def map[A+, B+](f: Fun[A, B], l: List[A]): List[B] {
  l.case[A] {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply[A, B](p), map[A, B](f, ps))
  }
}

def head(l: List[i64]): i64 {
  l.case[i64] {
    Nil => -1,
    Cons(i, is) => i
  }
}

def take[A+](n: i64, ls: List[A]): List[A] {
  ls.case[A] {
    Nil => Nil,
    Cons(i, is) => if n == 0 { Nil } else { Cons(i, take[A](n - 1, is)) }
  }
}

def drop[A+](n: i64, ls: List[A]): List[A] {
  if n == 0 {
    ls
  } else {
    ls.case[A] {
      Nil => Nil,
      Cons(i, is) => drop[A](n - 1, is)
    }
  }
}

def is_nil[A+](ls: List[A]): Bool {
  ls.case[A] {
    Nil => True,
    Cons(x, xs) => False
  }
}

def is_singleton[A+](ls: List[A]): Option[A] {
  ls.case[A] {
    Nil => None,
    Cons(x, xs) => xs.case[A] {
      Nil => Some(x),
      Cons(x, xs) => None
    }
  }
}

def list_len[A+](l: List[A]): i64 {
  l.case[A] {
    Nil => 0,
    Cons(i, is) => 1 + list_len[A](is)
  }
}

def zip[A+, B+](l1: List[A], l2: List[B]): List[Pair[A, B]] {
  l1.case[A] {
    Nil => Nil,
    Cons(i1, is1) => l2.case[B] {
      Nil => Nil,
      Cons(i2, is2) => Cons(Pair(i1, i2), zip[A, B](is1, is2))
    }
  }
}

def in_list(x: i64, ls: List[i64]): Bool {
  ls.case[i64] {
    Nil => False,
    Cons(i, is) =>
      if i == x {
        True
      } else {
        in_list(x, is)
      }
  }
}

def enum_from_then_to(from: i64, then: i64, t: i64): List[i64] {
  if from <= t {
    Cons(from, enum_from_then_to(then, (2 * then) - from, t))
  } else {
    Nil
  }
}

def add_zero[A+](ls: List[A]): List[Pair[A, i64]] {
  ls.case[A] {
    Nil => Nil,
    Cons(h, tl) =>
      Cons(Pair(h, 0), add_zero[A](tl))
  }
}

def algb2(x: i64, k0j1: i64, k1j1: i64, yss: List[Pair[i64, i64]]): List[Pair[i64, i64]] {
  yss.case[Pair[i64, i64]] {
    Nil => Nil,
    Cons(p, ys) => p.case[i64, i64] {
      Pair(y, k0j) =>
        let kjcurr: i64 = if x == y {
          k0j1 + 1
        } else {
          int_max(k1j1, k0j)
        };
        Cons(Pair(y, kjcurr), algb2(x, k0j, kjcurr, ys))
    }
  }
}

def algb1(xss: List[i64], yss: List[Pair[i64, i64]]): List[i64] {
  xss.case[i64] {
    Nil => map[Pair[i64, i64], i64](new { apply(x) => snd[i64, i64](x) }, yss),
    Cons(x, xs) => algb1(xs, algb2(x, 0, 0, yss))
  }
}

def algb(xs: List[i64], ys: List[i64]): List[i64] {
    Cons(0, algb1(xs, add_zero[i64](ys)))
}

def findk(k: i64, km: i64, m: i64, ls: List[Pair[i64, i64]]): i64 {
  ls.case[Pair[i64, i64]] {
    Nil => km,
    Cons(p, xys) => p.case[i64, i64] {
      Pair(x, y) =>
        if m <= (x + y) {
          findk(k + 1, k, x + y, xys)
        } else {
          findk(k + 1, km, m, xys)
        }
    }
  }
}

def algc(m: i64, n: i64, xs: List[i64], ys: List[i64]): Fun[List[i64], List[i64]] {
  is_nil[i64](ys).case {
    True => new { apply(x) => x },
    False => is_singleton[i64](xs).case[i64] {
      Some(x) => in_list(x, ys).case {
        True => new { apply(t) => Cons(x, t) },
        False => new { apply(x) => x }
      },
      None =>
        let m2: i64 = m/2;
        let xs1: List[i64] = take[i64](m2, xs);
        let xs2: List[i64] = drop[i64](m2, xs);
        let l1: List[i64] = algb(xs1, ys);
        let l2: List[i64] = rev[i64](algb(rev[i64](xs2), rev[i64](ys)));
        let k: i64 = findk(0, 0, -1, zip[i64, i64](l1, l2));
        new { apply(x) =>
          let f1 : Fun[List[i64], List[i64]] = (algc(m - m2, n - k, xs2, drop[i64](k, ys)));
          let f2 : Fun[List[i64], List[i64]] = algc(m2, k, xs1, take[i64](k, ys));
          f2.apply[List[i64], List[i64]](f1.apply[List[i64], List[i64]](x))
        }
    }
  }
}

def lcss(xs: List[i64], ys: List[i64]): List[i64] {
  algc(list_len[i64](xs), list_len[i64](ys), xs, ys).apply[List[i64], List[i64]](Nil)
}

def lcss_main(a: i64, b: i64, c: i64, d: i64, e: i64, f: i64): List[i64] {
  lcss(enum_from_then_to(a, b, c), enum_from_then_to(d, e, f))
}

def test_lcss_nofib(c: i64, f: i64): List[i64] {
  lcss_main(1, 2, c, 100, 101, f)
}

def main_loop(iters: i64, c: i64, f: i64): i64 {
  let res: List[i64] = test_lcss_nofib(c, f);
  if iters == 1 {
    println_i64(head(res));
    0
  } else {
    main_loop(iters - 1, c, f)
  }
}

def main(iters: i64, c: i64, f: i64): i64 {
  main_loop(iters, c, f)
}
