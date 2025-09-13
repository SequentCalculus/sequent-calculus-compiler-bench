module minimax

import std/os/env
import std/num/int64

type player
  X
  O

struct rosetree<a>
  a: a
  as_: list<rosetree<a>>

fun mk_leaf(p: a): rosetree<a> {
  Rosetree(p, Nil)
}

fun top(t: rosetree<a>): total a {
  match t
    Rosetree(p, _) -> p
}

fun snd_pair<a, b>((_, x): (a, b)): b {
 x
}

fun player_eq(p1: player, p2: player): total bool {
  match (p1, p2)
    (X, X) -> True
    (O, O) -> True
    _ -> False
}

fun other(p: player): total player {
  match p
    X -> O
    O -> X
}

fun is_some<a>(p: maybe<a>): total bool {
  match p
    Nothing -> False
    Just(_) -> True
}

fun head_list<a>(l: list<a>): exn a {
  match l
    Nil -> throw("Empty List")
    Cons(x, _) -> x
}

fun tail_list<a>(l: list<a>): exn list<a> {
  match l
    Nil -> throw("Empty List")
    Cons(_, xs) -> xs
}

fun rev_loop<a>(l: list<a>, acc: list<a>): total list<a> {
  match l
    Nil -> acc
    Cons(x, xs) -> rev_loop(xs, Cons(x, acc))
}

fun rev<a>(l: list<a>): total list<a> {
  rev_loop(l, Nil)
}

fun map_list<a, b>(l: list<a>, f: a -> <div, exn> b): <div, exn> list<b> {
  match l
    Nil -> Nil
    Cons(x, xs) -> Cons(f(x), map_list(xs, f))
}

fun fold_list<a, b>(xs: list<a>, acc: b, f: (b, a) -> b): total b {
  match xs {
    Nil -> acc
    Cons(x, xs) -> fold_list(xs, f(acc, x), f)
  }
}

fun tabulate_loop(n: int64, len: int64, f: () -> maybe<player>): div list<maybe<player>> {
  if n == len then
    Nil
  else
    Cons(f(), tabulate_loop(n + 1.int64, len, f))
}

fun tabulate(len: int64, f: () -> maybe<player>): <div, exn> list<maybe<player>> {
  if len < 0.int64 then
    throw("Negative list length")
  else
    tabulate_loop(0.int64, len, f)
}

fun nth(l: list<a>, i: int64): exn a {
  match l
    Nil -> throw("Empty list")
    Cons(a, as_) -> if i == 0.int64 then a else nth(as_, i - 1.int64)
}

fun find_player(l: list<maybe<player>>, i: int64): total maybe<player> {
  match l
    Nil -> Nothing
    Cons(p, ps) ->
      if i == 0.int64 then
        p
      else
        find_player(ps, i - 1.int64)
}

fun exists_l<a>(f: a -> exn bool, l: list<a>): exn bool {
  match l
    Nil -> False
    Cons(a, as_) -> if f(a) then True else exists_l(f, as_)
}

fun all_l<a>(ls: list<a>, f: a -> exn bool): exn bool {
  match ls
    Nil -> True
    Cons(x, xs) -> if f(x) then all_l(xs, f) else False
}

fun emptyBoard(): <div, exn> list<maybe<player>> {
  tabulate(9.int64, fn () -> Nothing)
}

fun is_full(board: list<maybe<player>>): exn bool {
  all_l(board, is_some)
}

fun player_occupies(p: player, board: list<maybe<player>>, i: int64): exn bool {
  match find_player(board, i)
    Just(p0) -> player_eq(p, p0)
    Nothing -> False
}

fun has_trip(board: list<maybe<player>>, p: player, l: list<int64>): exn bool {
  all_l(l, fn(i) player_occupies(p, board, i))
}

fun rows(): total list<list<int64>> {
  Cons(Cons(0.int64, Cons(1.int64, Cons(2.int64, Nil))),
    Cons(Cons(3.int64, Cons(4.int64, Cons(5.int64, Nil))),
      Cons(Cons(6.int64, Cons(7.int64, Cons(8.int64, Nil))),
        Nil)))
}

