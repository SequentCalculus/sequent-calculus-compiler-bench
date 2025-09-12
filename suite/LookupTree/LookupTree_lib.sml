structure LookupTree = struct
  datatype 'a tree = Leaf of 'a
                   | Node of 'a tree * 'a tree

  fun create i n =
    if i < n then
      let val t = create (i + 1) n
      in
        Node (t, t)
      end
    else Leaf n

  fun lookup t =
    case t of
         Leaf v => v
       | Node(left, right) => lookup left

  fun main_loop iters n =
  let val res = lookup (create 0 n)
      in
        if iters=1 then
          print ((Int.toString res) ^ "\n")
        else main_loop (iters - 1) n
      end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in
    main_loop iters n
  end
end
