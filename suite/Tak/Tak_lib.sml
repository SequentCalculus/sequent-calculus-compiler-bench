structure Tak = struct 
  fun tak x y z = 
    if y < x then 
      tak 
      (tak (x-1) y z)
      (tak (y-1) z x)
      (tak (z-1) x y)
    else z 

  fun main_loop iters x y z = 
  let val res = tak x y z
  in 
    if iters=1 then 
      print ((Int.toString res) ^ "\n")
    else main_loop (iters-1) x y z 
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
