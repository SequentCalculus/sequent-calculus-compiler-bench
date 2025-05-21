const $effekt = {  };

class Tuple_0 {
  constructor(first_0, second_0) {
    this.__tag = 0;
    this.first_0 = first_0;
    this.second_0 = second_0;
  }
  __reflect() {
    return {
      __tag: 0,
      __name: "Tuple2",
      __data: [this.first_0, this.second_0]
    };
  }
  __equals(other12376) {
    if (!other12376) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12376.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.first_0, other12376.first_0))) {
      return false;
    }
    if (!($effekt.equals(this.second_0, other12376.second_0))) {
      return false;
    }
    return true;
  }
}

class OutOfBounds_0 {
  constructor() {
    this.__tag = 0;
  }
  __reflect() {
    return { __tag: 0, __name: "OutOfBounds", __data: [] };
  }
  __equals(other12377) {
    if (!other12377) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12377.__tag))) {
      return false;
    }
    return true;
  }
}

class None_0 {
  constructor() {
    this.__tag = 0;
  }
  __reflect() {
    return { __tag: 0, __name: "None", __data: [] };
  }
  __equals(other12378) {
    if (!other12378) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12378.__tag))) {
      return false;
    }
    return true;
  }
}

class Some_0 {
  constructor(value_0) {
    this.__tag = 1;
    this.value_0 = value_0;
  }
  __reflect() {
    return { __tag: 1, __name: "Some", __data: [this.value_0] };
  }
  __equals(other12379) {
    if (!other12379) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12379.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.value_0, other12379.value_0))) {
      return false;
    }
    return true;
  }
}

class Nil_0 {
  constructor() {
    this.__tag = 0;
  }
  __reflect() {
    return { __tag: 0, __name: "Nil", __data: [] };
  }
  __equals(other12380) {
    if (!other12380) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12380.__tag))) {
      return false;
    }
    return true;
  }
}

class Cons_0 {
  constructor(head_0, tail_0) {
    this.__tag = 1;
    this.head_0 = head_0;
    this.tail_0 = tail_0;
  }
  __reflect() {
    return { __tag: 1, __name: "Cons", __data: [this.head_0, this.tail_0] };
  }
  __equals(other12381) {
    if (!other12381) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12381.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.head_0, other12381.head_0))) {
      return false;
    }
    if (!($effekt.equals(this.tail_0, other12381.tail_0))) {
      return false;
    }
    return true;
  }
}

class Error_0 {
  constructor(exception_0, msg_0) {
    this.__tag = 0;
    this.exception_0 = exception_0;
    this.msg_0 = msg_0;
  }
  __reflect() {
    return {
      __tag: 0,
      __name: "Error",
      __data: [this.exception_0, this.msg_0]
    };
  }
  __equals(other12382) {
    if (!other12382) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12382.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.exception_0, other12382.exception_0))) {
      return false;
    }
    if (!($effekt.equals(this.msg_0, other12382.msg_0))) {
      return false;
    }
    return true;
  }
}

class Success_0 {
  constructor(a_0) {
    this.__tag = 1;
    this.a_0 = a_0;
  }
  __reflect() {
    return { __tag: 1, __name: "Success", __data: [this.a_0] };
  }
  __equals(other12383) {
    if (!other12383) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12383.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.a_0, other12383.a_0))) {
      return false;
    }
    return true;
  }
}

class X_0 {
  constructor() {
    this.__tag = 0;
  }
  __reflect() {
    return { __tag: 0, __name: "X", __data: [] };
  }
  __equals(other12384) {
    if (!other12384) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12384.__tag))) {
      return false;
    }
    return true;
  }
}

class O_0 {
  constructor() {
    this.__tag = 1;
  }
  __reflect() {
    return { __tag: 1, __name: "O", __data: [] };
  }
  __equals(other12385) {
    if (!other12385) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12385.__tag))) {
      return false;
    }
    return true;
  }
}

class Rose_0 {
  constructor(a_1, as_0) {
    this.__tag = 0;
    this.a_1 = a_1;
    this.as_0 = as_0;
  }
  __reflect() {
    return { __tag: 0, __name: "Rose", __data: [this.a_1, this.as_0] };
  }
  __equals(other12386) {
    if (!other12386) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other12386.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.a_1, other12386.a_1))) {
      return false;
    }
    if (!($effekt.equals(this.as_0, other12386.as_0))) {
      return false;
    }
    return true;
  }
}

// Complexity of state:
//
//  get: O(1)
//  set: O(1)
//  capture: O(1)
//  restore: O(|write operations since capture|)
const Mem = null

function Arena() {
  const s = {
    root: { value: Mem },
    generation: 0,
    fresh: (v) => {
      const r = {
        value: v,
        generation: s.generation,
        store: s,
        set: (v) => {
          const s = r.store
          const r_gen = r.generation
          const s_gen = s.generation

          if (r_gen == s_gen) {
            r.value = v;
          } else {
            const root = { value: Mem }
            // update store
            s.root.value = { ref: r, value: r.value, generation: r_gen, root: root }
            s.root = root
            r.value = v
            r.generation = s_gen
          }
        }
      };
      return r
    },
    // not implemented
    newRegion: () => s
  };
  return s
}

function snapshot(s) {
  const snap = { store: s, root: s.root, generation: s.generation }
  s.generation = s.generation + 1
  return snap
}

function reroot(n) {
  if (n.value === Mem) return;

  const diff = n.value
  const r = diff.ref
  const v = diff.value
  const g = diff.generation
  const n2 = diff.root
  reroot(n2)
  n.value = Mem
  n2.value = { ref: r, value: r.value, generation: r.generation, root: n}
  r.value = v
  r.generation = g
}

function restore(store, snap) {
  // linear in the number of modifications...
  reroot(snap.root)
  store.root = snap.root
  store.generation = snap.generation + 1
}

// Common Runtime
// --------------
let _prompt = 1;

const TOPLEVEL_K = (x, ks) => { throw { computationIsDone: true, result: x } }
const TOPLEVEL_KS = { prompt: 0, arena: Arena(), rest: null }

function THUNK(f) {
  f.thunk = true
  return f
}

function CAPTURE(body) {
  return (ks, k) => {
    const res = body(x => TRAMPOLINE(() => k(x, ks)))
    if (res instanceof Function) return res
    else throw { computationIsDone: true, result: $effekt.unit }
  }
}

const RETURN = (x, ks) => ks.rest.stack(x, ks.rest)

// HANDLE(ks, ks, (p, ks, k) => { STMT })
function RESET(prog, ks, k) {
  const prompt = _prompt++;
  const rest = { stack: k, prompt: ks.prompt, arena: ks.arena, rest: ks.rest }
  return prog(prompt, { prompt, arena: Arena([]), rest }, RETURN)
}

