data List[A] { Nil, Cons(a: A, as: List[A]) }
data Pair[A, B] { Tup(a: A, b: B) }
data Option[A] { None, Some(a: A) }
data Bool { True, False }
codata Fun[A, B] { apply(a: A): B }
codata Fun2[A, B, C] { apply2(a: A, b: B): C }

data Assign { Assign(varr: i64, value: i64) }
data CSP { CSP(vars: i64, vals: i64, rel: Fun2[Assign, Assign, Bool]) }
data Node[T] { Node(lab: T, children: List[Node[T]]) }
data ConflictSet { Known(vs: List[i64]), Unknown }

def abs(i: i64): i64 {
  if i < 0 { -1 * i } else { i }
}

def eq(i1: i64, i2: i64): Bool {
  if i1 == i2 { True } else { False }
}

def not(b: Bool): Bool {
  b.case {
    True => False,
    False => True
  }
}

def level(a: Assign): i64 {
  a.case {
    Assign(varr, value) => varr
  }
}

def value(a: Assign): i64 {
  a.case {
    Assign(varr, value) => value
  }
}

def node_label[T+](n: Node[T]): T {
  n.case[T] {
    Node(p, cs) => p
  }
}

def map[A+, B+](f: Fun[A, B], l: List[A]): List[B] {
  l.case[A] {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply[A, B](p), map[A, B](f, ps))
  }
}

def test_map[A-, B+](f: Fun[A, B], l: List[A]): List[B] {
  l.case[A] {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply[A, B](p), test_map[A, B](f, ps))
  }
}

def all[A+](f: Fun[A, Bool], ls: List[A]): Bool {
  ls.case[A] {
    Nil => True,
    Cons(c, cs) => f.apply[A, Bool](c).case {
      True => all[A](f, cs),
      False => False
    }
  }
}

def filter[A+](f: Fun[A, Bool], ls: List[A]): List[A] {
  ls.case[A] {
    Nil => Nil,
    Cons(a, as) => f.apply[A, Bool](a).case {
      True => Cons(a, filter[A](f, as)),
      False => filter[A](f, as)
    }
  }
}

def is_empty[A+](ls: List[A]): Bool {
  ls.case[A] {
    Nil => True,
    Cons(l, ls) => False
  }
}

def enum_from_to(from: i64, to_: i64): List[i64] {
  if from <= to_{
    Cons(from, enum_from_to(from + 1, to_))
  } else {
    Nil
  }
}

def zip_with[A+, B+, C+](f: Fun2[A, B, C], x: List[A], y: List[B]): List[C] {
  x.case[A] {
    Nil => Nil,
    Cons(c, cs) => y.case[B] {
      Nil => Nil,
      Cons(p, ps) => Cons(f.apply2[A, B, C](c, p), zip_with[A, B, C](f, cs, ps))
    }
  }
}

def len[A+](l: List[A]): i64 {
  l.case[A] {
    Nil => 0,
    Cons(l, ls) => 1 + len[A](ls)
  }
}

def head(l: List[i64]): i64 {
  l.case[i64] {
    Nil => -1,
    Cons(x, xs) => x
  }
}

def head_list[A+](ls: List[List[A]]): List[A] {
  ls.case[List[A]] {
    Nil => Nil, //runtime error
    Cons(l, ls) => l
  }
}

def tail[A+](ls: List[A]): List[A] {
  ls.case[A] {
    Nil => Nil, // runtime error
    Cons(l, ls) => ls
  }
}

def at_index(ind: i64, ls: List[ConflictSet]): ConflictSet {
  ls.case[ConflictSet] {
    Nil => Unknown, // runtime error,
    Cons(c, cs) => if ind == 0 { c } else { at_index(ind - 1, cs) }
  }
}

def rev_loop[A+](ls: List[A], acc: List[A]): List[A] {
  ls.case[A] {
    Nil => acc,
    Cons(a, as) => rev_loop[A](as, Cons(a, acc))
  }
}

def reverse[A+](ls: List[A]): List[A] {
  rev_loop[A](ls, Nil)
}

def concat_loop[A+](ls: List[List[A]], acc: List[A]): List[A] {
  ls.case[List[A]] {
    Nil => reverse[A](acc),
    Cons(l, ls) => concat_loop[A](ls, rev_loop[A](l, acc))
  }
}

