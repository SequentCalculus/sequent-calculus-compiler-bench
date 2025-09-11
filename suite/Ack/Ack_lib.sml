structure Ack = struct

  fun ack m n =
    if m = 0 then
      n + 1
    else if n = 0 then
      ack (m - 1) 1
    else
      ack (m - 1) (ack m (n - 1))

  fun main_loop iters m n =
    let val res = ack m n in
    if iters = 1 then
      print ((Int.toString res) ^ "\n")
    else
      main_loop (iters - 1) m n
    end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
      val m = valOf (Int.fromString (hd (tl args)))
      val n = valOf (Int.fromString (hd (tl (tl args))))
    in
      main_loop iters m n
    end
end
