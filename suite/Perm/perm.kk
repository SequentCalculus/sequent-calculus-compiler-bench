module perm

import std/os/env
import std/num/int64

fun tail_n(l:list<int64>,n:int64): div list<int64>{
  if n == 0.int64 then
    l 
  else 
    tail_n(tail(l),n - 1.int64)
}

fun rev_loop(x:list<int64>,n:int64,y:list<int64>): <div,exn> list<int64>{
  if n == 0.int64 then
    y 
  else 
    rev_loop(tail(x),n - 1.int64,Cons(unjust(head(x)),y))
}

fun f(n:int64,perms:list<list<int64>>,x:list<int64>): <div,exn> (list<list<int64>>,list<int64>){
  val x_ = rev_loop(x,n,tail_n(x,n))
  val perms_ = Cons(x_,perms)
  (perms_,x_)
}

fun loop_p(j:int64,perms:list<list<int64>>,x:list<int64>,n:int64): <div,exn> (list<list<int64>>,list<int64>){
  if j == 0.int64 then
    p(n - 1.int64,perms,x)
  else 
    val (perms_,x_) = p(n - 1.int64,perms,x)
    val (perms__,x__) = f(n,perms_,x_)
    loop_p(j - 1.int64,perms__,x__,n)
}

fun p(n:int64,perms:list<list<int64>>,x:list<int64>): <div,exn> (list<list<int64>>,list<int64>){
  if 1.int64 < n then
    loop_p(n - 1.int64, perms,x,n)
  else 
    (perms,x)
}

fun permutations(x0:list<int64>): <div,exn> list<list<int64>>{
  val (final_perms,_) = p(length(x0).int64,Cons(x0,Nil),x0)
  final_perms
}

fun loop_sum2(y:list<int64>,sum:int64): total int64{
  match y
    Nil -> sum
    Cons(h,t) -> loop_sum2(t,sum + h)
}

fun loop_sum1(x:list<list<int64>>,sum:int64): total int64{
  match x
    Nil -> sum
    Cons(h,t) -> loop_sum1(t,loop_sum2(h,sum))
}

fun sumlists(x:list<list<int64>>): total int64{
  loop_sum1(x,0.int64)
}

fun loop_one2n(n:int64,p:list<int64>): div list<int64>{
  if n == 0.int64 then
    p 
  else 
    loop_one2n(n - 1.int64,Cons(n,p))
}

fun one2n(n:int64): div list<int64>{
  loop_one2n(n,Nil)
}

fun loop_run(iters:int64,
  work:() -> <div,exn> list<list<int64>>,
  result: list<list<int64>> -> div bool
): <div,exn> bool{
  val res = result(work())
  if iters == 0.int64 then
    res 
  else 
    loop_run(iters - 1.int64,work,result)
}

fun run_benchmark(iters:int64,
  work: () -> <div,exn> list<list<int64>>,
  result:list<list<int64>> -> div bool
) : <div,exn> bool{
  loop_run(iters,work,result)
}

fun factorial(n:int64): div int64{
  if n == 1.int64 then
    n
  else 
    n * factorial(n - 1.int64)
}

fun loop_work(m:int64,perms:list<list<int64>>): <div,exn> list<list<int64>>{
  if m == 0.int64 then
    perms
  else 
    loop_work(m - 1.int64,permutations(unjust(head(perms))))
}

fun perm9(m:int64,n:int64): <div,exn> bool{
  run_benchmark(1.int64,
    fn() loop_work(m,permutations(one2n(n))),
    fn(result) sumlists(result) == ((n * (n + 1.int64)) * factorial(n)) / 2.int64
  )
}

fun main_loop(iters:int64,m:int64,n:int64): <console,div,exn> (){
  val res = perm9(m,n)
  if iters == 1.int64 then
    if res then
      println("1")
    else 
      println("0")
  else 
    main_loop(iters - 1.int64,m,n)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val m = unjust(parse-int(unjust(head(tail(args))))).int64
  val n = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  main_loop(iters,m,n)
}
