structure Fish = struct 
  datatype vec = Vec of int * int 
  datatype vec4 = Vec4 of int*int*int*int

  fun vec_add (Vec (x1,y1)) (Vec (x2,y2)) = Vec (x1+x2,y1+y2)
  fun vec_sub (Vec (x1,y1)) (Vec (x2,y2)) = Vec (x1-x2,y1-y2)
  fun scale_vec (Vec(x,y)) (a:int) (b:int) = 
    Vec ((x*a) div b ,(y*a) div b)

  fun min i1 i2 = if i1 < i2 then i1 else i2

  fun nil_ a b c = nil

  fun tup2 (Vec(x1,y1)) (Vec(x2,y2)) = Vec4 (x1,y1,x2,y2)

  fun append_rev l1 l2 = 
    case l1 of 
         nil => l2
       | v::vs => append_rev vs (v::l2)

  fun rev l = append_rev l nil

  fun append l1 l2 = 
    case l2 of 
         nil => l1 
       | v::vs => append_rev (rev l1) (v::vs)

  fun map_list f l = 
    case l of 
         nil => nil
       | v::vs => (f v) :: (map_list f vs)

  fun len l = 
    case l of 
         nil => 0
       | _::vs => 1 + (len vs)

  fun head l = 
    case l of 
         nil => raise Fail "Empty List"
       | v::_ => v

  fun enum_from_to from to =
    if from <= to
    then from::(enum_from_to (from+1) to)
    else nil

  fun p_tile () = 
  let val p5 = [
  Vec4(10, 4, 13, 5),
  Vec4(13, 5, 16, 4),
  Vec4(11, 0, 14, 2),
  Vec4(14, 2, 16, 2)
               ]
    val p4 = [
    Vec4(8, 12, 16, 10),
    Vec4(8, 8, 12, 9),
    Vec4(12, 9, 16, 8),
    Vec4(9, 6, 12, 7),
    Vec4(12, 7, 16, 6)
               ] @ p5
    val p3 = [
    Vec4(10, 16, 12, 14),
    Vec4(12, 14, 16, 13),
    Vec4(12, 16, 13, 15),
    Vec4(13, 15, 16, 14),
    Vec4(14, 16, 16, 15)
             ] @ p4
    val p2 = [
    Vec4(4, 13, 0, 16),
    Vec4(0, 16, 6, 15),
    Vec4(6, 15, 8, 16),
    Vec4(8, 16, 12, 12),
    Vec4(12, 12, 16, 12)
             ] @ p3 
    val p1 = [
    Vec4(4, 10, 7, 6),
    Vec4(7, 6, 4, 5),
    Vec4(11, 0, 10, 4),
    Vec4(10, 4, 9, 6),
    Vec4(9, 6, 8, 8),
    Vec4(8, 8, 4, 13)
             ] @ p2
    val p = [
    Vec4(0, 3, 3, 4),
    Vec4(3, 4, 0, 8),
    Vec4(0, 8, 0, 3),
    Vec4(6, 0, 4, 4),
    Vec4(4, 5, 4, 10)
             ] @ p1
  in
    p 
  end

  fun q_tile () = 
  let val q7 = [ 
  Vec4(0, 0, 0, 8),
  Vec4(0, 12, 0, 16)
            ]
    val q6 = [
    Vec4(13, 0, 16, 6),
    Vec4(14, 0, 16, 4),
    Vec4(15, 0, 16, 2),
    Vec4(0, 0, 8, 0),
    Vec4(12, 0, 16, 0)
               ] @ q7
    val q5 = [
    Vec4(10, 0, 14, 11),
    Vec4(12, 0, 13, 4),
    Vec4(13, 4, 16, 8),
    Vec4(16, 8, 15, 10),
    Vec4(15, 10, 16, 16)
             ] @ q6
    val q4 = [
    Vec4(4, 5, 4, 7),
    Vec4(4, 0, 6, 5),
    Vec4(6, 5, 6, 7),
    Vec4(6, 0, 8, 5),
    Vec4(8, 5, 8, 8)
             ] @ q5
    val q3 = [
    Vec4(11, 15, 9, 13),
    Vec4(10, 10, 8, 12),
    Vec4(8, 12, 12, 12),
    Vec4(12, 12, 10, 10),
    Vec4(2, 0, 4, 5)
             ] @ q4
    val q2 = [
    Vec4(4, 16, 5, 14),
    Vec4(6, 16, 7, 15),
    Vec4(0, 10, 7, 11),
    Vec4(9, 13, 8, 15),
    Vec4(8, 15, 11, 15)
             ] @ q3
    val q1 = [
    Vec4(0, 12, 3, 13),
    Vec4(3, 13, 5, 14),
    Vec4(5, 14, 7, 15),
    Vec4(7, 15, 8, 16),
    Vec4(2, 16, 3, 13)
             ] @ q2
    val q = [
    Vec4(0, 8, 4, 7),
    Vec4(4, 7, 6, 7),
    Vec4(6, 7, 8, 8),
    Vec4(8, 8, 12, 10),
    Vec4(12, 10, 16, 16)
             ] @ q1
  in 
    q
  end

  fun r_tile () = 
  let val r4 = [
  Vec4(11, 16, 12, 12),
  Vec4(12, 12, 16, 8),
  Vec4(13, 13, 16, 10),
  Vec4(14, 14, 16, 12),
  Vec4(15, 15, 16, 14)
            ]
    val r3 = [
    Vec4(2, 2, 8, 0),
    Vec4(3, 3, 8, 2),
    Vec4(8, 2, 12, 0),
    Vec4(5, 5, 12, 3),
    Vec4(12, 3, 16, 0)
               ] @ r4
    val r2 = [
    Vec4(5, 10, 2, 12),
    Vec4(2, 12, 0, 16),
    Vec4(16, 8, 12, 12),
    Vec4(12, 12, 11, 16),
    Vec4(1, 1, 4, 0)
             ] @ r3
    val r1 = [
    Vec4(16, 6, 11, 10),
    Vec4(11, 10, 6, 16),
    Vec4(16, 4, 14, 6),
    Vec4(14, 6, 8, 8),
    Vec4(8, 8, 5, 10)
             ] @ r2
    val r = [
    Vec4(0, 0, 8, 8),
    Vec4(12, 12, 16, 16),
    Vec4(0, 4, 5, 10),
    Vec4(0, 8, 2, 12),
    Vec4(0, 12, 1, 14)
             ] @ r1
  in 
    r
  end

  fun s_tile () = 
  let val s5 = [
  Vec4(15, 5, 13, 7),
  Vec4(13, 7, 15, 8),
  Vec4(15, 8, 15, 5)
            ]
    val s4 = [ 
    Vec4(15, 9, 16, 8),
    Vec4(10, 16, 11, 10),
    Vec4(12, 4, 10, 6),
    Vec4(10, 6, 12, 7),
    Vec4(12, 7, 12, 4)
               ] @ s5
    val s3 = [
    Vec4(7, 8, 7, 13),
    Vec4(7, 13, 8, 16),
    Vec4(12, 16, 13, 13),
    Vec4(13, 13, 14, 11),
    Vec4(14, 11, 15, 9)
             ] @ s4
    val s2 = [
    Vec4(14, 11, 16, 12),
    Vec4(15, 9, 16, 10),
    Vec4(16, 0, 10, 4),
    Vec4(10, 4, 8, 6),
    Vec4(8, 6, 7, 8)
             ] @ s3
    val s1 = [
    Vec4(0, 8, 8, 6),
    Vec4(0, 10, 7, 8),
    Vec4(0, 12, 7, 10),
    Vec4(0, 14, 7, 13),
    Vec4(13, 13, 16, 14)
             ] @ s2
    val s = [
    Vec4(0, 0, 4, 2),
    Vec4(4, 2, 8, 2),
    Vec4(8, 2, 16, 0),
    Vec4(0, 4, 2, 1),
    Vec4(0, 6, 7, 4)
             ] @ s1
  in 
    s
  end

  fun grid m n segments a b c = 
    case segments of 
         nil => nil
       | (Vec4 (x0,y0,x1,y1))::t => 
           (tup2 
           (vec_add 
           (vec_add a (scale_vec b x0 m)) 
           (scale_vec c y0 n)
           ) 
           (vec_add 
           (vec_add a (scale_vec b x1 m)) 
           (scale_vec c y1 n)
           )
           )::grid m n t a b c

  fun tile_to_grid arg arg2 arg3 arg4 = 
    grid 16 16 arg arg2 arg3 arg4

  fun p arg q6 q7 = tile_to_grid (p_tile()) arg q6 q7

  fun q arg q6 q7 = tile_to_grid (q_tile()) arg q6 q7

  fun r arg q6 q7 = tile_to_grid (r_tile()) arg q6 q7

  fun s arg q6 q7 = tile_to_grid (s_tile()) arg q6 q7 

  fun rot p a b c = p((vec_add a b), c, (vec_sub (Vec (0,0)) b))

  fun beside (m:int) (n:int) p q a b c = 
    append (p (a,(scale_vec b m (m+n)),c))
    (q (
    (vec_add a (scale_vec b m (m+n))), 
    (scale_vec b n (n+m)),
    c
    ))

  fun above (m:int) (n:int) p q a b (c:vec) = 
    append (p (
    (vec_add a (scale_vec c n (n+m))),
    b,
    (scale_vec c m (n+m))
    ))  
    (q (
    a,
    b, 
    (scale_vec c n (m+n))
    ))

  fun quartet a b c d arg a6 a7 = 
    above 1 1 
    (fn (p5,p6,p7) => beside 1 1 a b p5 p6 p7) 
    (fn (p5,p6,p7) => beside 1 1 c d p5 p6 p7) 
    arg a6 a7

  fun t arg q6 q7 = 
    quartet 
    (fn (a,b,c) => p a b c)
    (fn (a,b,c) => q a b c)
    (fn (a,b,c) => r a b c)
    (fn (a,b,c) => s a b c)
    arg q6 q7

  fun cycle_ p1 arg p3 p4 = 
    quartet 
    p1 
    (fn (a,b,c) => rot (
    fn (a,b,c) => rot (
      fn (a,b,c) => rot p1 a b c 
        ) a b c 
        ) a b c)
        (fn (a,b,c) => rot p1 a b c)
        (fn (a,b,c) => rot (
        fn (a,b,c) => rot p1 a b c
          ) a b c)
          arg p3 p4

  fun u arg p2 p3 = 
    cycle_ 
    (fn (a,b,c) => rot (fn (a,b,c) => q a b c) a b c)
    arg p2 p3 

  fun side1 arg q6 q7 = 
    quartet 
    (fn (a,b,c) => nil_ a b c)
    (fn (a,b,c) => nil_ a b c)
    (fn (a,b,c) => rot (fn (a,b,c) => t a b c) a b c) 
    (fn (a,b,c) => t a b c)
    arg q6 q7

  fun side2 arg q6 q7 = 
    quartet 
    (fn (a,b,c) => side1 a b c)
    (fn (a,b,c) => side1 a b c)
    (fn (a,b,c) => rot (fn (a,b,c) => t a b c) a b c) 
    (fn (a,b,c) => t a b c)
    arg q6 q7

  fun corner1 arg q6 q7 = 
    quartet
    (fn (a,b,c) => nil_ a b c)
    (fn (a,b,c) => nil_ a b c)
    (fn (a,b,c) => nil_ a b c)
    (fn (a,b,c) => u a b c)
    arg q6 q7


  fun corner2 arg q6 q7 = 
    quartet 
    (fn (a,b,c) => corner1 a b c)
    (fn (a,b,c) => side1 a b c)
    (fn (a,b,c) => rot (fn (a,b,c) => side1 a b c) a b c) 
    (fn (a,b,c) => u a b c)
    arg q6 q7


  fun pseudocorner arg q6 q7 = 
    quartet 
    (fn (a,b,c) => corner2 a b c)
    (fn (a,b,c) => side2 a b c)
    (fn (a,b,c) => rot (fn (a,b,c) => side2 a b c) a b c) 
    (fn (a,b,c) => rot (fn (a,b,c) => t a b c) a b c)
    arg q6 q7

  fun pseudolimit arg p2 p3 = 
    cycle_ 
    (fn (a,b,c) => pseudocorner a b c)
    arg p2 p3 

  fun test_fish_nofib n = 
    map_list (fn i => 
    let val n = min 0 i
  in 
    pseudolimit (Vec (0, 0)) (Vec (640+n,0)) (Vec (0,640+n))
  end) (enum_from_to 1 n)

  fun run args =   
    let val n = valOf (Int.fromString (head args))
    val res = test_fish_nofib n 
    in 
      print ((Int.toString (len (head res))) ^ "\n")
    end
end
