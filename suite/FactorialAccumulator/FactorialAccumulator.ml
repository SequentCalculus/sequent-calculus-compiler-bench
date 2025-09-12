let rec factorial a i  =
  if i = 0 then a
  else factorial ((i * a) mod 1000000007) (i - 1)

let rec main_loop iters n =
  let res = factorial 1 n in
  if iters = 1 then
    print_endline (string_of_int res)
  else main_loop (iters - 1) n

let main =
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  main_loop iters n
