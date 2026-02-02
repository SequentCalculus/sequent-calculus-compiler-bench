data Bool { True, False }

def divide_range(min:i64,max:i64,test:i64): Bool{
  if min >= max{
    True
  }else{
    if test % min == 0 {
      divide_range(min + 1, max,test)
    }else{
      False
    }
  }
}

def smallest_multiple_rec(n:i64,curr:i64): i64{
  divide_range(1,n,curr).case{
    True => curr,
    False => smallest_multiple_rec(n,curr + 1)
  }
}

def smallest_multiple(n:i64): i64{
  smallest_multiple_rec(n,1)
}

def main_loop(iters:i64,n:i64): i64{
  let res:i64 = smallest_multiple(n);
  if iters == 1{
    println_i64(res);
    0
  }else {
    main_loop(iters - 1,n)
  }
}

def main(iters:i64,n:i64): i64{
  main_loop(iters, n)
}
