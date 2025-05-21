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
  __equals(other16084) {
    if (!other16084) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16084.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.first_0, other16084.first_0))) {
      return false;
    }
    if (!($effekt.equals(this.second_0, other16084.second_0))) {
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
  __equals(other16085) {
    if (!other16085) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16085.__tag))) {
      return false;
    }
    return true;
  }
}

class WrongFormat_0 {
  constructor() {
    this.__tag = 0;
  }
  __reflect() {
    return { __tag: 0, __name: "WrongFormat", __data: [] };
  }
  __equals(other16086) {
    if (!other16086) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16086.__tag))) {
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
  __equals(other16087) {
    if (!other16087) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16087.__tag))) {
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
  __equals(other16088) {
    if (!other16088) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16088.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.value_0, other16088.value_0))) {
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
  __equals(other16089) {
    if (!other16089) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16089.__tag))) {
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
  __equals(other16090) {
    if (!other16090) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16090.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.head_0, other16090.head_0))) {
      return false;
    }
    if (!($effekt.equals(this.tail_0, other16090.tail_0))) {
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
  __equals(other16091) {
    if (!other16091) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16091.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.exception_0, other16091.exception_0))) {
      return false;
    }
    if (!($effekt.equals(this.msg_0, other16091.msg_0))) {
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
  __equals(other16092) {
    if (!other16092) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16092.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.a_0, other16092.a_0))) {
      return false;
    }
    return true;
  }
}

class Assign_0 {
  constructor(varr_0, value_1) {
    this.__tag = 0;
    this.varr_0 = varr_0;
    this.value_1 = value_1;
  }
  __reflect() {
    return {
      __tag: 0,
      __name: "Assign",
      __data: [this.varr_0, this.value_1]
    };
  }
  __equals(other16093) {
    if (!other16093) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16093.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.varr_0, other16093.varr_0))) {
      return false;
    }
    if (!($effekt.equals(this.value_1, other16093.value_1))) {
      return false;
    }
    return true;
  }
}

class CSP_0 {
  constructor(vars_0, vals_0, rel_0) {
    this.__tag = 0;
    this.vars_0 = vars_0;
    this.vals_0 = vals_0;
    this.rel_0 = rel_0;
  }
  __reflect() {
    return {
      __tag: 0,
      __name: "CSP",
      __data: [this.vars_0, this.vals_0, this.rel_0]
    };
  }
  __equals(other16094) {
    if (!other16094) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16094.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.vars_0, other16094.vars_0))) {
      return false;
    }
    if (!($effekt.equals(this.vals_0, other16094.vals_0))) {
      return false;
    }
    if (!($effekt.equals(this.rel_0, other16094.rel_0))) {
      return false;
    }
    return true;
  }
}

class Node_0 {
  constructor(lab_0, children_0) {
    this.__tag = 0;
    this.lab_0 = lab_0;
    this.children_0 = children_0;
  }
  __reflect() {
    return {
      __tag: 0,
      __name: "Node",
      __data: [this.lab_0, this.children_0]
    };
  }
  __equals(other16095) {
    if (!other16095) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16095.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.lab_0, other16095.lab_0))) {
      return false;
    }
    if (!($effekt.equals(this.children_0, other16095.children_0))) {
      return false;
    }
    return true;
  }
}

class Known_0 {
  constructor(vs_0) {
    this.__tag = 0;
    this.vs_0 = vs_0;
  }
  __reflect() {
    return { __tag: 0, __name: "Known", __data: [this.vs_0] };
  }
  __equals(other16096) {
    if (!other16096) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16096.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.vs_0, other16096.vs_0))) {
      return false;
    }
    return true;
  }
}

