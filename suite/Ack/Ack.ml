let rec ack m n = 
  if m=0 then n+1 
  else if n=0 then ack (m-1) 1 
  else ack (m-1) (ack m (n-1))

let rec main_loop iters m n =
  let res = ack m n in
  if iters = 1 then print_endline (string_of_int res)
  else main_loop (iters-1) m n

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let m = int_of_string Sys.argv.(2) in 
  let n = int_of_string Sys.argv.(3) in
  main_loop iters m n 


