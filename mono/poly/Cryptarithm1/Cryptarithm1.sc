data List[A] { Nil, Cons(a: A, as: List[A]) }
data Bool { True, False }
codata Fun[A, B] { apply(a: A): B }

def eq(i1: i64, i2: i64): Bool {
  if i1 == i2 {
    True
  } else {
    False
  }
}

def first(l: List[List[List[i64]]]): i64 {
  l.case[List[List[i64]]] {
    Nil => -1,
    Cons(i, is) => i.case[List[i64]] {
      Nil => -1,
      Cons(i, is) => i.case[i64] {
        Nil => -1,
        Cons(i, is) => i
      }
    }
  }
}

def append[A+](l1: List[A], l2: List[A]): List[A] {
  l1.case[A]{
    Nil => l2,
    Cons(l, ls) => Cons(l, append[A](ls, l2))
  }
}

def take[A+](n: i64, l: List[A]): List[A] {
  l.case[A] {
    Nil => Nil,
    Cons(i, is) => if n <= 0 { Nil } else { Cons(i, take[A](n - 1, is)) }
  }
}

def filter[A+](f: Fun[A, Bool], l: List[A]): List[A] {
  l.case[A] {
    Nil => Nil,
    Cons(l, ls) => f.apply[A, Bool](l).case {
      True => Cons(l, filter[A](f, ls)),
      False => filter[A](f, ls)
    }
  }
}

def map[A+, B+](f: Fun[A, B], l: List[A]): List[B] {
  l.case[A] {
    Nil => Nil,
    Cons(i, is) => Cons(f.apply[A, B](i), map[A, B](f, is))
  }
}

def expand(a: i64, b: i64, c: i64, d: i64, e: i64, f: i64): i64 {
  (((((f + (e * 10)) + (d * 100)) + (c * 1000)) + (b * 10000)) + (a * 100000))
}

def enum_from_to(from: i64, to: i64): List[i64] {
  if to >= from {
    Cons(from, enum_from_to(from + 1, to))
  } else {
    Nil
  }
}

def condition(thirywelvn: List[i64]): Bool {
  thirywelvn.case[i64] {
    Nil => False,
    Cons(t, ts) => ts.case[i64] {
      Nil => False,
      Cons(h, hs) => hs.case[i64] {
        Nil => False,
        Cons(i, is) => is.case[i64] {
          Nil => False,
          Cons(r, rs) => rs.case[i64] {
            Nil => False,
            Cons(y, ys) => ys.case[i64] {
              Nil => False,
              Cons(w, ws) => ws.case[i64] {
                Nil => False,
                Cons(e, es) => es.case[i64] {
                  Nil => False,
                  Cons(l, ls) => ls.case[i64] {
                    Nil => False,
                    Cons(v, vs) => vs.case[i64] {
                      Nil => False,
                      Cons(n, ns) => ns.case[i64] {
                        Nil => eq((expand(t, h, i, r, t, y) + (5 * expand(t, w, e, l, v, e))), expand(n, i, n, e, t, y)),
                        Cons(i, is) => False
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

def push_k[A+](p1: List[List[A]], k: A): List[List[A]] {
  p1.case[List[A]] {
    Nil => Nil,
    Cons(h1, t1) => Cons(Cons(k, h1), push_k[A](t1, k))
  }
}

def addj[A+](j: A, ls: List[A]): List[List[A]] {
  ls.case[A] {
    Nil => Cons(Cons(j, Nil), Nil),
    Cons(k, ks) => Cons(Cons(j, Cons(k, ks)), push_k[A](addj[A](j, ks), k))
  }
}

def addj_ls[A+](p1: List[List[A]], j: A): List[List[A]] {
  p1.case[List[A]] {
    Nil => Nil,
    Cons(pjs, t1) =>
      append[List[A]](
        addj[A](j, pjs),
        addj_ls[A](t1, j)
      )
  }
}

def permutations[A+](ls: List[A]): List[List[A]] {
  ls.case[A] {
    Nil => Cons(Nil, Nil),
    Cons(j, js) => addj_ls[A](permutations[A](js), j)
  }
}

def test_cryptarithm_nofib(n: i64): List[List[List[i64]]] {
  map[i64, List[List[i64]]](
    new { apply(i) =>
      let p0: List[i64] = take[i64](10, enum_from_to(0, 9 + i));
      filter[List[i64]](new { apply(l) => condition(l) }, permutations[i64](p0))
    },
    enum_from_to(1, n)
  )
}

def main_loop(iters: i64, n: i64): i64 {
  if iters == 1 {
    let res: List[List[List[i64]]] = test_cryptarithm_nofib(n);
    println_i64(first(res));
    0
  } else {
    let res: List[List[List[i64]]] = test_cryptarithm_nofib(n);
    main_loop(iters - 1, n)
  }
}

def main(iters: i64, n: i64): i64 {
  main_loop(iters, n)
}
