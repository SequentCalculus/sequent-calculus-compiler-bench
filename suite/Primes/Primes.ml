let rec len l =
  match l with
    | [] -> 0
    | _ :: xs -> 1 + (len xs)

let rec interval_list m n =
  if n < m then []
  else m :: interval_list (m + 1) n

let rec remove_multiples n l =
  match l with
    | [] -> []
    | x :: xs ->
        if x mod n = 0
        then remove_multiples n xs
        else x :: remove_multiples n xs

let rec sieve l =
  match l with
    | [] -> []
    | x :: xs -> x :: sieve (remove_multiples x xs)

let rec main_loop iters n =
  let res = sieve (interval_list 2 n) in
  if iters = 1 then
    print_endline (string_of_int (len res))
  else main_loop (iters - 1) n

let main =
  let iters = int_of_string Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  main_loop iters n
