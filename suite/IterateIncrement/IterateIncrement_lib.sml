structure IterateIncrement = struct 
  fun iterate i f a =
    if i=0 then a 
    else iterate (i-1) f (f a)

  fun main_loop iters n = 
  let val res = iterate n (fn x => x+1) 0
  in 
    if iters=1 then print ((Int.toString res) ^ "\n")
    else main_loop (iters-1) n
  end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n 
  end

end 
