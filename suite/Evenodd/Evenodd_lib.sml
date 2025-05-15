structure Evenodd = struct 

  fun odd_abs n = 
    if n=0 then false else even_abs (n-1)
  and even_abs n = 
  if n=0 then true else odd_abs (n-1)

  fun even n = even_abs(abs n)

  fun odd n = odd_abs(abs n)

  fun main_loop iters n = 
  let val res = (even n) andalso (not (odd n))
  in 
    if iters=1 
    then if res then print "1\n" else print "0\n"
    else main_loop (iters-1) n
  end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n 
  end
end 

