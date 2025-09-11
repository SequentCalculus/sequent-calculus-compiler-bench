exception EmptyList

let snd (_,x) = x

let rec rev_loop l1 l2 = 
    match l1 with
      | [] -> l2
      | i::iss -> rev_loop iss (i::l2)

let rev l = rev_loop l []

let head l = 
  match l with 
    | [] -> raise EmptyList
    | h::_ -> h

let rec map f l = 
  match l with 
    | [] -> []
    | x::xs -> (f x) :: (map f xs)

let rec take n ls = 
  match ls with 
    | [] -> []
    | i::iss -> if n==0 then [] else i::(take (n-1) iss)

let rec drop n ls = 
  if n==0 then ls 
  else match ls with
    | [] -> []
    | i::iss -> drop (n-1) iss

let is_singleton ls = 
  match ls with 
    | x::[] -> Some x 
    | _ -> None

let rec len ls = 
  match ls with
    | [] -> 0
    | _::xs -> 1 + (len xs)

let rec zip xs ys = 
  match (xs,ys) with 
    ([],_) -> []
  | (_,[]) -> []
  | (x::xs,y::ys) -> (x,y) :: zip xs ys

let rec in_list x ls = 
  match ls with 
    | [] -> false 
    | y::ys -> if x=y then true else in_list x ys


let rec enum_from_then_to from th to_ =
  if from <= to_
  then from :: (enum_from_then_to th ((2*th)-from) to_)
  else []

let rec add_zero ls = 
  match ls with 
    | [] -> []
    | h::t -> (h,0)::add_zero t 

let rec algb2 x k0j1 k1j1 yss = 
  match yss with 
    | [] -> []
    | (y,k0j)::ys -> 
        let kjcurr = if x=y then k0j1+1 else Int.max k1j1 k0j in
        (y,kjcurr)::algb2 x k0j kjcurr ys 

let rec algb1 xss yss = 
  match xss with 
    | [] -> map (fun (_,x) -> x) yss
    | x::xs -> algb1 xs (algb2 x 0 0 yss)

let algb xs ys = 
  0 :: (algb1 xs (add_zero ys))

let rec findk k km m ls = 
  match ls with 
    | [] -> km 
    | (x,y) :: xys -> 
        if m <= (x+y) 
        then findk (k+1) k (x+y) xys 
        else findk (k+1) km m xys


let rec algc m n xs ys = 
  match ys with
    | [] -> fun x -> x 
    | _ -> match is_singleton xs with
      | Some x -> 
          if in_list x ys 
          then fun t -> x::t
          else fun x -> x
      | None -> 
          let m2 = m/2 in 
          let xs1 = take m2 xs in 
          let xs2 = drop m2 xs in 
          let l1 = algb xs1 ys in
          let l2 = rev (algb (rev xs2) (rev ys)) in 
          let k = findk 0 0 (-1) (zip l1 l2) in 
          fun x -> 
            let f1 = algc (m-m2) (n-k) xs2 (drop k ys) in 
            let f2 = algc m2 k xs1 (take k ys) in 
            f2 (f1 x)

let lcss xs ys = (algc (len xs) (len ys) xs ys) []

let lcss_main a b c d e f = 
  lcss (enum_from_then_to a b c) (enum_from_then_to d e f)

let test_lcss_nofib c f = lcss_main 1 2 c 100 101 f

let rec main_loop iters c f = 
  let res = test_lcss_nofib c f in 
  if iters=1 then
    print_endline (string_of_int (head res))
  else main_loop (iters-1) c f

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let c = int_of_string Sys.argv.(2) in 
  let f = int_of_string Sys.argv.(3) in 
  main_loop iters c f
