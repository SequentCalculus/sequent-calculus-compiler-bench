structure Life = struct
  datatype gen = MkGen of ((int * int) list)

  fun pair_eq (fst1,snd1) (fst2,snd2) = fst1 = fst2 andalso snd1=snd2

  fun fold xs acc f = 
    case xs of 
         nil => acc
       | h::t => fold t (f h acc) f
  
  fun revonto x y = fold x y (fn h => fn t => h::t)

  fun collect_accum sofar xs f =
    case xs of
         nil => sofar
       | p::xs => collect_accum (revonto sofar (f p)) xs f

  fun collect l f  = collect_accum nil l f

  fun append l1 l2 = 
    case l1 of 
         nil => l2 
       | h::t => h::append t l2

  fun map_list f l =
    case l of 
         nil => nil
       | h::t => (f h) :: (map_list f t)

  fun exists l f =
    case l of
         nil => false
       | p::ps => (f p) orelse (exists ps f)

  fun len l = 
    case l of 
         nil => 0
       | h::t => 1 + (len t)

  fun member l p = exists l (fn p1 => pair_eq p1 p)

  fun filter_list f l =
    case l of 
         nil => nil
       | h::t => if (f h) then h::filter_list f t else filter_list f t

  fun diff x y = filter_list (fn p => not (member y p) ) x

  fun alive (MkGen livecoords) = livecoords

  fun neighbors (fst,snd) =
    (fst-1,snd-1) :: (fst-1,snd) :: (fst-1,snd+1)
    :: (fst, snd-1) :: (fst, snd+1)
    :: (fst+1,snd-1) :: (fst+1,snd) :: (fst+1,snd+1) :: nil

  fun twoorthree n = n=2 orelse n=3

  fun collect_neighbors xover x3 x2 x1 xs =
    case xs of
         nil => diff x3 xover
       | a::x =>
           if member xover a
           then collect_neighbors xover x3 x2 x1 x
           else if member x3 a
           then collect_neighbors (a::xover) x3 x2 x1 x
           else if member x2 a
           then collect_neighbors xover (a::x3) x2 x1 x
           else if member x1 a
           then collect_neighbors xover x3 (a::x2) x1 x
           else collect_neighbors xover x3 x2 (a::x1) x

  fun occurs3 l =
    collect_neighbors nil nil nil nil l

  fun nextgen g =
  let val living= alive g
    val isalive= fn p => member living p
    val liveneighbors = fn p => len (filter_list isalive (neighbors p))
    val survivors = filter_list (fn p => twoorthree (liveneighbors(p))) living
    val newbrnlist= collect living (fn p => filter_list (fn n => not (isalive n)) (neighbors p))
    val newborn = occurs3 newbrnlist
  in
    MkGen (append survivors newborn)
  end

  fun nthgen g i =
    if i = 0 then g
    else nthgen (nextgen g) (i-1)

  fun gun () =
  let val r9 = (9,29) :: (9,30) :: (9,31) :: (9,32) :: nil
    val r8 = (8,20) :: (8,28) :: (8,29) :: (8,30) :: (8,31) :: (8,40) :: (8,41) :: r9
    val r7 = (7,19) :: (7,21) :: (7,28) :: (7,31) :: (7,40) :: (7,41) :: r8
    val r6 = (6,7) :: (6,8) :: (6,18) :: (6,22) :: (6,23) :: (6,28) :: (6,29) :: (6,30) :: (6,31) :: (6,36) :: r7
    val r5 = (5,7) :: (5,8) :: (5,18) :: (5,22) :: (5,23) :: (5,29) :: (5,30) :: (5,31) :: (5,32) :: (5,36) :: r6
    val r4 = (4,18) :: (4,22) :: (4,23) :: (4,32) :: r5
    val r3 = (3,19) :: (3,21) :: r4
    val r2 = (2,20) :: r3
  in
    MkGen r2
  end

  fun at_pos coordlist (fst2,snd2) =
  let val move = fn (fst1,snd1) => (fst1+fst2,snd1+snd2)
  in map_list move coordlist end

  val center_line = 5

  fun bail () =
    (0,0) :: (0,1) :: (1,0) :: (1,1) :: nil

  fun shuttle () =
  let val r4 = (4,1) :: (4,0) :: (4,5) :: (4,6) :: nil
    val r3 = (3,2) :: (3,3) :: (3,4) :: r4
    val r2 = (2,1) :: (2,5) :: r3
    val r1 = (1,2) :: (1,4) :: r2
  in
    (0,3) :: r1
  end

  fun non_steady () =
    MkGen (
    append
    (at_pos (bail()) (1,center_line))
    (append (at_pos (bail()) (21,center_line))
    (at_pos (shuttle()) (6,(center_line - 2)))
    ))

  fun go_gun steps =
    nthgen (gun()) steps

  fun go_shuttle steps =
    nthgen (non_steady()) steps

  fun go_loop iters steps go =
    let val res = go steps
    in
      if iters=1 then len (alive res)
      else
        go_loop (iters-1) steps go
    end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val steps = valOf (Int.fromString (hd (tl args)))
    val gun_res = go_loop iters steps go_gun
    val shuttle_res = go_loop iters steps go_shuttle
      in
        print (Int.toString gun_res);
        print ((Int.toString shuttle_res) ^ "\n")
      end
end
