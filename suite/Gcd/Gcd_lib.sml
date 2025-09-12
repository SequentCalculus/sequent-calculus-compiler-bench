structure Gcd = struct
  exception EmptyList

  fun abs_int i = if i < 0 then ~i else i

  fun map_list f l =
    case l of
         nil => nil
       | x :: xs => (f x) :: (map_list f xs)

  fun append l1 l2 =
    case l1 of
         nil => l2
       | p :: ps => p :: append ps l2

  fun enum_from_to from to =
    if from <= to
    then from :: (enum_from_to (from + 1) to)
    else nil

  fun max ls =
    case ls of
         nil => raise EmptyList
       | x :: nil => x
       | x :: y :: ys =>
           if x < y then max (y :: ys) else max (x :: ys)

  fun quot_rem a b = (a div b, a mod b)

  fun g (u1, u2, u3) (v1, v2, v3) =
    if v3 = 0 then (u3, u1, u2)
    else
      let val (q, r) = quot_rem u3 v3
      in
        g (v1, v2, v3) (u1 - (q * v1), u2 - (q * v2), r)
      end

  fun gcd_e x y =
    if x = 0 then (y, 0, 1) else g (1, 0, x) (0, 1, y)

  fun to_pair i ls =
    case ls of
         nil => nil
       | j :: js => (i, j) :: (to_pair i js)

  fun cartesian_product p1 ms =
    case p1 of
         nil => nil
       | h1 :: t1 => append (to_pair h1 ms) (cartesian_product t1 ms)

  fun test d =
  let val ns = enum_from_to 5000 (5000 + d)
    val ms = enum_from_to 10000 (10000 + d)
    val tripls =
      map_list (fn (x, y) => (x, y, gcd_e x y)) (cartesian_product ns ms)
    val rs =
      map_list (fn (d1, d2, (gg, u, v)) => abs_int (gg + u + v)) tripls
      in
        max rs
      end

  fun test_gcd_nofib x = test x

  fun main_loop iters n =
  let val res = test_gcd_nofib n
  in
    if iters = 1 then print ((Int.toString res) ^ "\n")
    else main_loop (iters - 1) n
  end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in
    main_loop iters n
  end
end
