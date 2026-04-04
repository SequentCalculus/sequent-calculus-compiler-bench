def sum_fib_acc(curr:i64,last:i64,max:i64,acc:i64): i64{
  let next: i64 = curr + last;
  if next > max{
    acc
  }else{
    if next % 2 == 0 {
      sum_fib_acc(next,curr,max, next + acc)
    }else{
      sum_fib_acc(next,curr,max,acc)
    }
  }
}

def sum_fib(max:i64): i64 {
  sum_fib_acc(1,1,max,0)
}

def main_loop(iters:i64,max:i64): i64{
  let res: i64 = sum_fib(max);
  if iters == 0{
    println_i64(res);
    0
  } else {
    main_loop(iters - 1, max)
  }
}

def main(iters:i64,max:i64): i64 {
  main_loop(iters,max)
}
