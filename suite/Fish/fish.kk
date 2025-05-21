module fish

import std/os/env
import std/num/int64

value struct vec
  x:int64
  y:int64

value struct vec4
  x:int64
  y:int64
  z:int64
  w:int64

fun vec_add(v1:vec,v2:vec): total vec{
  match (v1,v2)
    (Vec(x1,y1),Vec(x2,y2)) -> Vec(x1 + x2,y1 + y2)
}

fun vec_sub(v1:vec,v2:vec): total vec{
  match (v1,v2) 
    (Vec(x1,y1),Vec(x2,y2)) -> Vec(x1 - x2, y1 - y2)
}

fun scale_vec2(v:vec,a:int64,b:int64): vec{
  match v
    Vec(x,y) -> Vec((x * a) / b, (y * a) / b)
}

fun tup2(a_b:vec,c_d:vec): total vec4{
  match (a_b,c_d)
    (Vec(a,b),Vec(c,d)) -> Vec4(a,b,c,d)
}

fun enum_from_to(from:int64,to:int64): div list<int64>{
  if from<=to then
    Cons(from,enum_from_to(from + 1.int64,to))
  else 
    Nil 
}

fun p_tile(): total list<vec4> {
  val p5 = Cons(Vec4(10.int64, 4.int64, 13.int64, 5.int64),
    Cons(Vec4(13.int64, 5.int64, 16.int64, 4.int64),
      Cons(Vec4(11.int64, 0.int64, 14.int64, 2.int64),
        Cons(Vec4(14.int64, 2.int64, 16.int64, 2.int64),
          Nil))))
  val p4 = Cons(Vec4(8.int64, 12.int64, 16.int64, 10.int64),
    Cons(Vec4(8.int64, 8.int64, 12.int64, 9.int64),
      Cons(Vec4(12.int64, 9.int64, 16.int64, 8.int64),
        Cons(Vec4(9.int64, 6.int64, 12.int64, 7.int64),
          Cons(Vec4(12.int64, 7.int64, 16.int64, 6.int64),
            p5)))))
  val p3 = Cons(Vec4(10.int64, 16.int64, 12.int64, 14.int64),
    Cons(Vec4(12.int64, 14.int64, 16.int64, 13.int64),
      Cons(Vec4(12.int64, 16.int64, 13.int64, 15.int64),
        Cons(Vec4(13.int64, 15.int64, 16.int64, 14.int64),
          Cons(Vec4(14.int64, 16.int64, 16.int64, 15.int64),
            p4)))))
  val p2 = Cons(Vec4(4.int64, 13.int64, 0.int64, 16.int64),
    Cons(Vec4(0.int64, 16.int64, 6.int64, 15.int64),
      Cons(Vec4(6.int64, 15.int64, 8.int64, 16.int64),
        Cons(Vec4(8.int64, 16.int64, 12.int64, 12.int64),
          Cons(Vec4(12.int64, 12.int64, 16.int64, 12.int64),
            p3)))))
  val p1 = Cons(Vec4(4.int64, 10.int64, 7.int64, 6.int64),
    Cons(Vec4(7.int64, 6.int64, 4.int64, 5.int64),
      Cons(Vec4(11.int64, 0.int64, 10.int64, 4.int64),
        Cons(Vec4(10.int64, 4.int64, 9.int64, 6.int64),
          Cons(Vec4(9.int64, 6.int64, 8.int64, 8.int64),
            Cons(Vec4(8.int64, 8.int64, 4.int64, 13.int64),
              p2))))))
  val p = Cons(Vec4(0.int64, 3.int64, 3.int64, 4.int64),
    Cons(Vec4(3.int64, 4.int64, 0.int64, 8.int64),
      Cons(Vec4(0.int64, 8.int64, 0.int64, 3.int64),
        Cons(Vec4(6.int64, 0.int64, 4.int64, 4.int64),
          Cons(Vec4(4.int64, 5.int64, 4.int64, 10.int64),
          p1)))))
  p
}

