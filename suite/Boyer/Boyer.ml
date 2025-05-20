type id = A | B | C | D | X | Y | Z | U | W 
  | ADD1 | AND | APPEND | CONS | CONSP 
  | DIFFERENCE | DIVIDES | EQUAL | EVEN | EXP 
  | F | FALSE | FOUR | GCD | GREATEREQP | GREATERP 
  | IF | IFF | IMPLIES | LENGTH | LESSEQP | LESSP
  | LISTP | MEMBER | NIL | NILP | NLISTP | NOT
  | ODD | ONE | OR | PLUS | QUOTIENT | REMAINDER 
  | REVERSE | SUB1 | TIMES | TRUE | TWO | ZERO | ZEROP

type term = 
  Var of id
  | Func of id * (term list) * (unit -> (term * term) list)
  | ERROR

let rec term_equal t1 t2 = 
  match (t1,t2) with 
    | (Var id1, Var id2) -> id1=id2
    | (Func(f1,args1,_),Func(f2,args2,_)) ->
      f1=f2 && (term_list_equal args1 args2)
    | _ -> false
and term_list_equal ts1 ts2 = 
  match (ts1,ts2) with 
    | ([],[]) -> true
    | ([],_) -> false
    | (_,[]) -> false
    | (t1::ts1,t2::ts2) -> term_equal t1 t2 && term_list_equal ts1 ts2

let rec boyer_a = Var A
and boyer_b = Var B
and boyer_c = Var C 
and boyer_d = Var D
and boyer_u = Var U 
and boyer_w = Var W 
and boyer_x = Var X 
and boyer_y = Var Y 
and boyer_z = Var Z
and boyer_f a = Func(F,a::[],fun () -> [])
and boyer_true = Func(TRUE,[],fun () -> [])
and boyer_false = Func(FALSE,[], fun() -> [])
and boyer_if_ a b c = Func(IF,a::b::c::[],fun () ->
  (
    boyer_if_
      (boyer_if_ boyer_x boyer_y boyer_z)
      boyer_u boyer_w,
    boyer_if_ boyer_x
      (boyer_if_ boyer_y boyer_u boyer_w)
      (boyer_if_ boyer_z boyer_u boyer_w)
  )::[])
and boyer_implies a b = Func(IMPLIES,a::b::[],fun () ->
  (
    boyer_implies boyer_x boyer_y,
    boyer_if_ 
      boyer_x 
      (boyer_if_ boyer_y boyer_true boyer_false)
      boyer_true
  )::[])
and boyer_not_ a = Func(NOT,a::[],fun () -> 
  (
    boyer_not_ boyer_x,
    boyer_if_ boyer_x boyer_false boyer_true
  )::[])
and boyer_and_ a b = Func(AND,a::b::[],fun () -> 
  (
    boyer_and_ boyer_x boyer_y,
    boyer_if_ boyer_x 
      (boyer_if_ boyer_y boyer_true boyer_false)
      boyer_false
  )::[])
and boyer_or_ a b = Func(OR,a::b::[],fun () -> 
  (
    boyer_or_ boyer_x boyer_y,
    boyer_if_ boyer_x boyer_true 
      (boyer_if_ boyer_y boyer_true boyer_false)
  )::[])
and boyer_zerop a = Func(ZEROP,a::[],fun () ->
  (
    boyer_zerop boyer_x,
    boyer_equal boyer_x boyer_zero
  )::[])
and boyer_zero = Func(ZERO,[],fun () -> [])
and boyer_one  = Func(ONE,[],fun () -> (
  boyer_one, 
  boyer_add1 boyer_zero
  )::[])
and boyer_two = Func(TWO,[],fun () -> 
  (
    boyer_two,boyer_add1 boyer_one
  )::[])
and boyer_four = Func(FOUR,[],fun () -> 
  (
    boyer_four,
    boyer_add1 (boyer_add1 boyer_two)
  )::[])
