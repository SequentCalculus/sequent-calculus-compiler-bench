fun loop_one2n n p = 
  if n=0 then p else loop_one2n (n-1) (n::p)

fun one2n n = loop_one2n n nil

fun factorial n = 
  if n=1 then 1 else n*(factorial (n-1))

fun loop_sum2 y sum = 
  if null y then sum else 
    loop_sum2 (tl y) (sum + (hd y))

fun loop_sum1 x sum = 
  if null x then sum else 
    loop_sum1 (tl x) (loop_sum2 (hd x) sum)

fun sumlists x = loop_sum1 x 0

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

fun loop_run iters work result = 
  let val res = result (work())
  in 
    if iters = 0 
    then res 
    else loop_run (iters-1) work result
  end

fun run_benchmark iters work result = 
  loop_run iters work result 

fun perm9 m n = 
  run_benchmark 1 
    (fn () => loop_work m (permutations (one2n n)))
    (fn result => 
      (sumlists result) = (((n*(n+1)) * (factorial n)) div 2))

fun main_loop iters m n = 
  let val res = perm9 m n
  in if iters=1
     then if res then print "1\n" else print "0\n"
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
