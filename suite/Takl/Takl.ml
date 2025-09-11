exception EmptyList

let null ls =
  match ls with 
    | [] -> true
    | _ -> false

let tail l = 
  match l with
    | [] -> raise EmptyList
    | _::xs -> xs

let rec len l = 
  match l with
    | [] -> 0
    | _::xs -> 1 + (len xs)

let rec list_n n = 
  if n=0 then [] else n :: (list_n (n-1))

let rec shorterp x y = 
  if null y then false 
  else if null x then true 
  else shorterp (tail x) (tail y)

let rec mas x y z = 
  if not (shorterp y x) then z 
  else 
    mas 
      (mas (tail x) y z)
      (mas (tail y) z x)
      (mas (tail z) x y)

let rec main_loop iters x y z = 
  let res = len (mas (list_n x) (list_n y) (list_n z)) in 
  if iters = 1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) x y z 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let x = int_of_string Sys.argv.(2) in 
  let y = int_of_string Sys.argv.(3) in 
  let z = int_of_string Sys.argv.(4) in 
  main_loop iters x y z 
