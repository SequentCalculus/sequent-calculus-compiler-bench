exception Return of bool

let rec odd_abs i = 
  if i=0 then raise (Return false)
  else raise (Return (even_abs (i-1)))
and even_abs i = 
  if i=0 then true 
  else odd_abs (i-1)

let even i = try even_abs (abs i) with Return i -> i

let odd i = try odd_abs (abs i) with Return i -> i

let rec main_loop iters n = 
  let res = (even n) && (not (odd n)) in 
  if iters=1 then 
    if res then print_endline "1" else print_endline "0"
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
