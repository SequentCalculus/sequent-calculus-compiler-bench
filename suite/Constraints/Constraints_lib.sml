structure Constraints = struct 
  datatype assign = Assign of int * int

  datatype csp = CSP of int * int * ((assign * assign) -> bool)

  datatype ConflictSet = Known of int list 
                       | Unknown

  datatype 'a tree  = Node of 'a * 'a tree list 

  fun value a = 
    case a of Assign(_,value) => value

  fun level a = 
    case a of Assign(varr,_) => varr

  fun label t = 
    case t of Node (a,_) => a

  fun map_list ls f = 
    case ls of 
         nil => nil
       | x::xs => (f x)::(map_list xs f)

  fun all_list ls p = 
    case ls of 
         nil => true
       | x::xs => if (p x) then all_list xs p else false

  fun filter_list ls f = 
    case ls of 
        nil => nil
       | h::t => if (f h) then h::(filter_list t f) else filter_list t f



  fun is_empty ls = 
    case ls of 
         nil => true
       | _::_ => false

  fun enum_from_to from to = 
    if from<=to then from::(enum_from_to (from+1) to) else nil

  fun zip_with f x y = 
    case (x,y) of 
         (nil,_) => nil
       | (_,nil) => nil
       | (c::cs,p::ps) => (f (c,p))::(zip_with f cs ps)

  fun len ls = 
    case ls of 
         nil => 0
       | _::xs => 1 + (len xs)

  fun head ls = 
    case ls of 
         nil => raise Fail "empty List"
       | a::_ => a

  fun tail ls = 
    case ls of 
         nil => raise Fail "empty List"
       | _::xs => xs

  fun at_index ind ls = 
    case ls of 
         nil => raise Fail "empty list"
       | c::cs => if ind = 0 then c else at_index (ind - 1) cs

  fun rev_loop ls acc = 
    case ls of 
         nil => acc
       | p::ps => rev_loop ps (p::acc)

  fun reverse ls = rev_loop ls nil

  fun concat_loop ls acc = 
    case ls of 
         nil => (rev_loop acc nil)
       | l::ls => concat_loop ls (rev_loop l acc)

  fun concat lss = concat_loop lss nil

  fun append l1 l2 = 
    case l1 of 
         nil => l2
        | x::xs => x::(append xs l2)

  fun fold_list xs acc f = 
    case xs of 
         nil => acc
       | h::t => fold_list t (f acc h) f

  fun in_list i ls = 
    case ls of 
         nil => false
       | j::js => if i=j then true else in_list i js

  fun not_elem a ls = not (in_list a ls)

  fun map_tree f n = 
    case n of Node (l,ls) => 
      Node(f l, map_list ls (fn x => map_tree f x))

  fun fold_tree f t = 
    case t of Node(l,c) => 
      f (l,(map_list c (fn x => fold_tree f x) ))

  fun filter_tree p n = 
  let val f = fn (a,cs) => 
  Node(a,filter_list cs (fn x => p(label(x))) )
  in 
    fold_tree f n
  end

  fun leaves n = 
    case n of 
         Node(leaf,nil) => leaf::nil
       | Node(leaf,cs) => concat (map_list cs (fn x => leaves(x)) ) 

  fun prune f n = filter_tree (fn x => not (f x)) n

  fun max_level ls = 
    case ls of 
         nil => 0
       | Assign(v,_)::t => v

  fun complete (CSP (v,vals,rel)) s = max_level(s)=v

  fun delete_by f x ys = 
    case ys of 
         nil => nil
       | y::ys => if f (x,y) then ys else y::(delete_by f x ys)

  fun nub_by f ls = 
    case ls of 
         nil => nil
       | h::t => h::(nub_by f (filter_list t (fn y => not (f (h,y)))))

  fun union_by f l1 l2 = 
    append l1 (fold_list (nub_by f l2) l1 (fn acc => fn y => delete_by f y acc))

  fun union l1 l2 = union_by (fn (x,y) => x=y) l1 l2

  fun combine ls acc = 
    case ls of 
         nil => acc
       | ((s,Known(cs))::css) => 
           let val maxl = max_level(s)
           in 
             if not_elem (max_level s) cs then
               cs
             else combine css (union cs acc)
            end
       | ((s,Unknown)::_) => acc


  fun init_tree f x = 
    Node(x,map_list (f x) (fn y => init_tree f y))

  fun to_assign ls ss = 
    case ls of 
         nil => nil
       | j::t1 => 
           (Assign((max_level ss) +1,j)::ss)::(to_assign t1 ss)

  fun mk_tree (CSP (vars,vals,rel)) = 
  let val next = fn ss => 
  if max_level(ss) < vars 
  then to_assign (enum_from_to 1 vals) ss
  else nil
           in
             init_tree next nil
           end

  fun collect ls = 
    case ls of 
         nil => nil
       | Known(cs)::css => union cs (collect css)
       | Unknown::_ => nil

  fun known_solution c = 
    case c of 
         Known nil => true
       | Known (v::vs) => false
       | Unknown => false

  fun known_conflict c = 
    case c of 
         Known nil => false 
       | Known (_::_) => true
       | Unknown => false


  fun filter_known ls = 
    case ls of 
         nil => nil
        | vs::t1 => if (all_list vs known_conflict) then
          vs::(filter_known t1) 
        else 
          filter_known t1

  fun domain_wipeout (CSP (vars,vals,rel)) t = 
    let val f8 = fn ((as_,cs),tbl) => 
    let val wiped_domains = filter_known tbl
    val cs_ = 
      if is_empty wiped_domains 
      then cs 
      else Known(collect (head wiped_domains))
  in 
    (as_,cs_)
  end
  in
    map_tree f8 t
  end 

  fun check_complete csp s = 
    if complete csp s then Known(nil) else Unknown

  fun earliest_inconsistency (CSP (vars,vals,rel)) aas = 
    case aas of 
         nil => NONE
       | a::as_ => 
           (case filter_list (rev as_) (fn x => not (rel(a,x))) of
                 nil => NONE
               | b::bs_ => SOME (level a, level b))

  fun lookup_cache csp t = 
  let val f5  = fn (csp,(ls,tbl)) => 
  case ls of 
       nil => ((nil,Unknown),tbl)
     | a::as_ => 
         let val table_entry  = at_index ((value a)-1) (head tbl)
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

  fun to_pairs ls varrr = 
    case ls of 
         nil => nil
       | valll::t2 => (varrr,valll)::(to_pairs t2 varrr)

  fun n_pairs ls n = 
    case ls of 
         nil => nil
       | varrr::t1 => 
           (to_pairs (enum_from_to 1 n) varrr) 
           :: (n_pairs t1 n)


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
    (n_pairs (enum_from_to (var_+1) vars) vals)
  end


  fun cache_checks csp tbl n = 
    case n of 
         Node(s,cs) => 
         Node((s,tbl), 
         map_list cs (fn x => cache_checks csp (fill_table s csp (tail tbl)) x) )


  fun n_unknown ls vals = 
    case ls of 
         nil => nil
       | (n::t1) => 
           (to_unknown (enum_from_to 1 vals)) 
           :: (n_unknown t1 vals)
  and to_unknown ls = 
  case ls of 
       nil => nil
     | (_::t2) => Unknown::(to_unknown t2)

  fun empty_table (CSP (vars,vals,rel)) = 
    nil::(n_unknown (enum_from_to 1 vars) vals)

  fun search labeler csp = 
    map_list (filter_list  
    (leaves (
    prune (fn (_,x) => known_conflict x) 
    (labeler csp (mk_tree csp))
    )) (fn (_,x) => known_solution x)
    ) (fn (x,_) => x)

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
         Node ((a,Known (combine (map_list chs (fn x => label(x)) ) nil)), chs)
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
         Known (combine (map_list chs (fn x => label(x)) ) nil)
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
    len (search algorithm (queens n))

  fun test_constraints_nofib n = 
    map_list [bt,bm,bjbt,bjbt_,fc] (fn x => try_ n x)

  fun main_loop iters n = 
  let val res = test_constraints_nofib n 
  in 
    if iters=1 then print ((Int.toString (head res)) ^ "\n")
    else main_loop (iters-1) n
  end

  fun run args =   
  let val iters = valOf (Int.fromString (head args))
    val n = valOf (Int.fromString (head (tail args)))
  in 
    main_loop iters n
  end
end
