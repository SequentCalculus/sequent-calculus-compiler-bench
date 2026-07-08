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

def lab(n: Node[Pair[List[Assign], ConflictSet]]): Pair[List[Assign], ConflictSet] {
  n.case {
    Node(l, cs) => l
  }
}

def map(f: Fun[List[Assign], Node[List[Assign]]], l: List[List[Assign]]): List[Node[List[Assign]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[Pair[List[Assign], ConflictSet]], Node[Pair[List[Assign], ConflictSet]]],
  l: List[Node[Pair[List[Assign], ConflictSet]]]
): List[Node[Pair[List[Assign], ConflictSet]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[Pair[List[Assign], ConflictSet]], List[Pair[List[Assign], ConflictSet]]],
  l: List[Node[Pair[List[Assign], ConflictSet]]]
): List[List[Pair[List[Assign], ConflictSet]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Pair[List[Assign], ConflictSet], List[Assign]],
  l: List[Pair[List[Assign], ConflictSet]]
): List[List[Assign]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[List[Assign]], Node[Pair[List[Assign], List[List[ConflictSet]]]]],
  l: List[Node[List[Assign]]]
): List[Node[Pair[List[Assign], List[List[ConflictSet]]]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) =>  Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[Pair[List[Assign], List[List[ConflictSet]]]], Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]],
  l: List[Node[Pair[List[Assign], List[List[ConflictSet]]]]]
): List[Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) =>
      Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]],
  l: List[Node[List[Assign]]]
): List[Node[Pair[List[Assign], ConflictSet]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[Pair[List[Assign], ConflictSet]], Pair[List[Assign], ConflictSet]],
  l: List[Node[Pair[List[Assign], ConflictSet]]]
): List[Pair[List[Assign], ConflictSet]] {
  l.case[Node[Pair[List[Assign], ConflictSet]]] {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]], Node[Pair[List[Assign], ConflictSet]]],
  l: List[Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]]
): List[Node[Pair[List[Assign], ConflictSet]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def map(
  f: Fun[Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]], i64],
  l: List[Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]]]
): List[i64] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => Cons(f.apply(p), map(f, ps))
  }
}

def all(f: Fun[ConflictSet, Bool], ls: List[ConflictSet]): Bool {
  ls.case {
    Nil => True,
    Cons(c, cs) => f.apply(c).case {
      True => all(f, cs),
      False => False
    }
  }
}

def filter(f: Fun[Assign, Bool], ls: List[Assign]): List[Assign] {
  ls.case {
    Nil => Nil,
    Cons(a, as) => f.apply(a).case {
      True => Cons(a, filter(f, as)),
      False => filter(f, as)
    }
  }
}

def filter(
  f: Fun[Node[Pair[List[Assign], ConflictSet]], Bool],
  l: List[Node[Pair[List[Assign], ConflictSet]]]
): List[Node[Pair[List[Assign], ConflictSet]]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => f.apply(p).case {
      True => Cons(p, filter(f, ps)),
      False => filter(f, ps)
    }
  }
}

def filter(
  f: Fun[Pair[List[Assign], ConflictSet], Bool],
  l: List[Pair[List[Assign], ConflictSet]]
): List[Pair[List[Assign], ConflictSet]] {
  l.case {
    Nil => Nil,
    Cons(p, ps) => f.apply(p).case {
      True => Cons(p, filter(f, ps)),
      False => filter(f, ps)
    }
  }
}

def filter(f: Fun[i64, Bool], ls: List[i64]): List[i64] {
  ls.case {
    Nil => Nil,
    Cons(i, is) => f.apply(i).case {
      True => Cons(i, filter(f, is)),
      False => filter(f, is)
    }
  }
}