function SHIFT(p, body, ks, k) {

  // TODO avoid constructing this object
  let meta = { stack: k, prompt: ks.prompt, arena: ks.arena, rest: ks.rest }
  let cont = null

  while (!!meta && meta.prompt !== p) {
    let store = meta.arena
    cont = { stack: meta.stack, prompt: meta.prompt, arena: store, backup: snapshot(store), rest: cont }
    meta = meta.rest
  }
  if (!meta) { throw `Prompt not found ${p}` }

  // package the prompt itself
  let store = meta.arena
  cont = { stack: meta.stack, prompt: meta.prompt, arena: store, backup: snapshot(store), rest: cont }
  meta = meta.rest

  const k1 = meta.stack
  meta.stack = null
  return body(cont, meta, k1)
}

// Rewind stack `cont` back onto `k` :: `ks` and resume with c
function RESUME(cont, c, ks, k) {
  let meta = { stack: k, prompt: ks.prompt, arena: ks.arena, rest: ks.rest }
  let toRewind = cont
  while (!!toRewind) {
    restore(toRewind.arena, toRewind.backup)
    meta = { stack: toRewind.stack, prompt: toRewind.prompt, arena: toRewind.arena, rest: meta }
    toRewind = toRewind.rest
  }

  const k1 = meta.stack // TODO instead copy meta here, like elsewhere?
  meta.stack = null
  return () => c(meta, k1)
}

function RUN_TOPLEVEL(comp) {
  try {
    let a = comp(TOPLEVEL_KS, TOPLEVEL_K)
    while (true) { a = a() }
  } catch (e) {
    if (e.computationIsDone) return e.result
    else throw e
  }
}

// trampolines the given computation (like RUN_TOPLEVEL, but doesn't provide continuations)
function TRAMPOLINE(comp) {
  let a = comp;
  try {
    while (true) {
      a = a()
    }
  } catch (e) {
    if (e.computationIsDone) return e.result
    else throw e
  }
}

// keeps the current trampoline going and dispatches the given task
function RUN(task) {
  return () => task(TOPLEVEL_KS, TOPLEVEL_K)
}

// aborts the current continuation
function ABORT(value) {
  throw { computationIsDone: true, result: value }
}


// "Public API" used in FFI
// ------------------------

/**
 * Captures the current continuation as a WHOLE and makes it available
 * as argument to the passed body. For example:
 *
 *   $effekt.capture(k => ... k(42) ...)
 *
 * The body
 *
 *   $effekt.capture(k => >>> ... <<<)
 *
 * conceptually runs on the _native_ JS call stack. You can call JS functions,
 * like `setTimeout` etc., but you are not expected or required to return an
 * Effekt value like `$effekt.unit`. If you want to run an Effekt computation
 * like in `io::spawn`, you can use `$effekt.run`.
 *
 * Advanced usage details:
 *
 * The value returned by the function passed to `capture` returns
 * - a function: the returned function will be passed to the
 *   Effekt runtime, which performs trampolining.
 *   In this case, the Effekt runtime will keep running, though the
 *   continuation has been removed.
 *
 * - another value (like `undefined`): the Effekt runtime will terminate.
 */
$effekt.capture = CAPTURE

/**
 * Used to call Effekt function arguments in the JS FFI, like in `io::spawn`.
 *
 * Requires an active Effekt runtime (trampoline).
 */
$effekt.run = RUN

/**
 * Used to call Effekt function arguments in the JS FFI, like in `network::listen`.
 *
 * This function should be used when _no_ Effekt runtime is available. For instance,
 * in callbacks passed to the NodeJS eventloop.
 *
 * If a runtime is available, use `$effekt.run`, instead.
 */
$effekt.runToplevel = RUN_TOPLEVEL


$effekt.show = function(obj) {
  if (!!obj && !!obj.__reflect) {
    const meta = obj.__reflect()
    return meta.__name + "(" + meta.__data.map($effekt.show).join(", ") + ")"
  }
  else if (!!obj && obj.__unit) {
    return "()";
  } else {
    return "" + obj;
  }
}

$effekt.equals = function(obj1, obj2) {
  if (!!obj1.__equals) {
    return obj1.__equals(obj2)
  } else {
    return (obj1.__unit && obj2.__unit) || (obj1 === obj2);
  }
}

function compare$prim(n1, n2) {
  if (n1 == n2) { return 0; }
  else if (n1 > n2) { return 1; }
  else { return -1; }
}

$effekt.compare = function(obj1, obj2) {
  if ($effekt.equals(obj1, obj2)) { return 0; }

  if (!!obj1 && !!obj2) {
    if (!!obj1.__reflect && !!obj2.__reflect) {
      const tagOrdering = compare$prim(obj1.__tag, obj2.__tag)
      if (tagOrdering != 0) { return tagOrdering; }

      const meta1 = obj1.__reflect().__data
      const meta2 = obj2.__reflect().__data

      const lengthOrdering = compare$prim(meta1.length, meta2.length)
      if (lengthOrdering != 0) { return lengthOrdering; }

      for (let i = 0; i < meta1.length; i++) {
        const contentOrdering = $effekt.compare(meta1[i], meta2[i])
        if (contentOrdering != 0) { return contentOrdering; }
      }

      return 0;
    }
  }

  return compare$prim(obj1, obj2);
}

$effekt.println = function println$impl(str) {
  console.log(str); return $effekt.unit;
}

$effekt.unit = { __unit: true }

$effekt.emptyMatch = function() { throw "empty match" }

$effekt.hole = function() { throw "not implemented, yet" }


  function array$set(arr, index, value) {
    arr[index] = value;
    return $effekt.unit
  }



  function set$impl(ref, value) {
    ref.value = value;
    return $effekt.unit;
  }


function map_0(l_1, f_0, ks_0, k_2) {
  const acc_0 = ks_0.arena.fresh(new Nil_0());
  function foreach_worker_0(l_0, ks_1, k_0) {
    switch (l_0.__tag) {
      case 0:  return () => k_0($effekt.unit, ks_1);
      case 1: 
        const head_1 = l_0.head_0;
        const tail_1 = l_0.tail_0;
        return f_0(head_1, ks_1, (v_r_0, ks_2) => {
          const s_0 = acc_0.value;
          acc_0.set(new Cons_0(v_r_0, s_0));
          return foreach_worker_0(tail_1, ks_2, k_0);
        });
    }
  }
  return foreach_worker_0(l_1, ks_0, (_0, ks_3) => {
    const s_1 = acc_0.value;
    const res_0 = ks_3.arena.fresh(new Nil_0());
    function foreach_worker_1(l_2, ks_4, k_1) {
      foreach_worker_2: while (true) {
        switch (l_2.__tag) {
          case 0:  return () => k_1($effekt.unit, ks_4);
          case 1: 
            const head_2 = l_2.head_0;
            const tail_2 = l_2.tail_0;
            const s_2 = res_0.value;
            res_0.set(new Cons_0(head_2, s_2));
            /* prepare call */
            l_2 = tail_2;
            continue foreach_worker_2;
        }
      }
    }
    return foreach_worker_1(s_1, ks_3, (_1, ks_5) => {
      const s_3 = res_0.value;
      return () => k_2(s_3, ks_5);
    });
  });
}

