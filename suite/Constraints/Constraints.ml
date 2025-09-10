type assign = Assign of int * int 

type csp = CSP of int * int * ((assign * assign) -> bool)

type 'a tree = Node of 'a * 'a tree list

type conflict_set = 
  | Known of int list 
  | Unknown

let value (Assign(_,value)) = value
let level (Assign(varr,_)) = varr

let label (Node(a,_)) = a

let rec enum_from_to from to_ = 
  if from<=to_ then 
    from::(enum_from_to (from+1) to_)
  else []

let rec zip_with f x y = 
  match (x,y) with 
    | ([],_) -> []
    | (_,[]) -> []
    | (c::cs,p::ps) -> f(c,p) :: zip_with f cs ps

let rec map_tree f (Node(l,ls)) = 
  Node(f l,List.map (fun x -> map_tree f x) ls)

let rec fold_tree f (Node(l,c)) = 
  f (l,List.map (fun x -> fold_tree f x) c)

let rec filter_tree p n =
  let f = fun (a,cs) ->
    Node(a,List.filter (fun x -> p (label x)) cs)
  in 
  fold_tree f n 

let rec leaves n = 
  match n with
    | Node(leaf,[]) -> leaf::[]
    | Node(leaf,cs) -> List.concat (List.map (fun x -> leaves x) cs)

let prune f n = 
  filter_tree (fun x -> not (f x)) n

let max_level ls = 
  match ls with 
    | [] -> 0
    | Assign(v,_)::_ -> v

let complete (CSP (v,_,_)) s = max_level s = v

let rec delete_by f x ys = 
  match ys with 
    | [] -> []
    | y::ys -> 
        if (f (x,y)) then ys
        else y::delete_by f x ys

let rec nub_by f l = 
  match l with 
    | [] -> []
    | h::t -> h::nub_by f (List.filter (fun y -> not (f(h,y))) t)

let union_by f l1 l2 = 
  List.append l1 
  (List.fold_left
    (fun acc -> fun y -> delete_by f y acc) 
    (nub_by f l2)
    l1
  )


let union l1 l2 = union_by (fun (x,y) -> x=y) l1 l2

let rec combine ls acc = 
  match ls with 
    | [] -> acc
    | ((s,Known cs)::css) -> 
        let maxl = max_level s in 
        if not (Option.is_some (List.find_opt (fun x -> x=maxl) cs)) 
        then cs 
        else combine css (union cs acc)
    | ((s,Unknown)::_) -> acc

let rec init_tree f x = 
  Node(x, List.map (fun y -> init_tree f y) (f x))

let rec to_assign ls ss = 
  match ls with 
    | [] -> [] 
    | j::t1 -> (Assign((max_level ss) +1,j)::ss)::(to_assign t1 ss)


let mk_tree (CSP(vars,vals,_)) = 
  let next = fun ss -> 
    if max_level ss < vars then
      to_assign (enum_from_to 1 vals) ss
    else []
  in 
  init_tree next []


let rec collect ls = 
  match ls with 
    | [] -> []
    | Known cs :: css -> union cs (collect css)
    | Unknown :: _ -> []

let known_solution c = 
  match c with 
    | Known [] -> true
    | Known (_::_) -> false 
    | Unknown -> false

let known_conflict c = 
  match c with 
    | Known [] -> false 
    | Known (_::_) -> true
    | Unknown -> false


let domain_wipeout csp t = 
  let f8 = fun ((as_,cs),tbl) ->
    let wiped_domains = List.filter (fun x -> List.for_all known_conflict x) tbl in 
    let cs_ = 
      if List.is_empty wiped_domains then cs
      else Known (collect (List.hd wiped_domains))
    in 
    (as_,cs_)
  in 
  map_tree f8 t 

let check_complete csp s = 
  if complete csp s then Known [] else Unknown

let earliest_inconsistency (CSP(_,_,rel)) aas = 
  match aas with 
    | [] -> None
    | a::as_ -> 
        (match (List.filter (fun x -> not (rel(a,x))) (List.rev as_)) with
          | [] -> None
          | b::bs_ -> Some(level a, level b)
        )

