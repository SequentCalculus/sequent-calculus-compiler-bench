structure Nqueens = struct 
  fun len l = 
    case l of 
         nil => 0
       | _::xs => 1 + (len xs)

  fun append l1 l2 = 
    case l1 of 
         nil => l2
       | x::xs => x::append xs l2

  fun safe x d l = 
    case l of 
         nil => true
       | q::l => 
           (not (x=q)) 
           andalso (not (x=(q+d))) 
           andalso (not (x=(q-d)))
           andalso (safe x (d+1) l)

  fun check l acc q = 
    case l of
         nil => acc
       | b::bs => 
           if safe q 1 b 
           then check bs ((q::b)::acc) q
           else check bs acc q

  fun enumerate q acc bs =
    if q = 0 then acc
    else 
      let val res = check bs nil q 
      in
        enumerate (q-1) (append res acc) bs
      end

  fun gen n nq = 
    if n=0 then nil::nil
    else 
      let val bs = gen (n-1) nq
      in 
        enumerate nq nil bs
      end

  fun nsoln n = len (gen n n)

  fun main_loop iters n = 
  let val res = nsoln n
      in 
        if iters=1 then 
          print ((Int.toString res) ^ "\n")
        else main_loop (iters-1) n
      end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n 
  end
end
