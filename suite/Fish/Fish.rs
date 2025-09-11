use std::{
    ops::{Add, Sub},
    rc::Rc,
};

#[derive(Clone)]
enum List<A> {
    Nil,
    Cons(A, Rc<List<A>>),
}

impl<A> List<A> {
    fn append(self, other: List<A>) -> List<A>
    where
        A: Clone,
    {
        match self {
            List::Nil => other,
            List::Cons(a, as_) => List::Cons(a, Rc::new(Rc::unwrap_or_clone(as_).append(other))),
        }
    }

    fn map<B>(self, f: &impl Fn(A) -> B) -> List<B>
    where
        A: Clone,
    {
        match self {
            List::Nil => List::Nil,
            List::Cons(a, as_) => List::Cons(f(a), Rc::new(Rc::unwrap_or_clone(as_).map(f))),
        }
    }

    fn len(&self) -> i64 {
        match self {
            List::Nil => 0,
            List::Cons(_, as_) => 1 + as_.len(),
        }
    }

    fn head(self) -> A {
        match self {
            List::Nil => panic!("Cannot take head of empty list"),
            List::Cons(a, _) => a,
        }
    }
}

fn enum_from_to(from: i64, to: i64) -> List<i64> {
    if from <= to {
        List::Cons(from, Rc::new(enum_from_to(from + 1, to)))
    } else {
        List::Nil
    }
}

#[derive(Debug, Clone)]
struct Vec4 {
    x: i64,
    y: i64,
    z: i64,
    w: i64,
}

#[derive(Clone, Copy)]
struct Vec2 {
    x: i64,
    y: i64,
}

impl Vec2 {
    fn scale(self, a: i64, b: i64) -> Vec2 {
        Vec2 {
            x: (self.x * a) / b,
            y: (self.x * a) / b,
        }
    }

    fn tup2(self, other: Vec2) -> Vec4 {
        Vec4 {
            x: self.x,
            y: self.y,
            z: other.x,
            w: other.y,
        }
    }
}

impl Add for Vec2 {
    type Output = Self;
    fn add(self, other: Vec2) -> Vec2 {
        Vec2 {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl Sub for Vec2 {
    type Output = Self;
    fn sub(self, other: Vec2) -> Vec2 {
        Vec2 {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }
}

fn p_tile() -> List<Vec4> {
    let p5: List<Vec4> = List::Cons(
        Vec4 {
            x: 10,
            y: 4,
            z: 13,
            w: 5,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 13,
                y: 5,
                z: 16,
                w: 4,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 11,
                    y: 0,
                    z: 14,
                    w: 2,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 14,
                        y: 2,
                        z: 16,
                        w: 2,
                    },
                    Rc::new(List::Nil),
                )),
            )),
        )),
    );
    let p4 = List::Cons(
        Vec4 {
            x: 8,
            y: 12,
            z: 16,
            w: 10,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 8,
                y: 8,
                z: 12,
                w: 9,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 12,
                    y: 9,
                    z: 16,
                    w: 8,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 9,
                        y: 6,
                        z: 12,
                        w: 7,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 12,
                            y: 7,
                            z: 16,
                            w: 6,
                        },
                        Rc::new(p5),
                    )),
                )),
            )),
        )),
    );
    let p3 = List::Cons(
        Vec4 {
            x: 10,
            y: 16,
            z: 12,
            w: 14,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 12,
                y: 14,
                z: 16,
                w: 13,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 12,
                    y: 16,
                    z: 13,
                    w: 15,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 13,
                        y: 15,
                        z: 16,
                        w: 14,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 14,
                            y: 16,
                            z: 16,
                            w: 15,
                        },
                        Rc::new(p4),
                    )),
                )),
            )),
        )),
    );
    let p2 = List::Cons(
        Vec4 {
            x: 4,
            y: 13,
            z: 0,
            w: 16,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 0,
                y: 16,
                z: 6,
                w: 15,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 6,
                    y: 15,
                    z: 8,
                    w: 16,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 8,
                        y: 16,
                        z: 12,
                        w: 12,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 12,
                            y: 12,
                            z: 16,
                            w: 12,
                        },
                        Rc::new(p3),
                    )),
                )),
            )),
        )),
    );
    let p1 = List::Cons(
        Vec4 {
            x: 4,
            y: 10,
            z: 7,
            w: 6,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 7,
                y: 6,
                z: 4,
                w: 5,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 11,
                    y: 0,
                    z: 10,
                    w: 4,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 10,
                        y: 4,
                        z: 9,
                        w: 6,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 9,
                            y: 6,
                            z: 8,
                            w: 8,
                        },
                        Rc::new(List::Cons(
                            Vec4 {
                                x: 8,
                                y: 8,
                                z: 4,
                                w: 13,
                            },
                            Rc::new(p2),
                        )),
                    )),
                )),
            )),
        )),
    );
    let p = List::Cons(
        Vec4 {
            x: 0,
            y: 3,
            z: 3,
            w: 4,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 3,
                y: 4,
                z: 0,
                w: 8,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 0,
                    y: 8,
                    z: 0,
                    w: 3,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 6,
                        y: 0,
                        z: 4,
                        w: 4,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 4,
                            y: 5,
                            z: 4,
                            w: 10,
                        },
                        Rc::new(p1),
                    )),
                )),
            )),
        )),
    );
    p
}