and boyer_add1 a = Func(ADD1,a::[], fun () -> [])
and boyer_plus a b = Func(PLUS,a::b::[],fun () -> 
  (
    boyer_plus 
      (boyer_plus boyer_x boyer_y)
      boyer_z,
    boyer_plus boyer_x 
      (boyer_plus boyer_y boyer_z)
  )::(
    boyer_plus
      (boyer_remainder boyer_x boyer_y)
      (boyer_times boyer_y 
        (boyer_quotient boyer_x boyer_y)
      ),
    boyer_x
  )::(
    boyer_plus boyer_x (boyer_add1 boyer_y),
    boyer_add1 (boyer_plus boyer_x boyer_y)
  )::[])
and boyer_difference a b = Func(DIFFERENCE,a::b::[], fun() -> 
  (
    boyer_difference boyer_x boyer_x,
    boyer_zero
  )::(
    boyer_difference 
      (boyer_plus boyer_x boyer_y)
      boyer_x,
    boyer_y
  )::(
    boyer_difference 
      (boyer_plus boyer_y boyer_x)
      boyer_x,
    boyer_y
  )::(
    boyer_difference 
      (boyer_plus boyer_x boyer_y)
      (boyer_plus boyer_x boyer_z),
    boyer_difference boyer_y boyer_z  
  )::(
    boyer_difference 
      (boyer_plus boyer_y 
        (boyer_plus boyer_x boyer_z))
      boyer_x,
      boyer_plus boyer_y boyer_z
  )::(
    boyer_difference 
      (boyer_add1 (boyer_plus boyer_y boyer_z))
      boyer_z,
    boyer_add1 boyer_y
  )::(
    boyer_difference (boyer_add1 (boyer_add1 boyer_x))
    boyer_two,
    boyer_x
  )::[])
and boyer_times a b = Func(TIMES,a::b::[], fun () -> 
  (
    boyer_times boyer_x 
      (boyer_plus boyer_y boyer_z),
    boyer_plus
      (boyer_times boyer_x boyer_y)
      (boyer_times boyer_x boyer_z)
  )::(
    boyer_times 
      (boyer_times boyer_x boyer_y) boyer_z,
    boyer_times boyer_x 
      (boyer_times boyer_y boyer_z)
  )::(
    boyer_times boyer_x 
      (boyer_difference boyer_y boyer_z),
    boyer_difference
      (boyer_times boyer_y boyer_x)
      (boyer_times boyer_z boyer_x)
  )::(
    boyer_times boyer_x (boyer_add1 boyer_y),
    boyer_plus boyer_x 
      (boyer_times boyer_x boyer_y)
  )::[])
and boyer_quotient a b = Func(QUOTIENT,a::b::[],fun() -> 
  (
    boyer_quotient
      (boyer_plus boyer_x (boyer_plus boyer_x boyer_y))
      boyer_two,
    boyer_plus boyer_x 
      (boyer_quotient boyer_y boyer_two)
  )::[])
and boyer_remainder a b = Func(REMAINDER,a::b::[],fun() -> 
  (
    boyer_remainder boyer_x boyer_one,
    boyer_zero
  )::(
    boyer_remainder boyer_x boyer_x,
    boyer_zero
  )::(
    boyer_remainder 
      (boyer_times boyer_x boyer_y)
      boyer_x,
    boyer_zero
  )::(
    boyer_remainder 
      (boyer_times boyer_x boyer_y)
      boyer_y,
    boyer_zero
  )::[])
