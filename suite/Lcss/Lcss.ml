let rec enum_from_then_to from th to_ =
  if from <= to_
  then from :: (enum_from_then_to th ((2*th)-from) to_)
  else []

let is_singleton ls = 
  match ls with 
    | x::[] -> Some x 
    | _ -> None

let rec in_list x ls = 
  match ls with 
    | [] -> false 
    | y::ys -> if x=y then true else in_list x ys

let rec zip xs ys = 
  match (xs,ys) with 
    ([],_) -> []
  | (_,[]) -> []
  | (x::xs,y::ys) -> (x,y) :: zip xs ys

let rec findk k km m ls = 
  match ls with 
    | [] -> km 
    | (x,y) :: xys -> 
        if m <= (x+y) 
        then findk (k+1) k (x+y) xys 
        else findk (k+1) km m xys

let rec algb2 x k0j1 k1j1 yss = 
  match yss with 
    | [] -> []
    | (y,k0j)::ys -> 
        let kjcurr = if x=y then k0j1+1 else Int.max k1j1 k0j in
        (y,kjcurr)::algb2 x k0j kjcurr ys 

let rec algb1 xss yss = 
  match xss with 
    | [] -> List.map (fun (_,x) -> x) yss
    | x::xs -> algb1 xs (algb2 x 0 0 yss)

let rec add_zero ls = 
  match ls with 
    | [] -> []
    | h::t -> (h,0)::add_zero t 

let algb xs ys = 
  0 :: (algb1 xs (add_zero ys))

let rec algc m n xs ys = 
  if List.is_empty ys then fun x -> x 
  else match is_singleton xs with
    | Some x -> 
        if in_list x ys 
        then fun t -> x::t
        else fun x -> x
    | None -> 
        let m2 = m/2 in 
        let xs1 = List.take m2 xs in 
        let xs2 = List.drop m2 xs in 
        let l1 = algb xs1 ys in
        let l2 = List.rev (algb (List.rev xs2) (List.rev ys)) in 
        let k = findk 0 0 (-1) (zip l1 l2) in 
        fun x -> 
          let f1 = algc (m-m2) (n-k) xs2 (List.drop k ys) in 
          let f2 = algc m2 k xs1 (List.take k ys) in 
          f2 (f1 x)

let lcss xs ys = (algc (List.length xs) (List.length ys) xs ys) []

let lcss_main a b c d e f = 
  lcss (enum_from_then_to a b c) (enum_from_then_to d e f)

let test_lcss_nofib = lcss_main 1 2 200 100 101 300

let rec main_loop iters = 
  let res = test_lcss_nofib in 
  if iters=1 then
    print_endline (string_of_int (List.hd res))
  else main_loop (iters-1)

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  main_loop iters