fn q_tile() -> List<Vec4> {
    let q7 = List::Cons(
        Vec4 {
            x: 0,
            y: 0,
            z: 0,
            w: 8,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 0,
                y: 12,
                z: 0,
                w: 16,
            },
            Rc::new(List::Nil),
        )),
    );
    let q6 = List::Cons(
        Vec4 {
            x: 13,
            y: 0,
            z: 16,
            w: 6,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 14,
                y: 0,
                z: 16,
                w: 4,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 15,
                    y: 0,
                    z: 16,
                    w: 2,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 0,
                        y: 0,
                        z: 8,
                        w: 0,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 12,
                            y: 0,
                            z: 16,
                            w: 0,
                        },
                        Rc::new(q7),
                    )),
                )),
            )),
        )),
    );
    let q5 = List::Cons(
        Vec4 {
            x: 10,
            y: 0,
            z: 14,
            w: 11,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 12,
                y: 0,
                z: 13,
                w: 4,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 13,
                    y: 4,
                    z: 16,
                    w: 8,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 16,
                        y: 8,
                        z: 15,
                        w: 10,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 15,
                            y: 10,
                            z: 16,
                            w: 16,
                        },
                        Rc::new(q6),
                    )),
                )),
            )),
        )),
    );
    let q4 = List::Cons(
        Vec4 {
            x: 4,
            y: 5,
            z: 4,
            w: 7,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 4,
                y: 0,
                z: 6,
                w: 5,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 6,
                    y: 5,
                    z: 6,
                    w: 7,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 6,
                        y: 0,
                        z: 8,
                        w: 5,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 8,
                            y: 5,
                            z: 8,
                            w: 8,
                        },
                        Rc::new(q5),
                    )),
                )),
            )),
        )),
    );
    let q3 = List::Cons(
        Vec4 {
            x: 11,
            y: 15,
            z: 9,
            w: 13,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 10,
                y: 10,
                z: 8,
                w: 12,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 8,
                    y: 12,
                    z: 12,
                    w: 12,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 12,
                        y: 12,
                        z: 10,
                        w: 10,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 2,
                            y: 0,
                            z: 4,
                            w: 5,
                        },
                        Rc::new(q4),
                    )),
                )),
            )),
        )),
    );
    let q2 = List::Cons(
        Vec4 {
            x: 4,
            y: 16,
            z: 5,
            w: 14,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 6,
                y: 16,
                z: 7,
                w: 15,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 0,
                    y: 10,
                    z: 7,
                    w: 11,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 9,
                        y: 13,
                        z: 8,
                        w: 15,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 8,
                            y: 15,
                            z: 11,
                            w: 15,
                        },
                        Rc::new(q3),
                    )),
                )),
            )),
        )),
    );
    let q1 = List::Cons(
        Vec4 {
            x: 0,
            y: 12,
            z: 3,
            w: 13,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 3,
                y: 13,
                z: 5,
                w: 14,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 5,
                    y: 14,
                    z: 7,
                    w: 15,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 7,
                        y: 15,
                        z: 8,
                        w: 16,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 2,
                            y: 16,
                            z: 3,
                            w: 13,
                        },
                        Rc::new(q2),
                    )),
                )),
            )),
        )),
    );
    let q = List::Cons(
        Vec4 {
            x: 0,
            y: 8,
            z: 4,
            w: 7,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 4,
                y: 7,
                z: 6,
                w: 7,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 6,
                    y: 7,
                    z: 8,
                    w: 8,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 8,
                        y: 8,
                        z: 12,
                        w: 10,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 12,
                            y: 10,
                            z: 16,
                            w: 16,
                        },
                        Rc::new(q1),
                    )),
                )),
            )),
        )),
    );
    q
}

