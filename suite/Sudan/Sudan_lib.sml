structure Sudan = struct 
  fun sudan n x y =
    if n=0 then x+y
    else if y = 0 then x 
    else 
      let val inner = sudan n x (y-1)
      in 
        sudan (n-1) inner (inner+y)
      end 

  fun main_loop iters n x y = 
  let val res = sudan n x y
      in if iters=1
         then print ((Int.toString res) ^ "\n")
         else main_loop (iters-1) n x y 
      end

  fun run args = 
  let val args = CommandLine.arguments()
    val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
    val x = valOf (Int.fromString (hd (tl (tl args))))
    val y = valOf (Int.fromString (hd (tl (tl (tl args)))))
  in 
    main_loop iters n x y 
  end
end
