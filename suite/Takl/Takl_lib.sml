structure Takl = struct 
  fun list_n n = 
    if n=0 then nil else n :: (list_n (n-1))

  fun shorterp x y = 
    if null y then false 
    else if null x then true 
    else shorterp (tl x) (tl y)

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

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val x = valOf (Int.fromString (hd (tl args)))
    val y = valOf (Int.fromString (hd (tl (tl args))))
    val z = valOf (Int.fromString (hd (tl (tl (tl args)))))
  in 
    main_loop iters x y z
  end
end
