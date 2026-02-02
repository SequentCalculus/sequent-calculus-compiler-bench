data Bool { True, False }

def isqrt_rec(n:i64,l:i64,r:i64): i64{
  if l != (r - 1){
    let m: i64 = (l + r) / 2;
    if (m * m) <= n{
      isqrt_rec(n,m,r)
    }else{
      isqrt_rec(n,l,m)
    }
  }else{
    l 
  }
}

def isqrt(n:i64): i64{
  isqrt_rec(n, 0,n - 1)
}

def is_prime_rec(n:i64,last:i64): Bool{
  if last >= n{
    True
  } else { 
    if n % last == 0{
      False
    } else{
      is_prime_rec(n,last + 1)
    }
  }
}

def is_prime(n:i64) : Bool {
  is_prime_rec(n,2)
}

def next_prime(upper:i64): i64{
    is_prime(upper).case {
      True => upper,
      False => next_prime(upper - 1)
    }  
}

def largest_prime_factor_rec(n:i64,next_check:i64) : i64 {
  if n % next_check == 0 {
    next_check
  }else{
    let next: i64 = next_prime(next_check - 1);
    largest_prime_factor_rec(n,next)
  }
}

def largest_prime_factor(n:i64): i64{
  let max_check: i64 = isqrt(n);
  largest_prime_factor_rec(n, max_check)
}

def main_loop(iters:i64,n:i64): i64{
  let res:i64 = largest_prime_factor(n);
  if iters == 0{
    println_i64(res);
    0
  }else{
    main_loop(iters - 1, n)
  }
}

def main(iters:i64,n:i64): i64{
  main_loop(iters,n)
}
