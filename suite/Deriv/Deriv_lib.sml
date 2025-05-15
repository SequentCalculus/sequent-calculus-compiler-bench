structure Deriv = struct 
  exception BadExpr

  datatype Expr = Add of Expr list
                | Sub of Expr list 
                | Mul of Expr list 
                | Div of Expr list 
                | Num of int 
                | X

  fun deriv e = 
    case e of 
         Add sums => Add (map deriv sums)
       | Sub subs => Sub (map deriv subs)
       | Mul muls => 
           Mul [e,Add (map (fn x => Div [deriv x,x]) muls)] 
       | Div (x::y::nil) => 
           Sub [Div [deriv x, y],Div [x,Mul[y,y,deriv y]]]
       | Num i => Num 0
       | X => Num 1 
       | _ => raise BadExpr


  fun mk_exp a b = 
    Add [
    Mul [Num 3, X, X],
    Mul [a, X, X],
    Mul [b, X],
    Num 5
        ] 

  fun mk_ans a b = 
    Add [
    Mul [
    Mul [Num 3, X, X], 
    Add [
    Div [Num 0, Num 3],
    Div [Num 1, X],
    Div [Num 1, X]
        ]
        ], 
        Mul [
        Mul [a, X, X],
        Add [Div [Num 0, a], Div [Num 1, X], Div [Num 1, X]]
            ],
            Mul [Mul[b, X], Add [Div [Num 0, b], Div [Num 1, X]]],
            Num 0
                ]

  fun main_loop iters n m = 
  let val res = deriv (mk_exp (Num n) (Num m))
    val expected = mk_ans (Num n) (Num m)
  in 
    if iters=1 
    then 
      if expected = res 
      then print "1\n" else print "0\n"
      else main_loop (iters-1) n m
  end

  fun run args =
    let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
    val m = valOf (Int.fromString (hd (tl (tl args))))
  in 
    main_loop iters n m
  end
end 
