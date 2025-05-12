datatype ('a, 'b) either = Left of 'a | Right of 'b 


fun enum_from_then_to from th to = 
  if from<=to
  then from::(enum_from_then_to th ((2*th) - from) to)
  else nil

fun bench_lscomp1 ls bstart bstep blim op_ = 
  case ls of 
       nil => nil
     | a::t1 => bench_lscomp2 
       (enum_from_then_to bstart (bstart+bstep) blim) 
       t1 a op_ bstart bstep blim
and bench_lscomp2 ls t1 a op_ bstart bstep blim =
  case ls of 
       nil => nil
     | b::t2 => (op_ (a,b)) 
       :: (bench_lscomp2 t2 t1 a op_ bstart bstep blim)

fun integerbench op_ astart astep alim bstart bstep blim = 
  bench_lscomp1 
    (enum_from_then_to astart (astart+astep) alim)
    bstart bstep blim op_

fun runbench jop iop astart astep alim bstart bstep blim = 
  let val res1 = integerbench iop astart astep alim astart astep alim
  in 
    integerbench jop astart astep alim astart astep alim
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
      runbench z_add (fn (a,b) => Left (a+b)) 
      astart astep alim astart astep alim
    val sub = runbench z_sub (fn (a,b) => Left (a-b))
      astart astep alim astart astep alim
    val mul = runbench z_mul (fn (a,b) => Left (a*b))
      astart astep alim astart astep alim
    val div_ = runbench z_mul (fn (a,b) => Left (a div b))
      astart astep alim astart astep alim
    val mod_ = runbench z_mod (fn (a,b) => Left (a mod b))
      astart astep alim astart astep alim
    val equal = runbench z_equal (fn (a,b) => Left (a mod b))
      astart astep alim astart astep alim
    val lt = runbench z_lt (fn (a,b) => Right (a<b))
      astart astep alim astart astep alim
    val leq = runbench z_leq (fn (a,b) => Right (a<=b))
      astart astep alim astart astep alim
    val gt = runbench z_gt (fn (a,b) => Right (a>b))
      astart astep alim astart astep alim
  in
    runbench z_geq (fn (a,b) => Right (a>=b))
      astart astep alim astart astep alim
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

fun main () =   
  let val args = CommandLine.arguments()
    val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
in 
  main_loop iters n 
end

val _ = main()
