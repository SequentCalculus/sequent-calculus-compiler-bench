type ('a,'b) either = Left of 'a | Right of 'b 

let print_either e = 
  match e with 
    | Left i -> print_endline (string_of_int i)
    | Right b -> 
        if b then 
          print_endline "11"
        else 
          print_endline "00"

let rec enum_from_then_to from th to_ = 
  if from<=to_ then
    from::enum_from_then_to th ((2*th) - from) to_
  else []

let rec bench_lscomp1 ls bstart bstep blim op_ = 
  match ls with 
    | [] -> []
    | a :: t1 -> 
        bench_lscomp2 
          (enum_from_then_to bstart (bstart+bstep) blim)
          t1 a op_ bstart bstep blim
and bench_lscomp2 ls t1 a op_ bstart bstep blim = 
  match ls with 
    | [] -> []
    | b::t2 -> op_ (a,b) :: bench_lscomp2 t2 t1 a op_ bstart bstep blim

let integerbench op_ astart astep alim bstart bstep blim =
   bench_lscomp1 
    (enum_from_then_to astart (astart+astep) alim)
     bstart bstep blim op_

let runbench jop iop astart astep alim bstart bstep blim =
  let res1 = integerbench iop astart astep alim in 
  integerbench jop astart astep alim astart astep alim

let runalltests astart astep alim = 
  let z_add = fun (a,b) -> Left (a+b) in 
  let z_sub = fun (a,b) -> Left (a-b) in
  let z_mul = fun (a,b) -> Left (a*b) in
  let z_div = fun (a,b) -> Left (a / b) in
  let z_mod = fun (a,b) -> Left (a mod b) in
  let z_equal = fun (a,b) -> Right (a=b) in
  let z_lt = fun (a,b) -> Right (a<b) in
  let z_leq = fun (a,b) -> Right (a<=b) in
  let z_gt = fun (a,b) -> Right (a>b) in
  let z_geq = fun (a,b) -> Right (a>=b) in

  let add =
    runbench z_add (fun (a,b) -> Left (a+b)) 
    astart astep alim astart astep alim in 
  let sub = runbench z_sub (fun (a,b) -> Left (a-b))
  astart astep alim astart astep alim in
  let mul = runbench z_mul (fun (a,b) -> Left (a*b))
  astart astep alim astart astep alim in 
  let div_ = runbench z_mul (fun (a,b) -> Left (a /b))
  astart astep alim astart astep alim in
  let mod_ = runbench z_mod (fun (a,b) -> Left (a mod b))
  astart astep alim astart astep alim in
  let equal = runbench z_equal (fun (a,b) -> Left (a mod b))
  astart astep alim astart astep alim in
  let lt = runbench z_lt (fun (a,b) -> Right (a<b))
  astart astep alim astart astep alim in
  let leq = runbench z_leq (fun (a,b) -> Right (a<=b))
  astart astep alim astart astep alim in
  let gt = runbench z_gt (fun (a,b) -> Right (a>b))
  astart astep alim astart astep alim in 
  runbench z_geq (fun (a,b) -> Right (a>=b)) 
  astart astep alim astart astep alim


let test_integer_nofib n = 
  runalltests (-2100000000) n 2100000000


let rec main_loop iters n = 
  let res = test_integer_nofib n in 
  if iters=1 then 
    print_either (List.hd res)
        else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
