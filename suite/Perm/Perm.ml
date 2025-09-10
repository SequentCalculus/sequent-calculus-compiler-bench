let rec rev_loop x n y = 
  if n=0 then y else 
    rev_loop (List.tl x) (n-1) ((List.hd x)::y)

let rec list_tail x n = 
  if n=0 then x else list_tail (List.tl x) (n-1)

let f n perms x = 
  let x = rev_loop x n (list_tail x n) in 
  let perms = x::perms in 
  (perms,x)

let rec loop_p j perms x n = 
  if j=0 then p (n-1) perms x 
  else 
    let (perms,x) = p (n-1) perms x in 
    let (perms,x) = f n perms x in
    loop_p (j-1) perms x n 
and p n perms x = 
  if 1<n then loop_p (n-1) perms x n 
  else (perms,x)


let permutations x0 =
  let (final_perms,_) = p (List.length x0) (x0::[]) x0
  in final_perms

let rec loop_sum y = match y with 
  | [] -> 0 
  | i::is -> i + (loop_sum is)

let rec sumlists x = match x with
  | [] -> 0
  | is::iss -> (loop_sum is) + (sumlists iss)

let rec loop_one2n n p = 
  if n=0 then p else loop_one2n (n-1) (n::p)

let one2n n = loop_one2n n []

let rec factorial n = 
  if n=1 then 1 else n*(factorial (n-1))


let rec loop_work m perms = 
  if m=0 then perms 
  else loop_work (m-1) (permutations (List.hd perms))

let run_benchmark work result = 
  result (work())

let perm9 m n = 
  run_benchmark
    (fun () -> loop_work m (permutations (one2n n)))
    (fun result -> (sumlists result) = (((n*(n+1)) * (factorial n))/2))

let rec main_loop iters m n = 
  let res = perm9 m n in 
  if iters=1 then 
    if res then print_endline "1" else print_endline "0"
  else main_loop (iters-1) m n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let m = int_of_string Sys.argv.(2) in 
  let n = int_of_string Sys.argv.(3) in 
  main_loop iters m n 