def concat[A+](ls: List[List[A]]): List[A] {
  concat_loop[A](ls, Nil)
}

def append[A+](l1: List[A], l2: List[A]): List[A] {
  l1.case[A] {
    Nil => l2,
    Cons(is, iss) => Cons(is, append[A](iss, l2))
  }
}

def foldl[A+, B+](f: Fun[B, Fun[A, B]], a: B, xs: List[A]): B {
  xs.case[A] {
    Nil => a,
    Cons(h, t) => foldl[A, B](f, f.apply[B, Fun[A, B]](a).apply[A, B](h), t)
  }
}

def in_list(i: i64, ls: List[i64]): Bool {
  ls.case[i64] {
    Nil => False,
    Cons(j, js) => if i == j { True } else { in_list(i, js) }
  }
}

def not_elem(i: i64, ls: List[i64]): Bool {
  not(in_list(i, ls))
}

def nub_by[A+](f: Fun[A, Fun[A, Bool]], ls: List[A]): List[A] {
  ls.case[A] {
    Nil => Nil,
    Cons(h, t) => Cons(h, nub_by[A](f, filter[A](new { apply(y) => not(f.apply[A, Fun[A, Bool]](h).apply[A, Bool](y)) }, t)))
  }
}

def delete_by[A+](f: Fun[A, Fun[A, Bool]], x: A, ys: List[A]): List[A] {
  ys.case[A] {
    Nil => Nil,
    Cons(y, ys) => f.apply[A, Fun[A, Bool]](x).apply[A, Bool](y).case {
      True => ys,
      False => Cons(y, delete_by[A](f, x, ys))
    }
  }
}

def union_by[A+](f: Fun[A, Fun[A, Bool]], l1: List[A], l2: List[A]): List[A] {
  append[A](l1, foldl[A, List[A]](new { apply(acc) => new { apply(y) => delete_by[A](f, y, acc) } }, nub_by[A](f, l2), l1))
}

def union(l1: List[i64], l2: List[i64]): List[i64] {
  union_by[i64](new { apply(x) => new { apply(y) => eq(x, y) } }, l1, l2)
}

def map_tree[A+, B+](f: Fun[A, B], n: Node[A]): Node[B] {
  n.case[A] {
    Node(l, ls) => Node(f.apply[A, B](l), map[Node[A], Node[B]](new { apply(x) => map_tree[A, B](f, x) }, ls))
  }
}

def fold_tree[A+, B+](f: Fun2[A, List[B], B], n: Node[A]): B {
  n.case[A] {
    Node(l, c) => f.apply2[A, List[B], B](l, map[Node[A], B](new { apply(x) => fold_tree[A, B](f, x) }, c))
  }
}

def filter_tree[A+](p: Fun[A, Bool], n: Node[A]): Node[A] {
  let f: Fun2[A, List[Node[A]], Node[A]] =
    new { apply2(a, cs) =>
      Node(a, filter[Node[A]](new { apply(x) => p.apply[A, Bool](node_label[A](x)) }, cs))
    };
  fold_tree[A, Node[A]](f, n)
}

def leaves[A+](n: Node[A]): List[A] {
  n.case[A] {
    Node(leaf, cs) => cs.case[Node[A]] {
      Nil => Cons(leaf, Nil),
      Cons(c, cs) => concat[A](map[Node[A], List[A]](new { apply(x) => leaves[A](x) }, Cons(c, cs)))
    }
  }
}

def prune[A+](f: Fun[A, Bool], n: Node[A]): Node[A] {
  filter_tree[A](new { apply(x) => not(f.apply[A, Bool](x)) }, n)
}

def max_level(ls: List[Assign]): i64 {
  ls.case[Assign] {
    Nil => 0,
    Cons(a, t) => a.case {
      Assign(v, value) => v
    }
  }
}

def complete(csp: CSP, s: List[Assign]): Bool {
  csp.case {
    CSP(v, vals, rel) => eq(max_level(s), v)
  }
}

def combine(ls: List[Pair[List[Assign], ConflictSet]], acc: List[i64]): List[i64] {
  ls.case[Pair[List[Assign], ConflictSet]] {
    Nil => acc,
    Cons(p, css) => p.case[List[Assign], ConflictSet] {
      Tup(s, cs) => cs.case {
        Known(cs) => not_elem(max_level(s), cs).case {
          True => cs,
          False => combine(css, union(cs, acc))
        },
        Unknown => acc
      }
    }
  }
}

