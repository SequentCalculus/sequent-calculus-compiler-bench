let rec enum_from_to from to_ =
  if to_>=from then from::(enum_from_to (from+1) to_)
  else []

let expand a b c d e f =
  f + (10*e) + (100*d) + (1000*c) + (10000*b) + (100000*a)

let condition thirywelvn =
  match thirywelvn with
    | (t::h::i::r::y::w::e::l::v::n::[]) ->
        ((expand t h i r t y) + (5*(expand t w e l v e))) = (expand n i n e t y)
    | _ -> false

let rec push_k p1 k =
  match p1 with
    | [] -> []
    | h1::t1 -> (k::h1) :: (push_k t1 k)

let rec addj j ls =
  match ls with
    | [] -> (j::[])::[]
    | k::ks -> (j::k::ks) :: (push_k (addj j ks) k)

let rec addj_ls p1 j =
  match p1 with
    | [] -> []
    | pjs::t1 -> List.append (addj j pjs) (addj_ls t1 j)

let rec permutations ls =
  match ls with
    | [] -> []::[]
    | j::js -> addj_ls (permutations js) j

let test_cryptarithm_nofib n =
  List.map (fun i ->
    let p0 = List.take 10 (enum_from_to 0 (9+i)) in
    List.filter (fun l -> condition l) (permutations p0))
  (enum_from_to 1 n)

let rec main_loop iters n =
  let res = test_cryptarithm_nofib n in
  if iters=1 then
    print_endline (string_of_int (List.hd (List.hd (List.hd res))))
  else main_loop (iters-1) n

let main =
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  main_loop iters n