fun cols(): total list<list<int64>> {
  Cons(Cons(0.int64, Cons(3.int64, Cons(6.int64, Nil))),
    Cons(Cons(1.int64, Cons(4.int64, Cons(7.int64, Nil))),
      Cons(Cons(2.int64, Cons(5.int64, Cons(8.int64, Nil))),
        Nil)))
}

fun diags(): total list<list<int64>> {
  Cons(Cons(0.int64, Cons(4.int64, Cons(8.int64, Nil))),
    Cons(Cons(2.int64, Cons(4.int64, Cons(6.int64, Nil))),
      Nil))
}

fun has_row(board: list<maybe<player>>, p: player): exn bool {
  exists_l(fn(l) has_trip(board, p, l), rows())
}

fun has_col(board: list<maybe<player>>, p: player): exn bool {
  exists_l(fn(l) has_trip(board, p, l), cols())
}

fun has_diag(board: list<maybe<player>>, p: player): exn bool {
  exists_l(fn(l) has_trip(board, p, l), diags())
}

fun is_win_for(board: list<maybe<player>>, p: player): exn bool {
  has_row(board, p) || has_col(board, p) || has_diag(board, p)
}

fun is_cat(board: list<maybe<player>>): exn bool {
  is_full(board) && not(is_win_for(board, X)) && not(is_win_for(board, O))
}

fun list_extreme(f: (int64, int64) -> int64, l: list<int64>): exn int64 {
  match l
    Nil -> throw("Empty List")
    Cons(i, is) -> fold_list(is, i, f)
}

fun listmax(l: list<int64>): exn int64 {
  list_extreme(fn(a, b) if b < a then a else b, l)
}

fun listmin(l: list<int64>): exn int64 {
  list_extreme(fn(a, b) if a < b then a else b, l)
}

fun is_occupied(board: list<maybe<player>>, i: int64): exn bool {
  is_some(nth(board, i))
}

fun is_win(board: list<maybe<player>>): exn bool {
  is_win_for(board, X) || is_win_for(board, O)
}

fun game_over(board: list<maybe<player>>): exn bool {
  is_win(board) || is_cat(board)
}

fun score(board: list<maybe<player>>): exn int64 {
  if is_win_for(board, X) then
    1.int64
  else if is_win_for(board, O) then
    (-1).int64
  else
    0.int64
}

fun put_at(x: maybe<player>, xs: list<maybe<player>>, i: int64): <div, exn> list<maybe<player>> {
  if i == 0.int64 then
    Cons(x, tail_list(xs))
  else if i > 0.int64 then
    Cons(head_list(xs), put_at(x, tail_list(xs), i - 1.int64))
  else
    throw("Negative list index")
}

fun move_to(board: list<maybe<player>>, p: player, i: int64): <div, exn> list<maybe<player>> {
  if is_occupied(board, i) then
    throw("Positon occupied")
  else
    put_at(Just(p), board, i)
}

fun all_moves_rec(n: int64, board: list<maybe<player>>, acc: list<int64>): total list<int64> {
  match board
    Nil -> rev(acc)
    Cons(Just(_), more) -> all_moves_rec(n + 1.int64, more, acc)
    Cons(Nothing, more) -> all_moves_rec(n + 1.int64, more, Cons(n, acc))
}

fun all_moves(board: list<maybe<player>>): total list<int64> {
  all_moves_rec(0.int64, board, Nil)
}

fun successors(board: list<maybe<player>>, p: player): <div, exn> list<list<maybe<player>>> {
  map_list(all_moves(board), fn(i) move_to(board, p, i))
}

fun minimax(p: player, board: list<maybe<player>>): <div, exn> rosetree<(list<maybe<player>>, int64)> {
  if game_over(board) then
    mk_leaf((board, score(board)))
  else
    val trees = map_list(successors(board, p), fn(b) minimax(other(p), b))
    val scores = map_list(trees, fn(t) snd_pair(top(t)))
    match p
      X -> Rosetree((board, listmax(scores)), trees)
      O -> Rosetree((board, listmin(scores)), trees)
}

fun main_loop(iters: int64): <console, div, exn> () {
  val res = minimax(X, emptyBoard())
  if iters == 1.int64 then
    println(snd_pair(top(res)))
  else
    main_loop(iters - 1.int64)
}

fun main(): <exn, ndet, console, div> () {
  val args = get-args()
  val iters = unjust(parse-int(head_list(args))).int64
  main_loop(iters)
}
