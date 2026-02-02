data Bool { True, False}
data List { Nil, Cons(x:i64,xs:List) }

def powi(b:i64,e:i64): i64{
  if e == 0{ 
    1 
  } else {
    if e == 1{
      b 
    }else{
      b * powi(b,e - 1)
    }
  }
}

def rev_acc(l:List,acc:List): List{
  l.case{
    Nil => acc,
    Cons(x,xs) => rev_acc(xs,Cons(x,acc))
  }
}

def rev(l:List): List{
  rev_acc(l,Nil)
}

def digits_acc(n:i64,acc:List): List{
  if n < 10 {
    Cons(n,acc)
  }else{
    digits_acc(n / 10, Cons(n % 10,acc))
  }
}

def digits(n:i64): List{
  digits_acc(n,Nil)
}

def list_eq(l1:List,l2:List): Bool{
  l1.case{
    Nil => l2.case{
      Nil => True,
      Cons(x,xs) => False
    },
    Cons(x1,xs1) => l2.case{
      Nil => False,
      Cons(x2,xs2) => if x1 == x2 {
        list_eq(xs1,xs2)
      }else{
        False
      }
    }
  }
}

def is_palindrome(n:i64): Bool{
  let digits:List = digits(n);
  list_eq(digits,rev(digits))
}

def max_prod_between_rec(min:i64,max:i64,a:i64,b:i64,curr_max:i64): i64{
  let next_prod: i64 = a * b;
  let next_max:i64 = if next_prod >= curr_max{
    is_palindrome(next_prod).case{
      True => next_prod,
      False => curr_max
      }
  }else{
    curr_max
  };
  let next_a: i64 = if a == max {
    min
  }else{
     a + 1
  };
  let next_b: i64 = if next_a == min {
    b + 1
  }else{
    b
  };
  if next_b == max{
    curr_max
  }else{
      max_prod_between_rec(min,max,next_a,next_b,next_max)
  }
}

def max_prod_between(min:i64,max:i64): i64{
  max_prod_between_rec(min,max,min,min,0)
}

def max_prod(num_digits:i64): i64{
  let min: i64 = powi(10,num_digits - 1);
  let max:i64 = powi(10,num_digits) - 1;
  max_prod_between(min,max)
}

def main_loop(iters:i64,num_digits:i64): i64{
  let res: i64 = max_prod(num_digits);
  if iters == 0{
    println_i64(res);
    0
  }else{
    main_loop(iters - 1,num_digits)
  }
}

def main(iters:i64,num_digits:i64): i64{
  main_loop(iters, num_digits)
}
