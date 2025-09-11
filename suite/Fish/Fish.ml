exception EmptyList

type vec = Vec of int * int 
type vec4 = Vec4 of int * int * int * int 

let vec_add (Vec(x1,y1)) (Vec(x2,y2)) = Vec (x1+x2,y1+y2)

let vec_sub (Vec(x1,y1)) (Vec(x2,y2)) = Vec (x1-x2,y1-y2)

let scale_vec (Vec(x,y)) a b = Vec ((x*a) / b, (y*a) / b)

let min i1 i2 = if i1<i2 then i1 else i2

let nil_ _ _ _ = []

let tup2 (Vec(x1,y1)) (Vec(x2,y2)) = Vec4(x1,y1,x2,y2)

let rec append_rev l1 l2 = 
  match l1 with
    | [] -> l2
    | v::vs -> append_rev vs (v::l2)

let rec rev l = append_rev l []

let rec append l1 l2 = 
  match l2 with 
    | [] -> l1
    | v::vs -> append_rev (rev l1) (v::vs)

let rec map f ls = 
  match ls with
    | [] -> []
    | v::vs -> (f v) :: (map f vs)

let rec len l = 
  match l with 
    | [] -> 0
    | v::vs -> 1 + (len vs)

let head l = 
  match l with 
    | [] -> raise EmptyList
    | v::_ -> v

let rec enum_from_to from to_ = 
  if from<=to_ then from::(enum_from_to (from+1) to_)
  else []

let  p_tile = 
  let p5 = 
    Vec4(10, 4, 13, 5)::
      Vec4(13, 5, 16, 4)::
        Vec4(11, 0, 14, 2)::
          Vec4(14, 2, 16, 2)::[]
  in 
  let p4 = append (
    Vec4(8, 12, 16, 10)::
      Vec4(8, 8, 12, 9)::
        Vec4(12, 9, 16, 8)::
          Vec4(9, 6, 12, 7)::
            Vec4(12, 7, 16, 6)::[])
  p5
  in 
  let p3 = append (
    Vec4(10, 16, 12, 14)::
      Vec4(12, 14, 16, 13)::
        Vec4(12, 16, 13, 15)::
          Vec4(13, 15, 16, 14)::
            Vec4(14, 16, 16, 15)::[])
  p4
  in 
  let p2 = append (
    Vec4(4, 13, 0, 16)::
      Vec4(0, 16, 6, 15)::
        Vec4(6, 15, 8, 16)::
          Vec4(8, 16, 12, 12)::
            Vec4(12, 12, 16, 12)::[])
  p3 
  in 
  let p1 = append (
    Vec4(4, 10, 7, 6)::
      Vec4(7, 6, 4, 5)::
        Vec4(11, 0, 10, 4)::
          Vec4(10, 4, 9, 6)::
            Vec4(9, 6, 8, 8)::
              Vec4(8, 8, 4, 13)::[])
  p2
  in 
  let p = append (
    Vec4(0, 3, 3, 4)::
      Vec4(3, 4, 0, 8)::
        Vec4(0, 8, 0, 3)::
          Vec4(6, 0, 4, 4)::
            Vec4(4, 5, 4, 10)::[])
  p1
  in
    p 

let q_tile = 
  let q7 = 
    Vec4(0, 0, 0, 8)::
      Vec4(0, 12, 0, 16)::[]
  in 
  let q6 = append (
    Vec4(13, 0, 16, 6)::
      Vec4(14, 0, 16, 4)::
        Vec4(15, 0, 16, 2)::
          Vec4(0, 0, 8, 0)::
            Vec4(12, 0, 16, 0)::[])
  q7
  in 
  let q5 = append (
    Vec4(10, 0, 14, 11)::
      Vec4(12, 0, 13, 4)::
        Vec4(13, 4, 16, 8)::
          Vec4(16, 8, 15, 10)::
            Vec4(15, 10, 16, 16)::[])
  q6
  in 
  let q4 = append (
    Vec4(4, 5, 4, 7)::
      Vec4(4, 0, 6, 5)::
        Vec4(6, 5, 6, 7)::
          Vec4(6, 0, 8, 5)::
            Vec4(8, 5, 8, 8)::[])
  q5
  in 
  let q3 = append (
    Vec4(11, 15, 9, 13)::
      Vec4(10, 10, 8, 12)::
        Vec4(8, 12, 12, 12)::
          Vec4(12, 12, 10, 10)::
            Vec4(2, 0, 4, 5)::[])
  q4
  in 
  let q2 = append (
    Vec4(4, 16, 5, 14)::
      Vec4(6, 16, 7, 15)::
        Vec4(0, 10, 7, 11)::
          Vec4(9, 13, 8, 15)::
            Vec4(8, 15, 11, 15)::[])
  q3
  in 
  let q1 = append (
    Vec4(0, 12, 3, 13)::
      Vec4(3, 13, 5, 14)::
        Vec4(5, 14, 7, 15)::
          Vec4(7, 15, 8, 16)::
            Vec4(2, 16, 3, 13)::[])
  q2
  in 
  let q = append (
    Vec4(0, 8, 4, 7)::
      Vec4(4, 7, 6, 7)::
        Vec4(6, 7, 8, 8)::
          Vec4(8, 8, 12, 10)::
            Vec4(12, 10, 16, 16)::[])
  q1
  in
    q

