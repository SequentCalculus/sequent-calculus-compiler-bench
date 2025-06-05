module takl

import std/os/env
import std/num/int64

fun list_n(n:int64): div list<int64>{
  if n == 0.int64 then
    Nil
  else 
    Cons(n,list_n(n - 1.int64))
}

fun shorterp(x:list<int64>,y:list<int64>): div bool{
  if not(is-empty(y)) then
    if is-empty(x) then
      True
    else 
      shorterp(tail(x),tail(y))
  else 
    False
}

fun mas(x:list<int64>,y:list<int64>,z:list<int64>): div list<int64>{
  if not(shorterp(y,x)) then
    z 
  else 
    mas(
      mas(tail(x),y,z),
      mas(tail(y),z,x),
      mas(tail(z),x,y)
    )
}

fun main_loop(iters:int64,x:int64,y:int64,z:int64): <console,div> (){
  val res = length(mas(list_n(x),list_n(y),list_n(z)))
  if iters == 1.int64 then
    println(res)
  else 
    main_loop(iters - 1.int64,x,y,z)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val x = unjust(parse-int(unjust(head(tail(args))))).int64
  val y = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  val z = unjust(parse-int(unjust(head(tail(tail(tail(args))))))).int64
  main_loop(iters,x,y,z)
}