fun q_tile(): total list<vec4> {
  val q7 = Cons(Vec4(0.int64, 0.int64, 0.int64, 8.int64),
    Cons(Vec4(0.int64, 12.int64, 0.int64, 16.int64),
      Nil))
  val q6 = Cons(Vec4(13.int64, 0.int64, 16.int64, 6.int64),
    Cons(Vec4(14.int64, 0.int64, 16.int64, 4.int64),
      Cons(Vec4(15.int64, 0.int64, 16.int64, 2.int64),
        Cons(Vec4(0.int64, 0.int64, 8.int64, 0.int64),
          Cons(Vec4(12.int64, 0.int64, 16.int64, 0.int64),
            q7)))))
  val q5 = Cons(Vec4(10.int64, 0.int64, 14.int64, 11.int64),
    Cons(Vec4(12.int64, 0.int64, 13.int64, 4.int64),
      Cons(Vec4(13.int64, 4.int64, 16.int64, 8.int64),
        Cons(Vec4(16.int64, 8.int64, 15.int64, 10.int64),
          Cons(Vec4(15.int64, 10.int64, 16.int64, 16.int64),
            q6)))))
  val q4 = Cons(Vec4(4.int64, 5.int64, 4.int64, 7.int64),
    Cons(Vec4(4.int64, 0.int64, 6.int64, 5.int64),
      Cons(Vec4(6.int64, 5.int64, 6.int64, 7.int64),
        Cons(Vec4(6.int64, 0.int64, 8.int64, 5.int64),
          Cons(Vec4(8.int64, 5.int64, 8.int64, 8.int64),
            q5)))))
  val q3 = Cons(Vec4(11.int64, 15.int64, 9.int64, 13.int64),
    Cons(Vec4(10.int64, 10.int64, 8.int64, 12.int64),
      Cons(Vec4(8.int64, 12.int64, 12.int64, 12.int64),
        Cons(Vec4(12.int64, 12.int64, 10.int64, 10.int64),
          Cons(Vec4(2.int64, 0.int64, 4.int64, 5.int64),
            q4)))))
  val q2 = Cons(Vec4(4.int64, 16.int64, 5.int64, 14.int64),
    Cons(Vec4(6.int64, 16.int64, 7.int64, 15.int64),
      Cons(Vec4(0.int64, 10.int64, 7.int64, 11.int64),  
        Cons(Vec4(9.int64, 13.int64, 8.int64, 15.int64),
          Cons(Vec4(8.int64, 15.int64, 11.int64, 15.int64),
            q3)))))
  val q1 = Cons(Vec4(0.int64, 12.int64, 3.int64, 13.int64),
    Cons(Vec4(3.int64, 13.int64, 5.int64, 14.int64), 
      Cons(Vec4(5.int64, 14.int64, 7.int64, 15.int64),
        Cons(Vec4(7.int64, 15.int64, 8.int64, 16.int64),
          Cons(Vec4(2.int64, 16.int64, 3.int64, 13.int64),
            q2)))))
  val q = Cons(Vec4(0.int64, 8.int64, 4.int64, 7.int64),
    Cons(Vec4(4.int64, 7.int64, 6.int64, 7.int64),
      Cons(Vec4(6.int64, 7.int64, 8.int64, 8.int64),
        Cons(Vec4(8.int64, 8.int64, 12.int64, 10.int64),
          Cons(Vec4(12.int64, 10.int64, 16.int64, 16.int64),
            q1)))))
  q
}

fun r_tile(): total list<vec4> {
  val r4 = Cons(Vec4(11.int64, 16.int64, 12.int64, 12.int64),
    Cons(Vec4(12.int64, 12.int64, 16.int64, 8.int64),
      Cons(Vec4(13.int64, 13.int64, 16.int64, 10.int64),
        Cons(Vec4(14.int64, 14.int64, 16.int64, 12.int64),
          Cons(Vec4(15.int64, 15.int64, 16.int64, 14.int64),
            Nil)))));
  val r3 = Cons(Vec4(2.int64, 2.int64, 8.int64, 0.int64),
    Cons(Vec4(3.int64, 3.int64, 8.int64, 2.int64),
      Cons(Vec4(8.int64, 2.int64, 12.int64, 0.int64),
        Cons(Vec4(5.int64, 5.int64, 12.int64, 3.int64),
          Cons(Vec4(12.int64, 3.int64, 16.int64, 0.int64),
            r4)))));
  val r2 = Cons(Vec4(5.int64, 10.int64, 2.int64, 12.int64),
    Cons(Vec4(2.int64, 12.int64, 0.int64, 16.int64),
      Cons(Vec4(16.int64, 8.int64, 12.int64, 12.int64),
        Cons(Vec4(12.int64, 12.int64, 11.int64, 16.int64),
          Cons(Vec4(1.int64, 1.int64, 4.int64, 0.int64),
            r3)))));
  val r1 = Cons(Vec4(16.int64, 6.int64, 11.int64, 10.int64),
    Cons(Vec4(11.int64, 10.int64, 6.int64, 16.int64),
      Cons(Vec4(16.int64, 4.int64, 14.int64, 6.int64),
        Cons(Vec4(14.int64, 6.int64, 8.int64, 8.int64),
          Cons(Vec4(8.int64, 8.int64, 5.int64, 10.int64),
            r2)))));
  val r =  Cons(Vec4(0.int64, 0.int64, 8.int64, 8.int64),
    Cons(Vec4(12.int64, 12.int64, 16.int64, 16.int64),
      Cons(Vec4(0.int64, 4.int64, 5.int64, 10.int64),
        Cons(Vec4(0.int64, 8.int64, 2.int64, 12.int64),
          Cons(Vec4(0.int64, 12.int64, 1.int64, 14.int64),
            r1)))));
  r
}

