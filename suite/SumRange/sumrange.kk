module sumrange

import std/os/env
import std/num/int64

fun range(i: int64, n: int64): div list<int64> {
  if i < n then
    Cons(i, range(i + 1.int64, n))
  else
    Nil
}

fun sum(xs: list<int64>): total int64 {
  match xs
    Nil -> 0.int64
    Cons(y, ys) -> y + sum(ys)
}

fun main_loop(iters: int64, n: int64): <console, div> () {
  val res = sum(range(0.int64, n))
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
