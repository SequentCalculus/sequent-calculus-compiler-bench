structure Merge = struct 
  fun tabulate_loop n len f acc = 
    if n<len then 
      tabulate_loop (n+1) len f (f n::acc)
    else List.rev acc

  fun tabulate n f = 
    if n<0 then nil else tabulate_loop 0 n f nil

  fun merge l1 l2 = 
    case (l1,l2) of 
         (nil,_) => l2
       | (_,nil) => l1
       | (x1::xs1,x2::xs2) => 
           if x1<=x2 
           then x1::(merge xs1 l2)
           else x2::(merge l2 xs2)

  fun main_loop iters l1 l2 = 
  let val res = merge l1 l2 
  in 
    if iters=1 then 
      print ((Int.toString (hd res)) ^ "\n")
    else main_loop (iters-1)  l1 l2 
  end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
    val l1 = tabulate n (fn x => 2*x)
    val l2 = tabulate n (fn x => (2*x)+1)
  in 
    main_loop iters l1 l2
  end
end