function charAt_0(str_0, index_0, Exception_0, ks_6, k_3) {
  if ((index_0 < (0))) {
    return Exception_0.raise_0(new OutOfBounds_0(), ((("Index out of bounds: " + ('' + index_0)) + " in string: '") + str_0) + "'", ks_6, undefined);
  } else if ((index_0 >= (str_0.length))) {
    return Exception_0.raise_0(new OutOfBounds_0(), ((("Index out of bounds: " + ('' + index_0)) + " in string: '") + str_0) + "'", ks_6, undefined);
  } else {
    return () => k_3(str_0.codePointAt(index_0), ks_6);
  }
}

function nth_0(l_3, n_0, ks_7, k_4) {
  nth_1: while (true) {
    switch (l_3.__tag) {
      case 0: 
        const tmp_0 = (function() { throw "Emtpy List" })();
        return () => k_4(tmp_0, ks_7);
      case 1: 
        const a_2 = l_3.head_0;
        const as_1 = l_3.tail_0;
        if (n_0 === (0)) {
          return () => k_4(a_2, ks_7);
        } else {
          /* prepare call */
          const tmp_n_0 = n_0;
          l_3 = as_1;
          n_0 = (tmp_n_0 - (1));
          continue nth_1;
        }
        break;
    }
  }
}

function rows_0(ks_8, k_5) {
  return () =>
    k_5(new Cons_0(new Cons_0(0, new Cons_0(1, new Cons_0(2, new Nil_0()))), new Cons_0(new Cons_0(3, new Cons_0(4, new Cons_0(5, new Nil_0()))), new Cons_0(new Cons_0(6, new Cons_0(7, new Cons_0(8, new Nil_0()))), new Nil_0()))), ks_8);
}

function cols_0(ks_9, k_6) {
  return () =>
    k_6(new Cons_0(new Cons_0(0, new Cons_0(3, new Cons_0(6, new Nil_0()))), new Cons_0(new Cons_0(1, new Cons_0(4, new Cons_0(7, new Nil_0()))), new Cons_0(new Cons_0(2, new Cons_0(5, new Cons_0(8, new Nil_0()))), new Nil_0()))), ks_9);
}

function find_0(l_4, i_0, ks_10, k_7) {
  find_1: while (true) {
    switch (l_4.__tag) {
      case 0:  return () => k_7(new None_0(), ks_10);
      case 1: 
        const p_0 = l_4.head_0;
        const ps_0 = l_4.tail_0;
        if (i_0 === (0)) {
          return () => k_7(p_0, ks_10);
        } else {
          /* prepare call */
          const tmp_i_0 = i_0;
          l_4 = ps_0;
          i_0 = (tmp_i_0 - (1));
          continue find_1;
        }
        break;
    }
  }
}

function all_moves_rec_0(n_1, board_0, acc_1, ks_11, k_9) {
  all_moves_rec_1: while (true) {
    switch (board_0.__tag) {
      case 0: 
        const res_1 = ks_11.arena.fresh(new Nil_0());
        function foreach_worker_3(l_5, ks_12, k_8) {
          foreach_worker_4: while (true) {
            switch (l_5.__tag) {
              case 0:  return () => k_8($effekt.unit, ks_12);
              case 1: 
                const head_3 = l_5.head_0;
                const tail_3 = l_5.tail_0;
                const s_4 = res_1.value;
                res_1.set(new Cons_0(head_3, s_4));
                /* prepare call */
                l_5 = tail_3;
                continue foreach_worker_4;
            }
          }
        }
        return foreach_worker_3(acc_1, ks_11, (_2, ks_13) => {
          const s_5 = res_1.value;
          return () => k_9(s_5, ks_13);
        });
      case 1: 
        const head_4 = board_0.head_0;
        const more_0 = board_0.tail_0;
        switch (head_4.__tag) {
          case 1: 
            /* prepare call */
            const tmp_n_1 = n_1;
            const tmp_acc_0 = acc_1;
            n_1 = (tmp_n_1 + (1));
            board_0 = more_0;
            acc_1 = tmp_acc_0;
            continue all_moves_rec_1;
          case 0: 
            /* prepare call */
            const tmp_n_2 = n_1;
            const tmp_acc_1 = acc_1;
            n_1 = (tmp_n_2 + (1));
            board_0 = more_0;
            acc_1 = new Cons_0(tmp_n_2, tmp_acc_1);
            continue all_moves_rec_1;
        }
        break;
    }
  }
}