fun s_tile(): total list<vec4> {
  val s5 = Cons(Vec4(15.int64, 5.int64, 13.int64, 7.int64),
    Cons(Vec4(13.int64, 7.int64, 15.int64, 8.int64),
      Cons(Vec4(15.int64, 8.int64, 15.int64, 5.int64),
        Nil)));
  val s4 = Cons(Vec4(15.int64, 9.int64, 16.int64, 8.int64),
    Cons(Vec4(10.int64, 16.int64, 11.int64, 10.int64),
      Cons(Vec4(12.int64, 4.int64, 10.int64, 6.int64),
        Cons(Vec4(10.int64, 6.int64, 12.int64, 7.int64),
          Cons(Vec4(12.int64, 7.int64, 12.int64, 4.int64),
            s5)))));
  val s3 = Cons(Vec4(7.int64, 8.int64, 7.int64, 13.int64),
    Cons(Vec4(7.int64, 13.int64, 8.int64, 16.int64),
      Cons(Vec4(12.int64, 16.int64, 13.int64, 13.int64),
        Cons(Vec4(13.int64, 13.int64, 14.int64, 11.int64),
          Cons(Vec4(14.int64, 11.int64, 15.int64, 9.int64),
            s4)))));
  val s2 = Cons(Vec4(14.int64, 11.int64, 16.int64, 12.int64),
    Cons(Vec4(15.int64, 9.int64, 16.int64, 10.int64),
      Cons(Vec4(16.int64, 0.int64, 10.int64, 4.int64),
        Cons(Vec4(10.int64, 4.int64, 8.int64, 6.int64),
          Cons(Vec4(8.int64, 6.int64, 7.int64, 8.int64),
            s3)))));
  val s1 = Cons(Vec4(0.int64, 8.int64, 8.int64, 6.int64),
    Cons(Vec4(0.int64, 10.int64, 7.int64, 8.int64),
      Cons(Vec4(0.int64, 12.int64, 7.int64, 10.int64),
        Cons(Vec4(0.int64, 14.int64, 7.int64, 13.int64),
          Cons(Vec4(13.int64, 13.int64, 16.int64, 14.int64),
            s2)))));
  val s = Cons(Vec4(0.int64, 0.int64, 4.int64, 2.int64),
    Cons(Vec4(4.int64, 2.int64, 8.int64, 2.int64),
      Cons(Vec4(8.int64, 2.int64, 16.int64, 0.int64),
        Cons(Vec4(0.int64, 4.int64, 2.int64, 1.int64),
          Cons(Vec4(0.int64, 6.int64, 7.int64, 4.int64),
            s1)))));
  s
}

fun nil(_:vec,_:vec,_:vec): total list<vec4>{ Nil }

fun beside(m:int64,n:int64,p:(vec,vec,vec) -> div list<vec4>,q:(vec,vec,vec) -> div list<vec4>, a:vec,b:vec,c:vec): div list<vec4>{
  append(
    p(a,scale_vec2(b,m,m + n),c),
    q(vec_add(a, scale_vec2(b, m, m + n)),scale_vec2(b, n, n + m),c)
  )
}

fun above(m:int64,n:int64,p:(vec,vec,vec) -> div list<vec4>,q:(vec,vec,vec) -> div list<vec4>, a:vec,b:vec,c:vec): div list<vec4>{
  append(
    p(vec_add(a,scale_vec2(c,n,m + n)),b,scale_vec2(c,m,n + m)),
    q(a,b,scale_vec2(c,n,m + n))
  )
}

fun quartet(
  a:(vec,vec,vec) -> div list<vec4>, 
  b:(vec,vec,vec) -> div list<vec4>,
  c:(vec,vec,vec) -> div list<vec4>,
  d:(vec,vec,vec) -> div list<vec4>,
  arg:vec,q6:vec,q7:vec): div list<vec4>{
  above(1.int64,1.int64,
    fn(p5,p6,p7) beside(1.int64,1.int64,a,b,p5,p6,p7),
    fn(p5,p6,p7) beside(1.int64,1.int64,c,d,p5,p6,p7),
    arg,q6,q7)
}

