exception Return of int 

let rec sudan n x y = 
  if n=0 then raise (Return (x+y))
  else if y=0 then raise (Return x)
  else 
    let inner = try (sudan n x (y-1)) with Return i -> i 
    in 
    sudan (n-1) inner (inner+y)

let rec main_loop iters n x y = 
  let res = try sudan n x y with Return i -> i 
  in 
  if iters=1 then 
    print_endline (string_of_int res) 
  else main_loop (iters-1) n x y 

let main = 
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  let x = int_of_string Sys.argv.(3) in
  let y = int_of_string Sys.argv.(4) in
  main_loop iters n x y 
