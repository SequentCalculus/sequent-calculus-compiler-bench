structure Cryptarithm1 = struct
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
       | pjs::t1 => (addj j pjs) @ (addj_ls t1 j)

  fun permutations ls =
    case ls of
         nil => nil::nil
       | j::js => addj_ls (permutations js) j

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

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in
    main_loop iters n
  end
end

