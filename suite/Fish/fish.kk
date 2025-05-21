module fish

import std/os/env
import std/num/int64

fun todo(a:a) : total a { a }

value struct vec
  x:int64
  y:int64

value struct vec4
  x:int64
  y:int64
  z:int64
  w:int64

fun enum_from_to(from:int64,to:int64): div list<int64>{
  if from<=to then
    Cons(from,enum_from_to(from + 1.int64,to))
  else 
    Nil 
}

fun pseudolimit(arg:vec,p2:vec,p3:vec): list<vec4>{
  todo(Nil)
}

fun test_fish_nofib(m:int64): div list<list<vec4>>{
  map(enum_from_to(1.int64,m),fn(i)
    val n = min(0.int64,i)
    pseudolimit(Vec(0.int64,0.int64),Vec(640.int64 + n,0.int64),Vec(0.int64,640.int64 + n))
  )
}

fun main(): <ndet,exn,console,div> () {
  val args = get-args()
  val n = unjust(parse-int(unjust(head(args)))).int64
  val res = test_fish_nofib(n)
  println(length(unjust(head(res))))
}
