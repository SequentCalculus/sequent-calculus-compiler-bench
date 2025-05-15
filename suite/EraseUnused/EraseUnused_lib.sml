structure EraseUnused = struct 
  fun replicate v n a = 
    if n=0
    then a 
    else replicate v (n-1) (v::a)

  fun useless i n b = 
    if i<n
    then useless (i+1) n (replicate 0 i nil)
    else i 

  fun main_loop iters n = 
  let val res = useless 0 n nil
  in 
    if iters=1 
    then print ((Int.toString res) ^ "\n")
    else main_loop (iters-1) n
  end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n 
  end
end 
