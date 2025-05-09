exception OddNumber 

let rec create_n_loop n acc = 
  if n=0 then acc
  else create_n_loop (n-1) (()::acc)

let create_n n = create_n_loop n []

let rec rec_div2 l =
  match l with 
    | [] -> []
    | (x::y::ys) -> x::rec_div2 ys
    | _ -> raise OddNumber

let rec main_loop iters n =
  let res = List.length (rec_div2 (create_n n)) in 
  if iters = 1 then
    print_endline (string_of_int res) 
  else main_loop (iters-1) n

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
