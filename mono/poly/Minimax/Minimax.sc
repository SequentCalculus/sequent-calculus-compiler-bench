data Bool { True, False }
data Unit { Unit }
data Option[A] { None, Some(a: A) }
data Pair[A, B] { Tup(a: A, b: B) }
data List[A] { Nil, Cons(a: A, as: List[A]) }
codata Fun[A, B] { apply(a: A): B }
codata Fun2[A, B, C] { apply2(a: A, b: B): C }
data RoseTree[A] { Rose(a: A, as: List[RoseTree[A]]) }
data Player { X, O }

// Tree functions

def mk_leaf[A+](p: A): RoseTree[A] {
  Rose(p, Nil)
}

def top[A+](t: RoseTree[A]): A {
  t.case[A]{
    Rose(p, ps) => p
  }
}

// Tuple functions

def snd[A+, B+](p: Pair[A, B]): B  {
  p.case[A, B]{
    Tup(a, b) => b
  }
}

// Player functions

def player_eq(p1: Player, p2: Player): Bool {
  p1.case {
    X => p2.case {
      X => True,
      O => False
    },
    O => p2.case {
      X => False,
      O => True
    }
  }
}

def other(p: Player): Player {
  p.case {
    X => O,
    O => X
  }
}

// Boolean functions

def not(b: Bool): Bool {
  b.case {
    True => False,
    False => True,
  }
}

//Option functions

def is_some[A+](p: Option[A]): Bool {
  p.case[A] {
    None => False,
    Some(p) => True
  }
}

// List functions

def head[A+](l: List[Option[A]]): Option[A] {
  l.case[Option[A]] {
    Nil => None, // should give a runtime error
    Cons(p, ps) => p
  }
}

def tail[A+](l: List[A]): List[A] {
  l.case[A] {
    Nil => Nil, // should give a runtime error
    Cons(p, ps) => ps
  }
}

def rev_acc[A+](l: List[A], acc: List[A]): List[A] {
  l.case[A] {
    Nil => acc,
    Cons(x, xs) => rev_acc[A](xs, Cons(x, acc))
  }
}

def rev[A+](l: List[A]): List[A] {
  rev_acc[A](l, Nil)
}

def map[A+, B+](l: List[A], f: Fun[A, B]): List[B] {
  l.case[A] {
    Nil => Nil,
    Cons(x, xs) => Cons(f.apply[A, B](x), map[A, B](xs, f))
  }
}

def fold[A+, B+](f: Fun2[B, A, B], start: B, l: List[A]): B {
  l.case[A] {
    Nil => start,
    Cons(i, is) => fold[A, B](f, f.apply2[B, A, B](start, i), is)
  }
}

def tabulate_loop[A+](n: i64, len: i64, f: Fun[Unit, A]): List[A] {
  if n == len {
    Nil
  } else {
    Cons(f.apply[Unit, A](Unit), tabulate_loop[A](n + 1, len, f))
  }
}

def tabulate[A+](len: i64, f: Fun[Unit, A]): List[A] {
  if len < 0 {
    Nil // should raise a runtime error
  } else {
    tabulate_loop[A](0, len, f)
  }
}

def nth[A+](l: List[Option[A]], i: i64): Option[A] {
  l.case[Option[A]] {
    Nil => None, // should give a runtime error
    Cons(p, ps) => if i == 0 { p } else { nth[A](ps, i - 1) }
  }
}

def exists[A+](f: Fun[A, Bool], l: List[A]): Bool {
  l.case[A] {
    Nil => False,
    Cons(is, iss) => f.apply[A, Bool](is).case {
      True => True,
      False => exists[A](f, iss)
    }
  }
}

def all[A+](f: Fun[A, Bool], l: List[A]): Bool {
  l.case[A] {
    Nil => True,
    Cons(i, is) => f.apply[A, Bool](i).case {
      True => all[A](f, is),
      False => False
    }
  }
}

// Actual functions

def emptyBoard(): List[Option[Player]] {
  tabulate[Option[Player]](9, new { apply(u) => None })
}

def is_full(board: List[Option[Player]]): Bool {
  all[Option[Player]](new { apply(p) => is_some[Player](p) }, board)
}

def player_occupies(p: Player, board: List[Option[Player]], i: i64): Bool {
  nth[Player](board, i).case[Player] {
    Some(p0) => player_eq(p, p0),
    None => False
  }
}

def has_trip(board: List[Option[Player]], p: Player, l: List[i64]): Bool {
  all[i64](new { apply(i) => player_occupies(p, board, i) }, l)
}

def rows(): List[List[i64]] {
  Cons(Cons(0, Cons(1, Cons(2, Nil))),
    Cons(Cons(3, Cons(4, Cons(5, Nil))),
      Cons(Cons(6, Cons(7, Cons(8, Nil))),
        Nil)))
}