let lookup_cache csp t = 
  let f5 = fun (csp, (ls,tbl)) -> 
    match ls with 
      | [] -> (([],Unknown),tbl)
      | a::as_ -> 
          let table_entry = List.nth (List.hd tbl) ((value a)-1) in 
          let cs = (
            match table_entry with 
              | Unknown -> check_complete csp (a::as_)
              | Known vals -> table_entry)
          in 
          ((a::as_,cs),tbl)
  in 
  map_tree (fun x -> f5 (csp,x)) t

let rec to_pairs ls varrr = 
  match ls with 
    | [] -> []
    | valll::t2 -> (varrr,valll) :: (to_pairs t2 varrr)


let rec n_pairs ls vals = 
  match ls with 
    | [] -> []
    | varrr::t1 -> 
        (to_pairs (enum_from_to 1 vals) varrr)::(n_pairs t1 vals)


let fill_table s (CSP(vars,vals,rel)) tbl = 
  match s with 
    | [] -> tbl
    | Assign (var_,val_)::as__ -> 
        let f4 = fun (cs,(varr,vall)) -> 
          (match cs with 
            | Known vs -> cs
            | Unknown -> 
                if not (rel (Assign(var_,val_),Assign(varr,vall))) 
                then Known (var_::varr::[])
                else cs)
        in 
        zip_with 
          (fun (x,y) -> zip_with f4 x y)
          tbl
          (n_pairs (enum_from_to (var_+1) vars) vals)

let rec cache_checks csp tbl (Node (s,cs)) = 
  Node ((s,tbl),
    List.map 
      (fun x -> 
        cache_checks csp 
          (fill_table s csp (List.tl tbl)) 
        x) 
      cs)

let rec n_unknown ls n = 
  match ls with 
    | [] -> []
    | _::t1 -> 
        (to_unknown (enum_from_to 1 n)) 
        :: (n_unknown t1 n) 
and to_unknown ls = 
  match ls with
    | [] -> []
    | _::t2 -> Unknown::(to_unknown t2)
and empty_table (CSP(vars,vals,_)) = 
  []::(n_unknown (enum_from_to 1 vars) vals)

let search labeler csp = 
  List.map (fun (x,_) -> x)
    (List.filter (fun (_,x) -> known_solution x)
      (leaves 
        (prune (fun (_,x) -> known_conflict x)
          (labeler csp (mk_tree csp))
        )
      )
    )

let safe (Assign (i,m)) (Assign (j,n)) = 
  (not (m=n)) && (not ((abs (i-j)) = (abs (m-n))))

let queens n = CSP (n,n,fun (x,y) -> safe x y)

let bt csp t = 
  let f3 = fun s -> 
    match earliest_inconsistency csp s with 
      | Some (a,b) -> (s,Known (a::b::[]))
      | None -> (s,check_complete csp s)
  in 
  map_tree f3 t 

let bm csp t = 
  map_tree (fun (x,_) -> x)
    (lookup_cache csp 
      (cache_checks csp (empty_table csp) t))

let bj csp t = 
  let f6 = fun ((a,conf),chs) -> 
    match conf with 
      | Known cs -> Node((a,Known cs),chs)
      | Unknown -> 
          Node ((a,Known (combine (List.map (fun x -> label(x)) chs) [])), chs) 
  in
  fold_tree f6 t 

let bjbt csp t = bj csp (bt csp t)

let bj_ csp t = 
  let f6 = fun ((a,conf),chs) ->
    match conf with
      | Known cs -> Node ((a,Known cs),chs)
      | Unknown -> 
          let cs_ = Known (combine (List.map (fun x -> label x) chs) []) in 
          if known_conflict cs_ then 
            Node ((a,cs_),[])
          else Node((a,cs_),chs) in 
  fold_tree f6 t 

let bjbt_ csp t = bj_ csp (bt csp t)

let fc csp t = 
  domain_wipeout csp 
    (lookup_cache csp 
      (cache_checks csp (empty_table csp) t))

let try_ n algorithm = 
  List.length (search algorithm (queens n))

let test_constraints_nofib n = 
  List.map (fun x -> try_ n x) (bt::bm::bjbt::bjbt_::fc::[])

let rec main_loop iters n = 
  let res = test_constraints_nofib n in 
  if iters = 1 then
    print_endline (string_of_int (List.hd res))
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n