let r_tile = 
  let r4 = 
    Vec4(11, 16, 12, 12)::
      Vec4(12, 12, 16, 8)::
        Vec4(13, 13, 16, 10)::
          Vec4(14, 14, 16, 12)::
            Vec4(15, 15, 16, 14)::[]
  in 
    let r3 = append (
      Vec4(2, 2, 8, 0)::
        Vec4(3, 3, 8, 2)::
          Vec4(8, 2, 12, 0)::
            Vec4(5, 5, 12, 3)::
              Vec4(12, 3, 16, 0)::[])
    r4
  in 
    let r2 = append (
      Vec4(5, 10, 2, 12)::
        Vec4(2, 12, 0, 16)::
          Vec4(16, 8, 12, 12)::
            Vec4(12, 12, 11, 16)::
              Vec4(1, 1, 4, 0)::[])
    r3
    in 
    let  r1 = append (
      Vec4(16, 6, 11, 10)::
        Vec4(11, 10, 6, 16)::
          Vec4(16, 4, 14, 6)::
            Vec4(14, 6, 8, 8)::
              Vec4(8, 8, 5, 10)::[])
    r2
    in 
    let  r = append (
      Vec4(0, 0, 8, 8)::
        Vec4(12, 12, 16, 16)::
          Vec4(0, 4, 5, 10)::
            Vec4(0, 8, 2, 12)::
              Vec4(0, 12, 1, 14)::[])
    r1
    in 
    r

let s_tile = 
  let s5 = 
    Vec4(15, 5, 13, 7)::
      Vec4(13, 7, 15, 8)::
        Vec4(15, 8, 15, 5)::[]
    in 
    let s4 = append ( 
      Vec4(15, 9, 16, 8)::
        Vec4(10, 16, 11, 10)::
          Vec4(12, 4, 10, 6)::
            Vec4(10, 6, 12, 7)::
              Vec4(12, 7, 12, 4)::[])
    s5
  in 
    let  s3 = append (
      Vec4(7, 8, 7, 13)::
        Vec4(7, 13, 8, 16)::
          Vec4(12, 16, 13, 13)::
            Vec4(13, 13, 14, 11)::
              Vec4(14, 11, 15, 9)::[])
    s4
    in 
    let  s2 = append (
      Vec4(14, 11, 16, 12)::
        Vec4(15, 9, 16, 10)::
          Vec4(16, 0, 10, 4)::
            Vec4(10, 4, 8, 6)::
              Vec4(8, 6, 7, 8)::[])
    s3
    in 
    let  s1 = append (
      Vec4(0, 8, 8, 6)::
        Vec4(0, 10, 7, 8)::
          Vec4(0, 12, 7, 10)::
            Vec4(0, 14, 7, 13)::
              Vec4(13, 13, 16, 14)::[])
    s2
    in
    let s = append (
      Vec4(0, 0, 4, 2)::
        Vec4(4, 2, 8, 2)::
          Vec4(8, 2, 16, 0)::
            Vec4(0, 4, 2, 1)::
              Vec4(0, 6, 7, 4)::[])
    s1
    in 
    s

let rec grid m n segments a b c= 
  match segments with 
    | [] -> []
    | Vec4(x0,y0,x1,y1)::t -> 
        (tup2 
        (vec_add (vec_add a (scale_vec b x0 m)) (scale_vec c y0 n))
        (vec_add (vec_add a (scale_vec b x1 m)) (scale_vec c y1 n))) 
        :: grid m n t a b c

