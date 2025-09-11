structure Lcss = struct 
  fun snd (_,x) = x

  fun rev_loop l1 l2 = 
    case l1 of 
         nil => l2
       | x::xs => rev_loop xs (x::l2)

  fun rev l = rev_loop l nil

  fun map_list f l = 
    case l of 
         nil => nil
       | x::xs => (f x) :: (map_list f xs)

  fun head l = 
    case l of 
         nil => raise Fail("Empty List")
       | h::_ => h

  fun take n l = 
    case l of 
         nil => nil
       | x::xs => if n=0 then nil else x::(take (n-1) xs)

  fun drop n l = 
    if n=0 then l 
    else case l of 
              [] => []
            | x::xs => drop (n - 1) xs

  fun is_singleton ls = 
    case ls of 
         x::nil => SOME x
       | _ => NONE

  fun len ls = 
    case ls of 
         [] => 0
       | _::xs => 1 + (len xs)

  fun zip xs ys = 
    case (xs,ys) of 
         (nil,_) => nil
       | (_,nil) => nil
       | (x::xs,y::ys) => (x,y)::(zip xs ys)

  fun in_list x ls = 
    case ls of 
         nil => false 
       | y::ys => if x=y then true else in_list x ys

  fun enum_from_then_to from th to = 
    if from <= to
    then from :: (enum_from_then_to th ((2*th)-from) to)
    else nil
 
  fun add_zero ls = 
    case ls of 
         nil => nil
       | (h::t) => (h,0)::(add_zero t) 

  fun algb2 x k0j1 k1j1 yss = 
    case yss of 
         nil => nil
       | (y,k0j)::ys => 
           let val kjcurr = 
           if x=y then k0j1+1 else Int.max (k1j1,k0j)
           in 
             (y,kjcurr)::(algb2 x k0j kjcurr ys)
           end

  fun algb1 xss yss = 
    case xss of 
         nil => map_list snd yss 
       | (x::xs) => algb1 xs (algb2 x 0 0 yss)


  fun algb xs ys = 
    0::(algb1 xs (add_zero ys))
  fun findk k km m ls =
    case ls of 
         nil => km
       | (x,y)::xys => 
           if m <= (x+y) 
           then findk (k+1) k (x+y) xys
           else findk (k+1) km m xys

  fun algc m n xs ys = 
    if null ys 
    then fn x => x
    else 
      case (is_singleton xs) of 
           SOME x => 
           if in_list x ys 
           then (fn t => x::t)
           else (fn x => x)
         | NONE => 
             let val m2 = m div 2 
               val xs1 = take m2 xs
               val xs2 = drop m2 xs
               val l1 = algb xs1 ys
               val l2 = rev (algb (rev xs2) (rev ys))
               val k = findk 0 0 ~1 (zip l1 l2)
           in 
             (fn x => 
             let val f1 = algc (m-m2) (n-k) xs2 (drop k ys)
               val f2 = algc m2 k xs1 (take k ys)
             in 
               f2 (f1 x)
           end)
             end

  fun lcss xs ys = 
    (algc (len xs) (len ys) xs ys) nil

  fun lcss_main a b c d e f = 
    lcss (enum_from_then_to a b c) (enum_from_then_to d e f)

  fun test_lcss_nofib c f = 
    lcss_main 1 2 c 100 101 f

  fun main_loop iters c f = 
  let val res = test_lcss_nofib c f in 
    if iters=1 then print ((Int.toString (head res)) ^ "\n")
    else main_loop (iters-1) c f
             end

  fun run args =   
  let val iters = valOf (Int.fromString (head args))
    val c = valOf (Int.fromString (head (tl args)))
    val f = valOf (Int.fromString (head (tl (tl args))))
  in 
    main_loop iters c f
  end
  end 
