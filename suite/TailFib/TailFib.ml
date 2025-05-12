let rec tfib n a b = 
  if n=0 then a 
  else tfib (n-1) (a+b) a 

let fib n = tfib n 0 1

let rec main_loop iters n =
  let res = fib n in 
  if iters=1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 

