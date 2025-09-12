module ackgoto

import std/num/int64
import std/os/env

effect ret
  ctl ret(i: int64): int64

fun ret_id(action: () -> <div, ret> int64): div int64 {
  with ctl ret(i) i
  action()
}

fun ack(m: int64, n: int64): <ret, div> int64 {
  if m == 0.int64 then
     ret(n + 1.int64)
  else if n == 0.int64 then
      ack(m - 1.int64, 1.int64)
  else
    ack(m - 1.int64,
        ret_id(fn() ack(m, n - 1.int64))
    )
}

fun main_loop(iters: int64, m: int64, n: int64): <console, div> () {
  val res =
    with handler
      ctl ret(i) i
    ack(m, n)
  if iters == 1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64, m, n)
}

pub fun main() : <console,ndet,exn,div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val m = unjust(parse-int(unjust(head(tail(args))))).int64
  val n = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  main_loop(iters, m, n)
}
