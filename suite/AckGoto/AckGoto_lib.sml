structure AckGoto = struct
  structure CC = SMLofNJ.Cont

  fun ack m n k =
    if m = 0
    then CC.throw k (n + 1)
    else if n = 0
    then ack (m - 1) 1 k
    else ack (m - 1) (CC.callcc (ack m (n - 1))) k

  fun main_loop iters m n =
    let val res = CC.callcc (ack m n)
    in if iters = 1
       then print ((Int.toString res) ^ "\n")
       else main_loop (iters - 1) m n
    end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
      val m = valOf (Int.fromString (hd (tl args)))
      val n = valOf (Int.fromString (hd (tl (tl args))))
    in
      main_loop iters m n
    end
end
