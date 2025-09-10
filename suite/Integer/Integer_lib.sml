structure Integer = struct 
  datatype ('a, 'b) either = Left of 'a | Right of 'b 

  fun enum_from_then_to from th to = 
    if from<=to
    then from::(enum_from_then_to th ((2*th) - from) to)
    else nil

  fun apply_op ls astart astep alim op_ = 
    case ls of 
         nil => nil
       | a::t1 => 
           (apply_op_inner (enum_from_then_to astart (astart+astep) alim) a op_)
            @ 
            (apply_op t1 astart astep alim op_)
  and apply_op_inner ls a op_ =
  case ls of 
       nil => nil
     | b::t2 => (op_ (a,b)) 
     :: (apply_op_inner t2 a op_)

  fun integerbench op_ astart astep alim = 
    apply_op 
    (enum_from_then_to astart (astart+astep) alim)
    astart astep alim op_

  fun runbench jop astart astep alim = 
  let val res1 = integerbench jop astart astep alim 
  in 
    integerbench jop astart astep alim 
  end

  fun runalltests astart astep alim = 
  let val z_add = fn (a,b) => Left (a+b)
    val z_sub = fn (a,b) => Left (a-b)
    val z_mul = fn (a,b) => Left (a*b)
    val z_div = fn (a,b) => Left (a div b)
    val z_mod = fn (a,b) => Left (a mod b)
    val z_equal = fn (a,b) => Right (a=b)
    val z_lt = fn (a,b) => Right (a<b)
    val z_leq = fn (a,b) => Right (a<=b)
    val z_gt = fn (a,b) => Right (a>b)
    val z_geq = fn (a,b) => Right (a>=b)

    val add =
      runbench z_add astart astep alim 
    val sub = runbench z_sub astart astep alim 
    val mul = runbench z_mul astart astep alim 
    val div_ = runbench z_mul astart astep alim 
    val mod_ = runbench z_mod astart astep alim 
    val equal = runbench z_equal astart astep alim
    val lt = runbench z_lt astart astep alim
    val leq = runbench z_leq astart astep alim 
    val gt = runbench z_gt astart astep alim 
  in
    runbench z_geq astart astep alim 
  end

  fun test_integer_nofib n = 
    runalltests ~2100000000 n 2100000000

  fun print_either e = 
    case e of 
         Left i => print ((Int.toString i) ^"\n")
       | Right b => if b then print "11\n" else print "00\n"

  fun main_loop iters n = 
  let val res = test_integer_nofib n 
  in 
    if iters=1 then 
      print_either (hd res)
    else main_loop (iters-1) n
  end

  fun run args =   
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n 
  end
end
