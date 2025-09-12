module lcss

import std/os/env
import std/num/int64

fun rev_loop<a>(ls: list<a>, acc: list<a>): total list<a> {
  match ls
    Nil -> acc
    Cons(x, xs) -> rev_loop(xs, Cons(x, acc))
}

fun rev<a>(ls: list<a>): total list<a> {
  rev_loop(ls, Nil)
}

fun map_list<a, b>(ls: list<a>, f: a -> <div, exn> b): <div, exn> list<b> {
  match ls
    Nil -> Nil
    Cons(x, xs) -> Cons(f(x), map_list(xs, f))
}

fun list_head<a>(ls: list<a>): exn a {
  match ls
    Nil -> throw("Empty List")
    Cons(h, _) -> h
}

fun take_list<a>(l: list<a>, n: int64): total list<a> {
  match l {
    Nil -> Nil
    Cons(a, as_) -> if n == 0.int64 then Nil else Cons(a, take_list(as_, n - 1.int64))
  }
}

fun drop_list<a>(l: list<a>, n: int64): total list<a> {
  if n == 0.int64 then
    l
  else
    match l {
      Nil -> Nil
      Cons(_, as_) -> drop_list(as_, n - 1.int64)
    }
}

fun is_nil(xs: list<a>): total bool {
  match xs
    Nil -> True
    _ -> False
}

fun is_singleton(xs: list<a>): total maybe<a> {
  match xs
    Cons(x, Nil) -> Just(x)
    _ -> Nothing
}

fun len<a>(ls: list<a>): total int64 {
  match ls {
    Nil -> 0.int64
    Cons(_, xs) -> 1.int64 + len(xs)
  }
}

fun in_list(x: int64, ls: list<int64>): div bool {
  match ls
    Nil -> False
    Cons(x_, xs) ->
      if x == x_ then
        True
      else
        in_list(x, xs)
}

fun enum_from_then_to(from: int64, then_: int64, to: int64): div list<int64> {
  if from <= to then
    Cons(from, enum_from_then_to(then_, (2.int64 * then_) - from, to))
  else
    Nil
}

fun add_zero(xs: list<int64>): div list<(int64, int64)> {
  match xs
    Nil -> Nil
    Cons(h, t) -> Cons((h, 0.int64), add_zero(t))
}

fun algb2(x: int64, k0j1: int64, k1j1: int64, yss: list<(int64, int64)>): div list<(int64, int64)> {
  match yss
    Nil -> Nil
    Cons((y, k0j), ys) ->
      val kjcurr =
        if x == y then
          k0j1 + 1.int64
        else
          max(k1j1, k0j)
      Cons((y, kjcurr), algb2(x, k0j, kjcurr, ys))
}

fun algb1(xss: list<int64>, yss: list<(int64, int64)>): <div, exn> list<int64> {
  match xss
    Nil -> map_list(yss, fn((_, x)) x)
    Cons(x, xs) -> algb1(xs, algb2(x, 0.int64, 0.int64, yss))
}

fun algb(xs: list<int64>, ys: list<int64>): <div, exn> list<int64> {
  Cons(0.int64, algb1(xs, add_zero(ys)))
}

fun findk(k: int64, km: int64, m: int64, ls: list<(int64, int64)>): div int64 {
  match ls
    Nil -> km
    Cons((x, y), xys) ->
      if m <= (x + y) then
        findk(k + 1.int64, k, x + y, xys)
      else
        findk(k + 1.int64, km, m, xys)
}

fun algc(m: int64, n: int64, xs: list<int64>, ys: list<int64>): <div, exn> (list<int64> -> <div, exn> list<int64>) {
  if is_nil(ys) then
    fn(x) x
  else
    match is_singleton(xs)
      Just(x) ->
        if in_list(x, ys) then
          fn(t) Cons(x, t)
        else
          fn(x_) x_
      Nothing ->
        val m2 = m / 2.int64
        val xs1 = take_list(xs, m2)
        val xs2 = drop_list(xs, m2)
        val l1 = algb(xs1, ys)
        val l2 = rev(algb(rev(xs2), rev(ys)))
        val k = findk(0.int64, 0.int64, (-1).int64, zip(l1, l2))
        fn(x)
          val f1 = algc(m - m2, n - k, xs2, drop_list(ys, k))
          val f2 = algc(m2, k, xs1, take_list(ys, k))
          f2(f1(x))
}

fun lcss(xs: list<int64>, ys: list<int64>): <div, exn> list<int64> {
  algc(len(xs), len(ys), xs, ys)(Nil)
}

fun lcss_main(a: int64, b: int64, c: int64, d: int64, e: int64, f: int64): <div, exn> list<int64> {
  lcss(enum_from_then_to(a, b, c), enum_from_then_to(d, e, f))
}

fun test_lcss_nofib(c: int64, f: int64): <div, exn> list<int64> {
  lcss_main(1.int64, 2.int64, c, 100.int64, 101.int64, f)
}

fun main_loop(iters: int64, c: int64, f: int64): <console, div, exn> () {
  val res = test_lcss_nofib(c, f)
  if iters == 1.int64 then
    println(list_head(res))
  else
    main_loop(iters - 1.int64, c, f)
}

fun main(): <ndet, exn, console, div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val c = unjust(parse-int(unjust(head(tail(args))))).int64
  val f = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  main_loop(iters, c, f)
}
