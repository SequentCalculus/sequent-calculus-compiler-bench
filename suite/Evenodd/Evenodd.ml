let abs_int i =
  if i < 0 then -i else i

let rec odd_abs n =
  if n = 0 then false else even_abs (n - 1)
and even_abs n =
  if n = 0 then true else odd_abs (n - 1)

let even n = even_abs (abs_int n)
let odd n = odd_abs (abs_int n)

let rec main_loop iters n =
  let res = even n && (not (odd n)) in
  if iters = 1 then
    if res then print_endline "1" else print_endline "0"
  else main_loop (iters - 1) n

let main =
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  main_loop iters n
