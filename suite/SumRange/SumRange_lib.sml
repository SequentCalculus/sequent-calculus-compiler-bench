structure SumRange = struct
  fun range i n =
    if i < n then i :: (range (i + 1) n) else nil

  fun sum xs =
    case xs of
         nil => 0
       | y :: ys => y + (sum ys)

  fun main_loop iters n =
  let val res = sum (range 0 n)
  in
    if iters = 1
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