fn r_tile() -> List<Vec4> {
    let r4 = List::Cons(
        Vec4 {
            x: 11,
            y: 16,
            z: 12,
            w: 12,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 12,
                y: 12,
                z: 16,
                w: 8,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 13,
                    y: 13,
                    z: 16,
                    w: 10,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 14,
                        y: 14,
                        z: 16,
                        w: 12,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 15,
                            y: 15,
                            z: 16,
                            w: 14,
                        },
                        Rc::new(List::Nil),
                    )),
                )),
            )),
        )),
    );

    let r3 = List::Cons(
        Vec4 {
            x: 2,
            y: 2,
            z: 8,
            w: 0,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 3,
                y: 3,
                z: 8,
                w: 2,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 8,
                    y: 2,
                    z: 12,
                    w: 0,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 5,
                        y: 5,
                        z: 12,
                        w: 3,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 12,
                            y: 3,
                            z: 16,
                            w: 0,
                        },
                        Rc::new(r4),
                    )),
                )),
            )),
        )),
    );
    let r2 = List::Cons(
        Vec4 {
            x: 5,
            y: 10,
            z: 2,
            w: 12,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 2,
                y: 12,
                z: 0,
                w: 16,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 16,
                    y: 8,
                    z: 12,
                    w: 12,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 12,
                        y: 12,
                        z: 11,
                        w: 16,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 1,
                            y: 1,
                            z: 4,
                            w: 0,
                        },
                        Rc::new(r3),
                    )),
                )),
            )),
        )),
    );
    let r1 = List::Cons(
        Vec4 {
            x: 16,
            y: 6,
            z: 11,
            w: 10,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 11,
                y: 10,
                z: 6,
                w: 16,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 16,
                    y: 4,
                    z: 14,
                    w: 6,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 14,
                        y: 6,
                        z: 8,
                        w: 8,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 8,
                            y: 8,
                            z: 5,
                            w: 10,
                        },
                        Rc::new(r2),
                    )),
                )),
            )),
        )),
    );
    let r = List::Cons(
        Vec4 {
            x: 0,
            y: 0,
            z: 8,
            w: 8,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 12,
                y: 12,
                z: 16,
                w: 16,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 0,
                    y: 4,
                    z: 5,
                    w: 10,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 0,
                        y: 8,
                        z: 2,
                        w: 12,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 0,
                            y: 12,
                            z: 1,
                            w: 14,
                        },
                        Rc::new(r1),
                    )),
                )),
            )),
        )),
    );
    r
}

