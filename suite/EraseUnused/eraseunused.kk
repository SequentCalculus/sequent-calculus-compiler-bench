import std/os/env
import std/num/int64

fun useless(i: int64, n: int64, b: list<i64>): div int64 {
  if i < n then
    useless(i + 1.int64, n, replicate(0.int64, i, Nil))
  else
    i
}

fun replicate(v: int64, n: int64, a: list<int64>): div list<int64> {
  if n == 0.int64 then
    a
  else
    replicate(v, n - 1.int64, Cons(v, a))
}

fun main_loop(iters: int64, n: int64): <console, div> () {
  val res = useless(0.int64, n, Nil)
  if iters == 0.int64 then
    println(res)
  else
    main_loop(iters - 1.int64, n)
}

fun main(): <exn, ndet, console, div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters, n)
}
