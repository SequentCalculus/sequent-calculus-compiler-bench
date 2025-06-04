module constraints 

import std/os/env
import std/num/int64

value struct assign 
  varr:int64
  value:int64

value struct csp
  vars: int64
  vals: int64
  rel: (assign,assign) -> exn bool

type node<a>
  Node(lab:a,children:list<node<a>>)

value type conflictset
  Known(cs: list<int64>)
  Unknown

fun level(a:assign) : total int64{
  match a
    Assign(varr,_) -> varr
}

fun max_level(ls:list<assign>): total int64{
  match ls
    Nil -> 0.int64
    Cons(Assign(v,_),_) -> v
}

fun at_index(ind:int64,ls:list<conflictset>) : exn conflictset{
  match ls
    Nil -> throw("Empty list")
    Cons(c,cs) -> 
      if ind==0.int64 then
        c 
      else 
        at_index(ind - 1.int64,cs)
}

fun complete(csp:csp, s:list<assign>) : total bool {
  match csp
    Csp(v,_,_) -> max_level(s) == v
}

fun enum_from_to(from:int64,to:int64): div list<int64>{
  if (from<=to) then 
    Cons(from,enum_from_to(from + 1.int64,to))
  else
    Nil 
}


fun label(n:node<a>) : total a{
  match n 
    Node(l,_) -> l
}

fun map_tree(f:a -> <div,exn> b,t:node<a>): <div,exn> node<b> {
  match t 
    Node(l,ls) -> Node(f(l),map(ls,fn(x) map_tree(f,x)))
}

fun fold_tree(f:(a,list<node<b>>) -> div node<b> ,t:node<a>) : div node<b> {
  match t 
    Node(l,c) -> f(l,map(c, fn(x) fold_tree(f,x)))
}

fun filter_tree(p:a -> bool,n:node<a>): div node<a>{
  val f = fn(a,cs) Node(a,filter(cs,fn(x) -> p(label(x))))
  fold_tree(f,n)
}

fun leaves(n:node<a>): div list<a> {
  match n 
    Node(leaf,Nil) -> Cons(leaf,Nil)
    Node(_,Cons(c,cs)) -> concat(map(Cons(c,cs),fn(x) leaves(x)))
}

fun prune(f:a -> bool, n:node<a>): div node<a>{
  filter_tree(fn(x) not(f(x)),n)
}

fun in_list(i:int64,ls:list<int64>): total bool{
  match ls
    Nil -> False
    Cons(j,js) ->
      if i==j then True else in_list(i,js)
}

fun not_elem(i:int64,ls:list<int64>): total bool {
  not(in_list(i,ls))
}

fun combine(ls:list<(list<assign>,conflictset)>,acc:list<int64>) : div list<int64>{
  match ls
    Nil -> acc
    Cons((s,Known(cs)),css) -> 
      if not_elem(max_level(s),cs) then
        cs
      else 
        combine(css,union(cs,acc))
    Cons((_,Unknown),_) -> acc
}

fun delete_by(f:(int64,int64) -> bool,x:int64,ys:list<int64>): list<int64>{
  match ys 
    Nil -> Nil
    Cons(y,ys) -> 
      if f(x,y) then
        ys
      else
        Cons(y,delete_by(f,x,ys))
}

fun nub_by(f:(int64,int64) -> bool,ls:list<int64>) : div list<int64>{
  match ls
    Nil -> Nil
    Cons(h,t) -> Cons(h,nub_by(f,filter(t,fn(y) not(f(h,y)))))
  
}

fun union_by(f:(int64,int64) -> bool,l1:list<int64>,l2:list<int64>): div list<int64>{
  append(l1,foldl(nub_by(f,l2),l1,fn(acc,y) -> delete_by(f,y,acc)))
}

fun union(l1:list<int64>,l2:list<int64>): div list<int64>{
  union_by(fn(x,y) -> x==y,l1,l2)
}

fun known_conflict(c:conflictset): total bool{
  match c
    Known(Nil) -> False
    Known(Cons(_,_)) -> True
    Unknown -> False
}

fun known_solution(c:conflictset): total bool{
  match c
    Known(Nil) -> True
    Known(Cons(_,_)) -> False
    Unknown -> False 
}

