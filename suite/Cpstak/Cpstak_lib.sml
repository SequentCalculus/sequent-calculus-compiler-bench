structure Cpstak = struct
  fun cps_tak x y z k =
    if x <= y
    then k(z)
    else
      cps_tak (x - 1) y z (fn v1 =>
      cps_tak (y - 1) z x (fn v2 =>
      cps_tak (z - 1) x y (fn v3 =>
      cps_tak v1 v2 v3 k)))

  fun tak x y z = cps_tak x y z (fn a => a)

  fun main_loop iters x y z =
  let val res = tak x y z
  in
    if iters=1 then print ((Int.toString res) ^ "\n")
    else main_loop (iters - 1) x y z
  end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val x = valOf (Int.fromString (hd (tl args)))
    val y = valOf (Int.fromString (hd (tl (tl args))))
    val z = valOf (Int.fromString (hd (tl (tl (tl args)))))
  in
    main_loop iters x y z
  end
end
