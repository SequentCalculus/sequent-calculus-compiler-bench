structure Perm = struct 
  fun loop_one2n n p = 
    if n=0 then p else loop_one2n (n-1) (n::p)

  fun one2n n = loop_one2n n nil

  fun factorial n = 
    if n=1 then 1 else n*(factorial (n-1))

  fun loop_sum y = 
    case y of
       [] => 0
      | is::iss => is + (loop_sum iss)

  fun sumlists x = 
    case x of
       [] => 0
      | is::iss => (loop_sum is) + (sumlists iss)

  fun list_tail x n = 
    if n=0 then x else list_tail (tl x) (n-1)

  fun rev_loop x n y = 
    if n=0 then y else 
      rev_loop (tl x) (n-1) ((hd x)::y)

  fun f n perms x = 
  let val x = rev_loop x n (list_tail x n)
    val perms = x::perms
  in 
    (perms,x)
  end

  fun loop_p j perms x n = 
    if j=0 then p (n-1) perms x 
    else 
      let val (perms,x) = p (n-1) perms x  
        val (perms,x) = f n perms x 
  in 
    loop_p (j-1) perms x n 
  end
  and p n perms x = 
  if 1<n then loop_p (n-1) perms x n 
  else (perms,x)

  fun permutations x0 = 
  let val (final_perms,_) = p (length x0) (x0::nil) x0
      in final_perms end

  fun loop_work m perms = 
    if m=0 then perms 
    else loop_work (m-1) (permutations (hd perms))

  fun run_benchmark work result = 
    result (work())

  fun perm9 m n = 
    run_benchmark
    (fn () => loop_work m (permutations (one2n n)))
    (fn result => 
    (sumlists result) = (((n*(n+1)) * (factorial n)) div 2))

  fun main_loop iters m n = 
  let val res = perm9 m n
  in if iters=1
    then if res then print "1\n" else print "0\n"
    else main_loop (iters-1) m n
  end

  fun run args = 
    let val iters = valOf (Int.fromString (hd args))
    val m = valOf (Int.fromString (hd (tl args)))
    val n = valOf (Int.fromString (hd (tl (tl args))))
  in 
    main_loop iters m n
  end
end
