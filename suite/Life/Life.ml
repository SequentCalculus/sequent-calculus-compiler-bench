type gen = MkGen of (int*int) list

let member l p = List.exists (fun p1 -> p=p1) l

let accumulate a xs f = List.fold_left f a xs

let revonto x y = accumulate x y (fun t -> fun h -> h::t)

let rec collect_accum sofar xs f =
  match xs with
    | [] -> sofar
    | p::xs -> collect_accum (revonto sofar (f p)) xs f

let collect l f = collect_accum [] l f

let diff x y = List.filter (fun p -> not (member y p)) x

let alive (MkGen livecoords) = livecoords

let neighbors (fst,snd) =
  (fst-1,snd-1) :: (fst-1,snd) :: (fst-1,snd+1)
  :: (fst,snd-1) :: (fst,snd+1)
  :: (fst+1,snd-1) :: (fst+1,snd) :: (fst+1,snd+1) :: []

let twoorthree n = n=2 || n=3

let rec collect_neighbors xover x3 x2 x1 xs =
  match xs with
    | [] -> diff x3 xover
    | a::x ->
        if member xover a
        then collect_neighbors xover x3 x2 x1 x
        else if member x3 a
        then collect_neighbors (a::xover) x3 x2 x1 x
        else if member x2 a
        then collect_neighbors xover (a::x3) x2 x1 x
        else if member x1 a
        then collect_neighbors xover x3 (a::x2) x1 x
        else collect_neighbors xover x3 x2 (a::x1) x

let occurs3 l = collect_neighbors [] [] [] [] l

let nextgen g =
  let living = alive g in
  let isalive = fun p -> member living p in
  let liveneighbors = fun p -> List.length (List.filter isalive (neighbors p)) in
  let survivors = List.filter (fun p -> twoorthree (liveneighbors p)) living in
  let newbrnlist = collect living (fun p -> List.filter (fun n -> not (isalive n)) (neighbors p)) in
  let newborn = occurs3 newbrnlist in
  MkGen (List.append survivors newborn)

let rec nthgen g i =
  if i=0 then g
  else nthgen (nextgen g) (i-1)

let gun =
  let r9 = (9,29) :: (9,30) :: (9,31) :: (9,32) :: [] in
  let r8 = (8,20) :: (8,28) :: (8,29) :: (8,30) :: (8,31) :: (8,40) :: (8,41) :: r9 in
  let r7 = (7,19) :: (7,21) :: (7,28) :: (7,31) :: (7,40) :: (7,41) :: r8 in
  let r6 = (6,7) :: (6,8) :: (6,18) :: (6,22) :: (6,23) :: (6,28) :: (6,29) :: (6,30) :: (6,31) :: (6,36) :: r7 in
  let r5 = (5,7) :: (5,8) :: (5,18) :: (5,22) :: (5,23) :: (5,29) :: (5,30) :: (5,31) :: (5,32) :: (5,36) :: r6 in
  let r4 = (4,18) :: (4,22) :: (4,23) :: (4,32) :: r5 in
  let r3 = (3,19) :: (3,21) :: r4 in
  let r2 = (2,20) :: r3 in
  MkGen r2

let at_pos coordlist (fst2,snd2) =
  let move = fun (fst1,snd1) -> (fst1+fst2,snd1+snd2)
  in List.map move coordlist

let center_line = 5

let bail =
  (0,0)::(0,1)::(1,0)::(1,1)::[]

let shuttle =
  let r4 = (4,1) :: (4,0) :: (4,5) :: (4,6) :: [] in
  let r3 = (3,2)::(3,3)::(3,4)::r4 in
  let r2 = (2,1)::(2,5)::r3 in
  let r1 = (1,2) :: (1,4) :: r2 in
  (0,3) :: r1

let non_steady = MkGen (
  List.append (List.append
    (at_pos bail (1,center_line))
    (at_pos bail (21,center_line)))
    (at_pos shuttle (6,(center_line - 2)))
  )

let go_gun steps =
  nthgen gun steps

let go_shuttle steps =
  nthgen non_steady steps

let rec go_loop iters steps go =
  let res = go steps in
  if iters=1 then List.length (alive res)
  else
    go_loop (iters-1) steps go

let main =
  let iters = int_of_string Sys.argv.(1) in
  let steps = int_of_string Sys.argv.(2) in
  let gun_res = go_loop iters steps go_gun in
  let shuttle_res = go_loop iters steps go_shuttle in
  print_string (string_of_int gun_res);
  print_endline (string_of_int shuttle_res)
