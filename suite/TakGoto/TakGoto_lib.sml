structure TakGoto = struct 
  structure CC = SMLofNJ.Cont

  fun tak x y z k = 
    if y<x then
      tak 
      (CC.callcc (fn a => tak (x-1) y z a))
      (CC.callcc (fn b => tak (y-1) z x b))
      (CC.callcc (fn c => tak (z-1) x y c))
      k
    else 
      CC.throw k z 

  fun main_loop iters x y z = 
  let val res = CC.callcc (fn k => tak x y z k)
  in if iters=1
    then print ((Int.toString res) ^ "\n")
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
