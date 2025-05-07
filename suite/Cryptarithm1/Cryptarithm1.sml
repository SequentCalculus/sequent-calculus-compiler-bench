fun enum_from_to from to = 
  if from <= to
  then from::(enum_from_to (from+1) to)
  else nil

fun expand a b c d e f = 
  f + (10*e) + (100*d) + (1000*c) + (10000*b) + (100000*a)

fun condition thirywelvn = 
  case thirywelvn of 
       (t::h::i::r::y::w::e::l::v::n::nil) => 
        ((expand t h i r t y) + (5*(expand t w e l v e))) 
        = (expand n i n e t y)
     | _ => false

fun addj j ls = 
  case ls of 
       nil => (j::nil)::nil
     | k::ks => (j::k::ks)::(map (fn h1 => k::h1) (addj j ks))

fun perm_lscomp1 p1 j = 
  case p1 of 
       nil => nil
     | pjs::t1 => perm_lscomp2 (addj j pjs) t1 j
and perm_lscomp2 p2 t1 j = 
  case p2 of 
       nil => perm_lscomp1 t1 j 
     | r::t2 => r::(perm_lscomp2 t2 t1 j)

fun permutations ls = 
  case ls of 
       nil => nil::nil
     | j::js => perm_lscomp1 (permutations js) j

fun test_cryptarithm_nofib n = 
  map (fn i => 
    let val p0 = List.take ((enum_from_to 0 (9+i)), 10)
    in 
      List.filter (fn l => condition l) (permutations p0)
    end) (enum_from_to 1 n)

fun main_loop iters n = 
  let val res = test_cryptarithm_nofib n 
  in 
    if iters=1 
    then print ((Int.toString (hd (hd (hd res)))) ^ "\n")
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
