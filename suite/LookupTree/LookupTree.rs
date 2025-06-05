use std::rc::Rc;

#[derive(Debug, Clone)]
enum Tree<A> {
    Leaf(A),
    Node {
        left: Rc<Tree<A>>,
        _right: Rc<Tree<A>>,
    },
}

impl<A> Tree<A> {
    fn create(i: u64, n: u64) -> Tree<u64> {
        if i < n {
            let t = Rc::new(Tree::<u64>::create(i + 1, n));
            Tree::Node {
                left: t.clone(),
                _right: t,
            }
        } else {
            Tree::Leaf(n)
        }
    }

    fn lookup(&self) -> A
    where
        A: Clone + Copy,
    {
        match self {
            Tree::Leaf(a) => *a,
            Tree::Node { left, _right: _ } => left.lookup(),
        }
    }
}

fn main_loop(iters: u64, n: u64) -> i64 {
    for i in 0..=iters {
        let res = Tree::<u64>::create(0, n).lookup();
        if i == iters {
            println!("{:?}", res);
        }
    }
    0
}

fn main() {
    let mut args = std::env::args();
    args.next();
    let iters = args
        .next()
        .expect("Missing Argument iterations")
        .parse::<u64>()
        .expect("Iterations must be a number");
    let n = args
        .next()
        .expect("Missing Argument n")
        .parse::<u64>()
        .expect("n must be a number");
    std::process::exit(main_loop(iters, n) as i32)
}