fun cycle_(p1:(vec,vec,vec) -> div list<vec4>,arg:vec,p3:vec,p4:vec): div list<vec4>{
  quartet(p1,
    fn(a3,b3,c3) rot(fn(a2,b2,c2) rot(fn(a1,b1,c1) rot(p1,a1,b1,c1),a2,b2,c2),a3,b3,c3),
    fn(a,b,c) rot(p1,a,b,c),
    fn(a2,b2,c2) rot(fn(a1,b1,c1) rot(p1,a1,b1,c1),a2,b2,c2),
    arg,p3,p4)
}

fun grid_lscomp(m:int64, n:int64, a:vec,b:vec,c:vec,ls:list<vec4>): total list<vec4>{
  match ls 
    Nil -> Nil
    Cons(Vec4(x0,y0,x1,y1),t) -> 
      Cons(tup2(
        vec_add(vec_add(a,scale_vec2(b,x0,m)),scale_vec2(c,y0,n)),
        vec_add(vec_add(a,scale_vec2(b,x1,m)),scale_vec2(c, y1,n))),
        grid_lscomp(m,n,a,b,c,t)
      )
}

fun grid(m:int64, n:int64, segments:list<vec4>, a:vec,b:vec,c:vec): total list<vec4>{
  grid_lscomp(m,n,a,b,c,segments)
}

fun tile_to_grid(arg:list<vec4>, arg2:vec,arg3:vec,arg4:vec) : total list<vec4>{
  grid(16.int64, 16.int64, arg, arg2, arg3, arg4)
}

fun p(arg:vec,q6:vec,q7:vec): total list<vec4>{
  tile_to_grid(p_tile(),arg,q6,q7)
}

fun q(arg:vec,q6:vec,q7:vec): total list<vec4>{
  tile_to_grid(q_tile(),arg,q6,q7)
}

fun r(arg:vec,q6:vec,q7:vec): total list<vec4>{
  tile_to_grid(r_tile(),arg,q6,q7)
}

fun s(arg:vec,q6:vec,q7:vec): total list<vec4>{
  tile_to_grid(s_tile(),arg,q6,q7)
}

fun u(arg:vec,p2:vec,p3:vec): div list<vec4>{
  cycle_(fn(a,b,c) rot(q,a,b,c),arg,p2,p3)
}

fun t(arg:vec,q6:vec,q7:vec): div list<vec4>{
  quartet(p,q,r,s,arg,q6,q7)
}


fun rot(p:(vec,vec,vec) -> div list<vec4>,a:vec,b:vec,c:vec): div list<vec4>{
  p(vec_add(a,b),c,vec_sub(Vec(0.int64,0.int64),b))
}

fun corner1(arg:vec,q6:vec,q7:vec): div list<vec4>{
  quartet(corner1,side1,fn(a,b,c) rot(side1,a,b,c),u,arg,q6,q7)
}

fun corner2(arg:vec,q6:vec,q7:vec): div list<vec4>{
  quartet(corner1,side1,fn(a,b,c) rot(side1,a,b,c),u,arg,q6,q7)
}

fun side1(arg:vec,q6:vec,q7:vec): div list<vec4>{
  quartet(nil,nil,fn(a,b,c) rot(t,a,b,c),t,arg,q6,q7)
}

fun side2(arg:vec,q6:vec,q7:vec): div list<vec4>{
  quartet(side1,side1,fn(a,b,c) rot(t,a,b,c),t,arg,q6,q7)
}

fun pseudocorner(arg:vec,q6:vec,q7:vec): div list<vec4> {
  quartet(
    corner2,side2,fn(a,b,c) rot(side2,a,b,c),fn(a,b,c) rot(t,a,b,c),
    arg,q6,q7)
}

fun pseudolimit(arg:vec,p2:vec,p3:vec): div list<vec4>{
  cycle_(pseudocorner,arg,p2,p3)
}

fun test_fish_nofib(m:int64): div list<list<vec4>>{
  map(enum_from_to(1.int64,m),fn(i)
    val n = min(0.int64,i)
    pseudolimit(Vec(0.int64,0.int64),Vec(640.int64 + n,0.int64),Vec(0.int64,640.int64 + n))
  )
}

fun main(): <ndet,exn,console,div> () {
  val args = get-args()
  val n = unjust(parse-int(unjust(head(args)))).int64
  val res = test_fish_nofib(n)
  println(length(unjust(head(res))))
}
