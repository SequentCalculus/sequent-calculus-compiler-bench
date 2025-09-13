structure Motzkin = struct
  fun sum_loop i tot stop f =
    if stop < i then tot
    else sum_loop (i + 1) ((f i) + tot) stop f

  fun sum f start stop = sum_loop start 0 stop f

  fun motz n =
    if n <= 1 then 1 else
      let val limit = n - 2
        val product = fn i => (motz i) * (motz (limit - i))
      in
        (motz (n - 1)) + (sum product 0 limit)
      end

  fun main_loop iters n =
  let val res = motz n
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
