let rec fib n = 
  if n=0 then 0
  else if n = 1 then 1 
  else (fib (n - 1)) + (fib (n - 2))

let rec main_loop iters n =
  let res = fib n in 
  if iters = 1 then 
    print_endline (string_of_int res)
  else main_loop (iters - 1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 

