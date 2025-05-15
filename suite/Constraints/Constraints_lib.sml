structure Constraints = struct 
  datatype ConflictSet = Known of int list 
                       | Unknown

  datatype assign = Assign of int * int

  datatype csp = CSP of int * int * ((assign * assign) -> bool)

  datatype 'a tree  = Node of 'a * 'a tree list 

  fun value a = 
    case a of Assign(_,value) => value

  fun level a = 
    case a of Assign(varr,_) => varr

  fun label t = 
    case t of Node (a,_) => a

  fun map_tree f n = 
    case n of Node (l,ls) => 
      Node(f l, map (fn x => map_tree f x) ls)

  fun fold_tree f t = 
    case t of Node(l,c) => 
      f (l,(map (fn x => fold_tree f x) c))

  fun filter_tree p n = 
  let val f = fn (a,cs) => 
  Node(a,List.filter (fn x => p(label(x))) cs)
  in 
    fold_tree f n
  end

  fun prune f n = filter_tree (fn x => not (f x)) n

  fun leaves n = 
    case n of 
         Node(leaf,nil) => leaf::nil
       | Node(leaf,cs) => List.concat (map (fn x => leaves(x)) cs) 

  fun enum_from_to from to = 
    if from<=to then from::(enum_from_to (from+1) to) else nil

  fun max_level ls = 
    case ls of 
         nil => 0
       | Assign(v,_)::t => v

  fun nub_by f ls = 
    case ls of 
         nil => nil
       | h::t => h::(nub_by f (List.filter (fn y => not (f (h,y))) t))

  fun delete_by f x ys = 
    case ys of 
         nil => nil
       | y::ys => if f (x,y) then ys else y::(delete_by f x ys)

  fun union_by f l1 l2 = 
    l1 @ (foldl (fn (y,acc) => delete_by f y acc) (nub_by f l2) l1)

  fun union l1 l2 = union_by (fn (x,y) => x=y) l1 l2

  fun zip_with f x y = 
    case (x,y) of 
         (nil,_) => nil
       | (_,nil) => nil
       | (c::cs,p::ps) => (f (c,p))::(zip_with f cs ps)

  fun combine ls acc = 
    case ls of 
         nil => acc
       | ((s,Known(cs))::css) => 
           let val maxl = max_level(s)
  in 
    if not (Option.isSome (List.find (fn x => x=maxl) cs))
    then cs
    else combine css (union cs acc)
  end
       | ((s,Unknown)::_) => acc

  fun init_tree f x = 
    Node(x,map (fn y => init_tree f y) (f x))

  fun mk_lscomp ls ss = 
    case ls of 
         nil => nil
       | j::t1 => 
           (Assign((max_level ss) +1,j)::ss)::(mk_lscomp t1 ss)

  fun mk_tree (CSP (vars,vals,rel)) = 
  let val next = fn ss => 
  if max_level(ss) < vars 
  then mk_lscomp (enum_from_to 1 vals) ss
  else nil
           in
             init_tree next nil
           end

  fun collect ls = 
    case ls of 
         nil => nil
       | Known(cs)::css => union cs (collect css)
       | Unknown::_ => nil

  fun known_conflict c = 
    case c of 
         Known nil => false 
       | Known (_::_) => true
       | Unknown => false

  fun known_solution c = 
    case c of 
         Known nil => true
       | Known (v::vs) => false
       | Unknown => false

  fun earliest_inconsistency (CSP (vars,vals,rel)) aas = 
    case aas of 
         nil => NONE
       | a::as_ => 
           (case List.filter (fn x => not (rel(a,x))) (rev as_) of
                 nil => NONE
               | b::bs_ => SOME (level a, level b))

  fun wipe_lscomp ls = 
    case ls of 
         nil => nil
       | vs::t1 => 
           if List.all (fn x => known_conflict(x)) vs
           then vs::(wipe_lscomp t1)
           else wipe_lscomp t1

  fun domain_wipeout (CSP (vars,vals,rel)) t = 
  let val f8 = fn ((as_,cs),tbl) => 
  let val wiped_domains = wipe_lscomp tbl
    val cs_ = 
      if null wiped_domains 
      then cs 
      else Known(collect (hd wiped_domains))
  in 
    (as_,cs_)
  end
  in
    map_tree f8 t
  end 

  fun complete (CSP (v,vals,rel)) s = max_level(s)=v

  fun check_complete csp s = 
    if complete csp s then Known(nil) else Unknown


  fun lookup_cache csp t = 
  let val f5  = fn (csp,(ls,tbl)) => 
  case ls of 
       nil => ((nil,Unknown),tbl)
     | a::as_ => 
         let val table_entry  = List.nth ((hd tbl),((value a)-1))
           val cs  =
             (case table_entry of 
                   Unknown => check_complete csp (a::as_)
                 | Known vals => table_entry)
  in 
    ((a::as_,cs),tbl)
  end
         in 
           map_tree (fn x => f5 (csp,x)) t
         end

  fun empty_lscomp1 ls vals = 
    case ls of 
         nil => nil
       | (n::t1) => 
           (empty_lscomp2 (enum_from_to 1 vals)) 
           :: (empty_lscomp1 t1 vals)
  and empty_lscomp2 ls = 
  case ls of 
       nil => nil
     | (_::t2) => Unknown::(empty_lscomp2 t2)
  fun empty_table (CSP (vars,vals,rel)) = 
    nil::(empty_lscomp1 (enum_from_to 1 vars) vals)

  fun fill_lscomp2 ls varrr = 
    case ls of 
         nil => nil
       | valll::t2 => (varrr,valll)::(fill_lscomp2 t2 varrr)

  fun fill_lscomp1 ls vals = 
    case ls of 
         nil => nil
       | varrr::t1 => 
           (fill_lscomp2 (enum_from_to 1 vals) varrr) 
           :: (fill_lscomp1 t1 vals)

  fun fill_table s (CSP (vars,vals,rel)) tbl = 
    case s of 
         nil => tbl
       | Assign (var_,val_)::as__ => 
           let val f4 = fn (cs,(varr,vall)) => 
           case cs of 
                Known vs => cs
              | Unknown => 
                  if not (rel(Assign(var_,val_),Assign(varr,vall)))
                  then Known (var_::varr::nil)
                  else cs
  in
    zip_with 
    (fn (x,y) => zip_with f4 x y)
    tbl 
    (fill_lscomp1 (enum_from_to (var_+1) vars) vals)
  end

  fun cache_checks csp tbl n = 
    case n of 
         Node(s,cs) => 
         Node((s,tbl), 
         map (fn x => cache_checks csp (fill_table s csp (tl tbl)) x) cs)


  fun search labeler csp = 
    map (fn (x,_) => x)
    (List.filter (fn (_,x) => known_solution x) 
    (leaves (
    prune (fn (_,x) => known_conflict x) 
    (labeler csp (mk_tree csp))
    ))
    )

  fun safe (Assign (i,m)) (Assign (j,n)) = 
    (not (m=n)) andalso (not ((abs (i-j)) = (abs(m-n))))

  fun queens n = CSP (n,n,(fn (x,y) => safe x y))

  fun bt csp t = 
  let val f3 = fn s => 
  case earliest_inconsistency csp s of 
       SOME (a,b) => (s,Known (a::b::nil))
     | NONE => (s,check_complete csp s)
           in
             map_tree f3 t 
           end

  fun bm csp t = 
    map_tree (fn (x,_) => x) 
    (lookup_cache csp (cache_checks csp (empty_table csp) t))

  fun bj csp t = 
  let val f6 = fn ((a,conf),chs) => 
  case conf of 
       Known(cs) => Node ((a,Known cs),chs)
     | Unknown => 
         Node ((a,Known (combine (map (fn x => label(x)) chs) nil)), chs)
  in
    fold_tree f6 t 
  end

  fun bjbt csp t = bj csp (bt csp t)

  fun bj_ csp t = 
  let val f6 = fn ((a,conf),chs) => 
  case conf of
       Known cs => Node ((a,Known(cs)), chs)
     | Unknown => 
         let val cs_ = 
         Known (combine (map (fn x => label(x)) chs) nil)
  in
    if known_conflict cs_ 
    then Node ((a,cs_),nil) 
    else Node ((a,cs_),chs)
  end
         in 
           fold_tree f6 t
         end

  fun bjbt_ csp t = bj_ csp (bt csp t)

  fun fc csp t = 
    domain_wipeout csp 
    (lookup_cache csp 
    (cache_checks csp (empty_table csp) t))

  fun try_ n algorithm = 
    length (search algorithm (queens n))

  fun test_constraints_nofib n = 
    map (fn x => try_ n x) [bt,bm,bjbt,bjbt_,fc]

  fun main_loop iters n = 
  let val res = test_constraints_nofib n 
  in 
    if iters=1 then print ((Int.toString (hd res)) ^ "\n")
    else main_loop (iters-1) n
  end

  fun run args =   
  let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n
  end
end
