structure Divrec = struct 
  exception OddNumber

  fun create_n n = 
    if n=0 then 
      [] 
    else 
      () :: (create_n (n-1))

  fun len l = 
    case l of 
         nil => 0 
       | _::xs => 1 + (len xs)

  fun rec_div2 l = 
    case l of 
         nil => nil
       | (x::y::ys) => x::(rec_div2 ys)
       | _ => raise OddNumber

  fun main_loop iters n = 
  let val res = len (rec_div2 (create_n n))
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

