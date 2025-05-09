let rec fibonacci i = 
  if i=0 then i 
  else if i=1 then i
  else (fibonacci (i-1)) + (fibonacci (i-2))

let rec main_loop iters n = 
  let res = fibonacci n in 
  if iters = 1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) n

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
