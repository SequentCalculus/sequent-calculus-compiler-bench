type ('a,'b) either = Left of 'a | Right of 'b 
let rec enum_from_then_to from th to_ = 
  if from<=to_ then
    from::enum_from_then_to th ((2*th) - from) to_
  else []

let rec apply_op ls astart astep alim op_ = 
  match ls with 
    | [] -> []
    | a :: t1 -> 
        List.append
          (apply_op_inner (enum_from_then_to astart (astart+astep) alim) a op_)
          (apply_op t1 astart astep alim op_)
and apply_op_inner ls a op_ = 
  match ls with 
    | [] -> []
    | b::t2 -> op_ (a,b) :: apply_op_inner t2 a op_

let integerbench op_ astart astep alim =
   apply_op 
    (enum_from_then_to astart (astart+astep) alim)
     astart astep alim op_

let runbench jop astart astep alim =
  let _ = integerbench jop astart astep alim in 
  integerbench jop astart astep alim

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

  let _ =
    runbench z_add  astart astep alim in 
  let _ = runbench z_sub astart astep alim in
  let _ = runbench z_mul astart astep alim in 
  let _ = runbench z_div astart astep alim in
  let _ = runbench z_mod astart astep alim in
  let _ = runbench z_equal astart astep alim in
  let _ = runbench z_lt astart astep alim in
  let _ = runbench z_leq astart astep alim in
  let _ = runbench z_gt astart astep alim in 
  runbench z_geq  astart astep alim 


let test_integer_nofib n = 
  runalltests (-2100000000) n 2100000000

let print_either e = 
  match e with 
    | Left i -> print_endline (string_of_int i)
    | Right b -> 
        if b then 
          print_endline "11"
        else 
          print_endline "00"

let rec main_loop iters n = 
  let res = test_integer_nofib n in 
  if iters=1 then 
    print_either (List.hd res)
        else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
