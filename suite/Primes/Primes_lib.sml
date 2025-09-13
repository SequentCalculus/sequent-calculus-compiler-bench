structure Primes = struct
  fun len l =
    case l of
         nil => 0
       | _ :: xs => 1 + (len xs)

  fun interval_list m n =
    if n < m then nil else m :: (interval_list (m + 1) n)

  fun remove_multiples n l =
    case l of
         nil => nil
       | x :: xs =>
           if (x mod n) = 0
           then remove_multiples n xs
           else x :: (remove_multiples n xs)

  fun sieve l =
    case l of
         nil => nil
       | x :: xs => x :: (sieve (remove_multiples x xs))

  fun main_loop iters n =
  let val res = sieve (interval_list 2 n)
  in
    if iters = 1 then
      print ((Int.toString (len res)) ^ "\n")
    else main_loop (iters - 1) n
  end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in
    main_loop iters n
  end
end