def cols(): List[List[i64]] {
  Cons(Cons(0, Cons(3, Cons(6, Nil))),
    Cons(Cons(1, Cons(4, Cons(7, Nil))),
      Cons(Cons(2, Cons(5, Cons(8, Nil))),
        Nil)))
}

def diags(): List[List[i64]] {
  Cons(Cons(0, Cons(4, Cons(8, Nil))),
    Cons(Cons(2, Cons(4, Cons(6, Nil))),
      Nil))
}

def has_row(board: List[Option[Player]], p: Player): Bool {
  exists[List[i64]](new { apply(l) => has_trip(board, p, l) }, rows())
}

def has_col(board: List[Option[Player]], p: Player): Bool {
  exists[List[i64]](new { apply(l) => has_trip(board, p, l) }, cols())
}

def has_diag(board: List[Option[Player]], p: Player): Bool {
  exists[List[i64]](new { apply(l) => has_trip(board, p, l) }, diags())
}

def is_win_for(board: List[Option[Player]], p: Player): Bool {
  has_row(board, p).case {
    True => True,
    False => has_col(board, p).case {
      True => True,
      False => has_diag(board, p)
    }
  }
}

def is_cat(board: List[Option[Player]]): Bool {
  is_full(board).case {
    True => not(is_win_for(board, X)).case {
      True => not(is_win_for(board, O)),
      False => False
    },
    False => False
  }
}

def list_extreme(f: Fun2[i64, i64, i64], l: List[i64]): i64 {
  l.case[i64] {
    Nil => 0, // should give a runtime error
    Cons(i, is) => fold[i64, i64](f, i, is)
  }
}

def listmax(l: List[i64]): i64 {
  list_extreme(new { apply2(a, b) => if b < a { a } else { b } }, l)
}

def listmin(l: List[i64]): i64 {
  list_extreme(new { apply2(a, b) => if a < b { a } else { b } }, l)
}

def is_occupied(board: List[Option[Player]], i: i64): Bool { is_some[Player](nth[Player](board, i)) }

def is_win(board: List[Option[Player]]): Bool {
  is_win_for(board, X).case {
    True => True,
    False => is_win_for(board, O)
  }
}

def game_over(board: List[Option[Player]]): Bool {
  is_win(board).case {
    True => True,
    False => is_cat(board)
  }
}

def score(board: List[Option[Player]]): i64 {
  is_win_for(board, X).case {
    True => 1,
    False => is_win_for(board, O).case {
      True => -1,
      False => 0
    }
  }
}

def put_at[A+](x: Option[A], xs: List[Option[A]], i: i64): List[Option[A]] {
  if i == 0 {
    Cons(x, tail[Option[A]](xs))
  } else {
    if i > 0 {
      Cons(head[A](xs), put_at[A](x, tail[Option[A]](xs), i - 1))
    } else {
      Nil // should give a runtime error
    }
  }
}

def move_to(board: List[Option[Player]], p: Player, i: i64): List[Option[Player]] {
  is_occupied(board, i).case {
    True => Nil, // should give a runtime error
    False => put_at[Player](Some(p), board, i)
  }
}

def all_moves_rec(n: i64, board: List[Option[Player]], acc: List[i64]): List[i64] {
  board.case[Option[Player]] {
    Nil => rev[i64](acc),
    Cons(p, more) => p.case[Player] {
      Some(p) => all_moves_rec(n + 1, more, acc),
      None => all_moves_rec(n + 1, more, Cons(n, acc))
    }
  }
}

def all_moves(board: List[Option[Player]]): List[i64] { all_moves_rec(0, board, Nil) }

def successors(board: List[Option[Player]], p: Player): List[List[Option[Player]]] {
  map[i64, List[Option[Player]]](all_moves(board), new { apply(i) => move_to(board, p, i) })
}

def minimax(p: Player, board: List[Option[Player]]): RoseTree[Pair[List[Option[Player]], i64]] {
  game_over(board).case {
    True => mk_leaf[Pair[List[Option[Player]], i64]](Tup(board, score(board))),
    False =>
      let trees: List[RoseTree[Pair[List[Option[Player]], i64]]] =
        map[List[Option[Player]], RoseTree[Pair[List[Option[Player]], i64]]](successors(board, p), new { apply(b) => minimax(other(p), b) });
      let scores: List[i64] =
        map[RoseTree[Pair[List[Option[Player]], i64]], i64](trees, new { apply(t) => snd[List[Option[Player]], i64](top[Pair[List[Option[Player]], i64]](t)) });
      p.case {
        X => Rose(Tup(board, listmax(scores)), trees),
        O => Rose(Tup(board, listmin(scores)), trees)
      }
  }
}

def main_loop(iters: i64): i64 {
  let res: RoseTree[Pair[List[Option[Player]], i64]] = minimax(X, emptyBoard());
  if iters == 1 {
    println_i64(snd[List[Option[Player]], i64](top[Pair[List[Option[Player]], i64]](res)));
    0
  } else {
    main_loop(iters - 1)
  }
}

def main(iters: i64): i64 {
  main_loop(iters)
}
