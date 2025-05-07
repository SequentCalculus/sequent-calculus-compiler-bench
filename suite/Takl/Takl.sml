fun list_n_loop n a = 
  if n=0 then a else list_n_loop (n-1) (n::a)

fun list_n n = list_n_loop n nil

fun shorterp x y = 
  if not (null y) then true 
  else if null x then true
  else false 

fun mas x y z = 
  if not (shorterp y x) then z 
  else 
    mas 
      (mas (tl x) y z)
      (mas (tl y) z x)
      (mas (tl z) x y)

fun main_loop iters x y z = 
  let val res = length (mas (list_n x) (list_n y) (list_n z))
  in 
    if iters=1 then 
      print ((Int.toString res) ^ "\n")
    else main_loop (iters-1) x y z 
  end

fun main () =   
  let val args = CommandLine.arguments()
    val iters = valOf (Int.fromString (hd args))
    val x = valOf (Int.fromString (hd (tl args)))
    val y = valOf (Int.fromString (hd (tl (tl args))))
    val z = valOf (Int.fromString (hd (tl (tl (tl args)))))
in 
  main_loop iters x y z
end

val _ = main()
