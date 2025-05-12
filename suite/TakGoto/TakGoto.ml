exception Return of int 

let rec tak x y z = 
  if y < x then 
    tak 
      (try (tak (x-1) y z) with Return i -> i)
      (try (tak (y-1) z x) with Return i -> i)
      (try (tak (z-1) x y) with Return i -> i)
  else 
    raise (Return z)

let rec main_loop iters x y z = 
  let res = try (tak x y z) with Return i -> i
  in 
  if iters=1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) x y z

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let x = int_of_string Sys.argv.(2) in 
  let y = int_of_string Sys.argv.(3) in 
  let z = int_of_string Sys.argv.(4) in 
  main_loop iters x y z 