def init_tree[A+](f: Fun[A, List[A]], x: A): Node[A] {
  Node(x, map[A, Node[A]](new { apply(y) => init_tree[A](f, y) }, f.apply[A, List[A]](x)))
}

def to_assign(ls: List[i64], ss: List[Assign]): List[List[Assign]] {
  ls.case[i64] {
    Nil => Nil,
    Cons(j, t1) => Cons(Cons(Assign(max_level(ss) + 1, j), ss), to_assign(t1, ss))
  }
}

def mk_tree(csp: CSP): Node[List[Assign]] {
  csp.case {
    CSP(vars, vals, rel) =>
      let next: Fun[List[Assign], List[List[Assign]]] =
        new { apply(ss) =>
          if max_level(ss) < vars {
            to_assign(enum_from_to(1, vals), ss)
          } else {
            Nil
          }
        };
      init_tree[List[Assign]](next, Nil)
  }
}

def collect(ls: List[ConflictSet]): List[i64] {
  ls.case[ConflictSet] {
    Nil=>Nil,
    Cons(conf, css) => conf.case {
      Known(cs) => union(cs, collect(css)),
      Unknown => Nil
    }
  }
}

def known_solution(c: ConflictSet): Bool {
  c.case {
    Known(vs) => vs.case[i64] {
      Nil => True,
      Cons(v, vs) => False
    },
    Unknown => False
  }
}

def known_conflict(c: ConflictSet): Bool {
  c.case {
    Known(vs) => vs.case[i64] {
      Nil => False,
      Cons(v, vs) => True
    },
    Unknown => False
  }
}

def filter_known(ls: List[List[ConflictSet]]): List[List[ConflictSet]] {
  ls.case[List[ConflictSet]] {
    Nil => Nil,
    Cons(vs, t1) => all[ConflictSet](new { apply(x) => known_conflict(x) }, vs).case {
      True => Cons(vs, filter_known(t1)),
      False => filter_known(t1)
    }
  }
}

def domain_wipeout(csp: CSP, t: Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]): Node[Pair[List[Assign], ConflictSet]] {
  let f8: Fun[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]], Pair[List[Assign], ConflictSet]] =
    new { apply(tp2) =>
      tp2.case[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]] {
        Tup(p, tbl) => p.case[List[Assign], ConflictSet] {
          Tup(as_, cs) =>
            let wiped_domains: List[List[ConflictSet]]= filter_known(tbl);
            let cs_: ConflictSet = is_empty[List[ConflictSet]](wiped_domains).case {
              True => cs,
              False => Known(collect(head_list[ConflictSet](wiped_domains)))
            };
            Tup(as_, cs_)
      }}
    };
  map_tree[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]], Pair[List[Assign], ConflictSet]](f8, t)
}

def check_complete(csp: CSP, s: List[Assign]): ConflictSet {
  complete(csp, s).case {
    True => Known(Nil),
    False => Unknown
  }
}

def earliest_inconsistency(csp: CSP, aas: List[Assign]): Option[Pair[i64, i64]] {
  csp.case {
    CSP(vars, vals, rel) => aas.case[Assign] {
      Nil => None,
      Cons(a, as_) =>  filter[Assign](
        new { apply(x) => not(rel.apply2[Assign, Assign, Bool](a, x)) },
        reverse[Assign](as_)).case[Assign] {
          Nil => None,
          Cons(b, bs_) => Some(Tup(level(a), level(b)))
        }
    }
  }
}

def lookup_cache(
  csp: CSP,
  t: Node[Pair[List[Assign], List[List[ConflictSet]]]]
): Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]] {
  let f5: Fun2[CSP, Pair[List[Assign], List[List[ConflictSet]]], Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]] =
    new { apply2(csp, tp) =>
      tp.case[List[Assign], List[List[ConflictSet]]] {
        Tup(ls, tbl) => ls.case[Assign] {
          Nil => Tup(Tup(Nil, Unknown), tbl),
          Cons(a, as_) =>
            let table_entry: ConflictSet = at_index(value(a) - 1, head_list[ConflictSet](tbl));
            let cs: ConflictSet = table_entry.case {
              Unknown => check_complete(csp, Cons(a, as_)),
              Known(vals) => table_entry
            };
            Tup(Tup(Cons(a, as_), cs), tbl)
        }
      }
    };
  map_tree[Pair[List[Assign], List[List[ConflictSet]]], Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]](
    new { apply(x) =>
      f5.apply2[CSP, Pair[List[Assign], List[List[ConflictSet]]], Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]
      (csp, x)
    },
    t
  )
}

