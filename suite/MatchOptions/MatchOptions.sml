fun attempt i = 
  if i = 0 then SOME i
  else 
    case attempt (i-1) of 
         NONE => NONE
       | SOME x => SOME (x+1)

fun main_loop iters n = 
  let val res = 
  (case attempt n of 
       NONE => ~1
     | SOME x => x)
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
