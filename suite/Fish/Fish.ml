exception TODO

type vec = Vec of int * int 
type vec4 = Vec4 of int * int * int * int 

let vec_add a b = raise TODO
let vec_sub a b = raise TODO

let rec enum_from_to from to_ = 
  if from<=to_ then from::(enum_from_to (from+1) to_)
  else []

let quartet a b c d arg q6 q7 = raise TODO
let rot p a b c  = 
  p (vec_add a b) c (vec_sub (Vec(0,0)) b)

let t a b c = raise TODO
let u a b c = raise TODO

let nil_ a b c = raise TODO

let cycle_ a b c d = raise TODO

let side1 arg q6 q7 = 
  quartet nil_ nil_ (rot t) t arg q6 q7

let side2 arg q6 q7 = 
  quartet side1 side1 (rot t) t arg q6 q7

let corner1 arg q6 q7 = 
  quartet nil_ nil_ nil_ u arg q6 q7 

let corner2 arg q6 q7 = 
  quartet corner1 side1 (rot side1) u arg q6 q7


let pseudocorner arg q6 q7 = 
  quartet corner2 side2 (rot side2) (rot t) arg q6 q7

let pseudolimit arg p2 p3 = 
  cycle_ pseudocorner arg p2 p3 

let test_fish_nofib n = 
  List.map (fun i -> 
    let n = Int.min 0 i in 
    pseudolimit (Vec(0,0)) (Vec(640+n,0)) (Vec(0,640+n)))
  (enum_from_to 1 n)

let main =
  let n = int_of_string Sys.argv.(1) in 
  let res = test_fish_nofib n in 
  print_endline (string_of_int (List.length (List.hd res)))