def to_pairs[A+, B+](ls: List[B], x: A): List[Pair[A, B]] {
  ls.case[B] {
    Nil => Nil,
    Cons(y, t2) => Cons(Tup(x, y), to_pairs[A, B](t2, x))
  }
}

def n_pairs(ls: List[i64], n: i64): List[List[Pair[i64, i64]]] {
  ls.case[i64] {
    Nil => Nil,
    Cons(varrr, t1) => Cons(to_pairs[i64, i64](enum_from_to(1, n), varrr), n_pairs(t1, n))
  }
}

def fill_table(s: List[Assign], csp: CSP, tbl: List[List[ConflictSet]]): List[List[ConflictSet]] {
  s.case[Assign] {
    Nil => tbl,
    Cons(as, as_) => as.case { Assign(var_, val_) =>
      csp.case {
        CSP(vars, vals, rel) =>
          let f4: Fun2[ConflictSet, Pair[i64, i64], ConflictSet] = new { apply2(cs, varval) =>
            varval.case[i64, i64] {
              Tup(varr, vall) => cs.case {
                Known(vs) => cs,
                Unknown => not(rel.apply2[Assign, Assign, Bool](Assign(var_, val_), Assign(varr, vall))).case {
                  True => Known(Cons(var_, Cons(varr, Nil))),
                  False => cs
                }
              }
          }};
          zip_with[List[ConflictSet], List[Pair[i64, i64]], List[ConflictSet]](
            new { apply2(x, y) => zip_with[ConflictSet, Pair[i64, i64], ConflictSet](f4, x, y) },
            tbl,
            n_pairs(enum_from_to(var_ + 1, vars), vals))
      }
    }
  }
}

def cache_checks(csp: CSP, tbl: List[List[ConflictSet]], n: Node[List[Assign]]): Node[Pair[List[Assign], List[List[ConflictSet]]]] {
  n.case[List[Assign]] {
    Node(s, cs) => Node(Tup(s, tbl), map[Node[List[Assign]], Node[Pair[List[Assign], List[List[ConflictSet]]]]](
      new { apply(x) => cache_checks(csp, fill_table(s, csp, tail[List[ConflictSet]](tbl)), x) }, cs))
  }
}

def to_unknown[A+](ls: List[A]): List[ConflictSet] {
  ls.case[A] {
    Nil => Nil,
    Cons(m, t2) => Cons(Unknown, to_unknown[A](t2))
  }
}

def n_unknown(ls: List[i64], n: i64): List[List[ConflictSet]] {
  ls.case[i64] {
    Nil => Nil,
    Cons(n, t1) =>  Cons(to_unknown[i64](enum_from_to(1, n)), n_unknown(t1, n))
  }
}

def empty_table(csp: CSP): List[List[ConflictSet]] {
  csp.case {
    CSP(vars, vals, rel) => Cons(Nil, n_unknown(enum_from_to(1, vars), vals))
  }
}

def fst[A+, B+](p: Pair[A, B]): A {
  p.case[A, B] {
    Tup(l, c) => l
  }
}

def snd[A+, B+](p: Pair[A, B]): B {
  p.case[A, B] {
    Tup(l, c) => c
  }
}

def search(labeler: Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]], csp: CSP): List[List[Assign]] {
  map[Pair[List[Assign], ConflictSet], List[Assign]](new { apply(x) => fst[List[Assign], ConflictSet](x) },
    filter[Pair[List[Assign], ConflictSet]](new { apply(x) => known_solution(snd[List[Assign], ConflictSet](x)) },
      leaves[Pair[List[Assign], ConflictSet]](
        prune[Pair[List[Assign], ConflictSet]](new { apply(x) => known_conflict(snd[List[Assign], ConflictSet](x)) },
          labeler.apply2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]](csp, mk_tree(csp))))))
}

def safe(as1: Assign, as2: Assign): Bool {
  as1.case {
    Assign(i, m) => as2.case {
      Assign(j, n) => not(eq(m, n)).case {
        True => not(eq(abs(i - j), abs(m - n))),
        False => False
      }
    }
  }
}

