let rec sum_loop i tot stop f = 
  if stop<i then tot
  else sum_loop (i+1) ((f i) + tot) stop f

let sum f start stop = sum_loop start 0 stop f

let rec motz n = 
  if n<=1 then 1 
  else 
    let limit = n-2 in 
    let product = fun i -> (motz i) * (motz (limit-i)) in 
    (motz (n-1)) + (sum product 0 limit)

let rec main_loop iters n = 
  let res = motz n in 
  if iters=1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
