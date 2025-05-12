exception BadExpr

type expr = 
  | Add of expr list 
  | Sub of expr list 
  | Mul of expr list 
  | Div of expr list 
  | Num of int 
  | X


let rec deriv e = 
  match e with
    | Add sums -> Add (List.map deriv sums)
    | Sub subs -> Sub (List.map deriv subs)
    | Mul muls -> 
        Mul (e::(Add (List.map (fun x -> Div (deriv x :: x :: [])) muls))::[])
    | Div (x::y::[]) ->
        Sub ( 
          (Div (deriv x :: y :: []))
          :: 
          (Div (x::(Mul (y::y::deriv y::[]))::[]))
          ::[])
    | Num i -> Num 0 
    | X -> Num 1 
    | _ -> raise BadExpr

let mk_exp a b  = 
  Add ( 
    (Mul (Num 3 :: X :: X :: []))
    :: 
    (Mul (a::X::X::[]))
    :: 
    (Mul (b::X::[]))
    :: 
    (Num 5) 
    ::[])

let mk_ans a b = 
  Add (
    (Mul (
      (Mul (Num 3::X::X::[]))
      ::
      (Add( 
        (Div (Num 0::Num 3::[]))
        ::
        (Div (Num 1:: X :: []))
        ::
        (Div (Num 1 :: X :: []))
        ::[]
      ))
      ::[]
    ))
    :: 
    (Mul (
      (Mul (a::X::X::[]))
      ::
      (Add (
        Div (Num 0 :: a :: [])
        ::
        (Div (Num 1 :: X :: []))
        ::
        (Div (Num 1:: X::[]))
        ::[]))
      ::[])
      )
    :: 
    (Mul (
      (Mul (b::X::[]))
      ::
      (Add (
        (Div (Num 0 :: b :: []))
        ::
        (Div (Num 1 :: X ::[]))
        ::
        []))
      ::
      []))
    ::
    (Num 0)
    ::[])

let rec main_loop iters n m = 
  let res = deriv (mk_exp (Num n) (Num m)) in 
  let expected = mk_ans (Num n) (Num m) in 
  if iters = 1 then
    if res=expected then print_endline "1" else print_endline "0"
  else main_loop (iters-1) n m

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  let m = int_of_string Sys.argv.(3) in 
  main_loop iters n m 
