module gcd

import std/os/env
import std/num/int64

fun abs_int(i: int64): total int64 {
  if i < 0.int64 then ~i else i
}

fun map_list<a, b>(l: list<a>, f: a -> div b): div list<b> {
  match l {
    Nil -> Nil
    Cons(x, xs) -> Cons(f(x), map_list(xs, f))
  }
}

fun append_list<a>(l1: list<a>, l2: list<a>): total list<a> {
  match l1 {
    Nil -> l2
    Cons(x, xs) -> Cons(x, append_list(xs, l2))
  }
}

fun enum_from_to(from: int64, to: int64): div list<int64> {
  if from <= to then
    Cons(from, enum_from_to(from + 1.int64, to))
  else
    Nil
}

fun max_(ls: list<int64>): <div, exn> int64 {
  match ls
    Nil -> throw("Empty List")
    Cons(x, Nil) -> x
    Cons(x, Cons(y, ys)) ->
      if x<y then
        max_(Cons(y, ys))
      else
        max_(Cons(x, ys))
}

fun quot_rem(a: int64, b: int64): total (int64, int64) {
  (a / b, a % b)
}

fun g(u1u2u3: (int64, int64, int64), v1v2v3: (int64, int64, int64)): div (int64, int64, int64) {
  match (u1u2u3, v1v2v3)
    ((u1, u2, u3), (v1, v2, v3)) ->
      if v3 == 0.int64 then
        (u3, u1, u2)
      else
        val (q, r) = quot_rem(u3, v3)
        g((v1, v2, v3), (u1 - (q * v1), u2 - (q * v2), r))
}

fun gcd_e(x: int64, y: int64): div (int64, int64, int64) {
  if x == 0.int64 then
    (y, 0.int64, 1.int64)
  else
    g((1.int64, 0.int64, x), (0.int64, 1.int64, y))
}

fun to_pair(i: int64, l: list<int64>): total list<(int64, int64)> {
  match l
    Nil -> Nil
    Cons(j, js) -> Cons((i, j), to_pair(i, js))
}

fun cartesian_product(p1: list<int64>, m1: list<int64>): list<(int64, int64)> {
  match p1
    Nil -> Nil
    Cons(h1, t1) -> append_list(to_pair(h1, m1), cartesian_product(t1, m1))
}

fun test(d: int64): <div, exn> int64 {
  val ns = enum_from_to(5000.int64, 5000.int64 + d)
  val ms = enum_from_to(10000.int64, 10000.int64 + d)
  val tripls = map_list(cartesian_product(ns, ms), fn((x, y)) (x, y, gcd_e(x, y)))
  val rs = map_list(tripls, fn((_, _, (gg, u, v))) abs_int((gg + u) + v))
  max_(rs)
}

fun test_gcd_nofib(x: int64): <div, exn> int64 {
  test(x)
}

fun main_loop(iters: int64, n: int64): <console, div, exn> () {
  val res = test_gcd_nofib(n)
  if iters == 1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64, n)
}

fun main(): <ndet, exn, console, div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters, n)
}
