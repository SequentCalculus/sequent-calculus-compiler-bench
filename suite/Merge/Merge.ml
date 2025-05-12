let rec tabulate_loop n len f acc = 
  if n<len then 
    tabulate_loop (n+1) len f (f n::acc)
  else List.rev acc 

let tabulate n f = 
  if n<0 then [] else tabulate_loop 0 n f []

let rec merge l1 l2 =
  match (l1,l2) with 
    | ([],_) -> l2
    | (_,[]) -> l1
    | (x1::xs1,x2::xs2) -> 
        if x1<=x2 
        then x1::merge xs1 l2
        else x2::merge l1 xs2

let rec main_loop iters l1 l2 = 
  let res = merge l1 l2 in 
  if iters = 1 then 
    print_endline (string_of_int (List.hd res))
  else main_loop (iters-1) l1 l2 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  let l1 = tabulate n (fun x -> 2*x) in
  let l2 = tabulate n (fun x -> (2*x)+1) in 
  main_loop iters l1 l2 