fn s_tile() -> List<Vec4> {
    let s5: List<Vec4> = List::Cons(
        Vec4 {
            x: 15,
            y: 5,
            z: 13,
            w: 7,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 13,
                y: 7,
                z: 15,
                w: 8,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 15,
                    y: 8,
                    z: 15,
                    w: 5,
                },
                Rc::new(List::Nil),
            )),
        )),
    );

    let s4 = List::Cons(
        Vec4 {
            x: 15,
            y: 9,
            z: 16,
            w: 8,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 10,
                y: 16,
                z: 11,
                w: 10,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 12,
                    y: 4,
                    z: 10,
                    w: 6,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 10,
                        y: 6,
                        z: 12,
                        w: 7,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 12,
                            y: 7,
                            z: 12,
                            w: 4,
                        },
                        Rc::new(s5),
                    )),
                )),
            )),
        )),
    );
    let s3 = List::Cons(
        Vec4 {
            x: 7,
            y: 8,
            z: 7,
            w: 13,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 7,
                y: 13,
                z: 8,
                w: 16,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 12,
                    y: 16,
                    z: 13,
                    w: 13,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 13,
                        y: 13,
                        z: 14,
                        w: 11,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 14,
                            y: 11,
                            z: 15,
                            w: 9,
                        },
                        Rc::new(s4),
                    )),
                )),
            )),
        )),
    );
    let s2 = List::Cons(
        Vec4 {
            x: 14,
            y: 11,
            z: 16,
            w: 12,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 15,
                y: 9,
                z: 16,
                w: 10,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 16,
                    y: 0,
                    z: 10,
                    w: 4,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 10,
                        y: 4,
                        z: 8,
                        w: 6,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 8,
                            y: 6,
                            z: 7,
                            w: 8,
                        },
                        Rc::new(s3),
                    )),
                )),
            )),
        )),
    );
    let s1 = List::Cons(
        Vec4 {
            x: 0,
            y: 8,
            z: 8,
            w: 6,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 0,
                y: 10,
                z: 7,
                w: 8,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 0,
                    y: 12,
                    z: 7,
                    w: 10,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 0,
                        y: 14,
                        z: 7,
                        w: 13,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 13,
                            y: 13,
                            z: 16,
                            w: 14,
                        },
                        Rc::new(s2),
                    )),
                )),
            )),
        )),
    );
    let s = List::Cons(
        Vec4 {
            x: 0,
            y: 0,
            z: 4,
            w: 2,
        },
        Rc::new(List::Cons(
            Vec4 {
                x: 4,
                y: 2,
                z: 8,
                w: 2,
            },
            Rc::new(List::Cons(
                Vec4 {
                    x: 8,
                    y: 2,
                    z: 16,
                    w: 0,
                },
                Rc::new(List::Cons(
                    Vec4 {
                        x: 0,
                        y: 4,
                        z: 2,
                        w: 1,
                    },
                    Rc::new(List::Cons(
                        Vec4 {
                            x: 0,
                            y: 6,
                            z: 7,
                            w: 4,
                        },
                        Rc::new(s1),
                    )),
                )),
            )),
        )),
    );
    s
}

fn nil(_: Vec2, _: Vec2, _: Vec2) -> List<Vec4> {
    List::Nil
}

fn grid(m: i64, n: i64, segments: List<Vec4>, a: Vec2, b: Vec2, c: Vec2) -> List<Vec4> {
    match segments {
        List::Nil => List::Nil,
        List::Cons(v, t) => List::Cons(
            ((a + b.scale(v.x, m)) + c.scale(v.y, n)).tup2((a + b.scale(v.z, m)) + c.scale(v.w, n)),
            grid(m, n, Rc::unwrap_or_clone(t), a, b, c).into(),
        ),
    }
}

fn rot(p: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>, a: Vec2, b: Vec2, c: Vec2) -> List<Vec4> {
    p(a + b, c, Vec2 { x: 0, y: 0 } - b)
}

fn beside(
    m: i64,
    n: i64,
    p: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    q: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    a: Vec2,
    b: Vec2,
    c: Vec2,
) -> List<Vec4> {
    let res = p(a, b.scale(m, m + n), c);
    res.append(q(a + b.scale(m, m + n), b.scale(n, n + m), c))
}

