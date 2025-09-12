structure Fib = struct 

  fun fib n = 
    if n = 0 then 0 
    else if n = 1 then 1 
    else (fib (n - 1)) + (fib (n - 2))

  fun main_loop iters n = 
  let val res = fib n
  in 
    if iters = 1 then 
      print ((Int.toString res) ^ "\n")
    else main_loop (iters - 1) n
  end

  fun run args =    
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n 
  end
end 
