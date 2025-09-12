module lookuptree

import std/os/env
import std/num/int64

type tree<a>
  Leaf(x: a)
  Node(left: tree<a>, right: tree<a>)

fun create(i: int64, n: int64): div tree<int64> {
  if i<n then
    val t = create(i + 1.int64, n)
    Node(t, t)
  else
    Leaf(n)
}

fun lookup(t: tree<int64>): total int64 {
  match t
    Leaf(v) -> v
    Node(left, _) -> lookup(left)
}

fun main_loop(iters: int64, n: int64): <div, console> () {
  val res = lookup(create(0.int64, n))
  if iters == 1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64, n)
}

fun main(): <exn, console, div, ndet> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters, n)
}