def queens(n: i64): CSP {
  CSP(n, n, new { apply2(x, y) => safe(x, y)})
}

def bt(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  let f3: Fun[List[Assign], Pair[List[Assign], ConflictSet]] =
    new { apply(s) =>
      Tup(s, (earliest_inconsistency(csp, s).case[Pair[i64, i64]] {
        Some(p) => p.case[i64, i64] {
          Tup(a, b) => Known(Cons(a, Cons(b, Nil)))
        },
        None => check_complete(csp, s)
      }))
    };
  map_tree[List[Assign], Pair[List[Assign], ConflictSet]](f3, t)
}

def bm(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  map_tree[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]], Pair[List[Assign], ConflictSet]](
    new { apply(x) => fst[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]](x) },
    lookup_cache(csp, cache_checks(csp, empty_table(csp), t)))
}

def bj(csp: CSP, t: Node[Pair[List[Assign], ConflictSet]]): Node[Pair[List[Assign], ConflictSet]] {
  let f6: Fun2[Pair[List[Assign], ConflictSet], List[Node[Pair[List[Assign], ConflictSet]]], Node[Pair[List[Assign], ConflictSet]]] =
    new { apply2(tp2, chs) =>
      tp2.case[List[Assign], ConflictSet] {
        Tup(a, conf) => conf.case {
          Known(cs) => Node(Tup(a, Known(cs)), chs),
          Unknown =>  Node(Tup(a, Known(combine(map[Node[Pair[List[Assign], ConflictSet]], Pair[List[Assign], ConflictSet]](
            new { apply(x) => node_label[Pair[List[Assign], ConflictSet]](x) }, chs), Nil))), chs)
        }
      }
    };
  fold_tree[Pair[List[Assign], ConflictSet], Node[Pair[List[Assign], ConflictSet]]](f6, t)
}

def bjbt(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  bj(csp, bt(csp, t))
}

def bj_(csp: CSP, t: Node[Pair[List[Assign], ConflictSet]]): Node[Pair[List[Assign], ConflictSet]] {
  let f7: Fun2[Pair[List[Assign], ConflictSet], List[Node[Pair[List[Assign], ConflictSet]]], Node[Pair[List[Assign], ConflictSet]]] =
    new { apply2(tp2, chs) =>
      tp2.case[List[Assign], ConflictSet] { Tup(a, conf) => conf.case {
        Known(cs) => Node(Tup(a, Known(cs)), chs),
        Unknown =>
          let cs_: ConflictSet = Known(combine(map[Node[Pair[List[Assign], ConflictSet]], Pair[List[Assign], ConflictSet]](
            new { apply(x) => node_label[Pair[List[Assign], ConflictSet]](x) }, chs), Nil));
         known_conflict(cs_).case {
            True => Node(Tup(a, cs_), Nil),
            False => Node(Tup(a, cs_), chs)
          }
      }}
    };
  fold_tree[Pair[List[Assign], ConflictSet], Node[Pair[List[Assign], ConflictSet]]](f7, t)
}

def bjbt_(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
 bj_(csp, bt(csp, t))
}

def fc(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  domain_wipeout(csp, lookup_cache(csp, cache_checks(csp, empty_table(csp), t)))
}

def try_(n: i64, algorithm: Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]]): i64 {
  len[List[Assign]](search(algorithm, queens(n)))
}

def test_constraints_nofib(n: i64): List[i64] {
  test_map[Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]], i64](new { apply(x) => try_(n, x) },
    Cons(new { apply2(csp, n) => bt(csp, n) },
      Cons(new { apply2(csp, n) => bm(csp, n) },
        Cons(new { apply2(csp, n) => bjbt(csp, n) },
          Cons(new { apply2(csp, n) => bjbt_(csp, n) },
            Cons(new { apply2(csp, n) => fc(csp, n) },
              Nil))))))
}

def main_loop(iters: i64, n: i64): i64 {
  if iters == 1 {
    let res: List[i64] = test_constraints_nofib(n);
    println_i64(head(res));
    0
  } else {
    let res: List[i64] = test_constraints_nofib(n);
    main_loop(iters - 1, n)
  }
}

def main(iters: i64, n: i64): i64 {
  main_loop(iters, n)
}