function is_win_for_0(board_1, p_2, ks_14, k_13) {
  return rows_0(ks_14, (v_r_1, ks_15) => {
    function exists_worker_0(l_6, ks_16, k_10) {
      switch (l_6.__tag) {
        case 0:  return () => k_10(false, ks_16);
        case 1: 
          const a_3 = l_6.head_0;
          const as_2 = l_6.tail_0;
          function all_worker_0(list_0, ks_17, k_11) {
            switch (list_0.__tag) {
              case 1: 
                const x_0 = list_0.head_0;
                const xs_0 = list_0.tail_0;
                return find_0(board_1, x_0, ks_17, (v_r_2, ks_18) => {
                  switch (v_r_2.__tag) {
                    case 1: 
                      const p_1 = v_r_2.value_0;
                      switch (p_2.__tag) {
                        case 0: 
                          switch (p_1.__tag) {
                            case 0: 
                              return all_worker_0(xs_0, ks_18, k_11);
                            default:  return () => k_11(false, ks_18);
                          }
                          break;
                        case 1: 
                          switch (p_1.__tag) {
                            case 1: 
                              return all_worker_0(xs_0, ks_18, k_11);
                            default:  return () => k_11(false, ks_18);
                          }
                          break;
                        default:  return () => k_11(false, ks_18);
                      }
                      break;
                    case 0:  return () => k_11(false, ks_18);
                  }
                });
              case 0:  return () => k_11(true, ks_17);
            }
          }
          return all_worker_0(a_3, ks_16, (v_r_3, ks_19) => {
            if (v_r_3) {
              return () => k_10(true, ks_19);
            } else {
              return exists_worker_0(as_2, ks_19, k_10);
            }
          });
      }
    }
    return exists_worker_0(v_r_1, ks_15, (v_r_4, ks_20) => {
      function k_12(v_r_5, ks_21) {
        if (v_r_5) {
          return () => k_13(true, ks_21);
        } else {
          return rows_0(ks_21, (v_r_6, ks_22) => {
            function exists_worker_1(l_7, ks_23, k_14) {
              switch (l_7.__tag) {
                case 0:  return () => k_14(false, ks_23);
                case 1: 
                  const a_4 = l_7.head_0;
                  const as_3 = l_7.tail_0;
                  function all_worker_1(list_1, ks_24, k_15) {
                    switch (list_1.__tag) {
                      case 1: 
                        const x_1 = list_1.head_0;
                        const xs_1 = list_1.tail_0;
                        return find_0(board_1, x_1, ks_24, (v_r_7, ks_25) => {
                          switch (v_r_7.__tag) {
                            case 1: 
                              const p_3 = v_r_7.value_0;
                              switch (p_2.__tag) {
                                case 0: 
                                  switch (p_3.__tag) {
                                    case 0: 
                                      return all_worker_1(xs_1, ks_25, k_15);
                                    default: 
                                      return () => k_15(false, ks_25);
                                  }
                                  break;
                                case 1: 
                                  switch (p_3.__tag) {
                                    case 1: 
                                      return all_worker_1(xs_1, ks_25, k_15);
                                    default: 
                                      return () => k_15(false, ks_25);
                                  }
                                  break;
                                default:  return () => k_15(false, ks_25);
                              }
                              break;
                            case 0:  return () => k_15(false, ks_25);
                          }
                        });
                      case 0:  return () => k_15(true, ks_24);
                    }
                  }
                  return all_worker_1(a_4, ks_23, (v_r_8, ks_26) => {
                    if (v_r_8) {
                      return () => k_14(true, ks_26);
                    } else {
                      return exists_worker_1(as_3, ks_26, k_14);
                    }
                  });
              }
            }
            return exists_worker_1(v_r_6, ks_22, k_13);
          });
        }
      }
      if (v_r_4) {
        return () => k_12(true, ks_20);
      } else {
        return cols_0(ks_20, (v_r_9, ks_27) => {
          function exists_worker_2(l_8, ks_28, k_16) {
            switch (l_8.__tag) {
              case 0:  return () => k_16(false, ks_28);
              case 1: 
                const a_5 = l_8.head_0;
                const as_4 = l_8.tail_0;
                function all_worker_2(list_2, ks_29, k_17) {
                  switch (list_2.__tag) {
                    case 1: 
                      const x_2 = list_2.head_0;
                      const xs_2 = list_2.tail_0;
                      return find_0(board_1, x_2, ks_29, (v_r_10, ks_30) => {
                        switch (v_r_10.__tag) {
                          case 1: 
                            const p_4 = v_r_10.value_0;
                            switch (p_2.__tag) {
                              case 0: 
                                switch (p_4.__tag) {
                                  case 0: 
                                    return all_worker_2(xs_2, ks_30, k_17);
                                  default: 
                                    return () => k_17(false, ks_30);
                                }
                                break;
                              case 1: 
                                switch (p_4.__tag) {
                                  case 1: 
                                    return all_worker_2(xs_2, ks_30, k_17);
                                  default: 
                                    return () => k_17(false, ks_30);
                                }
                                break;
                              default:  return () => k_17(false, ks_30);
                            }
                            break;
                          case 0:  return () => k_17(false, ks_30);
                        }
                      });
                    case 0:  return () => k_17(true, ks_29);
                  }
                }
                return all_worker_2(a_5, ks_28, (v_r_11, ks_31) => {
                  if (v_r_11) {
                    return () => k_16(true, ks_31);
                  } else {
                    return exists_worker_2(as_4, ks_31, k_16);
                  }
                });
            }
          }
          return exists_worker_2(v_r_9, ks_27, k_12);
        });
      }
    });
  });
}

