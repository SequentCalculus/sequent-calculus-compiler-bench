module cryptarithm1

import std/os/env
import std/num/int64

fun enum_from_to(from:int64,to:int64): div list<int64>{
  if from<=to then
    Cons(from,enum_from_to(from + 1.int64,to))
  else 
    Nil
}

fun push_k(p1:list<list<int64>>,k:int64): total list<list<int64>>{
  match p1
    Nil -> Nil
    Cons(h1,t1) -> Cons(Cons(k,h1),push_k(t1,k))
}

fun addj(j:int64,ls:list<int64>): total list<list<int64>>{
  match ls
    Nil -> Cons(Cons(j,Nil),Nil)
    Cons(k,ks) -> Cons(Cons(j,Cons(k,ks)),push_k(addj(j,ks),k))
}

fun addj_ls(p1:list<list<int64>>,j:int64): div list<list<int64>>{
  match p1 
    Nil -> Nil
    Cons(pjs,t1) -> append(addj(j,pjs),addj_ls(t1,j))
}

fun permutations(ls:list<int64>): div list<list<int64>>{
  match ls
    Nil -> Cons(Nil,Nil)
    Cons(j,js) -> addj_ls(permutations(js),j)
}

fun expand(a:int64,b:int64,c:int64,d:int64,e:int64,f:int64) : total int64{
  f + (10.int64 * e) + (100.int64 * d) + (1000.int64 * c) + (10000.int64 * b) + (100000.int64 * a)
}

fun condition(thirywelvn:list<int64>): total bool {
  match thirywelvn
    Cons(t,Cons(h,Cons(i,Cons(r,Cons(y,Cons(w,Cons(e,Cons(l,Cons(v,Cons(n,Nil)))))))))) ->
      expand(t,h,i,r,t,y) + (5.int64 * expand(t,w,e,l,v,e))
      ==
      expand(n,i,n,e,t,y)
    _ -> False
}

fun test_cryptarithm_nofib(n:int64): div list<list<list<int64>>>{
  map(enum_from_to(1.int64,n),fn(i)
    val p0 = take(enum_from_to(0.int64,9.int64 + i),10)
    filter(permutations(p0),fn(l) condition(l))
  )
}

fun main_loop(iters:int64,n:int64) : <console,div,exn> () {
  val res = test_cryptarithm_nofib(n)
  if iters==1.int64 then
    println(unjust(head(unjust(head(unjust(head(res)))))))
  else 
    main_loop(iters - 1.int64,n)
}

fun main(): <exn,ndet,div,console> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