and boyer_equal a b = Func(EQUAL,a::b::[],fun () -> 
  (
    boyer_equal
      (boyer_plus boyer_x boyer_y)
      boyer_zero,
    boyer_and_ 
      (boyer_zerop boyer_x)
      (boyer_zerop boyer_y)
  )::( 
    boyer_equal 
      (boyer_plus boyer_x boyer_y)
      (boyer_plus boyer_x boyer_z),
    boyer_equal boyer_y boyer_z
  )::(
    boyer_equal boyer_zero
      (boyer_difference boyer_x boyer_y),
    boyer_not_ (boyer_lessp boyer_y boyer_x)
  )::(
    boyer_equal boyer_x
      (boyer_difference boyer_x boyer_y),
    boyer_not_ (boyer_lessp boyer_y boyer_x)
  )::(
    boyer_equal
      (boyer_times boyer_x boyer_y)
      boyer_zero,
    boyer_or_
      (boyer_zerop boyer_x)
      (boyer_zerop boyer_y)
  )::(
    boyer_equal
      (boyer_append_ boyer_x boyer_y)
      (boyer_append_ boyer_x boyer_z),
    boyer_equal boyer_y boyer_z
  )::(
    boyer_equal boyer_y
      (boyer_times boyer_x boyer_y),
    boyer_or_
      (boyer_equal boyer_y boyer_zero)
      (boyer_equal boyer_x boyer_one)
  )::(
    boyer_equal boyer_x
      (boyer_times boyer_x boyer_y),
    boyer_or_
      (boyer_equal boyer_x boyer_zero)
      (boyer_equal boyer_y boyer_one)
  )::(
    boyer_equal
      (boyer_times boyer_x boyer_y)
      boyer_one,
    boyer_and_
      (boyer_equal boyer_x boyer_one)
      (boyer_equal boyer_y boyer_one)
  )::(
    boyer_equal
      (boyer_difference boyer_x boyer_y)
      (boyer_difference boyer_z boyer_y),
    boyer_if_
      (boyer_lessp boyer_x boyer_y)
      (boyer_not_ (boyer_lessp boyer_y boyer_z))
      (boyer_equal boyer_x boyer_z)
  )::(
    boyer_equal
      (boyer_lessp boyer_x boyer_y)
      boyer_z,
    boyer_if_
      (boyer_lessp boyer_x boyer_y) 
      (boyer_equal boyer_true boyer_z) 
      (boyer_equal boyer_false boyer_z)
  )::[])
and boyer_lessp a b = Func(LESSP,a::b::[],fun () ->
  (
    boyer_lessp 
      (boyer_remainder boyer_x boyer_y)
      boyer_y,
    boyer_not_ (boyer_zerop boyer_y)
  )::[])
and boyer_nil = Func(NIL,[],fun () -> [])
and boyer_cons a b  = Func(CONS,a::b::[],fun () -> [])
and boyer_member a b = Func(MEMBER,a::b::[],fun () ->
  (
    boyer_member boyer_x
      (boyer_append_ boyer_y boyer_z),
    boyer_or_
      (boyer_member boyer_x boyer_y)
      (boyer_member boyer_x boyer_z)
  )::(
    boyer_member boyer_x 
      (boyer_reverse_ boyer_y),
    boyer_member boyer_x boyer_y
  )::[])
and boyer_length_ a = Func(LENGTH,a::[],fun () -> 
  (
    boyer_length_ (boyer_reverse_ boyer_x),
    boyer_length_ boyer_x
  )::(
    boyer_length_
      (boyer_cons boyer_x 
        (boyer_cons boyer_y 
          (boyer_cons boyer_z 
            (boyer_cons boyer_u boyer_w)))),
    boyer_plus boyer_four (boyer_length_ boyer_w)
  )::[])
and boyer_reverse_ a = Func(REVERSE,a::[],fun () -> 
  (
    boyer_reverse_ (boyer_append_ boyer_x boyer_y),
    boyer_append_ (boyer_reverse_ boyer_y) (boyer_reverse_ boyer_x)
  )::[])
and boyer_append_ a b = Func(APPEND,a::b::[],fun () -> 
  (
    boyer_append_ 
      (boyer_append_ boyer_x boyer_y)
      boyer_z,
    boyer_append_ boyer_x
      (boyer_append_ boyer_y boyer_z)
  )::[])

let rec find vid ls = 
  match ls with
    | [] -> (false,ERROR)
    | (vid2,val2)::bs -> 
        if vid=vid2 then (true,val2) else find vid bs

let rec apply_subst subst t =
  match t with 
    | Var vid -> 
        (match (find vid subst) with 
          | (true,value) -> value
          | (false,_) -> Var vid)
    | Func(f,args,ls) -> 
        Func(
          f, 
          (List.map (fun x -> apply_subst subst x) args),
          ls)
    | ERROR -> ERROR

let rec one_way_unify term1 term2 = 
  one_way_unify1 term1 term2 []
