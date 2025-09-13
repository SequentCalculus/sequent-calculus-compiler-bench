module tailfib

import std/os/env
import std/num/int64

fun tfib(n: int64, a: int64, b: int64): div int64 {
  if n == 0.int64 then
    a
  else
    tfib(n - 1.int64, a + b, a)
}

fun fib(n: int64): div int64 {
  tfib(n, 0.int64, 1.int64)
}

fun main_loop(iters: int64, n: int64): <console, div> () {
  val res = fib(n)
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
