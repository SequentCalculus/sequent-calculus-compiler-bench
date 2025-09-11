structure Cryptarithm1 = struct
  fun first l = 
    case l of 
         ((i::_)::_)::_ => i
       | _ => ~1

  fun append l1 l2 = 
    case l1 of 
         nil => l2
       | a::as_ => a::(append as_ l2)

  fun take n l = 
    case l of 
         nil => nil
       | i::iss => if n <= 0 then nil else i::(take (n-1) iss)

  fun filter_list ls f = 
    case ls of 
         nil => nil
       | x::xs => if f x then x::(filter_list xs f) else filter_list xs f

  fun map_list ls f = 
    case ls of 
         nil => nil
       | x::xs => (f x) :: (map_list xs f)

  fun expand a b c d e f =
    f + (10*e) + (100*d) + (1000*c) + (10000*b) + (100000*a)

  fun enum_from_to from to =
    if to >= from
    then from::(enum_from_to (from+1) to)
    else nil

  fun condition thirywelvn =
    case thirywelvn of
         (t::h::i::r::y::w::e::l::v::n::nil) =>
         ((expand t h i r t y) + (5*(expand t w e l v e)))
         = (expand n i n e t y)
       | _ => false

  fun push_k p1 k =
    case p1 of
         nil => nil
       | h1::t1 => (k::h1)::(push_k t1 k)

  fun addj j ls =
    case ls of
         nil => (j::nil)::nil
       | k::ks => (j::k::ks)::(push_k (addj j ks) k)

  fun addj_ls p1 j =
    case p1 of
         nil => nil
       | pjs::t1 => append (addj j pjs) (addj_ls t1 j)

  fun permutations ls =
    case ls of
         nil => nil::nil
       | j::js => addj_ls (permutations js) j

  fun test_cryptarithm_nofib n =
    map_list (enum_from_to 1 n) (fn i =>
    let val p0 = take 10 (enum_from_to 0 (9+i))
    in
      filter_list (permutations p0) (fn l => condition l)
    end) 

  fun main_loop iters n =
  let val res = test_cryptarithm_nofib n
    in
      if iters=1
      then print (Int.toString (first res) ^ "\n")
      else main_loop (iters-1) n
    end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in
    main_loop iters n
  end
end

