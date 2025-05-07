structure CC = SMLofNJ.Cont

fun ack m n k = 
  if m=0
  then CC.throw k (n+1)
  else if n=0
  then ack (m-1) 1 k
  else ack (m-1) (CC.callcc (fn a => ack m (n-1) a)) k

fun main_loop iters m n = 
  let val res = CC.callcc (fn k => ack m n k)
  in if iters=1
     then print ((Int.toString res) ^ "\n")
     else main_loop (iters-1) m n 
  end

fun main () = 
  let val args = CommandLine.arguments()
    val iters = valOf (Int.fromString (hd args))
    val m = valOf (Int.fromString (hd (tl args)))
    val n = valOf (Int.fromString (hd (tl (tl args))))
  in 
    main_loop iters m n
  end

val _ = main()