and one_way_unify1 term1 term2 subst = 
  match term2 with 
    | Var vid2 -> 
        (match (find vid2 subst) with 
        | (true,v2) -> (term_equal term1 v2,subst)
        | (false,v2) -> (true,(vid2,term1)::subst))
    | Func(f2,as2,l2) -> 
        (match term1 with
          | Var vid1 -> (false,[])
          | Func(f1,as1,l1) -> 
              if f1=f2 then
                one_way_unify1_lst as1 as2 subst 
              else (false,[])
          | ERROR -> (false,[]))
    | ERROR -> (false,[])
and one_way_unify1_lst tts1 tts2 subst = 
  match (tts1,tts2) with 
  | ([],[]) -> (true,subst)
  | ([],_) -> (false,[])
  | (_,[]) -> (false,[])
  | (t1::ts1,t2::ts2) -> 
      let (hd_ok,subst_) = one_way_unify1 t1 t2 subst in 
      let (tl_ok,subst__) = one_way_unify1_lst ts1 ts2 subst_ in 
      (hd_ok && tl_ok, subst__)

let rec rewrite t =
  match t with 
    | Var v -> Var v
    | Func(f,args,lemmas) -> 
        rewrite_with_lemmas 
          (Func(f, 
            (List.map (fun x -> rewrite x) args),
            lemmas)) 
          (lemmas ())
    | ERROR -> ERROR
and rewrite_with_lemmas term lss =
  rewrite_with_lemmas_helper term lss
and rewrite_with_lemmas_helper term lss = 
  match lss with 
    | [] -> term
    | (lhs,rhs)::ls -> 
        let (unified,subst) = one_way_unify term lhs in 
        if unified then 
          rewrite (apply_subst subst rhs)
        else 
          rewrite_with_lemmas_helper term ls



let truep x l = 
  Option.is_some (List.find_opt (fun t -> term_equal x t) l) 
  || 
  match x with 
    | Func(TRUE,_,_) -> true
    | _ -> false 

let falsep x l = 
  Option.is_some (List.find_opt (fun t -> term_equal x t) l) 
  || 
  match x with 
    | Func(FALSE,_,_) -> true
    | _ -> false 

let rec tautologyp x true_lst false_lst = 
  if truep x true_lst then true 
  else if falsep x false_lst then false 
  else match x with 
    | Func(IF,cond::t::e::nil,lemmas) -> 
        if truep cond true_lst then
          tautologyp t true_lst false_lst
        else if falsep cond false_lst then 
          tautologyp e true_lst false_lst
        else 
          (tautologyp t (cond::true_lst) false_lst)
          && 
          (tautologyp e true_lst (cond::false_lst))
    | _ -> false 

let tautp x = 
  tautologyp (rewrite x) [] []

let boyer_theorem xxxx = 
  boyer_implies 
    (boyer_and_ 
      (boyer_implies xxxx boyer_y)
      (boyer_and_ 
        (boyer_implies boyer_y boyer_z)
        (boyer_and_ 
          (boyer_implies boyer_z boyer_u)
          (boyer_implies boyer_u boyer_w)
        )
      )
    )
    (boyer_implies boyer_x boyer_w)
  

let boyer_subst0 = 
  (X,boyer_f 
    (boyer_plus 
      (boyer_plus boyer_a boyer_b)
      (boyer_plus boyer_c boyer_zero)
    )
  )::
  (Y,boyer_f 
    (boyer_times
      (boyer_times boyer_a boyer_b)
      (boyer_plus boyer_c boyer_d)
    )
  )::
  (Z, boyer_f 
    (boyer_reverse_
      (boyer_append_
        (boyer_append_ boyer_a boyer_b)
        boyer_nil
      )
    )
  )::
  (U, boyer_equal
    (boyer_plus boyer_a boyer_b)
    (boyer_difference boyer_x boyer_y)
  )::
  (W, boyer_lessp
    (boyer_remainder boyer_a boyer_b)
    (boyer_member boyer_a (boyer_length_ boyer_b))
  )::[]
    
let test0 xxxx = 
  tautp (apply_subst boyer_subst0 (boyer_theorem xxxx))

let rec replicate_term n t = 
  if n=0 then []
  else t :: (replicate_term (n-1) t)

let test_boyer_nofib n = 
  List.for_all test0 (replicate_term n (Var X))

let rec main_loop iters n = 
  let res = test_boyer_nofib n in
  if iters = 1 then
    if res then print_endline "1" else print_endline "0"
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n 
