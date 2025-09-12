module life

import std/os/env
import std/num/int64

struct gen
  coordslist: list<(int64, int64)>

fun pair_eq(p1: (int64, int64), p2: (int64, int64)): total bool {
  match (p1, p2)
    ((fst1, snd1), (fst2, snd2)) -> (fst1 == fst2) && (snd1 == snd2)
}

fun fold_list<a>(xs: list<a>, acc: list<a>, f: (list<a>, a) -> list<a>): total list<a> {
  match xs
    Nil -> acc
    Cons(h, t) -> fold_list(t, f(acc, h), f)
}

fun revonto<t>(x: list<t>, y: list<t>): total list<t> {
  fold_list(x, y, fn(tl, hd) -> Cons(hd, tl))
}

fun collect_accum<t>(
  sofar: list<t>,
  xs: list<t>,
  f: t -> list<t>
): total list<t> {
  match xs
    Nil -> sofar
    Cons(y, ys) -> collect_accum(revonto(sofar, f(y)), ys, f)
}

fun collect<t>(l: list<t>, f: t -> list<t>): total list<t> {
  collect_accum(Nil, l, f)
}

fun append_list<t>(l1: list<t>, l2: list<t>): total list<t> {
  match l1 {
    Nil -> l2
    Cons(x, xs) -> Cons(x, append_list(xs, l2))
  }
}

fun map_list<a, b>(l: list<a>, f: a -> b): total list<b> {
  match l {
    Nil -> Nil
    Cons(x, xs) -> Cons(f(x), map_list(xs, f))
  }
}

fun exists_l<t>(l: list<t>, f: t -> bool): total bool {
  match l
    Nil -> False
    Cons(p, ps) -> f(p) || exists_l(ps, f)
}

fun len<t>(l: list<t>): total int64 {
  match l {
    Nil -> 0.int64
    Cons(_, xs) -> 1.int64 + len(xs)
  }
}

fun member(l: list<(int64, int64)>, p: (int64, int64)): total bool {
  exists_l(l, fn(p1) pair_eq(p, p1))
}

fun filter_list<t>(l: list<t>, f: t -> bool): total list<t> {
  match l {
    Nil -> Nil
    Cons(x, xs) -> if f(x) then Cons(x, filter_list(xs, f)) else filter_list(xs, f)
  }
}

fun diff(x: list<(int64, int64)>, y: list<(int64, int64)>): total list<(int64, int64)> {
  filter_list(x, fn(p) not(member(y, p)))
}

fun alive(g: gen): total list<(int64, int64)> {
  match g
    Gen(livecoords) -> livecoords
}

fun neighbours(p: (int64, int64)): total list<(int64, int64)> {
  match p
    (fst, snd) ->
      Cons((fst - 1.int64, snd - 1.int64),
        Cons((fst - 1.int64, snd),
          Cons((fst - 1.int64, snd + 1.int64),
            Cons((fst, snd - 1.int64),
              Cons((fst, snd + 1.int64),
                Cons((fst + 1.int64, snd - 1.int64),
                  Cons((fst + 1.int64, snd),
                    Cons((fst + 1.int64, snd + 1.int64),
                      Nil))))))))
}

fun twoorthree(n: int64): bool {
  (n == 2.int64) || (n == 3.int64)
}

fun collect_neighbours(
  xover: list<(int64, int64)>,
  x3: list<(int64, int64)>,
  x2: list<(int64, int64)>,
  x1: list<(int64, int64)>,
  xs: list<(int64, int64)>
): total list<(int64, int64)> {
  match xs
    Nil -> diff(x3, xover)
    Cons(a, x) ->
      if member(xover, a) then
          collect_neighbours(xover, x3, x2, x1, x)
      else if member(x3, a) then
          collect_neighbours(Cons(a, xover), x3, x2, x1, x)
      else if member(x2, a) then
          collect_neighbours(xover, Cons(a, x3), x2, x1, x)
      else if member(x1, a) then
          collect_neighbours(xover, x3, Cons(a, x2), x1, x)
      else
          collect_neighbours(xover, x3, x2, Cons(a, x1), x)
}

fun occurs3(l: list<(int64, int64)>): total list<(int64, int64)> {
  collect_neighbours(Nil, Nil, Nil, Nil, l)
}

fun nextgen(gen: gen): total gen {
  val living = alive(gen)
  val isalive = fn(p) member(living, p)
  val liveneighbours = fn(x, y) len(filter_list(neighbours((x, y)), isalive))
  val survivors = filter_list(living, fn((x, y)) twoorthree(liveneighbours(x, y)))
  val newbrnlist: list<(int64, int64)> = collect(living, fn(p) filter_list(neighbours(p), fn(n) not(isalive(n))))
  val newborn = occurs3(newbrnlist)
  Gen(append_list(survivors, newborn))
}

