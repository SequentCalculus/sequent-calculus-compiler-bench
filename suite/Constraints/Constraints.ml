exception EmptyList

type assign = Assign of int * int 

type csp = CSP of int * int * ((assign * assign) -> bool)

type 'a tree = Node of 'a * 'a tree list

type conflict_set = 
  | Known of int list 
  | Unknown

let value (Assign(_,value)) = value
let level (Assign(varr,_)) = varr

let label (Node(a,_)) = a

let rec map_list f ls = 
  match ls with
    | [] -> []
    | x::xs -> (f x)::(map_list f xs)

let rec all_list f ls = 
  match ls with 
    | [] -> true
    | x::xs -> (f x) && (all_list f xs)

let rec filter_list f ls = 
  match ls with 
    | [] -> []
    | x::xs -> if f x then x::(filter_list f xs) else filter_list f xs

let is_empty ls = 
  match ls with
    | [] -> true
    | _ -> false

let rec enum_from_to from to_ = 
  if from<=to_ then 
    from::(enum_from_to (from+1) to_)
  else []

let rec zip_with f x y = 
  match (x,y) with 
    | ([],_) -> []
    | (_,[]) -> []
    | (c::cs,p::ps) -> f(c,p) :: zip_with f cs ps

let rec len ls = 
  match ls with 
    | [] -> 0
    | _::xs -> 1 + (len xs)

let head ls = 
  match ls with 
    | [] -> raise EmptyList
    | x::_ -> x

let tail ls = 
  match ls with 
    | [] -> raise EmptyList
    | _::xs -> xs

let rec at_index ls ind = 
  match ls with 
    | [] -> raise EmptyList
    | x::xs -> if ind == 0 then x else at_index xs (ind-1)

let rec rev_loop ls acc = 
  match ls with 
    | [] -> acc
    | p::ps -> rev_loop ps (p::acc)

let reverse ls = rev_loop ls []

let rec concat_loop ls acc = 
  match ls with 
    | [] -> rev_loop acc []
    | l::ls -> concat_loop ls (rev_loop l acc)

let concat lss = concat_loop lss []

let rec append l1 l2 = 
  match l1 with 
    | [] -> l2
    | a::as_ -> a::(append as_ l2)

let rec foldl xs acc f = 
  match xs with 
    | [] -> acc
    | h::t -> foldl t (f acc h) f

let rec in_list i ls = 
  match ls with 
    | [] -> false
    | j::js -> if i == j then true else in_list i js

let not_elem a ls = not (in_list a ls)

let rec map_tree f (Node(l,ls)) = 
  Node(f l,map_list (fun x -> map_tree f x) ls)

let rec fold_tree f (Node(l,c)) = 
  f (l,map_list (fun x -> fold_tree f x) c)

let rec filter_tree p n =
  let f = fun (a,cs) ->
    Node(a,filter_list (fun x -> p (label x)) cs)
  in 
  fold_tree f n 

let rec leaves n = 
  match n with
    | Node(leaf,[]) -> leaf::[]
    | Node(leaf,cs) -> concat (map_list (fun x -> leaves x) cs)

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
    | h::t -> h::nub_by f (filter_list (fun y -> not (f(h,y))) t)

let union_by f l1 l2 = 
  append l1 
  (foldl
    (nub_by f l2)
    l1
    (fun acc -> fun y -> delete_by f y acc) 
  )

let union l1 l2 = union_by (fun (x,y) -> x=y) l1 l2

let rec combine ls acc = 
  match ls with 
    | [] -> acc
    | ((s,Known cs)::css) -> 
        if not_elem (max_level s) cs then
          cs 
        else 
          combine css (union cs acc)
    | ((s,Unknown)::_) -> acc

let rec init_tree f x = 
  Node(x, map_list (fun y -> init_tree f y) (f x))

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

let rec filter_known ls = 
  match ls with 
    | [] -> []
    | vs::t1 -> if all_list known_conflict vs then 
      vs::(filter_known t1) 
    else 
      filter_known t1

let domain_wipeout csp t = 
  let f8 = fun ((as_,cs),tbl) ->
    let wiped_domains = filter_known tbl in
    let cs_ = 
      if is_empty wiped_domains then cs
      else Known (collect (head wiped_domains))
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
        (match (filter_list (fun x -> not (rel(a,x))) (reverse as_)) with
          | [] -> None
          | b::bs_ -> Some(level a, level b)
        )

let lookup_cache csp t = 
  let f5 = fun (csp, (ls,tbl)) -> 
    match ls with 
      | [] -> (([],Unknown),tbl)
      | a::as_ -> 
          let table_entry = at_index (head tbl) ((value a)-1) in 
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
    map_list
      (fun x -> 
        cache_checks csp 
          (fill_table s csp (tail tbl)) 
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
  map_list (fun (x,_) -> x)
    (filter_list (fun (_,x) -> known_solution x)
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
          Node ((a,Known (combine (map_list (fun x -> label(x)) chs) [])), chs) 
  in
  fold_tree f6 t 

let bjbt csp t = bj csp (bt csp t)

let bj_ csp t = 
  let f6 = fun ((a,conf),chs) ->
    match conf with
      | Known cs -> Node ((a,Known cs),chs)
      | Unknown -> 
          let cs_ = Known (combine (map_list (fun x -> label x) chs) []) in 
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
  len (search algorithm (queens n))

let test_constraints_nofib n = 
  map_list (fun x -> try_ n x) (bt::bm::bjbt::bjbt_::fc::[])

let rec main_loop iters n = 
  let res = test_constraints_nofib n in 
  if iters = 1 then
    print_endline (string_of_int (head res))
  else main_loop (iters-1) n 

let main = 
  let iters = int_of_string Sys.argv.(1) in 
  let n = int_of_string Sys.argv.(2) in 
  main_loop iters n
