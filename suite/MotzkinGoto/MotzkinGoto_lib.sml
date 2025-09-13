structure MotzkinGoto = struct
  structure CC = SMLofNJ.Cont

  fun sum_loop i tot stop f k =
    if stop < i then CC.throw k tot
    else sum_loop (i + 1) ((f i) + tot) stop f k

  fun sum f start stop k = sum_loop start 0 stop f k

  fun motz n k =
    if n <= 1
    then CC.throw k 1
    else
      let val limit = n - 2
        val product = fn i =>
        (CC.callcc (motz i))
        * (CC.callcc (motz (limit - i)))
      in
        CC.throw k (
        (CC.callcc (motz (n - 1)))
        + (CC.callcc (sum product 0 limit))
        )
      end

  fun main_loop iters n =
  let val res = CC.callcc (motz n)
      in if iters=1
    then print ((Int.toString res) ^ "\n")
    else main_loop (iters - 1) n
      end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in
    main_loop iters n
  end
end
