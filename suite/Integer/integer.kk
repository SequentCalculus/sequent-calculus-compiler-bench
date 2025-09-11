module integer

import std/os/env
import std/num/int64

fun head_list<a>(ls:list<a>): exn a{
  match ls{
    Nil -> throw("Empty List")
    Cons(a,_) -> a
  }
}

fun enum_from_then_to(from:int64,then_:int64,to:int64): div list<int64>{
  if from<=to then 
    Cons(from,enum_from_then_to(then_,(2.int64 * then_) - from,to))
  else
    Nil
}

fun apply_op_inner(
  ls:list<int64>,a:int64,
  op:(int64,int64) -> either<int64,bool>): total list<either<int64,bool>> {
  match ls 
    Nil -> Nil 
    Cons(b,t2) -> Cons(op(a,b),apply_op_inner(t2,a,op))
}

fun apply_op(
  ls:list<int64>,
  astart:int64,astep:int64,alim:int64,
  op:(int64,int64) -> either<int64,bool>
  ) : div list<either<int64,bool>>{
  match ls 
    Nil -> Nil
    Cons(a,t1) -> 
      append(
        apply_op_inner(enum_from_then_to(astart,astart + astep, alim), a,op),
        apply_op(t1,astart,astep,alim,op)
      )
}

fun integerbench(
  op:(int64,int64) -> either<int64,bool>,
  astart:int64,astep:int64,alim:int64): div list<either<int64,bool>>{
  apply_op(enum_from_then_to(astart,astart + astep,alim),astart,astep,alim,op)
}

fun runbench(
  jop:(int64,int64) -> either<int64,bool>,
  astart:int64,astep:int64,alim:int64): div list<either<int64,bool>>{
  val _ = integerbench(jop,astart,astep,alim)
  integerbench(jop,astart,astep,alim)
}

fun runalltests(astart:int64,astep:int64,alim:int64): div list<either<int64,bool>>{
  val z_add: (int64,int64) -> total either<int64,bool> = fn(a, b) Left(a + b) 
  val z_sub: (int64,int64) -> total either<int64,bool> = fn(a, b) Left(a - b) 
  val z_mul: (int64,int64) -> total either<int64,bool> = fn(a, b) Left(a * b) 
  val z_div: (int64,int64) -> total either<int64,bool> = fn(a, b) Left(a / b) 
  val z_mod: (int64,int64) -> total either<int64,bool> = fn(a, b) Left(a % b) 
  val z_equal: (int64,int64) -> total either<int64,bool> = fn(a, b) Right(a == b)
  val z_lt: (int64,int64) -> total either<int64,bool> = fn(a, b) Right(a<b) 
  val z_leq: (int64,int64) -> total either<int64,bool> = fn(a, b) Right(a<=b)
  val z_gt: (int64,int64) -> total either<int64,bool> = fn(a, b) Right(a<b) 
  val z_geq: (int64,int64) -> total either<int64,bool> = fn(a, b) Right(a<=b) 

  val add = runbench(z_add, astart, astep, alim)
  val sub = runbench(z_sub, astart, astep, alim)
  val mul = runbench(z_mul, astart, astep, alim)
  val div = runbench(z_div, astart, astep, alim)
  val mod = runbench(z_mod, astart, astep, alim)
  val equal = runbench(z_equal, astart, astep, alim)
  val lt = runbench(z_lt, astart, astep, alim)
  val leq = runbench(z_leq, astart, astep, alim)
  val gt = runbench(z_gt,astart, astep, alim)
  runbench(z_geq, astart, astep, alim)
}

fun test_integer_nofib(n:int64): div list<either<int64,bool>>{
  runalltests(-2100000000.int64, n, 2100000000.int64)
}

fun print_either(e:either<int64,bool>): console (){
  match e
    Left(i) -> println(i)
    Right(b) -> 
      if b then
        println("11")
      else 
        println("00")
}

fun main_loop(iters:int64,n:int64): <console,div,exn> (){
  val res = test_integer_nofib(n)
  if iters == 1.int64 then
    print_either(head_list(res))
  else 
    main_loop(iters - 1.int64,n)
}

fun main(): <ndet,exn,console,div> () {
  val args = get-args()
  val iters = unjust(parse-int(head_list(args))).int64
  val n = unjust(parse-int(head_list(tail(args)))).int64
  main_loop(iters,n)
}