def is_empty(ls: List[List[ConflictSet]]): Bool {
  ls.case {
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

def zip_with(f: Fun2[ConflictSet, Pair[i64, i64], ConflictSet], x: List[ConflictSet], y: List[Pair[i64, i64]]):
  List[ConflictSet] {
  x.case {
    Nil => Nil,
    Cons(c, cs) => y.case {
      Nil => Nil,
      Cons(p, ps) => Cons(f.apply2(c, p), zip_with(f, cs, ps))
    }
  }
}

def zip_with(f: Fun2[List[ConflictSet], List[Pair[i64, i64]], List[ConflictSet]], tbl: List[List[ConflictSet]],
    ls: List[List[Pair[i64, i64]]]): List[List[ConflictSet]] {
      tbl.case {
        Nil => Nil,
        Cons(cs, css) => ls.case {
          Nil => Nil,
          Cons(ps, pss) => Cons(f.apply2(cs, ps), zip_with(f, css, pss))
        }
      }
}

def len(l: List[List[Assign]]): i64 {
  l.case {
    Nil => 0,
    Cons(l, ls) => 1 + len(ls)
  }
}

def head(l: List[i64]): i64 {
  l.case {
    Nil => -1,
    Cons(x, xs) => x
  }
}

def head(tbl: List[List[ConflictSet]]): List[ConflictSet] {
  tbl.case {
    Nil => Nil, // runtime error
    Cons(cs, css) => cs
  }
}

def tail(ls: List[List[ConflictSet]]): List[List[ConflictSet]] {
  ls.case {
    Nil => Nil, // runtime error
    Cons(l, ls) => ls
  }
}

def at_index(ind: i64, ls: List[ConflictSet]): ConflictSet {
  ls.case {
    Nil => Unknown, // runtime error,
    Cons(c, cs) => if ind == 0 { c } else { at_index(ind - 1, cs) }
  }
}

def rev_loop(ls: List[Assign], acc: List[Assign]): List[Assign] {
  ls.case {
    Nil => acc,
    Cons(a, as) => rev_loop(as, Cons(a, acc))
  }
}

def reverse(ls: List[Assign]): List[Assign] {
  rev_loop(ls, Nil)
}

def search_rev_loop(
  l1: List[Pair[List[Assign], ConflictSet]],
  l2: List[Pair[List[Assign], ConflictSet]]
): List[Pair[List[Assign], ConflictSet]] {
  l1.case {
    Nil => l2,
    Cons(p, ps) => search_rev_loop(ps, Cons(p, l2))
  }
}

def search_rev(l: List[Pair[List[Assign], ConflictSet]]): List[Pair[List[Assign], ConflictSet]] {
  search_rev_loop(l, Nil)
}

def search_concat_loop(
  ls: List[List[Pair[List[Assign], ConflictSet]]],
  acc: List[Pair[List[Assign], ConflictSet]]
): List[Pair[List[Assign], ConflictSet]] {
  ls.case {
    Nil => search_rev(acc),
    Cons(l, ls) => search_concat_loop(ls, search_rev_loop(l, acc))
  }
}

def search_concat(ls: List[List[Pair[List[Assign], ConflictSet]]]): List[Pair[List[Assign], ConflictSet]] {
  search_concat_loop(ls, Nil)
}

def append(l1: List[i64], l2: List[i64]): List[i64] {
  l1.case {
    Nil => l2,
    Cons(is, iss) => Cons(is, append(iss, l2))
  }
}

def foldl(f: Fun[List[i64], Fun[i64, List[i64]]], a: List[i64], xs: List[i64]): List[i64] {
  xs.case {
    Nil => a,
    Cons(h, t) => foldl(f, f.apply(a).apply(h), t)
  }
}

def in_list(i: i64, ls: List[i64]): Bool {
  ls.case {
    Nil => False,
    Cons(j, js) => if i == j { True } else { in_list(i, js) }
  }
}

def not_elem(i: i64, ls: List[i64]): Bool {
  not(in_list(i, ls))
}

def nub_by(f: Fun[i64, Fun[i64, Bool]], ls: List[i64]): List[i64] {
  ls.case {
    Nil => Nil,
    Cons(h, t) => Cons(h, nub_by(f, filter(new { apply(y) => not(f.apply(h).apply(y)) }, t)))
  }
}

def delete_by(f: Fun[i64, Fun[i64, Bool]], x: i64, ys: List[i64]): List[i64] {
  ys.case {
    Nil => Nil,
    Cons(y, ys) => f.apply(x).apply(y).case {
      True => ys,
      False => Cons(y, delete_by(f, x, ys))
    }
  }
}

def union_by(f: Fun[i64, Fun[i64, Bool]], l1: List[i64], l2: List[i64]): List[i64] {
  append(l1, foldl(new { apply(acc) => new { apply(y) => delete_by(f, y, acc) } }, nub_by(f, l2), l1))
}

def union(l1: List[i64], l2: List[i64]): List[i64] {
  union_by(new { apply(x) => new { apply(y) => eq(x, y) } }, l1, l2)
}

def map_tree(f: Fun[List[Assign], Pair[List[Assign], ConflictSet]], n: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  n.case {
    Node(l, ls) =>
      Node(f.apply(l), map(new { apply(x) => map_tree(f, x) }, ls))
  }
}

def map_tree(
  f: Fun[Pair[List[Assign], List[List[ConflictSet]]], Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]],
  t: Node[Pair[List[Assign], List[List[ConflictSet]]]]
): Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]] {
  t.case {
    Node(p, ps) =>
      Node(f.apply(p), map(new { apply(x) => map_tree(f, x) }, ps))
  }
}