function minimax_0(p_11, board_2, ks_32, k_24) {
  return is_win_for_0(board_2, new X_0(), ks_32, (v_r_12, ks_33) => {
    function k_18(v_r_13, ks_34) {
      function k_19(v_r_14, ks_35) {
        if (v_r_14) {
          return rows_0(ks_35, (v_r_15, ks_36) => {
            function exists_worker_3(l_9, ks_37, k_20) {
              switch (l_9.__tag) {
                case 0:  return () => k_20(false, ks_37);
                case 1: 
                  const a_6 = l_9.head_0;
                  const as_5 = l_9.tail_0;
                  function all_worker_3(list_3, ks_38, k_21) {
                    switch (list_3.__tag) {
                      case 1: 
                        const x_3 = list_3.head_0;
                        const xs_3 = list_3.tail_0;
                        return find_0(board_2, x_3, ks_38, (v_r_16, ks_39) => {
                          switch (v_r_16.__tag) {
                            case 1: 
                              const p_5 = v_r_16.value_0;
                              switch (p_5.__tag) {
                                case 0: 
                                  return all_worker_3(xs_3, ks_39, k_21);
                                default:  return () => k_21(false, ks_39);
                              }
                              break;
                            case 0:  return () => k_21(false, ks_39);
                          }
                        });
                      case 0:  return () => k_21(true, ks_38);
                    }
                  }
                  return all_worker_3(a_6, ks_37, (v_r_17, ks_40) => {
                    if (v_r_17) {
                      return () => k_20(true, ks_40);
                    } else {
                      return exists_worker_3(as_5, ks_40, k_20);
                    }
                  });
              }
            }
            return exists_worker_3(v_r_15, ks_36, (v_r_18, ks_41) => {
              function k_22(v_r_19, ks_42) {
                function k_23(v_r_20, ks_43) {
                  if (v_r_20) {
                    return () =>
                      k_24(new Rose_0(new Tuple_0(board_2, 1), new Nil_0()), ks_43);
                  } else {
                    return rows_0(ks_43, (v_r_21, ks_44) => {
                      function exists_worker_4(l_10, ks_45, k_25) {
                        switch (l_10.__tag) {
                          case 0:  return () => k_25(false, ks_45);
                          case 1: 
                            const a_7 = l_10.head_0;
                            const as_6 = l_10.tail_0;
                            function all_worker_4(list_4, ks_46, k_26) {
                              switch (list_4.__tag) {
                                case 1: 
                                  const x_4 = list_4.head_0;
                                  const xs_4 = list_4.tail_0;
                                  return find_0(board_2, x_4, ks_46, (v_r_22, ks_47) => {
                                    switch (v_r_22.__tag) {
                                      case 1: 
                                        const p_6 = v_r_22.value_0;
                                        switch (p_6.__tag) {
                                          case 1: 
                                            return all_worker_4(xs_4, ks_47, k_26);
                                          default: 
                                            return () => k_26(false, ks_47);
                                        }
                                        break;
                                      case 0: 
                                        return () => k_26(false, ks_47);
                                    }
                                  });
                                case 0:  return () => k_26(true, ks_46);
                              }
                            }
                            return all_worker_4(a_7, ks_45, (v_r_23, ks_48) => {
                              if (v_r_23) {
                                return () => k_25(true, ks_48);
                              } else {
                                return exists_worker_4(as_6, ks_48, k_25);
                              }
                            });
                        }
                      }
                      return exists_worker_4(v_r_21, ks_44, (v_r_24, ks_49) => {
                        function k_27(v_r_25, ks_50) {
                          function k_28(v_r_26, ks_51) {
                            if (v_r_26) {
                              return () =>
                                k_24(new Rose_0(new Tuple_0(board_2, -1), new Nil_0()), ks_51);
                            } else {
                              return () =>
                                k_24(new Rose_0(new Tuple_0(board_2, 0), new Nil_0()), ks_51);
                            }
                          }
                          if (v_r_25) {
                            return () => k_28(true, ks_50);
                          } else {
                            return rows_0(ks_50, (v_r_27, ks_52) => {
                              function exists_worker_5(l_11, ks_53, k_29) {
                                switch (l_11.__tag) {
                                  case 0:  return () => k_29(false, ks_53);
                                  case 1: 
                                    const a_8 = l_11.head_0;
                                    const as_7 = l_11.tail_0;
                                    function all_worker_5(list_5, ks_54, k_30) {
                                      switch (list_5.__tag) {
                                        case 1: 
                                          const x_5 = list_5.head_0;
                                          const xs_5 = list_5.tail_0;
                                          return find_0(board_2, x_5, ks_54, (v_r_28, ks_55) => {
                                            switch (v_r_28.__tag) {
                                              case 1: 
                                                const p_7 = v_r_28.value_0;
                                                switch (p_7.__tag) {
                                                  case 1: 
                                                    return all_worker_5(xs_5, ks_55, k_30);
                                                  default: 
                                                    return () =>
                                                      k_30(false, ks_55);
                                                }
                                                break;
                                              case 0: 
                                                return () =>
                                                  k_30(false, ks_55);
                                            }
                                          });
                                        case 0: 
                                          return () => k_30(true, ks_54);
                                      }
                                    }
                                    return all_worker_5(a_8, ks_53, (v_r_29, ks_56) => {
                                      if (v_r_29) {
                                        return () => k_29(true, ks_56);
                                      } else {
                                        return exists_worker_5(as_7, ks_56, k_29);
                                      }
                                    });
                                }
                              }
                              return exists_worker_5(v_r_27, ks_52, k_28);
                            });
                          }
                        }
                        if (v_r_24) {
                          return () => k_27(true, ks_49);
                        } else {
                          return cols_0(ks_49, (v_r_30, ks_57) => {
                            function exists_worker_6(l_12, ks_58, k_31) {
                              switch (l_12.__tag) {
                                case 0:  return () => k_31(false, ks_58);
                                case 1: 
                                  const a_9 = l_12.head_0;
                                  const as_8 = l_12.tail_0;
                                  function all_worker_6(list_6, ks_59, k_32) {
                                    switch (list_6.__tag) {
                                      case 1: 
                                        const x_6 = list_6.head_0;
                                        const xs_6 = list_6.tail_0;
                                        return find_0(board_2, x_6, ks_59, (v_r_31, ks_60) => {
                                          switch (v_r_31.__tag) {
                                            case 1: 
                                              const p_8 = v_r_31.value_0;
                                              switch (p_8.__tag) {
                                                case 1: 
                                                  return all_worker_6(xs_6, ks_60, k_32);
                                                default: 
                                                  return () =>
                                                    k_32(false, ks_60);
                                              }
                                              break;
                                            case 0: 
                                              return () =>
                                                k_32(false, ks_60);
                                          }
                                        });
                                      case 0: 
                                        return () => k_32(true, ks_59);
                                    }
                                  }
                                  return all_worker_6(a_9, ks_58, (v_r_32, ks_61) => {
                                    if (v_r_32) {
                                      return () => k_31(true, ks_61);
                                    } else {
                                      return exists_worker_6(as_8, ks_61, k_31);
                                    }
                                  });
                              }
                            }
                            return exists_worker_6(v_r_30, ks_57, k_27);
                          });
                        }
                      });
                    });
                  }
                }
                if (v_r_19) {
                  return () => k_23(true, ks_42);
                } else {
                  return rows_0(ks_42, (v_r_33, ks_62) => {
                    function exists_worker_7(l_13, ks_63, k_33) {
                      switch (l_13.__tag) {
                        case 0:  return () => k_33(false, ks_63);
                        case 1: 
                          const a_10 = l_13.head_0;
                          const as_9 = l_13.tail_0;
                          function all_worker_7(list_7, ks_64, k_34) {
                            switch (list_7.__tag) {
                              case 1: 
                                const x_7 = list_7.head_0;
                                const xs_7 = list_7.tail_0;
                                return find_0(board_2, x_7, ks_64, (v_r_34, ks_65) => {
                                  switch (v_r_34.__tag) {
                                    case 1: 
                                      const p_9 = v_r_34.value_0;
                                      switch (p_9.__tag) {
                                        case 0: 
                                          return all_worker_7(xs_7, ks_65, k_34);
                                        default: 
                                          return () => k_34(false, ks_65);
                                      }
                                      break;
                                    case 0: 
                                      return () => k_34(false, ks_65);
                                  }
                                });
                              case 0:  return () => k_34(true, ks_64);
                            }
                          }
                          return all_worker_7(a_10, ks_63, (v_r_35, ks_66) => {
                            if (v_r_35) {
                              return () => k_33(true, ks_66);
                            } else {
                              return exists_worker_7(as_9, ks_66, k_33);
                            }
                          });
                      }
                    }
                    return exists_worker_7(v_r_33, ks_62, k_23);
                  });
                }
              }
              if (v_r_18) {
                return () => k_22(true, ks_41);
              } else {
                return cols_0(ks_41, (v_r_36, ks_67) => {
                  function exists_worker_8(l_14, ks_68, k_35) {
                    switch (l_14.__tag) {
                      case 0:  return () => k_35(false, ks_68);
                      case 1: 
                        const a_11 = l_14.head_0;
                        const as_10 = l_14.tail_0;
                        function all_worker_8(list_8, ks_69, k_36) {
                          switch (list_8.__tag) {
                            case 1: 
                              const x_8 = list_8.head_0;
                              const xs_8 = list_8.tail_0;
                              return find_0(board_2, x_8, ks_69, (v_r_37, ks_70) => {
                                switch (v_r_37.__tag) {
                                  case 1: 
                                    const p_10 = v_r_37.value_0;
                                    switch (p_10.__tag) {
                                      case 0: 
                                        return all_worker_8(xs_8, ks_70, k_36);
                                      default: 
                                        return () => k_36(false, ks_70);
                                    }
                                    break;
                                  case 0:  return () => k_36(false, ks_70);
                                }
                              });
                            case 0:  return () => k_36(true, ks_69);
                          }
                        }
                        return all_worker_8(a_11, ks_68, (v_r_38, ks_71) => {
                          if (v_r_38) {
                            return () => k_35(true, ks_71);
                          } else {
                            return exists_worker_8(as_10, ks_71, k_35);
                          }
                        });
                    }
                  }
                  return exists_worker_8(v_r_36, ks_67, k_22);
                });
              }
            });
          });
        } else {
          return all_moves_rec_0(0, board_2, new Nil_0(), ks_35, (v_r_39, ks_72) =>
            map_0(v_r_39, (i_1, ks_73, k_37) =>
              nth_0(board_2, i_1, ks_73, (v_r_40, ks_74) => {
                let v_r_41 = undefined;
                switch (v_r_40.__tag) {
                  case 0:  v_r_41 = false;break;
                  case 1:  v_r_41 = true;break;
                }
                if (v_r_41) {
                  return () => k_37(new Nil_0(), ks_74);
                } else {
                  function put_at_worker_0(xs_9, i_2, ks_75, k_38) {
                    put_at_worker_1: while (true) {
                      if (i_2 === (0)) {
                        switch (xs_9.__tag) {
                          case 0: 
                            const tmp_1 = (function() { throw "Empty List" })();
                            return () => k_38(tmp_1, ks_75);
                          case 1: 
                            const as_11 = xs_9.tail_0;
                            return () =>
                              k_38(new Cons_0(new Some_0(p_11), as_11), ks_75);
                        }
                      } else if (((0) < i_2)) {
                        switch (xs_9.__tag) {
                          case 0: 
                            const tmp_2 = (function() { throw "Empty List" })();
                            return () => k_38(tmp_2, ks_75);
                          case 1: 
                            const a_12 = xs_9.head_0;
                            switch (xs_9.__tag) {
                              case 0: 
                                const tmp_3 = (function() { throw "Empty List" })();
                                return () => k_38(tmp_3, ks_75);
                              case 1: 
                                const as_12 = xs_9.tail_0;
                                /* prepare call */
                                const tmp_i_1 = i_2;
                                const tmp_k_0 = k_38;
                                k_38 = (v_r_42, ks_76) =>
                                  () =>
                                    tmp_k_0(new Cons_0(a_12, v_r_42), ks_76);
                                xs_9 = as_12;
                                i_2 = (tmp_i_1 - (1));
                                continue put_at_worker_1;
                            }
                            break;
                        }
                      } else {
                        return () => k_38(new Nil_0(), ks_75);
                      }
                    }
                  }
                  return put_at_worker_0(board_2, i_1, ks_74, k_37);
                }
              }), ks_72, (v_r_43, ks_77) =>
              map_0(v_r_43, (b_0, ks_78, k_39) => {
                switch (p_11.__tag) {
                  case 0:  return minimax_0(new O_0(), b_0, ks_78, k_39);
                  case 1:  return minimax_0(new X_0(), b_0, ks_78, k_39);
                }
              }, ks_77, (trees_0, ks_79) =>
                map_0(trees_0, (t_0, ks_80, k_40) => {
                  const p_12 = t_0.a_1;
                  const b_1 = p_12.second_0;
                  return () => k_40(b_1, ks_80);
                }, ks_79, (scores_0, ks_81) => {
                  switch (p_11.__tag) {
                    case 0: 
                      switch (scores_0.__tag) {
                        case 0: 
                          const tmp_4 = (function() { throw "Empty List" })();
                          return () => k_24(tmp_4, ks_81);
                        case 1: 
                          const i_3 = scores_0.head_0;
                          const is_0 = scores_0.tail_0;
                          const acc_2 = ks_81.arena.fresh(i_3);
                          function foreach_worker_5(l_15, ks_82, k_41) {
                            foreach_worker_6: while (true) {
                              switch (l_15.__tag) {
                                case 0: 
                                  return () => k_41($effekt.unit, ks_82);
                                case 1: 
                                  const head_5 = l_15.head_0;
                                  const tail_4 = l_15.tail_0;
                                  const s_6 = acc_2.value;
                                  if ((head_5 < s_6)) {
                                    acc_2.set(s_6);
                                    /* prepare call */
                                    l_15 = tail_4;
                                    continue foreach_worker_6;
                                  } else {
                                    acc_2.set(head_5);
                                    /* prepare call */
                                    l_15 = tail_4;
                                    continue foreach_worker_6;
                                  }
                                  break;
                              }
                            }
                          }
                          return foreach_worker_5(is_0, ks_81, (_3, ks_83) => {
                            const s_7 = acc_2.value;
                            return () =>
                              k_24(new Rose_0(new Tuple_0(board_2, s_7), trees_0), ks_83);
                          });
                      }
                      break;
                    case 1: 
                      switch (scores_0.__tag) {
                        case 0: 
                          const tmp_5 = (function() { throw "Empty List" })();
                          return () => k_24(tmp_5, ks_81);
                        case 1: 
                          const i_4 = scores_0.head_0;
                          const is_1 = scores_0.tail_0;
                          const acc_3 = ks_81.arena.fresh(i_4);
                          function foreach_worker_7(l_16, ks_84, k_42) {
                            foreach_worker_8: while (true) {
                              switch (l_16.__tag) {
                                case 0: 
                                  return () => k_42($effekt.unit, ks_84);
                                case 1: 
                                  const head_6 = l_16.head_0;
                                  const tail_5 = l_16.tail_0;
                                  const s_8 = acc_3.value;
                                  if ((s_8 < head_6)) {
                                    acc_3.set(s_8);
                                    /* prepare call */
                                    l_16 = tail_5;
                                    continue foreach_worker_8;
                                  } else {
                                    acc_3.set(head_6);
                                    /* prepare call */
                                    l_16 = tail_5;
                                    continue foreach_worker_8;
                                  }
                                  break;
                              }
                            }
                          }
                          return foreach_worker_7(is_1, ks_81, (_4, ks_85) => {
                            const s_9 = acc_3.value;
                            return () =>
                              k_24(new Rose_0(new Tuple_0(board_2, s_9), trees_0), ks_85);
                          });
                      }
                      break;
                  }
                }))));
        }
      }
      if (v_r_13) {
        return () => k_19(true, ks_34);
      } else {
        function all_worker_9(list_9, ks_86, k_43) {
          all_worker_10: while (true) {
            switch (list_9.__tag) {
              case 1: 
                const x_9 = list_9.head_0;
                const xs_10 = list_9.tail_0;
                switch (x_9.__tag) {
                  case 0:  return () => k_43(false, ks_86);
                  case 1: 
                    /* prepare call */
                    list_9 = xs_10;
                    continue all_worker_10;
                }
                break;
              case 0:  return () => k_43(true, ks_86);
            }
          }
        }
        return all_worker_9(board_2, ks_34, (v_r_44, ks_87) => {
          function l_17(v_r_45, ks_88) {
            if (v_r_45) {
              return rows_0(ks_88, (v_r_46, ks_89) => {
                function exists_worker_9(l_18, ks_90, k_44) {
                  switch (l_18.__tag) {
                    case 0:  return () => k_44(false, ks_90);
                    case 1: 
                      const a_13 = l_18.head_0;
                      const as_13 = l_18.tail_0;
                      function all_worker_11(list_10, ks_91, k_45) {
                        switch (list_10.__tag) {
                          case 1: 
                            const x_10 = list_10.head_0;
                            const xs_11 = list_10.tail_0;
                            return find_0(board_2, x_10, ks_91, (v_r_47, ks_92) => {
                              switch (v_r_47.__tag) {
                                case 1: 
                                  const p_13 = v_r_47.value_0;
                                  switch (p_13.__tag) {
                                    case 1: 
                                      return all_worker_11(xs_11, ks_92, k_45);
                                    default: 
                                      return () => k_45(false, ks_92);
                                  }
                                  break;
                                case 0:  return () => k_45(false, ks_92);
                              }
                            });
                          case 0:  return () => k_45(true, ks_91);
                        }
                      }
                      return all_worker_11(a_13, ks_90, (v_r_48, ks_93) => {
                        if (v_r_48) {
                          return () => k_44(true, ks_93);
                        } else {
                          return exists_worker_9(as_13, ks_93, k_44);
                        }
                      });
                  }
                }
                return exists_worker_9(v_r_46, ks_89, (v_r_49, ks_94) => {
                  function k_46(v_r_50, ks_95) {
                    if (v_r_50) {
                      return () => k_19(!(true), ks_95);
                    } else {
                      return rows_0(ks_95, (v_r_51, ks_96) => {
                        function exists_worker_10(l_19, ks_97, k_47) {
                          switch (l_19.__tag) {
                            case 0:  return () => k_47(false, ks_97);
                            case 1: 
                              const a_14 = l_19.head_0;
                              const as_14 = l_19.tail_0;
                              function all_worker_12(list_11, ks_98, k_48) {
                                switch (list_11.__tag) {
                                  case 1: 
                                    const x_11 = list_11.head_0;
                                    const xs_12 = list_11.tail_0;
                                    return find_0(board_2, x_11, ks_98, (v_r_52, ks_99) => {
                                      switch (v_r_52.__tag) {
                                        case 1: 
                                          const p_14 = v_r_52.value_0;
                                          switch (p_14.__tag) {
                                            case 1: 
                                              return all_worker_12(xs_12, ks_99, k_48);
                                            default: 
                                              return () =>
                                                k_48(false, ks_99);
                                          }
                                          break;
                                        case 0: 
                                          return () => k_48(false, ks_99);
                                      }
                                    });
                                  case 0:  return () => k_48(true, ks_98);
                                }
                              }
                              return all_worker_12(a_14, ks_97, (v_r_53, ks_100) => {
                                if (v_r_53) {
                                  return () => k_47(true, ks_100);
                                } else {
                                  return exists_worker_10(as_14, ks_100, k_47);
                                }
                              });
                          }
                        }
                        return exists_worker_10(v_r_51, ks_96, (v_r_54, ks_101) =>
                          () => k_19(!v_r_54, ks_101));
                      });
                    }
                  }
                  if (v_r_49) {
                    return () => k_46(true, ks_94);
                  } else {
                    return cols_0(ks_94, (v_r_55, ks_102) => {
                      function exists_worker_11(l_20, ks_103, k_49) {
                        switch (l_20.__tag) {
                          case 0:  return () => k_49(false, ks_103);
                          case 1: 
                            const a_15 = l_20.head_0;
                            const as_15 = l_20.tail_0;
                            function all_worker_13(list_12, ks_104, k_50) {
                              switch (list_12.__tag) {
                                case 1: 
                                  const x_12 = list_12.head_0;
                                  const xs_13 = list_12.tail_0;
                                  return find_0(board_2, x_12, ks_104, (v_r_56, ks_105) => {
                                    switch (v_r_56.__tag) {
                                      case 1: 
                                        const p_15 = v_r_56.value_0;
                                        switch (p_15.__tag) {
                                          case 1: 
                                            return all_worker_13(xs_13, ks_105, k_50);
                                          default: 
                                            return () =>
                                              k_50(false, ks_105);
                                        }
                                        break;
                                      case 0: 
                                        return () => k_50(false, ks_105);
                                    }
                                  });
                                case 0:  return () => k_50(true, ks_104);
                              }
                            }
                            return all_worker_13(a_15, ks_103, (v_r_57, ks_106) => {
                              if (v_r_57) {
                                return () => k_49(true, ks_106);
                              } else {
                                return exists_worker_11(as_15, ks_106, k_49);
                              }
                            });
                        }
                      }
                      return exists_worker_11(v_r_55, ks_102, k_46);
                    });
                  }
                });
              });
            } else {
              return () => k_19(false, ks_88);
            }
          }
          if (v_r_44) {
            return rows_0(ks_87, (v_r_58, ks_107) => {
              function exists_worker_12(l_21, ks_108, k_51) {
                switch (l_21.__tag) {
                  case 0:  return () => k_51(false, ks_108);
                  case 1: 
                    const a_16 = l_21.head_0;
                    const as_16 = l_21.tail_0;
                    function all_worker_14(list_13, ks_109, k_52) {
                      switch (list_13.__tag) {
                        case 1: 
                          const x_13 = list_13.head_0;
                          const xs_14 = list_13.tail_0;
                          return find_0(board_2, x_13, ks_109, (v_r_59, ks_110) => {
                            switch (v_r_59.__tag) {
                              case 1: 
                                const p_16 = v_r_59.value_0;
                                switch (p_16.__tag) {
                                  case 0: 
                                    return all_worker_14(xs_14, ks_110, k_52);
                                  default: 
                                    return () => k_52(false, ks_110);
                                }
                                break;
                              case 0:  return () => k_52(false, ks_110);
                            }
                          });
                        case 0:  return () => k_52(true, ks_109);
                      }
                    }
                    return all_worker_14(a_16, ks_108, (v_r_60, ks_111) => {
                      if (v_r_60) {
                        return () => k_51(true, ks_111);
                      } else {
                        return exists_worker_12(as_16, ks_111, k_51);
                      }
                    });
                }
              }
              return exists_worker_12(v_r_58, ks_107, (v_r_61, ks_112) => {
                function k_53(v_r_62, ks_113) {
                  function k_54(v_r_63, ks_114) {
                    return () => l_17(!v_r_63, ks_114);
                  }
                  if (v_r_62) {
                    return () => k_54(true, ks_113);
                  } else {
                    return rows_0(ks_113, (v_r_64, ks_115) => {
                      function exists_worker_13(l_22, ks_116, k_55) {
                        switch (l_22.__tag) {
                          case 0:  return () => k_55(false, ks_116);
                          case 1: 
                            const a_17 = l_22.head_0;
                            const as_17 = l_22.tail_0;
                            function all_worker_15(list_14, ks_117, k_56) {
                              switch (list_14.__tag) {
                                case 1: 
                                  const x_14 = list_14.head_0;
                                  const xs_15 = list_14.tail_0;
                                  return find_0(board_2, x_14, ks_117, (v_r_65, ks_118) => {
                                    switch (v_r_65.__tag) {
                                      case 1: 
                                        const p_17 = v_r_65.value_0;
                                        switch (p_17.__tag) {
                                          case 0: 
                                            return all_worker_15(xs_15, ks_118, k_56);
                                          default: 
                                            return () =>
                                              k_56(false, ks_118);
                                        }
                                        break;
                                      case 0: 
                                        return () => k_56(false, ks_118);
                                    }
                                  });
                                case 0:  return () => k_56(true, ks_117);
                              }
                            }
                            return all_worker_15(a_17, ks_116, (v_r_66, ks_119) => {
                              if (v_r_66) {
                                return () => k_55(true, ks_119);
                              } else {
                                return exists_worker_13(as_17, ks_119, k_55);
                              }
                            });
                        }
                      }
                      return exists_worker_13(v_r_64, ks_115, k_54);
                    });
                  }
                }
                if (v_r_61) {
                  return () => k_53(true, ks_112);
                } else {
                  return cols_0(ks_112, (v_r_67, ks_120) => {
                    function exists_worker_14(l_23, ks_121, k_57) {
                      switch (l_23.__tag) {
                        case 0:  return () => k_57(false, ks_121);
                        case 1: 
                          const a_18 = l_23.head_0;
                          const as_18 = l_23.tail_0;
                          function all_worker_16(list_15, ks_122, k_58) {
                            switch (list_15.__tag) {
                              case 1: 
                                const x_15 = list_15.head_0;
                                const xs_16 = list_15.tail_0;
                                return find_0(board_2, x_15, ks_122, (v_r_68, ks_123) => {
                                  switch (v_r_68.__tag) {
                                    case 1: 
                                      const p_18 = v_r_68.value_0;
                                      switch (p_18.__tag) {
                                        case 0: 
                                          return all_worker_16(xs_16, ks_123, k_58);
                                        default: 
                                          return () => k_58(false, ks_123);
                                      }
                                      break;
                                    case 0: 
                                      return () => k_58(false, ks_123);
                                  }
                                });
                              case 0:  return () => k_58(true, ks_122);
                            }
                          }
                          return all_worker_16(a_18, ks_121, (v_r_69, ks_124) => {
                            if (v_r_69) {
                              return () => k_57(true, ks_124);
                            } else {
                              return exists_worker_14(as_18, ks_124, k_57);
                            }
                          });
                      }
                    }
                    return exists_worker_14(v_r_67, ks_120, k_53);
                  });
                }
              });
            });
          } else {
            return () => l_17(false, ks_87);
          }
        });
      }
    }
    if (v_r_12) {
      return () => k_18(true, ks_33);
    } else {
      return is_win_for_0(board_2, new O_0(), ks_33, k_18);
    }
  });
}

