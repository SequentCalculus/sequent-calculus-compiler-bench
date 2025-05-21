module minimax

import std/os/env
import std/num/int64

struct rosetree<a> 
  a:a
  as_:list<rosetree<a>>

type player
  X 
  O

fun top(t:rosetree<a>): total a {
  match t
    Rosetree(p,_) -> p
}

fun mk_leaf(p:a): rosetree<a>{
  Rosetree(p,Nil)
}

fun other(p:player): total player{
  match p
    X -> O
    O -> X
}

fun player_eq(p1:player,p2:player): total bool{
  match (p1,p2)
    (X,X) -> True
    (O,O) -> True
    _ -> False
}

fun exists_l(f:a -> exn bool, l:list<a>): exn bool{
  match l
    Nil -> False
    Cons(a,as_) -> if f(a) then True else exists_l(f,as_)
}

fun tabulate_loop(n:int64,len:int64,f:() -> maybe<player>): div list<maybe<player>>{
  if n == len then
    Nil
  else 
    Cons(f(),tabulate_loop(n + 1.int64,len,f))
}

fun tabulate(len:int64,f:() -> maybe<player>): <div,exn> list<maybe<player>>{
  if len < 0.int64 then
    throw("Negative list length")
  else 
    tabulate_loop(0.int64,len,f)
}

fun nth(l:list<a>,i:int64): exn a {
  match l
    Nil -> throw("Empty list")
    Cons(a,as_) -> if i==0.int64 then a else nth(as_,i - 1.int64)
}

fun find_player(l:list<maybe<player>>,i:int64): exn maybe<player> {
  match l 
    Nil -> throw("Empty list")
    Cons(p,ps) -> 
      if i == 0.int64 then
        p
      else 
        find_player(ps,i - 1.int64)
}

fun list_extreme(f:(int64,int64) -> int64,l:list<int64>): exn int64{
  match l 
    Nil -> throw("Empty List")
    Cons(i,is) -> foldl(is,i,f)
}

fun listmax(l:list<int64>): exn int64{
  list_extreme(fn(a,b) if b < a then a else b,l)
}

fun listmin(l:list<int64>): exn int64{
  list_extreme(fn(a,b) if a < b then a else b,l)
}

fun rows(): total list<list<int64>> {
  Cons(Cons(0.int64, Cons(1.int64, Cons(2.int64, Nil))),
    Cons(Cons(3.int64, Cons(4.int64, Cons(5.int64, Nil))), 
      Cons(Cons(6.int64, Cons(7.int64, Cons(8.int64, Nil))), 
        Nil)))
}

fun cols(): total list<list<int64>>{
  Cons(Cons(0.int64, Cons(3.int64, Cons(6.int64, Nil))),
    Cons(Cons(1.int64, Cons(4.int64, Cons(7.int64, Nil))),
      Cons(Cons(2.int64, Cons(5.int64, Cons(8.int64, Nil))), 
        Nil)))
}

fun diags(): total list<list<int64>>{
  Cons(Cons(0.int64, Cons(4.int64, Cons(8.int64, Nil))), 
    Cons(Cons(2.int64, Cons(4.int64, Cons(6.int64, Nil))),
      Nil))

}

fun empty(): <div,exn> list<maybe<player>>{
  tabulate(9.int64,fn () -> Nothing)
}

fun put_at(x:maybe<player>,xs:list<maybe<player>>,i:int64): <div,exn> list<maybe<player>>{
  if i == 0.int64 then 
    Cons(x,tail(xs))
  else if 0.int64 < i then 
    Cons(unjust(head(xs)),put_at(x,tail(xs),i - 1.int64))
  else 
    throw("Negative list index")
}

fun is_occupied(board:list<maybe<player>>,i:int64): exn bool{
  is-just(nth(board,i))
}

fun move_to(board:list<maybe<player>>,p:player,i:int64): <div,exn> list<maybe<player>>{
  if is_occupied(board,i) then
    throw("Positon occupied")
  else 
    put_at(Just(p),board,i)
}

fun all_moves_rec(n:int64,board:list<maybe<player>>,acc:list<int64>): total list<int64>{
  match board 
    Nil -> reverse(acc)
    Cons(Just(_),more) -> all_moves_rec(n + 1.int64,more,acc)
    Cons(Nothing,more) -> all_moves_rec(n + 1.int64,more,Cons(n,acc))
}

fun all_moves(board:list<maybe<player>>): total list<int64>{
  all_moves_rec(0.int64,board,Nil)
}

fun successors(board:list<maybe<player>>,p:player): <div,exn> list<list<maybe<player>>>{
  map(all_moves(board),fn(i) move_to(board,p,i))
}

fun is_full(board:list<maybe<player>>): total bool{
  all(board,fn(p) is-just(p))
}

fun player_occupies(p:player,board:list<maybe<player>>,i:int64): exn bool{
  match find_player(board,i) 
    Just(p0) -> player_eq(p,p0)
    Nothing -> False
}

fun has_trip(board:list<maybe<player>>,p:player,l:list<int64>): exn bool{
  all(l,fn(i) player_occupies(p,board,i))
}

fun has_row(board:list<maybe<player>>,p:player): exn bool{
  exists_l(fn(l) has_trip(board,p,l),rows())
}

fun has_col(board:list<maybe<player>>,p:player): exn bool{
  exists_l(fn(l) has_trip(board,p,l),cols())
}

fun has_diag(board:list<maybe<player>>,p:player): exn bool{
  exists_l(fn(l) has_trip(board,p,l),diags())
}

fun is_win_for(board:list<maybe<player>>,p:player): exn bool{
  has_row(board,p) || has_col(board,p) || has_diag(board,p)
}

fun is_cat(board:list<maybe<player>>): exn bool{
  is_full(board) && not(is_win_for(board,X)) && not(is_win_for(board,O))
}

fun is_win(board:list<maybe<player>>): exn bool{
  is_win_for(board,X) || is_win_for(board,O)
}

fun game_over(board:list<maybe<player>>): exn bool{
  is_win(board) || is_cat(board)
}

fun score(board:list<maybe<player>>): exn int64{
  if is_win_for(board,X) then
    1.int64
  else if is_win_for(board,O) then
    (-1).int64
  else 
    0.int64
}

fun minimax(p:player,board:list<maybe<player>>): <div,exn> rosetree<(list<maybe<player>>,int64)>{
  if game_over(board) then
    mk_leaf((board,score(board)))
  else 
    val trees = map(successors(board,p), fn(b) minimax(other(p),b))
    val scores = map(trees,fn(t) snd(top(t)))
    match p 
      X -> Rosetree((board,listmax(scores)),trees)
      O -> Rosetree((board,listmin(scores)),trees)
}

fun main_loop(iters:int64): <console,div,exn> (){
  val res = minimax(X,empty())
  if iters == 1.int64 then
    println(snd(top(res)))
  else 
    main_loop(iters - 1.int64)
}

fun main(): <exn,ndet,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  main_loop(iters)
}
