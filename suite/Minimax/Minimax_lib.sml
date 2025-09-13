structure Minimax = struct
  datatype Player =  X | O

  datatype 'a rosetree = Rose of 'a * ('a rosetree) list

  fun mk_leaf p = Rose (p, nil)

  fun top (Rose (p, _)) = p

  fun snd (_, x) = x

  fun player_equal p1 p2 =
    case (p1, p2) of
         (X, X) => true
       | (O, O) => true
       | _ => false

  fun other p =
    case p of
         X => O
       | O => X

  fun is_some p =
    case p of
         NONE => false
       | SOME(_) => true

  fun head l =
    case l of
         nil => raise Fail("Empty List")
       | a :: _ => a

  fun tail l =
    case l of
         nil => raise Fail("Empty List")
       | _ :: as_ => as_

  fun rev_acc l acc =
    case l of
         nil => acc
       | x :: xs => rev_acc xs (x :: acc)

  fun rev l = rev_acc l nil

  fun map_list f l =
    case l of
         nil => nil
       | a :: as_ => (f a) :: (map_list f as_)

  fun fold_list f acc xs =
    case xs of
         nil => acc
       | h :: t => fold_list f (f (acc, h)) t

  fun tabulate_loop n len f =
    if n = len then nil
    else
      (f()) :: (tabulate_loop (n + 1) len f)

  fun tabulate len f =
    if len < 0 then nil else tabulate_loop 0 len f

  fun nth l i =
    case l of
         nil => raise Fail "Bad Index"
       | p :: ps => if i = 0 then p else nth ps (i - 1)

  fun find l i =
    case l of
         nil => NONE
       | p :: ps => if i = 0 then p else find ps (i - 1)

  fun exists f l =
    case l of
         nil => false
       | x :: xs => if f x then true else exists f xs

  fun all f l =
    case l of
         nil => true
       | x :: xs => f x andalso all f xs

  fun emptyBoard () = tabulate 9 (fn () => NONE)

  fun is_full board =
    all is_some board

  fun player_occupies p board i =
    case find board i of
         NONE => false
       | SOME p0 => player_equal p0 p

  fun has_trip board p l =
    all (fn i => player_occupies p board i) l

  fun rows () = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]

  fun cols () = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]

  fun diags() = [[0, 4, 8], [2, 4, 6]]

  fun has_row board p =
    exists (fn l => has_trip board p l) (rows())

  fun has_col board p =
    exists (fn l => has_trip board p l) (cols())

  fun has_diag board p =
    exists (fn l => has_trip board p l) (diags())

  fun is_win_for board p =
    (has_row board p) orelse (has_col board p) orelse (has_diag board p)

  fun is_cat board =
    (is_full board) andalso (not (is_win_for board X)) andalso (not (is_win_for board O))

  fun list_extreme f l =
    case l of
         nil => 0
       | i :: is => fold_list f i is

  fun listmax l = list_extreme Int.max l

  fun listmin l = list_extreme Int.min l

  fun is_occupied board i = Option.isSome (nth board i)

  fun is_win board =
    (is_win_for board X) orelse (is_win_for board O)

  fun game_over board = (is_win board) orelse (is_cat board)

  fun score board =
    if is_win_for board X then 1
    else if is_win_for board O then ~1
    else 0

  fun put_at x xs i =
    if i = 0 then (x :: tail xs)
    else if i > 0 then (head xs:: put_at x (tail xs) (i - 1))
    else raise Fail "Bad Index"

  fun move_to board p i =
    if is_occupied board i
    then nil
    else put_at (SOME p) board i

  fun all_moves_rec n board acc =
    case board of
         nil => rev acc
       | p :: more =>
           (case p of
                 SOME p => all_moves_rec (n + 1) more acc
               | NONE => all_moves_rec (n + 1) more (n :: acc))

  fun all_moves board = all_moves_rec 0 board nil

  fun successors board p = map_list (fn i => move_to board p i) (all_moves board)

  fun minimax p board =
    if game_over board
    then mk_leaf (board, score board)
    else
      let val trees = map_list (fn b => minimax (other p) b) (successors board p)
        val scores = map_list (fn t => snd (top t)) trees
      in
        case p of
             X => Rose((board, listmax scores), trees)
           | O => Rose((board, listmin scores), trees)
      end

  fun main_loop iters =
  let val res = minimax X (emptyBoard())
      in
        if iters = 1 then
          print ((Int.toString (snd (top res))) ^ "\n")
        else main_loop (iters - 1)
      end

  fun run args =
    let val iters = valOf (Int.fromString (head args))
  in
    main_loop iters
  end
end
