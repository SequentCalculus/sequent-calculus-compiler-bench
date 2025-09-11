exception BadIndex
exception EmptyList

type player = X | O 

type 'a rosetree = Rose of 'a * ('a rosetree) list

let mk_leaf p = Rose (p,[])

let top (Rose (p,_)) = p

let snd (_,x) = x 

let player_equal p1 p2 = 
  match (p1,p2) with 
    | (X,X) -> true
    | (O,O) -> true
    | _ -> false

let other p = 
  match p with 
    | X -> O 
    | O -> X

let is_some p = 
  match p with 
    | None -> false
    | Some(_) -> true

let head l = 
  match l with 
    | [] -> raise EmptyList
    | x::_ -> x

let tail l = 
  match l with 
    | [] -> raise EmptyList
    | _::xs -> xs

let rec rev_acc l acc = 
  match l with 
    | [] -> acc
    | x::xs -> rev_acc xs (x::acc)

let rev l = rev_acc l []

let rec map f l = 
  match l with 
    | [] -> []
    | x::xs -> (f x) :: (map f xs)

let rec fold f xs acc = 
  match xs with 
    | [] -> acc
    | h::t -> fold f t (f acc h)

let rec tabulate_loop n len f =
  if n=len then []
  else (f ()) :: tabulate_loop (n+1) len f

let tabulate len f =
  if len < 0 then [] else tabulate_loop 0 len f

let rec nth l i = 
  match l with 
    | [] -> raise BadIndex
    | p::ps -> if i=0 then p else nth ps (i-1)

let rec find l i = 
  match l with 
    | [] -> None
    | p::ps -> if i=0 then p else find ps (i-1)

let rec exists f l = 
  match l with 
    | [] -> false
    | x::xs -> if f x then true else exists f xs

let rec all f l =
  match l with 
    | [] -> true
    | x::xs -> if f x then all f xs else false

let emptyBoard = tabulate 9 (fun () -> None)

let is_full board =
  all (fun p -> is_some p) board

let player_occupies p board i =
  match find board i with 
    | None -> false 
    | Some p0 -> player_equal p p0

let has_trip board p l =
  all (fun i -> player_occupies p board i) l

let rows = 
  (0::1::2::[])::(3::4::5::[])::(6::7::8::[])::[]
let cols = 
  (0::3::6::[])::(1::4::7::[])::(2::5::8::[])::[]
let diags = 
  (0::4::8::[])::(2::4::6::[])::[]

let has_row board p = 
  exists (fun l -> has_trip board p l) rows

let has_col board p = 
  exists (fun l -> has_trip board p l) cols 

let has_diag board p = 
  exists (fun l -> has_trip board p l) diags

let is_win_for board p = 
  (has_row board p) || (has_col board p) || (has_diag board p)

let is_cat board = 
  (is_full board) && (not (is_win_for board X)) && (not (is_win_for board O))

let list_extreme f l = 
  match l with 
    | [] -> 0 
    | i::is -> fold f is i

let listmax l = list_extreme Int.max l

let listmin l = list_extreme Int.min l

let is_occupied board i = is_some (nth board i)

let is_win board = (is_win_for board X) || (is_win_for board O)

let game_over board = (is_win board) || (is_cat board)

let score board = 
  if is_win_for board X then 1 
  else if is_win_for board O then -1 
  else 0 

let rec put_at x xs i = 
  if i=0 then (x::tail xs) 
  else if i>0 then head xs :: put_at x (tail xs) (i-1)
  else raise BadIndex

let move_to board p i = 
  if is_occupied board i then [] 
  else put_at (Some p) board i

let rec all_moves_rec n board acc = 
  match board with 
    | [] -> rev acc 
    | (p::more) -> (
      match p with 
        | Some p -> all_moves_rec (n+1) more acc
        | None -> all_moves_rec (n+1) more (n::acc))

let all_moves board = all_moves_rec 0 board [] 
let successors board p = 
  map (fun i -> move_to board p i) (all_moves board)

let rec minimax p board = 
  if game_over board then
    mk_leaf (board,score board)
  else 
    let trees = map (fun b -> minimax (other p) b) (successors board p) in 
    let scores = map (fun t -> snd (top t)) trees in 
    match p with 
      | X -> Rose ((board,listmax scores), trees)
      | O -> Rose ((board,listmin scores), trees)

let rec main_loop iters = 
  let res = minimax X emptyBoard in
  if iters = 1 then
    print_endline (string_of_int (snd (top res)))
  else main_loop (iters-1)

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  main_loop iters
