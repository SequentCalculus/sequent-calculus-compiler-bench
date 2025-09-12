module matchoptions

import std/os/env
import std/num/int64

fun attempt(i: int64): div maybe<int64> {
  if i == 0.int64 then
    Just(i)
  else
    match attempt(i - 1.int64)
      Nothing -> Nothing
      Just(x) -> Just(x + 1.int64)
}

fun main_loop(iters: int64, n: int64): <console,div> () {
  val res = match attempt(n)
    Nothing -> -1.int64
    Just(x) -> x
  if iters == 1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64,n)
}

fun main(): <ndet,exn,console,div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters, n)
}
