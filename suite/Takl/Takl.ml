let rec list_n_loop n a = 
  if n=0 then a else list_n_loop (n-1) (n::a)

let list_n n = list_n_loop n []

let rec shorterp x y = 
  if List.is_empty y then false 
  else if List.is_empty x then true 
  else shorterp (List.tl x) (List.tl y)

let rec mas x y z = 
  if not (shorterp y x) then x 
  else 
    mas 
      (mas (List.tl x) y z)
      (mas (List.tl y) z x)
      (mas (List.tl z) x y)

let rec main_loop iters x y z = 
  let res = List.length (mas (list_n x) (list_n y) (list_n z)) in 
  if iters = 1 then 
    print_endline (string_of_int res)
  else main_loop (iters-1) x y z 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let x = int_of_string Sys.argv.(2) in 
  let y = int_of_string Sys.argv.(3) in 
  let z = int_of_string Sys.argv.(4) in 
  main_loop iters x y z 