def map_tree(
  f: Fun[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]], Pair[List[Assign], ConflictSet]],
  t: Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]
): Node[Pair[List[Assign], ConflictSet]] {
  t.case {
    Node(l, c) =>
      Node(f.apply(l), map(new { apply(x) => map_tree(f, x) }, c))
  }
}

def fold_tree(
  f: Fun2[Pair[List[Assign], ConflictSet], List[Node[Pair[List[Assign], ConflictSet]]], Node[Pair[List[Assign], ConflictSet]]],
  n: Node[Pair[List[Assign], ConflictSet]]
): Node[Pair[List[Assign], ConflictSet]] {
  n.case {
    Node(l, c) =>
      f.apply2(l, map(new { apply(x) => fold_tree(f, x)}, c))
  }
}

def filter_tree(
  p: Fun[Pair[List[Assign], ConflictSet], Bool],
  n: Node[Pair[List[Assign], ConflictSet]]
): Node[Pair[List[Assign], ConflictSet]] {
  let f =
    new { apply2(a, cs) =>
      Node(a, filter(new { apply(x) => p.apply(lab(x)) }, cs))
    };
  fold_tree(f, n)
}

def leaves(n: Node[Pair[List[Assign], ConflictSet]]): List[Pair[List[Assign], ConflictSet]] {
  n.case {
    Node(leaf, cs) => cs.case {
      Nil => Cons(leaf, Nil),
      Cons(c, cs) => search_concat(map(new { apply(x) => leaves(x) }, Cons(c, cs)))
    }
  }
}

def prune(
  f: Fun[Pair[List[Assign], ConflictSet], Bool],
  n: Node[Pair[List[Assign], ConflictSet]]
): Node[Pair[List[Assign], ConflictSet]] {
  filter_tree(new { apply(x) => not(f.apply(x)) }, n)
}

