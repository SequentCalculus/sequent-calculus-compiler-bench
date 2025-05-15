structure Divrec = struct 
  exception OddNumber

  fun create_n_loop n acc = 
    if n=0 
    then acc
    else create_n_loop (n-1) (()::acc)

  fun create_n n = create_n_loop n nil

  fun rec_div2 l = 
    case l of 
         nil => nil
       | (x::y::ys) => x::(rec_div2 ys)
       | _ => raise OddNumber

  fun main_loop iters n = 
  let val res = length (rec_div2 (create_n n))
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

