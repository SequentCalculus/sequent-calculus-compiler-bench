let rec attempt i =
  if i=0 then Some i
  else match attempt (i-1) with 
    | None -> None 
    | Some x -> Some (x+1)

let rec main_loop iters n = 
  let res = match attempt n with 
    | None -> -1 
    | Some x -> x 
  in 
  if iters=1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) n

let main =
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