fun check_complete(csp:csp,s:list<assign>) : conflictset{
  if complete(csp,s) then
    Known(Nil)
  else
    Unknown
}

fun collect(ls:list<conflictset>): div list<int64> {
  match ls 
    Nil -> Nil
    Cons(Known(cs),css) -> union(cs,collect(css))
    Cons(Unknown,_) -> Nil
}


fun domain_wipeout(csp:csp,t:node<((list<assign>,conflictset),list<list<conflictset>>)>): <div,exn> node<(list<assign>,conflictset)>{
  val f8 = fn(((as_,cs),tbl))
    val wiped_domains = filter(tbl,fn(x) all(x,known_conflict))
    val cs_ = 
      if (is-empty(wiped_domains)) then
        cs
      else 
        Known(collect(unjust(head(wiped_domains))))
    (as_,cs_)
  map_tree(f8,t)
}

fun to_unknown(ls:list<int64>): total list<conflictset>{
  match ls
    Nil -> Nil
    Cons(_,t2) -> Cons(Unknown,to_unknown(t2))
}

fun n_unknown(ls:list<int64>,n:int64): div list<list<conflictset>> {
  match ls 
    Nil -> Nil
    Cons(_,t1) -> Cons(to_unknown(enum_from_to(1.int64, n)), n_unknown(t1,n))
}

fun empty_table(csp:csp): div list<list<conflictset>> {
  match csp
    Csp(vars,vals,_) -> Cons(Nil,n_unknown(enum_from_to(1.int64, vars), vals))
}

fun to_pairs(ls:list<int64>,varrr:int64): total list<(int64,int64)> {
  match ls 
    Nil -> Nil
    Cons(valll,t2) -> Cons((varrr,valll),to_pairs(t2,varrr))
}

fun n_pairs(ls:list<int64>,vals:int64) : div list<list<(int64,int64)>>{
  match ls
    Nil -> Nil
    Cons(varrr,t1) -> Cons(to_pairs(enum_from_to(1.int64, vals), varrr), n_pairs(t1,vals))
}

fun fill_table(s:list<assign>,csp:csp,tbl:list<list<conflictset>>) : <div,exn> list<list<conflictset>> {
  match s 
    Nil -> tbl
    Cons(Assign(var_,val_),_) -> 
      match csp
        Csp(vars,vals,rel) ->
          val f4 = fn(cs,(varr,vall))
            match cs
              Known(_) -> cs
              Unknown -> 
                if not(rel(Assign(var_,val_),Assign(varr,vall))) then
                  Known(Cons(var_,Cons(varr,Nil)))
                else
                  cs
          zipwith(tbl,n_pairs(enum_from_to(var_ + 1.int64,vars),vals),fn(x,y) -> zipwith(x,y,f4))
}

fun cache_checks(csp:csp,tbl:list<list<conflictset>>,n:node<list<assign>>): <div,exn> node<(list<assign>,list<list<conflictset>>)>{
  match n
    Node(s,cs) -> Node((s,tbl),map(cs,fn(x) cache_checks(csp,fill_table(s,csp,tail(tbl)),x)))
}

fun lookup_cache(csp:csp,t:node<(list<assign>,list<list<conflictset>>)>) : <div,exn> node<((list<assign>,conflictset),list<list<conflictset>>)> {
  val f5 = fn(csp_,(ls,tbl)) 
    match ls
      Nil -> ((Nil,Unknown),tbl)
      Cons(a,as_) -> 
        val table_entry = at_index(value(a) - 1.int64,unjust(list/head(tbl)))
        val cs = match table_entry
          Unknown  -> check_complete(csp_,Cons(a,as_))
          Known(_) -> table_entry
        ((Cons(a,as_),cs),tbl)
  map_tree(fn(x) f5(csp,x),t)
}

fun init_tree(f:list<assign> -> div list<list<assign>>,x:list<assign>): div node<list<assign>>{
  Node(x,map(f(x),fn(y) -> init_tree(f,y)))
}

fun to_assign(ls:list<int64>,ss:list<assign>): total list<list<assign>> {
  match ls 
    Nil -> Nil
    Cons(j,t1) -> Cons(Cons(Assign(max_level(ss) + 1.int64, j), ss), to_assign(t1,ss))
}

