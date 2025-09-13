structure TailFib = struct
  fun tfib n a b =
    if n = 0 then a else tfib (n - 1) (a + b) a

  fun fib n = tfib n 0 1

  fun main_loop iters n =
  let val res = fib n
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