let tile_to_grid arg arg2 arg3 arg4 = 
  grid 16 16  arg arg2 arg3 arg4 

let p arg q6 q7 = tile_to_grid p_tile arg q6 q7 
let q arg q6 q7 = tile_to_grid q_tile arg q6 q7 
let r arg q6 q7 = tile_to_grid r_tile arg q6 q7 
let s arg q6 q7 = tile_to_grid s_tile arg q6 q7 


let rot p a b c  = 
  p ((vec_add a b),c,(vec_sub (Vec(0,0)) b))

let beside m n p q a b c = 
  append
  (p (a, (scale_vec b m (m+n)), c))
  (q ((vec_add a (scale_vec b m (m+n))),(scale_vec b n (n+m)),c))

let above m n p q a b c = 
  append 
  (p ((vec_add a (scale_vec c n (n+m)),b,(scale_vec c m (n+m)))))
  (q (a,b,(scale_vec c n (m+n))))


let quartet a b c d arg q6 q7 = 
  above 1 1 
    (fun (p5,p6,p7) -> beside 1 1 a b p5 p6 p7) 
    (fun (p5,p6,p7) -> beside 1 1 c d p5 p6 p7)
    arg q6 q7

let t arg q6 q7 = 
  quartet 
    (fun (a,b,c) -> p a b c)
    (fun (a,b,c) -> q a b c)
    (fun (a,b,c) -> r a b c)
    (fun (a,b,c) -> s a b c) 
    arg q6 q7

let cycle_ p1 arg p3 p4 = 
  quartet p1 
    (fun (a,b,c) -> (rot (fun (a,b,c) -> rot p1 a b c) a b c))
    (fun (a,b,c) -> rot p1 a b c) 
    (fun (a,b,c) -> rot (fun (a,b,c) -> rot p1 a b c) a b c) 
    arg p3 p4 

let u arg p2 p3 =
  cycle_ 
    (fun (a,b,c) -> rot (fun (a,b,c) -> q a b c) a b c)
    arg p2 p3

let side1 arg q6 q7 = 
  quartet 
    (fun (a,b,c) -> nil_ a b c) 
    (fun (a,b,c) -> nil_ a b c)
    (fun (a,b,c) -> rot (fun (a,b,c) -> t a b c) a b c) 
    (fun (a,b,c) -> t a b c)
    arg q6 q7

let side2 arg q6 q7 = 
  quartet 
    (fun (a,b,c) -> side1 a b c) 
    (fun (a,b,c) -> side1 a b c)
    (fun (a,b,c) -> 
      (rot (fun (a,b,c) -> t a b c)) a b c)
    (fun (a,b,c) -> t a b c)
    arg q6 q7

let corner1 arg q6 q7 = 
  quartet 
    (fun (a,b,c) -> nil_ a b c)
    (fun (a,b,c) -> nil_ a b c)
    (fun (a,b,c) -> nil_ a b c)
    (fun (a,b,c) -> u a b c)
    arg q6 q7 

let corner2 arg q6 q7 = 
  quartet 
    (fun (a,b,c) -> corner1 a b c)
    (fun (a,b,c) -> side1 a b c)
    (fun (a,b,c) -> 
      (rot (fun (a,b,c) -> side1 a b c)) a b c)
    (fun (a,b,c) -> u a b c)
    arg q6 q7

let pseudocorner arg q6 q7 = 
  quartet 
    (fun (a,b,c) -> corner2 a b c)
    (fun (a,b,c) -> side2 a b c)
    (fun (a,b,c) -> 
      (rot (fun (a,b,c) -> side2 a b c) a b c) )
    (fun (a,b,c) -> 
      (rot (fun (a,b,c) -> t a b c) a b c))
    arg q6 q7

let pseudolimit arg p2 p3 = 
  cycle_ 
    (fun (a,b,c) -> pseudocorner a b c)
    arg p2 p3 

let test_fish_nofib n = 
  map (fun i -> 
    let n = min 0 i in 
    pseudolimit (Vec(0,0)) (Vec(640+n,0)) (Vec(0,640+n)))
  (enum_from_to 1 n)

let main =
  let n = int_of_string Sys.argv.(1) in 
  let res = test_fish_nofib n in 
  print_endline (string_of_int (len (head res)))
