fun factorial a i = 
  if i=0 then a 
  else  factorial ((i * a) mod 1000000007) (i - 1)

fun main_loop iters n = 
  let val res = factorial 1 n
  in 
    if iters=1 
    then print ((Int.toString res) ^ "\n")
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
