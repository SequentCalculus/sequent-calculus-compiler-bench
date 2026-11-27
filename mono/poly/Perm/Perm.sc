data Unit { Unit }
data Bool { True, False }
data List[A] { Nil, Cons(a: A, as: List[A]) }
data Pair[A, B] { Tup(a: A, b: B) }
codata Fun[A, B] { apply(a: A): B }

def factorial(n: i64): i64 {
  if n == 1 {
    1
  } else {
    n * factorial(n - 1)
  }
}

def tail[A+](l: List[A]): List[A] {
  l.case[A] {
    Nil => Nil, //should give a runtime error
    Cons(i, is) => is
  }
}

def head_i(l: List[i64]): i64 {
  l.case[i64] {
    Nil => 0, //should give a runtime error
    Cons(i, is) => i
  }
}

def head_list[A+](l: List[List[A]]): List[A] {
  l.case[List[A]] {
    Nil => Nil, //should give a runtime error
    Cons(is, iss) => is
  }
}

def len[A+](l: List[A]): i64 {
  l.case[A]{
    Nil => 0,
    Cons(x, xs) => 1 + len[A](xs)
  }
}

def rev_loop(x: List[i64], n: i64, y: List[i64]): List[i64] {
  if n == 0 {
    y
  } else {
    rev_loop(tail[i64](x), n - 1, Cons(head_i(x), y))
  }
}

def loop_sum(y: List[i64]): i64 {
  y.case[i64]{
    Nil => 0,
    Cons(h, t) => h + loop_sum(t)
  }
}

def sumlists(x: List[List[i64]]): i64 {
  x.case[List[i64]]{
    Nil => 0,
    Cons(h, t) => loop_sum(h) + sumlists(t)
  }
}

def loop_one2n(n: i64, p: List[i64]): List[i64] {
  if n == 0 {
    p
  } else {
    loop_one2n(n - 1, Cons(n, p))
  }
}

def one2n(n: i64): List[i64] {
  loop_one2n(n, Nil)
}

def list_tail[A+](x: List[A], n: i64): List[A] {
  if n == 0 {
    x
  } else {
    list_tail[A](tail[A](x), n - 1)
  }
}

def f(n: i64, perms: List[List[i64]], x: List[i64]): Pair[List[List[i64]], List[i64]] {
  let x: List[i64] = rev_loop(x, n, list_tail[i64](x, n));
  let perms: List[List[i64]] = Cons(x, perms);
  Tup(perms, x)
}

def loop_p(j: i64, perms: List[List[i64]], x: List[i64], n: i64): Pair[List[List[i64]], List[i64]] {
  if j == 0 {
    p(n - 1, perms, x)
  } else {
    let pair_perms_x: Pair[List[List[i64]], List[i64]] = p(n - 1, perms, x);
    pair_perms_x.case[List[List[i64]], List[i64]] {
      Tup(perms, x) =>
        let pair_perms_x: Pair[List[List[i64]], List[i64]] = f(n, perms, x);
        pair_perms_x.case[List[List[i64]], List[i64]] {
          Tup(perms, x) => loop_p(j - 1, perms, x, n)
        }
    }
  }
}

def p(n: i64, perms: List[List[i64]], x: List[i64]): Pair[List[List[i64]], List[i64]] {
  if 1 < n {
    loop_p(n - 1, perms, x, n)
  } else {
    Tup(perms, x)
  }
}

def permutations(x0: List[i64]): List[List[i64]] {
  p(len[i64](x0), Cons(x0, Nil), x0).case[List[List[i64]], List[i64]] {
    Tup(final_perms, x) => final_perms
  }
}

def loop_work(m: i64, perms: List[List[i64]]): List[List[i64]] {
  if m == 0 {
    perms
  } else {
    loop_work(m - 1, permutations(head_list[i64](perms)))
  }
}

def run_benchmark[A+](work: Fun[Unit, A], result: Fun[A, Bool]): Bool {
  result.apply[A, Bool](work.apply[Unit, A](Unit))
}

def perm9(m: i64, n: i64): Bool {
  run_benchmark[List[List[i64]]](
    new { apply(u) =>  loop_work(m, permutations(one2n(n))) },
    new { apply(result) =>
      if sumlists(result) == (((n * (n + 1)) * factorial(n)) / 2) {
        True
      } else {
        False
      }
    })
}

def main_loop(iters: i64, m: i64, n: i64): i64 {
  let res: Bool = perm9(m, n);
  if iters == 1 {
    res.case {
      True => println_i64(1);
              0,
      False => println_i64(0);
               0
    }
  } else {
    main_loop(iters - 1, m, n)
  }
}

def main(iters: i64, m: i64, n: i64): i64 {
  main_loop(iters, m, n)
}