function main_loop_0(iters_0, ks_125, k_59) {
  return minimax_0(new X_0(), new Nil_0(), ks_125, (res_2, ks_126) => {
    if (iters_0 === (1)) {
      const p_19 = res_2.a_1;
      const b_2 = p_19.second_0;
      const tmp_6 = $effekt.println(('' + b_2));
      return () => k_59(tmp_6, ks_126);
    } else {
      return main_loop_0((iters_0 - (1)), ks_126, k_59);
    }
  });
}

function main_0(ks_128, k_74) {
  const tmp_7 = process.argv.slice(1);
  const tmp_8 = tmp_7.length;
  function toList_worker_0(start_0, acc_4, ks_127, k_60) {
    toList_worker_1: while (true) {
      if ((start_0 < (1))) {
        return () => k_60(acc_4, ks_127);
      } else {
        const tmp_9 = tmp_7[start_0];
        /* prepare call */
        const tmp_start_0 = start_0;
        const tmp_acc_2 = acc_4;
        start_0 = (tmp_start_0 - (1));
        acc_4 = new Cons_0(tmp_9, tmp_acc_2);
        continue toList_worker_1;
      }
    }
  }
  return toList_worker_0((tmp_8 - (1)), new Nil_0(), ks_128, (v_r_70, ks_129) => {
    switch (v_r_70.__tag) {
      case 1: 
        const iters_str_0 = v_r_70.head_0;
        const tail_6 = v_r_70.tail_0;
        switch (tail_6.__tag) {
          case 0: 
            return RESET((p_20, ks_130, k_61) => {
              function go_0(index_1, acc_5, ks_135, k_66) {
                return RESET((p_21, ks_131, k_62) => {
                  const Exception_1 = {
                    raise_0: (exc_0, msg_1, ks_132, k_63) =>
                      SHIFT(p_21, (k_64, ks_133, k_65) =>
                        () => k_65(new Error_0(exc_0, msg_1), ks_133), ks_132, undefined)
                  };
                  return charAt_0(iters_str_0, index_1, Exception_1, ks_131, (v_r_71, ks_134) =>
                    () => k_62(new Success_0(v_r_71), ks_134));
                }, ks_135, (v_r_72, ks_136) => {
                  switch (v_r_72.__tag) {
                    case 1: 
                      const c_0 = v_r_72.a_0;
                      if ((c_0 >= (48))) if ((c_0 <= (57))) {
                        return go_0((index_1 + (1)), ((((10) * acc_5)) + (((c_0) - ((48))))), ks_136, k_66);
                      } else {
                        return SHIFT(p_20, (k_67, ks_137, k_68) => {
                          const tmp_10 = (function() { throw (("Not a valid number: '" + iters_str_0) + "'") })();
                          return () => k_68(tmp_10, ks_137);
                        }, ks_136, undefined);
                      } else {
                        return SHIFT(p_20, (k_69, ks_138, k_70) => {
                          const tmp_11 = (function() { throw (("Not a valid number: '" + iters_str_0) + "'") })();
                          return () => k_70(tmp_11, ks_138);
                        }, ks_136, undefined);
                      }
                      break;
                    case 0:  return () => k_66(acc_5, ks_136);
                  }
                });
              }
              const Exception_2 = {
                raise_0: (exception_1, msg_2, ks_139, k_71) =>
                  SHIFT(p_20, (k_72, ks_140, k_73) => {
                    const tmp_12 = (function() { throw "Empty string is not a valid number" })();
                    return () => k_73(tmp_12, ks_140);
                  }, ks_139, undefined)
              };
              return charAt_0(iters_str_0, 0, Exception_2, ks_130, (v_r_73, ks_141) => {
                if (v_r_73 === (45)) {
                  return go_0(1, 0, ks_141, (v_r_74, ks_142) =>
                    () => k_61(((0) - v_r_74), ks_142));
                } else {
                  return go_0(0, 0, ks_141, k_61);
                }
              });
            }, ks_129, (iters_1, ks_143) =>
              main_loop_0(iters_1, ks_143, k_74));
          default: 
            const tmp_13 = (function() { throw "Expected argument \"iters\"" })();
            return () => k_74(tmp_13, ks_129);
        }
        break;
      default: 
        const tmp_14 = (function() { throw "Expected argument \"iters\"" })();
        return () => k_74(tmp_14, ks_129);
    }
  });
}

(typeof module != "undefined" && module !== null ? module : {}).exports = $Minimax = {
  main: () => RUN_TOPLEVEL(main_0)
};