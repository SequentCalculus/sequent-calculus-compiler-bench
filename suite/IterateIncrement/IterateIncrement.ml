let rec iterate i f a =
  if i = 0 then a
  else iterate (i - 1) f (f a)

let rec main_loop iters n =
  let res = iterate n (fun x -> x + 1) 0 in
  if iters = 1 then
    print_endline (string_of_int res)
  else main_loop (iters - 1) n

let main =
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  main_loop iters n