fn above(
    m: i64,
    n: i64,
    p: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    q: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    a: Vec2,
    b: Vec2,
    c: Vec2,
) -> List<Vec4> {
    let res = p(a + c.scale(n, m + n), b, c.scale(m, n + m));
    res.append(q(a, b, c.scale(n, m + n)))
}

fn tile_to_grid(arg: List<Vec4>, arg2: Vec2, arg3: Vec2, arg4: Vec2) -> List<Vec4> {
    grid(16, 16, arg, arg2, arg3, arg4)
}

fn p(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    tile_to_grid(p_tile(), arg, q6, q7)
}

fn q(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    tile_to_grid(q_tile(), arg, q6, q7)
}

fn r(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    tile_to_grid(r_tile(), arg, q6, q7)
}

fn s(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    tile_to_grid(s_tile(), arg, q6, q7)
}

fn quartet(
    a: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    b: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    c: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    d: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    arg: Vec2,
    a6: Vec2,
    a7: Vec2,
) -> List<Vec4> {
    above(
        1,
        1,
        &move |p5, p6, p7| beside(1, 1, a, b, p5, p6, p7),
        &move |p5, p6, p7| beside(1, 1, c, d, p5, p6, p7),
        arg,
        a6,
        a7,
    )
}

fn t(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    quartet(&p, &q, &r, &s, arg, q6, q7)
}

fn cycle_(
    p1: &impl Fn(Vec2, Vec2, Vec2) -> List<Vec4>,
    arg: Vec2,
    p3: Vec2,
    p4: Vec2,
) -> List<Vec4> {
    quartet(
        p1,
        &move |a, b, c| rot(&move |a, b, c| rot(p1, a, b, c), a, b, c),
        &move |a, b, c| rot(p1, a, b, c),
        &move |a, b, c| rot(&move |a, b, c| rot(p1, a, b, c), a, b, c),
        arg,
        p3,
        p4,
    )
}

fn u(arg: Vec2, p2: Vec2, p3: Vec2) -> List<Vec4> {
    cycle_(&|a, b, c| rot(&q, a, b, c), arg, p2, p3)
}

fn side1(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    quartet(&nil, &nil, &|a, b, c| rot(&t, a, b, c), &t, arg, q6, q7)
}

fn side2(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    quartet(&side1, &side1, &|a, b, c| rot(&t, a, b, c), &t, arg, q6, q7)
}

fn corner1(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    quartet(&nil, &nil, &nil, &u, arg, q6, q7)
}

fn corner2(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    quartet(
        &corner1,
        &side1,
        &|a, b, c| rot(&side1, a, b, c),
        &|a, b, c| rot(&u, a, b, c),
        arg,
        q6,
        q7,
    )
}

fn pseudocorner(arg: Vec2, q6: Vec2, q7: Vec2) -> List<Vec4> {
    quartet(
        &corner2,
        &side2,
        &|a, b, c| rot(&side2, a, b, c),
        &|a, b, c| rot(&t, a, b, c),
        arg,
        q6,
        q7,
    )
}

fn pseudolimit(arg: Vec2, p2: Vec2, p3: Vec2) -> List<Vec4> {
    cycle_(&|a, b, c| pseudocorner(a, b, c), arg, p2, p3)
}

fn test_fish_nofib(n: i64) -> List<List<Vec4>> {
    enum_from_to(1, n).map(&|i: i64| {
        let n = i.min(0);
        pseudolimit(
            Vec2 { x: 0, y: 0 },
            Vec2 { x: 640 + n, y: 0 },
            Vec2 { x: 0, y: 640 + n },
        )
    })
}

fn main() {
    let mut args = std::env::args();
    args.next();
    let n = args
        .next()
        .expect("Missing Argument n")
        .parse::<i64>()
        .expect("n must be a number");
    println!("{}", test_fish_nofib(n).head().len());
}
