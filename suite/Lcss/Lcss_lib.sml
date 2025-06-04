structure Lcss = struct 
  fun enum_from_then_to from th to = 
    if from <= to
    then from :: (enum_from_then_to th ((2*th)-from) to)
    else nil

  fun is_singleton ls = 
    case ls of 
         x::nil => SOME x
       | _ => NONE

  fun in_list x ls = 
    case ls of 
         nil => false 
       | y::ys => if x=y then true else in_list x ys

  fun zip xs ys = 
    case (xs,ys) of 
         (nil,_) => nil
       | (_,nil) => nil
       | (x::xs,y::ys) => (x,y)::(zip xs ys)

  fun findk k km m ls =
    case ls of 
         nil => km
       | (x,y)::xys => 
           if m <= (x+y) 
           then findk (k+1) k (x+y) xys
           else findk (k+1) km m xys

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
         nil => map (fn (_,x) => x) yss 
       | (x::xs) => algb1 xs (algb2 x 0 0 yss)

  fun add_zero ls = 
    case ls of 
         nil => nil
       | (h::t) => (h,0)::(add_zero t)

  fun algb xs ys = 
    0::(algb1 xs (add_zero ys))

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
               val xs1 = List.take (xs, m2)
               val xs2 = List.drop (xs, m2)
               val l1 = algb xs1 ys
               val l2 = List.rev (algb (List.rev xs2) (List.rev ys))
               val k = findk 0 0 ~1 (zip l1 l2)
           in 
             (fn x => 
             let val f1 = algc (m-m2) (n-k) xs2 (List.drop (ys,k))
               val f2 = algc m2 k xs1 (List.take (ys, k))
             in 
               f2 (f1 x)
           end)
             end

  fun lcss xs ys = 
    (algc (length xs) (length ys) xs ys) nil

  fun lcss_main a b c d e f = 
    lcss (enum_from_then_to a b c) (enum_from_then_to d e f)

  fun test_lcss_nofib () = 
    lcss_main 1 2 200 100 101 300

  fun main_loop iters = 
  let val res = test_lcss_nofib ()
             in 
               if iters=1 then print ((Int.toString (hd res)) ^ "\n")
               else main_loop (iters-1)
             end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
  in 
    main_loop iters
  end
end 
