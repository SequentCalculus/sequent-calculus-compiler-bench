exception EmptyList 

let rec enum_from_to from to_ = 
  if from<=to_ then 
    from::enum_from_to (from+1) to_
  else []

let rec max ls = 
  match ls with 
    | [] -> raise EmptyList
    | x::[] -> x
    | x::y::ys -> if x < y then max (y::ys) else max (x::ys)
let quot_rem a b = (a/b, a mod b)

let rec g (u1,u2,u3) (v1,v2,v3) = 
  if v3=0 then (u3,u1,u2) 
  else
    let (q,r) = quot_rem u3 v3 in 
    g (v1,v2,v3) (u1 - (q*v1),u2 - (q*v2),r)

let gcd_e x y =
  if x=0 then (y,0,1) else g (1,0,x) (0,1,y)

let rec to_pair i l = 
  match l with
    | [] -> []
    | j::js -> (i,j)::(to_pair i js)

let rec cartesian_product p1 m1 = 
  match p1 with 
    | [] -> [] 
    | h1::t1 -> List.append (to_pair h1 m1) (cartesian_product t1 m1)

let test d =
  let ns = enum_from_to 5000 (5000+d) in 
  let ms = enum_from_to 10000 (10000+d) in 
  let tripls = List.map (fun (x,y) -> (x,y,gcd_e x y)) (cartesian_product ns ms) in 
  let rs = List.map (fun (d1,d2,(gg,u,v)) -> abs (gg+u+v)) tripls in 
  max rs 

let test_gcd_nofib x = test x 

let rec main_loop iters n =
  let res = test_gcd_nofib n in 
  if iters = 1 then
    print_endline (string_of_int res)
  else main_loop (iters-1) n

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
