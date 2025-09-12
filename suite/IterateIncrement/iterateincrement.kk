module iterateincrement

import std/os/env
import std/num/int64

fun iterate(i: int64, f: int64 -> int64, a: int64): div int64 {
  if i == 0.int64 then
    a
  else
    iterate(i - 1.int64, f, f(a))
}

fun main_loop(iters: int64 , n: int64): <div, console> () {
  val res = iterate(n, fn(x) x + 1.int64, 0.int64)
  if iters == 1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64, n)
}

fun main() : <ndet, exn, div, console> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters, n)
}
