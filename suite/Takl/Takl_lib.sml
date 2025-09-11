structure Takl = struct 
  fun null_list l = 
    case l of 
         nil => true
       | _ => false

  fun tail l = 
    case l of 
         nil => raise Fail "EmptyList"
       | _::xs => xs

  fun head l = 
    case l of 
         nil => raise Fail "EmptyList"
       | x::_ => x

  fun len l = 
    case l of 
         nil => 0
       | _::xs => 1 + (len xs)

  fun list_n n = 
    if n=0 then nil else n :: (list_n (n-1))

  fun shorterp x y = 
    if null_list y then false 
    else if null_list x then true 
    else shorterp (tail x) (tail y)

  fun mas x y z = 
    if not (shorterp y x) then z 
    else 
      mas 
      (mas (tail x) y z)
      (mas (tail y) z x)
      (mas (tail z) x y)

  fun main_loop iters x y z = 
  let val res = len (mas (list_n x) (list_n y) (list_n z))
  in 
    if iters=1 then 
      print ((Int.toString res) ^ "\n")
    else main_loop (iters-1) x y z 
  end

  fun run args =   
    let val iters = valOf (Int.fromString (head args))
    val x = valOf (Int.fromString (head (tail args)))
    val y = valOf (Int.fromString (head (tail (tail args))))
    val z = valOf (Int.fromString (head (tail (tail (tail args)))))
  in 
    main_loop iters x y z
  end
end
