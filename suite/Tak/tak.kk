module tak

import std/os/env
import std/num/int64

fun tak(x: int64, y: int64, z: int64): div int64 {
  if y < x then
    tak(
      tak(x - 1.int64, y, z),
      tak(y - 1.int64, z, x),
      tak(z - 1.int64, x, y)
    )
  else
    z
}

fun main_loop(iters: int64, x: int64, y: int64, z: int64): <console, div> () {
  val res = tak(x, y, z)
  if iters == 1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64, x, y, z)
}

fun main(): <ndet, exn, console, div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val x = unjust(parse-int(unjust(head(tail(args))))).int64
  val y = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  val z = unjust(parse-int(unjust(head(tail(tail(tail(args))))))).int64
  main_loop(iters, x, y, z)
}
