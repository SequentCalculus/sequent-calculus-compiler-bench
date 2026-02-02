def sum_multiples_acc(start:i64,max:i64,acc:i64): i64{
  if start == max{
    acc
  }else {

    if start % 3 == 0{
      sum_multiples_acc(start + 1, max,acc + start)
    }else {
      if start % 5 == 0{
        sum_multiples_acc(start + 1, max, acc + start)
      }else{
        sum_multiples_acc(start + 1, max, acc)
      }
    }
  }
}

def sum_multiples(n:i64) : i64{
  sum_multiples_acc(0,n,0)
}

def main_loop(iters:i64,n:i64): i64 {
  let res: i64 = sum_multiples(n);
  if iters == 0{
    println_i64(res);
    0
  }else{
    main_loop(iters -1,n)
  }
}

def main(iters:i64,n:i64): i64 {
  main_loop(iters,n)
}
