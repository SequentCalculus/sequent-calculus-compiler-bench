let first l = 
  match l with
    | ((i::_)::_)::_ -> i 
    | _ -> -1

let rec append l1 l2 = 
  match l1 with
    | [] -> l2
    | a::as_ -> a::(append as_ l2)

let rec take n l = 
  match l with
    | [] -> []
    | a::as_ -> if n <= 0 then [] else a::(take (n-1) as_)

let rec filter l f = 
  match l with 
    | [] -> []
    | a::as_ -> if (f a) then a::(filter as_ f) else filter as_ f

let rec map l f = 
  match l with 
    | [] -> []
    | a::as_ -> (f a) :: (map as_ f)

let expand a b c d e f =
  f + (10*e) + (100*d) + (1000*c) + (10000*b) + (100000*a)

let rec enum_from_to from to_ =
  if to_>=from then from::(enum_from_to (from+1) to_)
  else []

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
    | pjs::t1 -> append (addj j pjs) (addj_ls t1 j)

let rec permutations ls =
  match ls with
    | [] -> []::[]
    | j::js -> addj_ls (permutations js) j

let test_cryptarithm_nofib n =
  map (enum_from_to 1 n) (fun i ->
    let p0 = take 10 (enum_from_to 0 (9+i)) in
    filter (permutations p0) (fun l -> condition l))

let rec main_loop iters n =
  let res = test_cryptarithm_nofib n in
  if iters=1 then
    print_endline (string_of_int (first res))
  else main_loop (iters-1) n

let main =
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  main_loop iters n