fun mk_tree(csp:csp) : div node<list<assign>> {
  match csp 
    Csp(vars,vals,_) -> 
      val next = fn(ss) 
        if (max_level(ss) < vars) then 
          to_assign(enum_from_to(1.int64,vals),ss)
        else
          Nil
      init_tree(next,Nil)
}

fun earliest_inconsistency(csp:csp,aas:list<assign>): exn maybe<(int64,int64)> {
  match(csp,aas)
    (_,Nil) -> Nothing
    (Csp(_,_,rel),Cons(a,as_)) ->
      match filter(reverse(as_),fn(x) not(rel(a,x)))
        Nil -> Nothing
        Cons(b,_) -> Just((level(a),level(b)))
}

fun search(labeler: (csp,node<list<assign>>) -> <div,exn> node<(list<assign>,conflictset)>,csp:csp) : <div,exn> list<list<assign>> {
  map(
    filter(
      leaves(
        prune(
          fn((_,x)) known_conflict(x),
          labeler(csp,mk_tree(csp))
        )
      ), 
      fn((_,x)) known_solution(x)
    ),
    fn((x,_)) x
  )
}

fun safe(as1:assign,as2:assign): exn bool{
  match (as1,as2) 
    (Assign(i,m),Assign(j,n)) -> not(m==n) && not(abs(i - j)==abs(m - n)) 
}

fun queens(n:int64) : total csp {
  CSP(n,n, fn(x,y) safe(x,y))
}

fun try_(n:int64,algorithm:(csp,node<list<assign>>) -> <div,exn> node<(list<assign>,conflictset)>) : <div,exn> int64 {
  length(search(algorithm,queens(n))).int64
}

fun bt(csp:csp,t:node<list<assign>>): <div,exn> node<(list<assign>,conflictset)> {
  val f3 = fn(s)
    match earliest_inconsistency(csp,s)
      Just((a,b)) -> (s,Known(Cons(a,Cons(b,Nil))))
      Nothing -> (s,check_complete(csp,s))
  map_tree(f3,t)
}

fun bm(csp:csp,t:node<list<assign>>): <div,exn> node<(list<assign>,conflictset)> {
  map_tree(fn((x,_)) x,lookup_cache(csp,cache_checks(csp,empty_table(csp),t)))
}

fun bj(csp:csp,t:node<(list<assign>,conflictset)>): div node<(list<assign>,conflictset)>{
  val f6 = fn((a,conf),chs)
    match conf
      Known(cs) -> Node((a,Known(cs)),chs)
      Unknown -> Node((a,Known(combine(map(chs,fn(x) label(x)),Nil))),chs)
  fold_tree(f6,t)
}

fun bjbt(csp:csp,t:node<list<assign>>): <div,exn> node<(list<assign>,conflictset)> {
  bj(csp,bt(csp,t))
}

fun bj_(csp:csp,t:node<(list<assign>,conflictset)>): div node<(list<assign>,conflictset)>{
  val f7 = fn((a,conf),chs) 
    match conf
      Known(cs) -> Node((a,Known(cs)),chs)
      Unknown ->
        val cs_ = Known(combine(map(chs,fn(x) label(x)),Nil))
        if known_conflict(cs_) then
          Node((a,cs_),Nil)
        else 
          Node((a,cs_),chs)
  fold_tree(f7,t)
}

fun bjbt_(csp:csp,t:node<list<assign>>): <div,exn> node<(list<assign>,conflictset)> {
  bj_(csp,bt(csp,t))
}

fun fc(csp:csp,t:node<list<assign>>): <div,exn> node<(list<assign>,conflictset)> {
  domain_wipeout(csp,lookup_cache(csp,cache_checks(csp,empty_table(csp),t)))
}

fun test_constraints_nofib(n:int64) : <div,exn> list<int64>{
  map(
    Cons(bt,Cons(bm,Cons(bjbt,Cons(bjbt_,Cons(fc,Nil))))),
    fn(x) try_(n,x)
  )
}

fun main_loop(iters:int64,n:int64) : <div,exn,console> (){
  val res = test_constraints_nofib(n)
  if iters==1.int64 then
    println(unjust(head(res)))
  else
    main_loop(iters - 1.int64,n)
}

pub fun main() : <div,console,exn,ndet> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
