module integer

import std/os/env
import std/num/int64

fun enum_from_then_to(from:int64,then_:int64,to:int64): div list<int64>{
  if from<=to then 
    Cons(from,enum_from_then_to(then_,(2.int64 * then_) - from,to))
  else
    Nil
}

fun bench_lscomp2(
  ls:list<int64>,t1:list<int64>,a:int64,
  op:(int64,int64) -> either<int64,bool>,
  bstart:int64,bstep:int64,blim:int64
  ): div list<either<int64,bool>>{
  match ls 
    Nil -> bench_lscomp1(t1,bstart,bstep,blim,op)
    Cons(b,t2) -> Cons(op(a,b),bench_lscomp2(t2,t1,a,op,bstart,bstep,blim))
}

fun bench_lscomp1(
  ls:list<int64>,
  bstart:int64,bstep:int64,blim:int64,
  op:(int64,int64) -> either<int64,bool>
  ) : div list<either<int64,bool>>{
  match ls 
    Nil -> Nil
    Cons(a,t1) -> bench_lscomp2(enum_from_then_to(bstart,bstart + bstep, blim), t1,a,op,bstart,bstep,blim)
}

fun integerbench(
  op:(int64,int64) -> either<int64,bool>,
  astart:int64,astep:int64,alim:int64,
  bstart:int64,bstep:int64,blim:int64
  ): div list<either<int64,bool>>{
  bench_lscomp1(enum_from_then_to(astart,astart + astep,alim),bstart,bstep,blim,op)
}

fun runbench(
  jop:(int64,int64) -> either<int64,bool>,
  iop:(int64,int64) -> either<int64,bool>,
  astart:int64,astep:int64,alim:int64,
  bstart:int64,bstep:int64,blim:int64
  ): div list<either<int64,bool>>{
  val _ = integerbench(iop,astart,astep,alim,astart,astep,alim)
  integerbench(jop,astart,astep,alim,astart,astep,alim)
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

  val add = runbench(z_add, fn(a, b) Left(a + b), astart, astep, alim, astart, astep, alim)
  val sub = runbench(z_sub, fn(a, b) Left(a - b), astart, astep, alim, astart, astep, alim)
  val mul = runbench(z_mul, fn(a, b) Left(a * b), astart, astep, alim, astart, astep, alim)
  val div = runbench(z_div, fn(a, b) Left(a / b), astart, astep, alim, astart, astep, alim)
  val mod = runbench(z_mod, fn(a, b) Left(a % b), astart, astep, alim, astart, astep, alim)
  val equal = runbench(z_equal, fn(a,b) Right(a==b), astart, astep, alim, astart, astep, alim)
  val lt = runbench(z_lt, fn(a,b) Right(a<b), astart, astep, alim, astart, astep, alim)
  val leq = runbench(z_leq, fn(a,b) Right(a<=b), astart, astep, alim, astart, astep, alim)
  val gt = runbench(z_gt, fn(a,b) Right(a<b), astart, astep, alim, astart, astep, alim)
  runbench(z_geq, fn(a,b) Right(a<=b), astart, astep, alim, astart, astep, alim)
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
    print_either(unjust(head(res)))
  else 
    main_loop(iters - 1.int64,n)
}

fun main(): <ndet,exn,console,div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
