structure SudanGoto = struct 
  structure CC = SMLofNJ.Cont

  fun sudan n x y k = 
    if n=0 then CC.throw k (x+y)
    else if y=0 then CC.throw k x 
    else 
      let val inner = CC.callcc (fn a => sudan n x (y-1) a)
      in 
        sudan (n-1) inner (inner+y) k
      end

  fun main_loop iters n x y = 
  let val res = CC.callcc (fn k => sudan n x y k)
      in if iters=1
         then print ((Int.toString res) ^ "\n")
         else main_loop (iters-1) n x y
      end

  fun run args = 
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
    val x = valOf (Int.fromString (hd (tl (tl args))))
    val y = valOf (Int.fromString (hd (tl (tl (tl args)))))
  in 
    main_loop iters n x y
  end
end
