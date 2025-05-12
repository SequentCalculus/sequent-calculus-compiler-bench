type 'a tree = Leaf of 'a | Node of 'a tree * 'a tree

let rec create i n = 
  if i<n then 
    let t = create (i+1) n 
    in Node (t,t)
  else Leaf n 

let rec lookup t = 
  match t with 
    | Leaf v -> v 
    | Node(left,right) -> lookup left 

let rec main_loop iters n =
  let res = lookup (create 0 n) in 
  if iters=1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
