let rec cps_tak x y z k = 
  if x<=y then k(z) 
  else 
    cps_tak (x-1) y z (fun v1 -> 
    cps_tak (y-1) z x (fun v2 -> 
    cps_tak (z-1) x y (fun v3 -> 
    cps_tak v1 v2 v3 k)))

let tak x y z = cps_tak x y z (fun a -> a)

let rec main_loop iters x y z = 
  let res = tak x y z in
  if iters = 1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) x y z

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let x = int_of_string Sys.argv.(2) in 
  let y = int_of_string Sys.argv.(3) in 
  let z = int_of_string Sys.argv.(4) in 
  main_loop iters x y z
