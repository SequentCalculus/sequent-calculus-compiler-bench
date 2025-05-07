structure CC = SMLofNJ.Cont

fun odd_abs i k = 
  if i=0 
  then CC.throw k false 
  else CC.throw k (even_abs (i-1))
and even_abs i = 
  if i=0 then true else CC.callcc (fn k => odd_abs (i-1) k)

fun even i = even_abs (abs i)

fun odd i = 
  CC.callcc (fn k => odd_abs (abs i) k)

fun main_loop iters n = 
  let val res = (even n) andalso (not (odd n))
  in 
    if iters=1 
    then if res then print "1\n" else print "0\n"
    else main_loop (iters-1) n
  end

fun main () =   
let val args = CommandLine.arguments()
  val iters = valOf (Int.fromString (hd args))
  val n = valOf (Int.fromString (hd (tl args)))
in 
  main_loop iters n 
end

val _ = main()