class Unknown_0 {
  constructor() {
    this.__tag = 1;
  }
  __reflect() {
    return { __tag: 1, __name: "Unknown", __data: [] };
  }
  __equals(other16097) {
    if (!other16097) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other16097.__tag))) {
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

function reverseOnto_0(l_3, other_0, ks_6, k_3) {
  reverseOnto_1: while (true) {
    switch (l_3.__tag) {
      case 0:  return () => k_3(other_0, ks_6);
      case 1: 
        const a_1 = l_3.head_0;
        const rest_0 = l_3.tail_0;
        /* prepare call */
        const tmp_other_0 = other_0;
        l_3 = rest_0;
        other_0 = new Cons_0(a_1, tmp_other_0);
        continue reverseOnto_1;
    }
  }
}

function zipWith_0(left_1, right_1, combine_0, ks_13, k_7) {
  function go_0(acc_1, left_0, right_0, ks_7, k_4) {
    switch (left_0.__tag) {
      case 1: 
        const a_2 = left_0.head_0;
        const as_0 = left_0.tail_0;
        switch (right_0.__tag) {
          case 1: 
            const b_0 = right_0.head_0;
            const bs_0 = right_0.tail_0;
            return combine_0(a_2, b_0, ks_7, (result_0, ks_8) =>
              go_0(new Cons_0(result_0, acc_1), as_0, bs_0, ks_8, k_4));
          default: 
            const res_1 = ks_7.arena.fresh(new Nil_0());
            function foreach_worker_3(l_4, ks_9, k_5) {
              foreach_worker_4: while (true) {
                switch (l_4.__tag) {
                  case 0:  return () => k_5($effekt.unit, ks_9);
                  case 1: 
                    const head_3 = l_4.head_0;
                    const tail_3 = l_4.tail_0;
                    const s_4 = res_1.value;
                    res_1.set(new Cons_0(head_3, s_4));
                    /* prepare call */
                    l_4 = tail_3;
                    continue foreach_worker_4;
                }
              }
            }
            return foreach_worker_3(acc_1, ks_7, (_2, ks_10) => {
              const s_5 = res_1.value;
              return () => k_4(s_5, ks_10);
            });
        }
        break;
      default: 
        const res_2 = ks_7.arena.fresh(new Nil_0());
        function foreach_worker_5(l_5, ks_11, k_6) {
          foreach_worker_6: while (true) {
            switch (l_5.__tag) {
              case 0:  return () => k_6($effekt.unit, ks_11);
              case 1: 
                const head_4 = l_5.head_0;
                const tail_4 = l_5.tail_0;
                const s_6 = res_2.value;
                res_2.set(new Cons_0(head_4, s_6));
                /* prepare call */
                l_5 = tail_4;
                continue foreach_worker_6;
            }
          }
        }
        return foreach_worker_5(acc_1, ks_7, (_3, ks_12) => {
          const s_7 = res_2.value;
          return () => k_4(s_7, ks_12);
        });
    }
  }
  return go_0(new Nil_0(), left_1, right_1, ks_13, k_7);
}

function toInt_0(str_0, Exception_1, ks_25, k_17) {
  function go_1(index_0, acc_2, ks_18, k_12) {
    return RESET((p_0, ks_14, k_8) => {
      const Exception_0 = {
        raise_0: (exc_0, msg_1, ks_15, k_9) =>
          SHIFT(p_0, (k_10, ks_16, k_11) =>
            () => k_11(new Error_0(exc_0, msg_1), ks_16), ks_15, undefined)
      };
      return charAt_0(str_0, index_0, Exception_0, ks_14, (v_r_1, ks_17) =>
        () => k_8(new Success_0(v_r_1), ks_17));
    }, ks_18, (v_r_2, ks_19) => {
      switch (v_r_2.__tag) {
        case 1: 
          const c_0 = v_r_2.a_0;
          if ((c_0 >= (48))) if ((c_0 <= (57))) {
            return go_1((index_0 + (1)), ((((10) * acc_2)) + (((c_0) - ((48))))), ks_19, k_12);
          } else {
            return Exception_1.raise_0(new WrongFormat_0(), ("Not a valid number: '" + str_0) + "'", ks_19, undefined);
          } else {
            return Exception_1.raise_0(new WrongFormat_0(), ("Not a valid number: '" + str_0) + "'", ks_19, undefined);
          }
          break;
        case 0:  return () => k_12(acc_2, ks_19);
      }
    });
  }
  return RESET((p_1, ks_20, k_13) => {
    const Exception_2 = {
      raise_0: (exception_1, msg_2, ks_21, k_14) =>
        SHIFT(p_1, (k_15, ks_22, k_16) =>
          Exception_1.raise_0(new WrongFormat_0(), "Empty string is not a valid number", ks_22, undefined), ks_21, undefined)
    };
    return charAt_0(str_0, 0, Exception_2, ks_20, (v_r_3, ks_23) => {
      if (v_r_3 === (45)) {
        return go_1(1, 0, ks_23, (v_r_4, ks_24) =>
          () => k_13(((0) - v_r_4), ks_24));
      } else {
        return go_1(0, 0, ks_23, k_13);
      }
    });
  }, ks_25, k_17);
}

function charAt_0(str_1, index_1, Exception_3, ks_26, k_18) {
  if ((index_1 < (0))) {
    return Exception_3.raise_0(new OutOfBounds_0(), ((("Index out of bounds: " + ('' + index_1)) + " in string: '") + str_1) + "'", ks_26, undefined);
  } else if ((index_1 >= (str_1.length))) {
    return Exception_3.raise_0(new OutOfBounds_0(), ((("Index out of bounds: " + ('' + index_1)) + " in string: '") + str_1) + "'", ks_26, undefined);
  } else {
    return () => k_18(str_1.codePointAt(index_1), ks_26);
  }
}

function leaves_0(n_0, ks_27, k_19) {
  const leaf_0 = n_0.lab_0;
  const children_1 = n_0.children_0;
  switch (children_1.__tag) {
    case 0:  return () => k_19(new Cons_0(leaf_0, new Nil_0()), ks_27);
    case 1: 
      const c_1 = children_1.head_0;
      const cs_0 = children_1.tail_0;
      return map_0(new Cons_0(c_1, cs_0), (x_0, ks_28, k_20) =>
        leaves_0(x_0, ks_28, k_20), ks_27, (v_r_5, ks_29) =>
        concat_loop_0(v_r_5, new Nil_0(), ks_29, k_19));
  }
}

function len_0(ls_0, ks_30, k_21) {
  len_1: while (true) {
    switch (ls_0.__tag) {
      case 0:  return () => k_21(0, ks_30);
      case 1: 
        const xs_0 = ls_0.tail_0;
        /* prepare call */
        const tmp_k_0 = k_21;
        k_21 = (v_r_6, ks_31) => () => tmp_k_0(((1) + v_r_6), ks_31);
        ls_0 = xs_0;
        continue len_1;
    }
  }
}

function at_index_0(ind_0, ls_1, ks_32, k_22) {
  at_index_1: while (true) {
    switch (ls_1.__tag) {
      case 0: 
        const tmp_0 = (function() { throw "Empty List" })();
        return () => k_22(tmp_0, ks_32);
      case 1: 
        const c_2 = ls_1.head_0;
        const cs_1 = ls_1.tail_0;
        if (ind_0 === (0)) {
          return () => k_22(c_2, ks_32);
        } else {
          /* prepare call */
          const tmp_ind_0 = ind_0;
          ind_0 = (tmp_ind_0 - (1));
          ls_1 = cs_1;
          continue at_index_1;
        }
        break;
    }
  }
}

function rev_loop_0(ls_2, acc_3, ks_33, k_23) {
  rev_loop_1: while (true) {
    switch (ls_2.__tag) {
      case 0:  return () => k_23(acc_3, ks_33);
      case 1: 
        const p_2 = ls_2.head_0;
        const ps_0 = ls_2.tail_0;
        /* prepare call */
        const tmp_acc_0 = acc_3;
        ls_2 = ps_0;
        acc_3 = new Cons_0(p_2, tmp_acc_0);
        continue rev_loop_1;
    }
  }
}

function concat_loop_0(ls_3, acc_4, ks_34, k_25) {
  switch (ls_3.__tag) {
    case 0: 
      const res_3 = ks_34.arena.fresh(new Nil_0());
      function foreach_worker_7(l_6, ks_35, k_24) {
        foreach_worker_8: while (true) {
          switch (l_6.__tag) {
            case 0:  return () => k_24($effekt.unit, ks_35);
            case 1: 
              const head_5 = l_6.head_0;
              const tail_5 = l_6.tail_0;
              const s_8 = res_3.value;
              res_3.set(new Cons_0(head_5, s_8));
              /* prepare call */
              l_6 = tail_5;
              continue foreach_worker_8;
          }
        }
      }
      return foreach_worker_7(acc_4, ks_34, (_4, ks_36) => {
        const s_9 = res_3.value;
        return () => k_25(s_9, ks_36);
      });
    case 1: 
      const l_7 = ls_3.head_0;
      const ls_4 = ls_3.tail_0;
      return rev_loop_0(l_7, acc_4, ks_34, (v_r_7, ks_37) =>
        concat_loop_0(ls_4, v_r_7, ks_37, k_25));
  }
}

function combine_1(ls_5, acc_5, ks_38, k_26) {
  switch (ls_5.__tag) {
    case 0:  return () => k_26(acc_5, ks_38);
    case 1: 
      const head_6 = ls_5.head_0;
      const css_0 = ls_5.tail_0;
      const s_10 = head_6.first_0;
      const second_1 = head_6.second_0;
      switch (second_1.__tag) {
        case 0: 
          const cs_2 = second_1.vs_0;
          let v_r_8 = undefined;
          switch (s_10.__tag) {
            case 0:  v_r_8 = 0;break;
            case 1: 
              const head_7 = s_10.head_0;
              const v_0 = head_7.varr_0;
              v_r_8 = v_0;
              break;
          }
          function in_list_worker_0(ls_6, ks_39, k_27) {
            in_list_worker_1: while (true) {
              switch (ls_6.__tag) {
                case 0:  return () => k_27(false, ks_39);
                case 1: 
                  const j_0 = ls_6.head_0;
                  const js_0 = ls_6.tail_0;
                  if (v_r_8 === j_0) {
                    return () => k_27(true, ks_39);
                  } else {
                    /* prepare call */
                    ls_6 = js_0;
                    continue in_list_worker_1;
                  }
                  break;
              }
            }
          }
          return in_list_worker_0(cs_2, ks_38, (v_r_9, ks_40) => {
            if (!v_r_9) {
              return () => k_26(cs_2, ks_40);
            } else {
              function nub_by_worker_0(ls_7, ks_41, k_28) {
                switch (ls_7.__tag) {
                  case 0:  return () => k_28(new Nil_0(), ks_41);
                  case 1: 
                    const h_0 = ls_7.head_0;
                    const t_0 = ls_7.tail_0;
                    function filter_worker_0(ls_8, ks_42, k_29) {
                      filter_worker_1: while (true) {
                        switch (ls_8.__tag) {
                          case 0:  return () => k_29(new Nil_0(), ks_42);
                          case 1: 
                            const a_3 = ls_8.head_0;
                            const as_1 = ls_8.tail_0;
                            if (!(h_0 === a_3)) {
                              /* prepare call */
                              const tmp_k_1 = k_29;
                              k_29 = (v_r_10, ks_43) =>
                                () =>
                                  tmp_k_1(new Cons_0(a_3, v_r_10), ks_43);
                              ls_8 = as_1;
                              continue filter_worker_1;
                            } else {
                              /* prepare call */
                              ls_8 = as_1;
                              continue filter_worker_1;
                            }
                            break;
                        }
                      }
                    }
                    return filter_worker_0(t_0, ks_41, (v_r_11, ks_44) =>
                      nub_by_worker_0(v_r_11, ks_44, (v_r_12, ks_45) =>
                        () => k_28(new Cons_0(h_0, v_r_12), ks_45)));
                }
              }
              return nub_by_worker_0(acc_5, ks_40, (v_r_13, ks_46) => {
                const acc_6 = ks_46.arena.fresh(cs_2);
                function foreach_worker_9(l_8, ks_47, k_30) {
                  switch (l_8.__tag) {
                    case 0:  return () => k_30($effekt.unit, ks_47);
                    case 1: 
                      const head_8 = l_8.head_0;
                      const tail_6 = l_8.tail_0;
                      const s_11 = acc_6.value;
                      function delete_by_worker_0(ys_0, ks_48, k_31) {
                        delete_by_worker_1: while (true) {
                          switch (ys_0.__tag) {
                            case 0:  return () => k_31(new Nil_0(), ks_48);
                            case 1: 
                              const y_0 = ys_0.head_0;
                              const ys_1 = ys_0.tail_0;
                              if (head_8 === y_0) {
                                return () => k_31(ys_1, ks_48);
                              } else {
                                /* prepare call */
                                const tmp_k_2 = k_31;
                                k_31 = (v_r_14, ks_49) =>
                                  () =>
                                    tmp_k_2(new Cons_0(y_0, v_r_14), ks_49);
                                ys_0 = ys_1;
                                continue delete_by_worker_1;
                              }
                              break;
                          }
                        }
                      }
                      return delete_by_worker_0(s_11, ks_47, (v_r_15, ks_50) => {
                        acc_6.set(v_r_15);
                        return foreach_worker_9(tail_6, ks_50, k_30);
                      });
                  }
                }
                return foreach_worker_9(v_r_13, ks_46, (_5, ks_51) => {
                  const s_12 = acc_6.value;
                  const res_4 = ks_51.arena.fresh(new Nil_0());
                  function foreach_worker_10(l_9, ks_52, k_32) {
                    foreach_worker_11: while (true) {
                      switch (l_9.__tag) {
                        case 0:  return () => k_32($effekt.unit, ks_52);
                        case 1: 
                          const head_9 = l_9.head_0;
                          const tail_7 = l_9.tail_0;
                          const s_13 = res_4.value;
                          res_4.set(new Cons_0(head_9, s_13));
                          /* prepare call */
                          l_9 = tail_7;
                          continue foreach_worker_11;
                      }
                    }
                  }
                  return foreach_worker_10(cs_2, ks_51, (_6, ks_53) => {
                    const s_14 = res_4.value;
                    return reverseOnto_0(s_14, s_12, ks_53, (v_r_16, ks_54) =>
                      combine_1(css_0, v_r_16, ks_54, (tmp_1, ks_55) =>
                        () => k_26(tmp_1, ks_55)));
                  });
                });
              });
            }
          });
        case 1:  return () => k_26(acc_5, ks_38);
      }
      break;
  }
}

function collect_0(ls_9, ks_56, k_33) {
  collect_1: while (true) {
    switch (ls_9.__tag) {
      case 0:  return () => k_33(new Nil_0(), ks_56);
      case 1: 
        const head_10 = ls_9.head_0;
        const css_1 = ls_9.tail_0;
        switch (head_10.__tag) {
          case 0: 
            const cs_3 = head_10.vs_0;
            /* prepare call */
            const tmp_k_3 = k_33;
            k_33 = (v_r_17, ks_57) => {
              function nub_by_worker_1(ls_10, ks_58, k_34) {
                switch (ls_10.__tag) {
                  case 0:  return () => k_34(new Nil_0(), ks_58);
                  case 1: 
                    const h_1 = ls_10.head_0;
                    const t_1 = ls_10.tail_0;
                    function filter_worker_2(ls_11, ks_59, k_35) {
                      filter_worker_3: while (true) {
                        switch (ls_11.__tag) {
                          case 0:  return () => k_35(new Nil_0(), ks_59);
                          case 1: 
                            const a_4 = ls_11.head_0;
                            const as_2 = ls_11.tail_0;
                            if (!(h_1 === a_4)) {
                              /* prepare call */
                              const tmp_k_4 = k_35;
                              k_35 = (v_r_18, ks_60) =>
                                () =>
                                  tmp_k_4(new Cons_0(a_4, v_r_18), ks_60);
                              ls_11 = as_2;
                              continue filter_worker_3;
                            } else {
                              /* prepare call */
                              ls_11 = as_2;
                              continue filter_worker_3;
                            }
                            break;
                        }
                      }
                    }
                    return filter_worker_2(t_1, ks_58, (v_r_19, ks_61) =>
                      nub_by_worker_1(v_r_19, ks_61, (v_r_20, ks_62) =>
                        () => k_34(new Cons_0(h_1, v_r_20), ks_62)));
                }
              }
              return nub_by_worker_1(v_r_17, ks_57, (v_r_21, ks_63) => {
                const acc_7 = ks_63.arena.fresh(cs_3);
                function foreach_worker_12(l_10, ks_64, k_36) {
                  switch (l_10.__tag) {
                    case 0:  return () => k_36($effekt.unit, ks_64);
                    case 1: 
                      const head_11 = l_10.head_0;
                      const tail_8 = l_10.tail_0;
                      const s_15 = acc_7.value;
                      function delete_by_worker_2(ys_2, ks_65, k_37) {
                        delete_by_worker_3: while (true) {
                          switch (ys_2.__tag) {
                            case 0:  return () => k_37(new Nil_0(), ks_65);
                            case 1: 
                              const y_1 = ys_2.head_0;
                              const ys_3 = ys_2.tail_0;
                              if (head_11 === y_1) {
                                return () => k_37(ys_3, ks_65);
                              } else {
                                /* prepare call */
                                const tmp_k_5 = k_37;
                                k_37 = (v_r_22, ks_66) =>
                                  () =>
                                    tmp_k_5(new Cons_0(y_1, v_r_22), ks_66);
                                ys_2 = ys_3;
                                continue delete_by_worker_3;
                              }
                              break;
                          }
                        }
                      }
                      return delete_by_worker_2(s_15, ks_64, (v_r_23, ks_67) => {
                        acc_7.set(v_r_23);
                        return foreach_worker_12(tail_8, ks_67, k_36);
                      });
                  }
                }
                return foreach_worker_12(v_r_21, ks_63, (_7, ks_68) => {
                  const s_16 = acc_7.value;
                  const res_5 = ks_68.arena.fresh(new Nil_0());
                  function foreach_worker_13(l_11, ks_69, k_38) {
                    foreach_worker_14: while (true) {
                      switch (l_11.__tag) {
                        case 0:  return () => k_38($effekt.unit, ks_69);
                        case 1: 
                          const head_12 = l_11.head_0;
                          const tail_9 = l_11.tail_0;
                          const s_17 = res_5.value;
                          res_5.set(new Cons_0(head_12, s_17));
                          /* prepare call */
                          l_11 = tail_9;
                          continue foreach_worker_14;
                      }
                    }
                  }
                  return foreach_worker_13(cs_3, ks_68, (_8, ks_70) => {
                    const s_18 = res_5.value;
                    return reverseOnto_0(s_18, s_16, ks_70, (tmp_2, ks_71) =>
                      () => tmp_k_3(tmp_2, ks_71));
                  });
                });
              });
            };
            ls_9 = css_1;
            continue collect_1;
          case 1:  return () => k_33(new Nil_0(), ks_56);
        }
        break;
    }
  }
}

function wipe_lscomp_0(ls_12, ks_72, k_39) {
  switch (ls_12.__tag) {
    case 0:  return () => k_39(new Nil_0(), ks_72);
    case 1: 
      const vs_1 = ls_12.head_0;
      const t_2 = ls_12.tail_0;
      function all_worker_0(list_0, ks_73, k_40) {
        all_worker_1: while (true) {
          switch (list_0.__tag) {
            case 1: 
              const x_1 = list_0.head_0;
              const xs_1 = list_0.tail_0;
              switch (x_1.__tag) {
                case 0: 
                  const vs_2 = x_1.vs_0;
                  switch (vs_2.__tag) {
                    case 0:  return () => k_40(false, ks_73);
                    case 1: 
                      /* prepare call */
                      list_0 = xs_1;
                      continue all_worker_1;
                  }
                  break;
                case 1:  return () => k_40(false, ks_73);
              }
              break;
            case 0:  return () => k_40(true, ks_73);
          }
        }
      }
      return all_worker_0(vs_1, ks_72, (v_r_24, ks_74) => {
        if (v_r_24) {
          return wipe_lscomp_0(t_2, ks_74, (v_r_25, ks_75) =>
            () => k_39(new Cons_0(vs_1, v_r_25), ks_75));
        } else {
          return wipe_lscomp_0(t_2, ks_74, k_39);
        }
      });
  }
}

function lookup_cache_0(csp_0, t_4, ks_82, k_44) {
  function map_tree_worker_0(t_3, ks_77, k_42) {
    const l_12 = t_3.lab_0;
    const ls_13 = t_3.children_0;
    const first_1 = l_12.first_0;
    const tbl_0 = l_12.second_0;
    switch (first_1.__tag) {
      case 0: 
        return map_0(ls_13, (x_2, ks_76, k_41) =>
          map_tree_worker_0(x_2, ks_76, k_41), ks_77, (v_r_26, ks_78) =>
          () =>
            k_42(new Node_0(new Tuple_0(new Tuple_0(new Nil_0(), new Unknown_0()), tbl_0), v_r_26), ks_78));
      case 1: 
        const a_5 = first_1.head_0;
        const as_3 = first_1.tail_0;
        const value_2 = a_5.value_1;
        switch (tbl_0.__tag) {
          case 0: 
            const tmp_3 = (function() { throw "Empty List" })();
            return () => k_42(tmp_3, ks_77);
          case 1: 
            const a_6 = tbl_0.head_0;
            return at_index_0((value_2 - (1)), a_6, ks_77, (table_entry_0, ks_79) => {
              let cs_4 = undefined;
              switch (table_entry_0.__tag) {
                case 1: 
                  const v_1 = csp_0.vars_0;
                  const v_2 = a_5.varr_0;
                  if (v_2 === v_1) {
                    cs_4 = new Known_0(new Nil_0());
                  } else {
                    cs_4 = new Unknown_0();
                  }
                  break;
                case 0:  cs_4 = table_entry_0;break;
              }
              return map_0(ls_13, (x_3, ks_80, k_43) =>
                map_tree_worker_0(x_3, ks_80, k_43), ks_79, (v_r_27, ks_81) =>
                () =>
                  k_42(new Node_0(new Tuple_0(new Tuple_0(new Cons_0(a_5, as_3), cs_4), tbl_0), v_r_27), ks_81));
            });
        }
        break;
    }
  }
  return map_tree_worker_0(t_4, ks_82, k_44);
}

function cache_checks_0(csp_1, tbl_2, n_2, ks_102, k_54) {
  function cache_checks_worker_0(tbl_1, n_1, ks_100, k_53) {
    const s_19 = n_1.lab_0;
    const cs_5 = n_1.children_0;
    return map_0(cs_5, (x_4, ks_83, k_45) => {
      switch (tbl_1.__tag) {
        case 0: 
          const tmp_4 = (function() { throw "Empty List" })();
          return () => k_45(tmp_4, ks_83);
        case 1: 
          const as_4 = tbl_1.tail_0;
          function k_46(v_r_28, ks_84) {
            return cache_checks_worker_0(v_r_28, x_4, ks_84, k_45);
          }
          switch (s_19.__tag) {
            case 0:  return () => k_46(as_4, ks_83);
            case 1: 
              const head_13 = s_19.head_0;
              const var_0 = head_13.varr_0;
              const val_0 = head_13.value_1;
              const vars_1 = csp_1.vars_0;
              const vals_1 = csp_1.vals_0;
              const rel_1 = csp_1.rel_0;
              function enum_from_to_worker_0(from_0, ks_86, k_47) {
                enum_from_to_worker_1: while (true) {
                  if ((from_0 <= vars_1)) {
                    /* prepare call */
                    const tmp_from_0 = from_0;
                    const tmp_k_6 = k_47;
                    k_47 = (v_r_29, ks_85) =>
                      () => tmp_k_6(new Cons_0(tmp_from_0, v_r_29), ks_85);
                    from_0 = (tmp_from_0 + (1));
                    continue enum_from_to_worker_1;
                  } else {
                    return () => k_47(new Nil_0(), ks_86);
                  }
                }
              }
              return enum_from_to_worker_0((var_0 + (1)), ks_83, (v_r_30, ks_87) => {
                function fill_lscomp_0(ls_14, ks_88, k_48) {
                  switch (ls_14.__tag) {
                    case 0:  return () => k_48(new Nil_0(), ks_88);
                    case 1: 
                      const varrr_0 = ls_14.head_0;
                      const t_5 = ls_14.tail_0;
                      function enum_from_to_worker_2(from_1, ks_90, k_49) {
                        enum_from_to_worker_3: while (true) {
                          if ((from_1 <= vals_1)) {
                            /* prepare call */
                            const tmp_from_1 = from_1;
                            const tmp_k_7 = k_49;
                            k_49 = (v_r_31, ks_89) =>
                              () =>
                                tmp_k_7(new Cons_0(tmp_from_1, v_r_31), ks_89);
                            from_1 = (tmp_from_1 + (1));
                            continue enum_from_to_worker_3;
                          } else {
                            return () => k_49(new Nil_0(), ks_90);
                          }
                        }
                      }
                      return enum_from_to_worker_2(1, ks_88, (v_r_32, ks_91) => {
                        function fill_lscomp_1(ls_15, ks_92, k_50) {
                          fill_lscomp_2: while (true) {
                            switch (ls_15.__tag) {
                              case 0: 
                                return () => k_50(new Nil_0(), ks_92);
                              case 1: 
                                const valll_0 = ls_15.head_0;
                                const t_6 = ls_15.tail_0;
                                /* prepare call */
                                const tmp_k_8 = k_50;
                                k_50 = (v_r_33, ks_93) =>
                                  () =>
                                    tmp_k_8(new Cons_0(new Tuple_0(varrr_0, valll_0), v_r_33), ks_93);
                                ls_15 = t_6;
                                continue fill_lscomp_2;
                            }
                          }
                        }
                        return fill_lscomp_1(v_r_32, ks_91, (v_r_34, ks_94) =>
                          fill_lscomp_0(t_5, ks_94, (v_r_35, ks_95) =>
                            () => k_48(new Cons_0(v_r_34, v_r_35), ks_95)));
                      });
                  }
                }
                return fill_lscomp_0(v_r_30, ks_87, (v_r_36, ks_96) =>
                  zipWith_0(as_4, v_r_36, (x_5, y_2, ks_97, k_51) => {
                    function tmp_5(cs_6, varval_0, ks_98, k_52) {
                      switch (cs_6.__tag) {
                        case 0:  return () => k_52(cs_6, ks_98);
                        case 1: 
                          const varr_1 = varval_0.first_0;
                          const vall_0 = varval_0.second_0;
                          const tmp_6 = rel_1;
                          return tmp_6(new Assign_0(var_0, val_0), new Assign_0(varr_1, vall_0), ks_98, (v_r_37, ks_99) => {
                            if (!v_r_37) {
                              return () =>
                                k_52(new Known_0(new Cons_0(var_0, new Cons_0(varr_1, new Nil_0()))), ks_99);
                            } else {
                              return () => k_52(cs_6, ks_99);
                            }
                          });
                      }
                    }
                    return zipWith_0(x_5, y_2, tmp_5, ks_97, k_51);
                  }, ks_96, k_46));
              });
          }
          break;
      }
    }, ks_100, (v_r_38, ks_101) =>
      () => k_53(new Node_0(new Tuple_0(s_19, tbl_1), v_r_38), ks_101));
  }
  return cache_checks_worker_0(tbl_2, n_2, ks_102, k_54);
}

function empt_lscomp_0(ls_16, ks_103, k_55) {
  empt_lscomp_1: while (true) {
    switch (ls_16.__tag) {
      case 0:  return () => k_55(new Nil_0(), ks_103);
      case 1: 
        const t_7 = ls_16.tail_0;
        /* prepare call */
        const tmp_k_9 = k_55;
        k_55 = (v_r_39, ks_104) =>
          () => tmp_k_9(new Cons_0(new Unknown_0(), v_r_39), ks_104);
        ls_16 = t_7;
        continue empt_lscomp_1;
    }
  }
}

function empty_table_0(csp_2, ks_107, k_59) {
  const vars_2 = csp_2.vars_0;
  const vals_2 = csp_2.vals_0;
  function enum_from_to_worker_4(from_2, ks_106, k_56) {
    enum_from_to_worker_5: while (true) {
      if ((from_2 <= vars_2)) {
        /* prepare call */
        const tmp_from_2 = from_2;
        const tmp_k_10 = k_56;
        k_56 = (v_r_40, ks_105) =>
          () => tmp_k_10(new Cons_0(tmp_from_2, v_r_40), ks_105);
        from_2 = (tmp_from_2 + (1));
        continue enum_from_to_worker_5;
      } else {
        return () => k_56(new Nil_0(), ks_106);
      }
    }
  }
  return enum_from_to_worker_4(1, ks_107, (v_r_41, ks_108) => {
    function empt_lscomp_2(ls_17, ks_109, k_57) {
      switch (ls_17.__tag) {
        case 0:  return () => k_57(new Nil_0(), ks_109);
        case 1: 
          const t_8 = ls_17.tail_0;
          function enum_from_to_worker_6(from_3, ks_111, k_58) {
            enum_from_to_worker_7: while (true) {
              if ((from_3 <= vals_2)) {
                /* prepare call */
                const tmp_from_3 = from_3;
                const tmp_k_11 = k_58;
                k_58 = (v_r_42, ks_110) =>
                  () => tmp_k_11(new Cons_0(tmp_from_3, v_r_42), ks_110);
                from_3 = (tmp_from_3 + (1));
                continue enum_from_to_worker_7;
              } else {
                return () => k_58(new Nil_0(), ks_111);
              }
            }
          }
          return enum_from_to_worker_6(1, ks_109, (v_r_43, ks_112) =>
            empt_lscomp_0(v_r_43, ks_112, (v_r_44, ks_113) =>
              empt_lscomp_2(t_8, ks_113, (v_r_45, ks_114) =>
                () => k_57(new Cons_0(v_r_44, v_r_45), ks_114))));
      }
    }
    return empt_lscomp_2(v_r_41, ks_108, (v_r_46, ks_115) =>
      () => k_59(new Cons_0(new Nil_0(), v_r_46), ks_115));
  });
}

function bt_0(csp_3, t_10, ks_130, k_66) {
  function map_tree_worker_1(t_9, ks_121, k_63) {
    const l_13 = t_9.lab_0;
    const ls_18 = t_9.children_0;
    function l_14(v_r_47, ks_117, k_61) {
      switch (v_r_47.__tag) {
        case 1: 
          const value_3 = v_r_47.value_0;
          const a_7 = value_3.first_0;
          const b_1 = value_3.second_0;
          return map_0(ls_18, (x_6, ks_116, k_60) =>
            map_tree_worker_1(x_6, ks_116, k_60), ks_117, (v_r_48, ks_118) =>
            () =>
              k_61(new Node_0(new Tuple_0(l_13, new Known_0(new Cons_0(a_7, new Cons_0(b_1, new Nil_0())))), v_r_48), ks_118));
        case 0: 
          const v_3 = csp_3.vars_0;
          let v_r_49 = undefined;
          switch (l_13.__tag) {
            case 0: 
              if ((0) === v_3) {
                v_r_49 = new Known_0(new Nil_0());
              } else {
                v_r_49 = new Unknown_0();
              }
              break;
            case 1: 
              const head_14 = l_13.head_0;
              const v_4 = head_14.varr_0;
              if (v_4 === v_3) {
                v_r_49 = new Known_0(new Nil_0());
              } else {
                v_r_49 = new Unknown_0();
              }
              break;
          }
          return map_0(ls_18, (x_7, ks_119, k_62) =>
            map_tree_worker_1(x_7, ks_119, k_62), ks_117, (v_r_50, ks_120) =>
            () =>
              k_61(new Node_0(new Tuple_0(l_13, v_r_49), v_r_50), ks_120));
      }
    }
    switch (l_13.__tag) {
      case 0:  return l_14(new None_0(), ks_121, k_63);
      case 1: 
        const a_8 = l_13.head_0;
        const as_5 = l_13.tail_0;
        const rel_2 = csp_3.rel_0;
        const res_6 = ks_121.arena.fresh(new Nil_0());
        function foreach_worker_15(l_15, ks_122, k_64) {
          foreach_worker_16: while (true) {
            switch (l_15.__tag) {
              case 0:  return () => k_64($effekt.unit, ks_122);
              case 1: 
                const head_15 = l_15.head_0;
                const tail_10 = l_15.tail_0;
                const s_20 = res_6.value;
                res_6.set(new Cons_0(head_15, s_20));
                /* prepare call */
                l_15 = tail_10;
                continue foreach_worker_16;
            }
          }
        }
        return foreach_worker_15(as_5, ks_121, (_9, ks_123) => {
          const s_21 = res_6.value;
          function filter_worker_4(ls_19, ks_124, k_65) {
            switch (ls_19.__tag) {
              case 0:  return () => k_65(new Nil_0(), ks_124);
              case 1: 
                const a_9 = ls_19.head_0;
                const as_6 = ls_19.tail_0;
                const tmp_7 = rel_2;
                return tmp_7(a_8, a_9, ks_124, (v_r_51, ks_125) => {
                  if (!v_r_51) {
                    return filter_worker_4(as_6, ks_125, (v_r_52, ks_126) =>
                      () => k_65(new Cons_0(a_9, v_r_52), ks_126));
                  } else {
                    return filter_worker_4(as_6, ks_125, k_65);
                  }
                });
            }
          }
          return filter_worker_4(s_21, ks_123, (v_r_53, ks_127) => {
            switch (v_r_53.__tag) {
              case 0: 
                return l_14(new None_0(), ks_127, (tmp_8, ks_128) =>
                  () => k_63(tmp_8, ks_128));
              case 1: 
                const b_2 = v_r_53.head_0;
                const varr_2 = a_8.varr_0;
                const varr_3 = b_2.varr_0;
                return l_14(new Some_0(new Tuple_0(varr_2, varr_3)), ks_127, (tmp_8, ks_129) =>
                  () => k_63(tmp_8, ks_129));
            }
          });
        });
    }
  }
  return map_tree_worker_1(t_10, ks_130, k_66);
}

function bm_0(csp_4, t_11, ks_131, k_69) {
  return empty_table_0(csp_4, ks_131, (v_r_54, ks_132) =>
    cache_checks_0(csp_4, v_r_54, t_11, ks_132, (v_r_55, ks_133) =>
      lookup_cache_0(csp_4, v_r_55, ks_133, (v_r_56, ks_134) => {
        function map_tree_worker_2(t_12, ks_136, k_68) {
          const l_16 = t_12.lab_0;
          const ls_20 = t_12.children_0;
          const a_10 = l_16.first_0;
          return map_0(ls_20, (x_8, ks_135, k_67) =>
            map_tree_worker_2(x_8, ks_135, k_67), ks_136, (v_r_57, ks_137) =>
            () => k_68(new Node_0(a_10, v_r_57), ks_137));
        }
        return map_tree_worker_2(v_r_56, ks_134, k_69);
      })));
}

function bjbt_0(csp_5, t_13, ks_138, k_73) {
  return bt_0(csp_5, t_13, ks_138, (v_r_58, ks_139) => {
    function fold_tree_worker_0(t_14, ks_141, k_71) {
      const l_17 = t_14.lab_0;
      const c_3 = t_14.children_0;
      return map_0(c_3, (x_9, ks_140, k_70) =>
        fold_tree_worker_0(x_9, ks_140, k_70), ks_141, (v_r_59, ks_142) => {
        const a_11 = l_17.first_0;
        const second_2 = l_17.second_0;
        switch (second_2.__tag) {
          case 0: 
            const cs_7 = second_2.vs_0;
            return () =>
              k_71(new Node_0(new Tuple_0(a_11, new Known_0(cs_7)), v_r_59), ks_142);
          case 1: 
            return map_0(v_r_59, (x_10, ks_143, k_72) => {
              const p_3 = x_10.lab_0;
              return () => k_72(p_3, ks_143);
            }, ks_142, (v_r_60, ks_144) =>
              combine_1(v_r_60, new Nil_0(), ks_144, (v_r_61, ks_145) =>
                () =>
                  k_71(new Node_0(new Tuple_0(a_11, new Known_0(v_r_61)), v_r_59), ks_145)));
        }
      });
    }
    return fold_tree_worker_0(v_r_58, ks_139, k_73);
  });
}

function bjbt_1(csp_6, t_15, ks_146, k_77) {
  return bt_0(csp_6, t_15, ks_146, (v_r_62, ks_147) => {
    function fold_tree_worker_1(t_16, ks_149, k_75) {
      const l_18 = t_16.lab_0;
      const c_4 = t_16.children_0;
      return map_0(c_4, (x_11, ks_148, k_74) =>
        fold_tree_worker_1(x_11, ks_148, k_74), ks_149, (v_r_63, ks_150) => {
        const a_12 = l_18.first_0;
        const second_3 = l_18.second_0;
        switch (second_3.__tag) {
          case 0: 
            const cs_8 = second_3.vs_0;
            return () =>
              k_75(new Node_0(new Tuple_0(a_12, new Known_0(cs_8)), v_r_63), ks_150);
          case 1: 
            return map_0(v_r_63, (x_12, ks_151, k_76) => {
              const p_4 = x_12.lab_0;
              return () => k_76(p_4, ks_151);
            }, ks_150, (v_r_64, ks_152) =>
              combine_1(v_r_64, new Nil_0(), ks_152, (v_r_65, ks_153) => {
                const tmp_9 = new Known_0(v_r_65);
                switch (v_r_65.__tag) {
                  case 0: 
                    return () =>
                      k_75(new Node_0(new Tuple_0(a_12, tmp_9), v_r_63), ks_153);
                  case 1: 
                    return () =>
                      k_75(new Node_0(new Tuple_0(a_12, tmp_9), new Nil_0()), ks_153);
                }
              }));
        }
      });
    }
    return fold_tree_worker_1(v_r_62, ks_147, k_77);
  });
}

function fc_0(csp_7, t_17, ks_154, k_81) {
  return empty_table_0(csp_7, ks_154, (v_r_66, ks_155) =>
    cache_checks_0(csp_7, v_r_66, t_17, ks_155, (v_r_67, ks_156) =>
      lookup_cache_0(csp_7, v_r_67, ks_156, (v_r_68, ks_157) => {
        function map_tree_worker_3(t_18, ks_158, k_79) {
          const l_19 = t_18.lab_0;
          const ls_21 = t_18.children_0;
          const p_5 = l_19.first_0;
          const tbl_3 = l_19.second_0;
          const as_7 = p_5.first_0;
          const cs_9 = p_5.second_0;
          return wipe_lscomp_0(tbl_3, ks_158, (wiped_domains_0, ks_159) => {
            let v_r_69 = undefined;
            switch (wiped_domains_0.__tag) {
              case 0:  v_r_69 = true;break;
              case 1:  v_r_69 = false;break;
            }
            if (v_r_69) {
              return map_0(ls_21, (x_13, ks_160, k_78) =>
                map_tree_worker_3(x_13, ks_160, k_78), ks_159, (v_r_70, ks_161) =>
                () =>
                  k_79(new Node_0(new Tuple_0(as_7, cs_9), v_r_70), ks_161));
            } else {
              switch (wiped_domains_0.__tag) {
                case 0: 
                  const tmp_10 = (function() { throw "Empty List" })();
                  return () => k_79(tmp_10, ks_159);
                case 1: 
                  const a_13 = wiped_domains_0.head_0;
                  return collect_0(a_13, ks_159, (v_r_71, ks_162) =>
                    map_0(ls_21, (x_14, ks_163, k_80) =>
                      map_tree_worker_3(x_14, ks_163, k_80), ks_162, (v_r_72, ks_164) =>
                      () =>
                        k_79(new Node_0(new Tuple_0(as_7, new Known_0(v_r_71)), v_r_72), ks_164)));
              }
            }
          });
        }
        return map_tree_worker_3(v_r_68, ks_157, k_81);
      })));
}

function main_0(ks_166, k_104) {
  const tmp_11 = process.argv.slice(1);
  const tmp_12 = tmp_11.length;
  function toList_worker_0(start_0, acc_8, ks_165, k_82) {
    toList_worker_1: while (true) {
      if ((start_0 < (1))) {
        return () => k_82(acc_8, ks_165);
      } else {
        const tmp_13 = tmp_11[start_0];
        /* prepare call */
        const tmp_start_0 = start_0;
        const tmp_acc_1 = acc_8;
        start_0 = (tmp_start_0 - (1));
        acc_8 = new Cons_0(tmp_13, tmp_acc_1);
        continue toList_worker_1;
      }
    }
  }
  return toList_worker_0((tmp_12 - (1)), new Nil_0(), ks_166, (v_r_73, ks_167) => {
    switch (v_r_73.__tag) {
      case 1: 
        const iters_str_0 = v_r_73.head_0;
        const tail_11 = v_r_73.tail_0;
        switch (tail_11.__tag) {
          case 1: 
            const n_str_0 = tail_11.head_0;
            const tail_12 = tail_11.tail_0;
            switch (tail_12.__tag) {
              case 0: 
                return RESET((p_6, ks_168, k_83) => {
                  const Exception_4 = {
                    raise_0: (_10, msg_3, ks_169, k_84) =>
                      SHIFT(p_6, (k_85, ks_170, k_86) => {
                        const tmp_14 = (function() { throw msg_3 })();
                        return () => k_86(tmp_14, ks_170);
                      }, ks_169, undefined)
                  };
                  return toInt_0(iters_str_0, Exception_4, ks_168, k_83);
                }, ks_167, (iters_0, ks_171) =>
                  RESET((p_7, ks_172, k_87) => {
                    const Exception_5 = {
                      raise_0: (_11, msg_4, ks_173, k_88) =>
                        SHIFT(p_7, (k_89, ks_174, k_90) => {
                          const tmp_15 = (function() { throw msg_4 })();
                          return () => k_90(tmp_15, ks_174);
                        }, ks_173, undefined)
                    };
                    return toInt_0(n_str_0, Exception_5, ks_172, k_87);
                  }, ks_171, (n_3, ks_175) => {
                    function main_loop_worker_0(iters_1, ks_205, k_103) {
                      return map_0(new Cons_0(bt_0, new Cons_0(bm_0, new Cons_0(bjbt_0, new Cons_0(bjbt_1, new Cons_0(fc_0, new Nil_0()))))), (x_15, ks_176, k_91) => {
                        const tmp_16 = x_15;
                        function init_tree_worker_0(x_16, ks_182, k_94) {
                          let v_r_74 = undefined;
                          switch (x_16.__tag) {
                            case 0:  v_r_74 = 0;break;
                            case 1: 
                              const head_16 = x_16.head_0;
                              const v_5 = head_16.varr_0;
                              v_r_74 = v_5;
                              break;
                          }
                          function k_92(v_r_75, ks_177) {
                            return map_0(v_r_75, (y_3, ks_178, k_93) =>
                              init_tree_worker_0(y_3, ks_178, k_93), ks_177, (v_r_76, ks_179) =>
                              () => k_94(new Node_0(x_16, v_r_76), ks_179));
                          }
                          if ((v_r_74 < n_3)) {
                            function enum_from_to_worker_8(from_4, ks_181, k_95) {
                              enum_from_to_worker_9: while (true) {
                                if ((from_4 <= n_3)) {
                                  /* prepare call */
                                  const tmp_from_4 = from_4;
                                  const tmp_k_12 = k_95;
                                  k_95 = (v_r_77, ks_180) =>
                                    () =>
                                      tmp_k_12(new Cons_0(tmp_from_4, v_r_77), ks_180);
                                  from_4 = (tmp_from_4 + (1));
                                  continue enum_from_to_worker_9;
                                } else {
                                  return () => k_95(new Nil_0(), ks_181);
                                }
                              }
                            }
                            return enum_from_to_worker_8(1, ks_182, (v_r_78, ks_183) => {
                              function mk_lscomp_0(ls_22, ks_184, k_96) {
                                mk_lscomp_1: while (true) {
                                  switch (ls_22.__tag) {
                                    case 0: 
                                      return () =>
                                        k_96(new Nil_0(), ks_184);
                                    case 1: 
                                      const j_1 = ls_22.head_0;
                                      const t_19 = ls_22.tail_0;
                                      switch (x_16.__tag) {
                                        case 0: 
                                          /* prepare call */
                                          const tmp_k_13 = k_96;
                                          k_96 = (v_r_79, ks_185) =>
                                            () =>
                                              tmp_k_13(new Cons_0(new Cons_0(new Assign_0(((0) + (1)), j_1), x_16), v_r_79), ks_185);
                                          ls_22 = t_19;
                                          continue mk_lscomp_1;
                                        case 1: 
                                          const head_17 = x_16.head_0;
                                          const v_6 = head_17.varr_0;
                                          /* prepare call */
                                          const tmp_k_14 = k_96;
                                          k_96 = (v_r_80, ks_186) =>
                                            () =>
                                              tmp_k_14(new Cons_0(new Cons_0(new Assign_0((v_6 + (1)), j_1), x_16), v_r_80), ks_186);
                                          ls_22 = t_19;
                                          continue mk_lscomp_1;
                                      }
                                      break;
                                  }
                                }
                              }
                              return mk_lscomp_0(v_r_78, ks_183, k_92);
                            });
                          } else {
                            return () => k_92(new Nil_0(), ks_182);
                          }
                        }
                        return init_tree_worker_0(new Nil_0(), ks_176, (v_r_81, ks_187) =>
                          tmp_16(new CSP_0(n_3, n_3, (x_17, y_4, ks_188, k_97) => {
                            const i_0 = x_17.varr_0;
                            const m_0 = x_17.value_1;
                            const j_2 = y_4.varr_0;
                            const n_4 = y_4.value_1;
                            if (!(m_0 === n_4)) {
                              const tmp_17 = (i_0 - j_2);
                              const tmp_18 = ((0) - tmp_17);
                              if ((tmp_17 > tmp_18)) {
                                const tmp_19 = (m_0 - n_4);
                                const tmp_20 = ((0) - tmp_19);
                                if ((tmp_19 > tmp_20)) {
                                  return () =>
                                    k_97(!(tmp_17 === tmp_19), ks_188);
                                } else {
                                  return () =>
                                    k_97(!(tmp_17 === tmp_20), ks_188);
                                }
                              } else {
                                const tmp_21 = (m_0 - n_4);
                                const tmp_22 = ((0) - tmp_21);
                                if ((tmp_21 > tmp_22)) {
                                  return () =>
                                    k_97(!(tmp_18 === tmp_21), ks_188);
                                } else {
                                  return () =>
                                    k_97(!(tmp_18 === tmp_22), ks_188);
                                }
                              }
                            } else {
                              return () => k_97(false, ks_188);
                            }
                          }), v_r_81, ks_187, (v_r_82, ks_189) => {
                            function fold_tree_worker_2(t_20, ks_191, k_100) {
                              const l_20 = t_20.lab_0;
                              const c_5 = t_20.children_0;
                              return map_0(c_5, (x_18, ks_190, k_98) =>
                                fold_tree_worker_2(x_18, ks_190, k_98), ks_191, (v_r_83, ks_192) => {
                                function filter_worker_5(ls_23, ks_193, k_99) {
                                  filter_worker_6: while (true) {
                                    switch (ls_23.__tag) {
                                      case 0: 
                                        return () =>
                                          k_99(new Nil_0(), ks_193);
                                      case 1: 
                                        const a_14 = ls_23.head_0;
                                        const as_8 = ls_23.tail_0;
                                        const p_8 = a_14.lab_0;
                                        const b_3 = p_8.second_0;
                                        switch (b_3.__tag) {
                                          case 0: 
                                            const vs_3 = b_3.vs_0;
                                            switch (vs_3.__tag) {
                                              case 0: 
                                                if (!(false)) {
                                                  /* prepare call */
                                                  const tmp_k_15 = k_99;
                                                  k_99 = (v_r_84, ks_194) =>
                                                    () =>
                                                      tmp_k_15(new Cons_0(a_14, v_r_84), ks_194);
                                                  ls_23 = as_8;
                                                  continue filter_worker_6;
                                                } else {
                                                  /* prepare call */
                                                  ls_23 = as_8;
                                                  continue filter_worker_6;
                                                }
                                                break;
                                              case 1: 
                                                if (!(true)) {
                                                  /* prepare call */
                                                  const tmp_k_16 = k_99;
                                                  k_99 = (v_r_85, ks_195) =>
                                                    () =>
                                                      tmp_k_16(new Cons_0(a_14, v_r_85), ks_195);
                                                  ls_23 = as_8;
                                                  continue filter_worker_6;
                                                } else {
                                                  /* prepare call */
                                                  ls_23 = as_8;
                                                  continue filter_worker_6;
                                                }
                                                break;
                                            }
                                            break;
                                          case 1: 
                                            if (!(false)) {
                                              /* prepare call */
                                              const tmp_k_17 = k_99;
                                              k_99 = (v_r_86, ks_196) =>
                                                () =>
                                                  tmp_k_17(new Cons_0(a_14, v_r_86), ks_196);
                                              ls_23 = as_8;
                                              continue filter_worker_6;
                                            } else {
                                              /* prepare call */
                                              ls_23 = as_8;
                                              continue filter_worker_6;
                                            }
                                            break;
                                        }
                                        break;
                                    }
                                  }
                                }
                                return filter_worker_5(v_r_83, ks_192, (v_r_87, ks_197) =>
                                  () =>
                                    k_100(new Node_0(l_20, v_r_87), ks_197));
                              });
                            }
                            return fold_tree_worker_2(v_r_82, ks_189, (v_r_88, ks_198) =>
                              leaves_0(v_r_88, ks_198, (v_r_89, ks_199) => {
                                function filter_worker_7(ls_24, ks_200, k_101) {
                                  filter_worker_8: while (true) {
                                    switch (ls_24.__tag) {
                                      case 0: 
                                        return () =>
                                          k_101(new Nil_0(), ks_200);
                                      case 1: 
                                        const a_15 = ls_24.head_0;
                                        const as_9 = ls_24.tail_0;
                                        const b_4 = a_15.second_0;
                                        switch (b_4.__tag) {
                                          case 0: 
                                            const vs_4 = b_4.vs_0;
                                            switch (vs_4.__tag) {
                                              case 0: 
                                                /* prepare call */
                                                const tmp_k_18 = k_101;
                                                k_101 = (v_r_90, ks_201) =>
                                                  () =>
                                                    tmp_k_18(new Cons_0(a_15, v_r_90), ks_201);
                                                ls_24 = as_9;
                                                continue filter_worker_8;
                                              case 1: 
                                                /* prepare call */
                                                ls_24 = as_9;
                                                continue filter_worker_8;
                                            }
                                            break;
                                          case 1: 
                                            /* prepare call */
                                            ls_24 = as_9;
                                            continue filter_worker_8;
                                        }
                                        break;
                                    }
                                  }
                                }
                                return filter_worker_7(v_r_89, ks_199, (v_r_91, ks_202) =>
                                  map_0(v_r_91, (x_19, ks_203, k_102) => {
                                    const a_16 = x_19.first_0;
                                    return () => k_102(a_16, ks_203);
                                  }, ks_202, (v_r_92, ks_204) =>
                                    len_0(v_r_92, ks_204, k_91)));
                              }));
                          }));
                      }, ks_205, (res_7, ks_206) => {
                        if (iters_1 === (1)) {
                          switch (res_7.__tag) {
                            case 0: 
                              const tmp_23 = $effekt.println(('' + (-1)));
                              return () => k_103(tmp_23, ks_206);
                            case 1: 
                              const a_17 = res_7.head_0;
                              const tmp_24 = $effekt.println(('' + a_17));
                              return () => k_103(tmp_24, ks_206);
                          }
                        } else {
                          return main_loop_worker_0((iters_1 - (1)), ks_206, k_103);
                        }
                      });
                    }
                    return main_loop_worker_0(iters_0, ks_175, k_104);
                  }));
              default: 
                const tmp_25 = (function() { throw "Expected Arguments \"iters\" and \"n\"" })();
                return () => k_104(tmp_25, ks_167);
            }
            break;
          default: 
            const tmp_26 = (function() { throw "Expected Arguments \"iters\" and \"n\"" })();
            return () => k_104(tmp_26, ks_167);
        }
        break;
      default: 
        const tmp_27 = (function() { throw "Expected Arguments \"iters\" and \"n\"" })();
        return () => k_104(tmp_27, ks_167);
    }
  });
}

(typeof module != "undefined" && module !== null ? module : {}).exports = $Constraints = {
  main: () => RUN_TOPLEVEL(main_0)
};