fun nthgen(g: gen, i: int64): div gen {
  if i == 0.int64 then
    g
  else
    nthgen(nextgen(g), i - 1.int64)
}

fun gun(): total gen {
  val r9 = Cons((9.int64, 29.int64), Cons((9.int64, 30.int64), Cons((9.int64, 31.int64), Cons((9.int64, 32.int64), Nil))))
  val r8 = Cons((8.int64, 20.int64), Cons((8.int64, 28.int64), Cons((8.int64, 29.int64), Cons((8.int64, 30.int64),
    Cons((8.int64, 31.int64), Cons((8.int64, 40.int64), Cons((8.int64, 41.int64), r9)))))))
  val r7 = Cons((7.int64, 19.int64), Cons((7.int64, 21.int64), Cons((7.int64, 28.int64), Cons((7.int64, 31.int64),
    Cons((7.int64, 40.int64), Cons((7.int64, 41.int64), r8))))))
  val r6 = Cons((6.int64, 7.int64), Cons((6.int64, 8.int64), Cons((6.int64, 18.int64), Cons((6.int64, 22.int64),
     Cons((6.int64, 23.int64), Cons((6.int64, 28.int64), Cons((6.int64, 29.int64), Cons((6.int64, 30.int64),
      Cons((6.int64, 31.int64), Cons((6.int64, 36.int64), r7))))))))))
  val r5 = Cons((5.int64, 7.int64), Cons((5.int64, 8.int64), Cons((5.int64, 18.int64), Cons((5.int64, 22.int64),
     Cons((5.int64, 23.int64), Cons((5.int64, 29.int64), Cons((5.int64, 30.int64), Cons((5.int64, 31.int64),
      Cons((5.int64, 32.int64), Cons((5.int64, 36.int64), r6))))))))))
  val r4 = Cons((4.int64, 18.int64), Cons((4.int64, 22.int64), Cons((4.int64, 23.int64), Cons((4.int64, 32.int64), r5))))
  val r3 = Cons((3.int64, 19.int64), Cons((3.int64, 21.int64), r4))
  val r2 = Cons((2.int64, 20.int64), r3)
  Gen(r2)
}

fun at_pos(coordlist: list<(int64, int64)>, p: (int64, int64)): total list<(int64, int64)> {
  val move = fn((fst1, snd1))
    match p
      (fst2, snd2) -> (fst1 + fst2, snd1 + snd2)
  map_list(coordlist, move)
}

fun center_line(): total int64 {
  5.int64
}

fun bail(): total list<(int64, int64)> {
  Cons((0.int64, 0.int64), Cons((0.int64, 1.int64), Cons((1.int64, 0.int64), Cons((1.int64, 1.int64), Nil))))

}

fun shuttle(): total list<(int64, int64)> {
  val r4 = Cons((4.int64, 1.int64), Cons((4.int64, 0.int64), Cons((4.int64, 5.int64), Cons((4.int64, 6.int64), Nil))));
  val r3 = Cons((3.int64, 2.int64), Cons((3.int64, 3.int64), Cons((3.int64, 4.int64), r4)));
  val r2 = Cons((2.int64, 1.int64), Cons((2.int64, 5.int64), r3));
  val r1 = Cons((1.int64, 2.int64), Cons((1.int64, 4.int64), r2));
  Cons((0.int64, 3.int64), r1)
}

fun non_steady(): total gen {
  Gen(append_list(append_list(
    at_pos(bail(), (1.int64, center_line())),
    at_pos(bail(), (21.int64, center_line()))),
    at_pos(shuttle(), (6.int64, center_line() - 2.int64))))
}

fun go_gun(steps: int64): div gen {
  nthgen(gun(), steps)
}

fun go_shuttle(steps: int64): div gen {
  nthgen(non_steady(), steps)
}

fun go_loop(iters: int64, steps: int64, go: int64 -> div gen): div int64 {
  val res = go(steps)
  if iters == 1.int64 then
    len(alive(res))
  else
    go_loop(iters - 1.int64, steps, go)
}

fun main(): <ndet, exn, console, div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val steps = unjust(parse-int(unjust(head(tail(args))))).int64
  val gun_res = go_loop(iters, steps, go_gun)
  val shuttle_res = go_loop(iters, steps, go_shuttle)
  println(show(gun_res) ++ show(shuttle_res))
}
