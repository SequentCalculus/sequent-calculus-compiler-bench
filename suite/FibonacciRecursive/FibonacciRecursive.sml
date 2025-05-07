fun fibonacci i = 
  if i=0 then i 
  else if i=1 then i 
  else (fibonacci (i-1)) + (fibonacci (i-2))

fun main_loop iters n = 
  let val res = fibonacci n
  in 
    if iters=1 then 
      print ((Int.toString res) ^ "\n")
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
