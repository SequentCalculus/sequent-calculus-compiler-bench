module takl

import std/os/env
import std/num/int64

fun null<a>(ls:list<a>): total bool{
  match ls
    Nil -> True
    Cons(_,_) -> False
}

fun tail_list<a>(ls:list<a>): exn list<a>{
  match ls
    Nil -> throw("Empty List")
    Cons(_,xs) -> xs
}

fun head_list<a>(ls:list<a>): exn a{
  match ls
    Nil -> throw("Empty List")
    Cons(x,_) -> x
}

fun list_n(n:int64): div list<int64>{
  if n == 0.int64 then
    Nil
  else 
    Cons(n,list_n(n - 1.int64))
}

fun shorterp(x:list<int64>,y:list<int64>): <div,exn> bool{
  if null(y) then
    False
  else
    if null(x) then
      True
    else 
      shorterp(tail_list(x),tail(y))
}

fun mas(x:list<int64>,y:list<int64>,z:list<int64>): <div,exn> list<int64>{
  if not(shorterp(y,x)) then
    z 
  else 
    mas(
      mas(tail_list(x),y,z),
      mas(tail_list(y),z,x),
      mas(tail_list(z),x,y)
    )
}

fun main_loop(iters:int64,x:int64,y:int64,z:int64): <console,div,exn> (){
  val res = length(mas(list_n(x),list_n(y),list_n(z)))
  if iters == 1.int64 then
    println(res)
  else 
    main_loop(iters - 1.int64,x,y,z)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(head_list(args))).int64
  val x = unjust(parse-int(head_list(tail_list(args)))).int64
  val y = unjust(parse-int(head_list(tail_list(tail(args))))).int64
  val z = unjust(parse-int(head_list(tail_list(tail(tail(args)))))).int64
  main_loop(iters,x,y,z)
}
