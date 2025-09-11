let rec len l = 
  match l with
    | [] -> 0
    | _::xs -> 1 + (len xs)

let rec append l1 l2 = 
  match l1 with 
    | [] -> l2
    | hd::tl -> hd::append tl l2

let rec safe x d l = 
  match l with 
    | [] -> true 
    | q::l -> 
        (not (x=q)) && (not (x=(q+d))) && (not (x=(q-d))) && (safe x (d+1) l)

let rec check l acc q = 
  match l with 
    | [] -> acc 
    | b::bs -> 
        if safe q 1 b 
        then check bs ((q::b)::acc) q 
        else check bs acc q 

let rec enumerate q acc bs = 
  if q=0 then acc 
  else 
    let res = check bs [] q in 
    enumerate (q-1) (append res acc) bs 

let rec gen n nq = 
  if n=0 then []::[]
  else 
    let bs = gen (n-1) nq  in
    enumerate nq [] bs

let nsoln n = len (gen n n)

let rec main_loop iters n = 
  let res = nsoln n in
  if iters=1 then 
    print_endline (string_of_int res) 
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n