def max_level(ls: List[Assign]): i64 {
  ls.case {
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
  ls.case {
    Nil => acc,
    Cons(p, css) => p.case {
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

def init_tree(f: Fun[List[Assign], List[List[Assign]]], x: List[Assign]): Node[List[Assign]] {
  Node(x, map(new { apply(y) => init_tree(f, y) }, f.apply(x)))
}

def to_assign(ls: List[i64], ss: List[Assign]): List[List[Assign]] {
  ls.case {
    Nil => Nil,
    Cons(j, t1) => Cons(Cons(Assign(max_level(ss) + 1, j), ss), to_assign(t1, ss))
  }
}

def mk_tree(csp: CSP): Node[List[Assign]] {
  csp.case {
    CSP(vars, vals, rel) =>
      let next =
        new { apply(ss) =>
          if max_level(ss) < vars {
            to_assign(enum_from_to(1, vals), ss)
          } else {
            Nil
          }
        };
      init_tree(next, Nil)
  }
}

def collect(ls: List[ConflictSet]): List[i64] {
  ls.case {
    Nil => Nil,
    Cons(conf, css) => conf.case {
      Known(cs) => union(cs, collect(css)),
      Unknown => Nil
    }
  }
}

def known_solution(c: ConflictSet): Bool {
  c.case {
    Known(vs) => vs.case {
      Nil => True,
      Cons(v, vs) => False
    },
    Unknown => False
  }
}

def known_conflict(c: ConflictSet): Bool {
  c.case {
    Known(vs) => vs.case {
      Nil => False,
      Cons(v, vs) => True
    },
    Unknown => False
  }
}

def filter_known(ls: List[List[ConflictSet]]): List[List[ConflictSet]] {
  ls.case {
    Nil => Nil,
    Cons(vs, t1) => all(new { apply(x) => known_conflict(x) }, vs).case {
      True => Cons(vs, filter_known(t1)),
      False => filter_known(t1)
    }
  }
}

def domain_wipeout(csp: CSP, t: Node[Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]]): Node[Pair[List[Assign], ConflictSet]] {
  let f8 =
    new { apply(tp2) =>
      tp2.case {
        Tup(p, tbl) => p.case {
          Tup(as_, cs) =>
            let wiped_domains = filter_known(tbl);
            let cs_ = is_empty(wiped_domains).case {
              True => cs,
              False => Known(collect(head(wiped_domains)))
            };
            Tup(as_, cs_)
      }}
    };
  map_tree(f8, t)
}

def check_complete(csp: CSP, s: List[Assign]): ConflictSet {
  complete(csp, s).case {
    True => Known(Nil),
    False => Unknown
  }
}

def earliest_inconsistency(csp: CSP, aas: List[Assign]): Option[Pair[i64, i64]] {
  csp.case {
    CSP(vars, vals, rel) => aas.case {
      Nil => None,
      Cons(a, as_) =>  filter(
        new { apply(x) => not(rel.apply2(a, x)) },
        reverse(as_)).case {
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
  let f5 =
    new { apply2(csp, tp) =>
      tp.case {
        Tup(ls, tbl) => ls.case {
          Nil => Tup(Tup(Nil, Unknown), tbl),
          Cons(a, as_) =>
            let table_entry = at_index(value(a) - 1, head(tbl));
            let cs = table_entry.case {
              Unknown => check_complete(csp, Cons(a, as_)),
              Known(vals) => table_entry
            };
            Tup(Tup(Cons(a, as_), cs), tbl)
        }
      }
    };
  map_tree(
    new { apply(x) =>
      f5.apply2(csp, x)
    },
    t
  )
}

def to_pairs(ls: List[i64], varrr: i64): List[Pair[i64, i64]] {
  ls.case {
    Nil => Nil,
    Cons(valll, t2) => Cons(Tup(varrr, valll), to_pairs(t2, varrr))
  }
}

def n_pairs(ls: List[i64], n: i64): List[List[Pair[i64, i64]]] {
  ls.case {
    Nil => Nil,
    Cons(varrr, t1) => Cons(to_pairs(enum_from_to(1, n), varrr), n_pairs(t1, n))
  }
}

def fill_table(s: List[Assign], csp: CSP, tbl: List[List[ConflictSet]]): List[List[ConflictSet]] {
  s.case {
    Nil => tbl,
    Cons(as, as_) => as.case { Assign(var_, val_) =>
      csp.case {
        CSP(vars, vals, rel) =>
          let f4 = new { apply2(cs, varval) =>
            varval.case {
              Tup(varr, vall) => cs.case {
                Known(vs) => cs,
                Unknown => not(rel.apply2(Assign(var_, val_), Assign(varr, vall))).case {
                  True => Known(Cons(var_, Cons(varr, Nil))),
                  False => cs
                }
              }
          }};
          zip_with(new { apply2(x, y) => zip_with(f4, x, y) }, tbl, n_pairs(enum_from_to(var_ + 1, vars), vals))
      }
    }
  }
}

def cache_checks(csp: CSP, tbl: List[List[ConflictSet]], n: Node[List[Assign]]): Node[Pair[List[Assign], List[List[ConflictSet]]]] {
  n.case {
    Node(s, cs) => Node(Tup(s, tbl), map(new { apply(x) => cache_checks(csp, fill_table(s, csp, tail(tbl)), x) }, cs))
  }
}

def to_unknown(ls: List[i64]): List[ConflictSet] {
  ls.case {
    Nil => Nil,
    Cons(m, t2) => Cons(Unknown, to_unknown(t2))
  }
}

def n_unknown(ls: List[i64], n: i64): List[List[ConflictSet]] {
  ls.case {
    Nil => Nil,
    Cons(n, t1) =>  Cons(to_unknown(enum_from_to(1, n)), n_unknown(t1, n))
  }
}

def empty_table(csp: CSP): List[List[ConflictSet]] {
  csp.case {
    CSP(vars, vals, rel) => Cons(Nil, n_unknown(enum_from_to(1, vars), vals))
  }
}

def fst(p: Pair[List[Assign], ConflictSet]): List[Assign] {
  p.case {
    Tup(l, c) => l
  }
}

def snd(p: Pair[List[Assign], ConflictSet]): ConflictSet {
  p.case {
    Tup(l, c) => c
  }
}

def search(labeler: Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]], csp: CSP): List[List[Assign]] {
  let f = new { apply(x) => fst(x) };
  map(f,
    filter(new { apply(x) => known_solution(snd(x)) },
      leaves(
        prune(new { apply(x) => known_conflict(snd(x)) },
          labeler.apply2(csp, mk_tree(csp))))))
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
  let f3 =
    new { apply(s) =>
      Tup(s, (earliest_inconsistency(csp, s).case {
        Some(p) => p.case {
          Tup(a, b) => Known(Cons(a, Cons(b, Nil)))
        },
        None => check_complete(csp, s)
      }))
    };
  map_tree(f3, t)
}

def fst(x: Pair[Pair[List[Assign], ConflictSet], List[List[ConflictSet]]]): Pair[List[Assign], ConflictSet] {
  x.case {
    Tup(p, ls) => p
  }
}

def bm(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  let f = new { apply(x) => fst(x) };
  map_tree(f, lookup_cache(csp, cache_checks(csp, empty_table(csp), t)))
}

def bj(csp: CSP, t: Node[Pair[List[Assign], ConflictSet]]): Node[Pair[List[Assign], ConflictSet]] {
  let f6 =
    new { apply2(tp2, chs) =>
      tp2.case {
        Tup(a, conf) => conf.case {
          Known(cs) => Node(Tup(a, Known(cs)), chs),
          Unknown =>  Node(Tup(a, Known(combine(map(new { apply(x) => lab(x) }, chs), Nil))), chs)
        }
      }
    };
  fold_tree(f6, t)
}

def bjbt(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  bj(csp, bt(csp, t))
}

def bj_(csp: CSP, t: Node[Pair[List[Assign], ConflictSet]]): Node[Pair[List[Assign], ConflictSet]] {
  let f7 =
    new { apply2(tp2, chs) =>
      tp2.case { Tup(a, conf) => conf.case {
        Known(cs) => Node(Tup(a, Known(cs)), chs),
        Unknown =>
          let cs_ = Known(combine(map(new { apply(x) => lab(x) }, chs), Nil));
         known_conflict(cs_).case {
            True => Node(Tup(a, cs_), Nil),
            False => Node(Tup(a, cs_), chs)
          }
      }}
    };
  fold_tree(f7, t)
}

def bjbt_(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
 bj_(csp, bt(csp, t))
}

def fc(csp: CSP, t: Node[List[Assign]]): Node[Pair[List[Assign], ConflictSet]] {
  domain_wipeout(csp, lookup_cache(csp, cache_checks(csp, empty_table(csp), t)))
}

def try_(n: i64, algorithm: Fun2[CSP, Node[List[Assign]], Node[Pair[List[Assign], ConflictSet]]]): i64 {
  len(search(algorithm, queens(n)))
}

def test_constraints_nofib(n: i64): List[i64] {
  map(new { apply(x) => try_(n, x) },
    Cons(new { apply2(csp, n) => bt(csp, n) },
      Cons(new { apply2(csp, n) => bm(csp, n) },
        Cons(new { apply2(csp, n) => bjbt(csp, n) },
          Cons(new { apply2(csp, n) => bjbt_(csp, n) },
            Cons(new { apply2(csp, n) => fc(csp, n) },
              Nil))))))
}

def main_loop(iters: i64, n: i64): i64 {
  if iters == 1 {
    let res = test_constraints_nofib(n);
    println_i64(head(res));
    0
  } else {
    let res = test_constraints_nofib(n);
    main_loop(iters - 1, n)
  }
}

def main(iters: i64, n: i64): i64 {
  main_loop(iters, n)
}
