// `Tree[A]` recurses at `Tree[Two[A]]` through `Branch`, but the program never traverses that
// path recursively: `isLeaf` only inspects the outermost constructor. Without splitting, the
// declaration's own field still closes a growing cycle; with splitting, the inner tree's class
// never uses `Branch`, so there is no cycle to erase. A recursive traversal through `Branch`
// would bring the cycle back in both configurations.

data Tree[A] {
    Leaf(x: A),
    Branch(b: Tree[Two[A]])
}

data Two[B] { Both(fst: B, snd: B) }

def isLeaf[C+](t: Tree[C]): i64 {
    t.case[C] {
        Leaf(x) => 1,
        Branch(y) => 0
    }
}

def main(): i64 {
    println_i64(isLeaf[i64](Branch(Leaf(Both(123, 456)))));
    0
}
