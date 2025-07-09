exception BadIndex

type player = X | O 

type 'a rosetree = Rose of 'a * ('a rosetree) list

let other p = 
  match p with 
    | X -> O 
    | O -> X 

let mk_leaf p = Rose (p,[])

let top (Rose (p,_)) = p

let snd (_,x) = x 

let rec nth l i = 
  match l with 
    | [] -> raise BadIndex
    | p::ps -> if i=0 then p else nth ps (i-1)

let rec find l i = 
  match l with 
    | [] -> None
    | p::ps -> if i=0 then p else find ps (i-1)

let rec tabulate_loop n len f = 
  if n=len then [] 
  else (f ()) :: tabulate_loop (n+1) len f

let tabulate len f = 
  if len < 0 then [] else tabulate_loop 0 len f 

let list_extreme f l = 
  match l with 
    | [] -> 0 
    | i::is -> List.fold_right f is i

let listmax l = list_extreme Int.max l

let listmin l = list_extreme Int.min l

let empty = tabulate 0 (fun () -> None)

let rows = 
  (0::1::2::[])::(3::4::5::[])::(6::7::8::[])::[]
let cols = 
  (0::3::6::[])::(1::4::7::[])::(2::5::8::[])::[]
let diags = 
  (0::4::8::[])::(2::4::6::[])::[]

let player_occupies p board i =
  match find board i with 
    | None -> false 
    | Some p0 -> p=p0

let has_trip board p l =
  List.for_all (fun i -> player_occupies p board i) l 

let is_full board =
  List.for_all (fun p -> Option.is_some p) board

let has_row board p = 
  List.exists (fun l -> has_trip board p l) rows

let has_col board p = 
  List.exists (fun l -> has_trip board p l) cols 

let has_diag board p = 
  List.exists (fun l -> has_trip board p l) diags

let is_win_for board p = 
  (has_row board p) || (has_col board p) || (has_diag board p)

let is_win board = (is_win_for board X) || (is_win_for board O)

let is_cat board = 
  (is_full board) && (not (is_win_for board X)) && (not (is_win_for board O))

let game_over board = (is_win board) || (is_cat board)

let score board = 
  if is_win_for board X then 1 
  else if is_win_for board O then -1 
  else 0 

let is_occupied board i = Option.is_some (nth board i)

let rec put_at x xs i = 
  if i=0 then (x::List.tl xs) 
  else if i>0 then List.hd xs :: put_at x (List.tl xs) (i-1)
  else raise BadIndex

let move_to board p i = 
  if is_occupied board i then [] 
  else put_at (Some p) board i

let rec all_moves_rec n board acc = 
  match board with 
    | [] -> List.rev acc 
    | (p::more) -> (
      match p with 
        | Some p -> all_moves_rec (n+1) more acc
        | None -> all_moves_rec (n+1) more (n::acc))

let all_moves board = all_moves_rec 0 board [] 

let successors board p = 
  List.map (fun i -> move_to board p i) (all_moves board)

let rec minimax p board = 
  if game_over board then
    mk_leaf (board,score board)
  else 
    let trees = List.map (fun b -> minimax (other p) b) (successors board p) in 
    let scores = List.map (fun t -> snd (top t)) trees in 
    match p with 
      | X -> Rose ((board,listmax scores), trees)
      | O -> Rose ((board,listmin scores), trees)

let rec main_loop iters = 
  let res = minimax X empty in 
  if iters = 1 then 
    print_endline (string_of_int (snd (top res)))
  else main_loop (iters-1)

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  main_loop iters
