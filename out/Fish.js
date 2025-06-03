const $effekt = {  };

class OutOfBounds_0 {
  constructor() {
    this.__tag = 0;
  }
  __reflect() {
    return { __tag: 0, __name: "OutOfBounds", __data: [] };
  }
  __equals(other8870) {
    if (!other8870) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other8870.__tag))) {
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
  __equals(other8871) {
    if (!other8871) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other8871.__tag))) {
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
  __equals(other8872) {
    if (!other8872) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other8872.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.head_0, other8872.head_0))) {
      return false;
    }
    if (!($effekt.equals(this.tail_0, other8872.tail_0))) {
      return false;
    }
    return true;
  }
}

class Vec_0 {
  constructor(x_0, y_0) {
    this.__tag = 0;
    this.x_0 = x_0;
    this.y_0 = y_0;
  }
  __reflect() {
    return { __tag: 0, __name: "Vec", __data: [this.x_0, this.y_0] };
  }
  __equals(other8873) {
    if (!other8873) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other8873.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.x_0, other8873.x_0))) {
      return false;
    }
    if (!($effekt.equals(this.y_0, other8873.y_0))) {
      return false;
    }
    return true;
  }
}

class Vec_1 {
  constructor(x_1, y_1, z_0, w_0) {
    this.__tag = 0;
    this.x_1 = x_1;
    this.y_1 = y_1;
    this.z_0 = z_0;
    this.w_0 = w_0;
  }
  __reflect() {
    return {
      __tag: 0,
      __name: "Vec4",
      __data: [this.x_1, this.y_1, this.z_0, this.w_0]
    };
  }
  __equals(other8874) {
    if (!other8874) {
      return false;
    }
    if (!($effekt.equals(this.__tag, other8874.__tag))) {
      return false;
    }
    if (!($effekt.equals(this.x_1, other8874.x_1))) {
      return false;
    }
    if (!($effekt.equals(this.y_1, other8874.y_1))) {
      return false;
    }
    if (!($effekt.equals(this.z_0, other8874.z_0))) {
      return false;
    }
    if (!($effekt.equals(this.w_0, other8874.w_0))) {
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



$effekt.readln = function readln$impl(callback) {
  const readline = require('node:readline').createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  readline.question('', (answer) => {
    readline.close();
    callback(answer);
  });
}



  function array$set(arr, index, value) {
    arr[index] = value;
    return $effekt.unit
  }



  function set$impl(ref, value) {
    ref.value = value;
    return $effekt.unit;
  }


function reverseOnto_0(l_0, other_0, ks_0, k_0) {
  reverseOnto_1: while (true) {
    switch (l_0.__tag) {
      case 0:  return () => k_0(other_0, ks_0);
      case 1: 
        const a_0 = l_0.head_0;
        const rest_0 = l_0.tail_0;
        /* prepare call */
        const tmp_other_0 = other_0;
        l_0 = rest_0;
        other_0 = new Cons_0(a_0, tmp_other_0);
        continue reverseOnto_1;
    }
  }
}

function charAt_0(str_0, index_0, Exception_0, ks_1, k_1) {
  if ((index_0 < (0))) {
    return Exception_0.raise_0(new OutOfBounds_0(), ((("Index out of bounds: " + ('' + index_0)) + " in string: '") + str_0) + "'", ks_1, undefined);
  } else if ((index_0 >= (str_0.length))) {
    return Exception_0.raise_0(new OutOfBounds_0(), ((("Index out of bounds: " + ('' + index_0)) + " in string: '") + str_0) + "'", ks_1, undefined);
  } else {
    return () => k_1(str_0.codePointAt(index_0), ks_1);
  }
}

function list_len_0(l_1, ks_2, k_2) {
  list_len_1: while (true) {
    switch (l_1.__tag) {
      case 0:  return () => k_2(0, ks_2);
      case 1: 
        const as_0 = l_1.tail_0;
        /* prepare call */
        const tmp_k_0 = k_2;
        k_2 = (v_r_0, ks_3) => () => tmp_k_0(((1) + v_r_0), ks_3);
        l_1 = as_0;
        continue list_len_1;
    }
  }
}

function tile_to_grid_0(arg_3, arg_1, arg_0, arg_2, ks_6, k_4) {
  function grid_worker_0(segments_0, ks_4, k_3) {
    grid_worker_1: while (true) {
      switch (segments_0.__tag) {
        case 0:  return () => k_3(new Nil_0(), ks_4);
        case 1: 
          const head_1 = segments_0.head_0;
          const t_0 = segments_0.tail_0;
          const x_2 = head_1.x_1;
          const y_2 = head_1.y_1;
          const x_3 = head_1.z_0;
          const y_3 = head_1.w_0;
          const x_4 = arg_0.x_0;
          const y_4 = arg_0.y_0;
          const x_5 = arg_1.x_0;
          const y_5 = arg_1.y_0;
          const x_6 = arg_2.x_0;
          const y_6 = arg_2.y_0;
          const x_7 = arg_0.x_0;
          const y_7 = arg_0.y_0;
          const x_8 = arg_1.x_0;
          const y_8 = arg_1.y_0;
          const x_9 = arg_2.x_0;
          const y_9 = arg_2.y_0;
          /* prepare call */
          const tmp_k_1 = k_3;
          k_3 = (v_r_1, ks_5) =>
            () =>
              tmp_k_1(new Cons_0(new Vec_1((((x_5 + (Math.floor(((x_4 * x_2)) / (16))))) + (Math.floor(((x_6 * y_2)) / (16)))), (((y_5 + (Math.floor(((y_4 * x_2)) / (16))))) + (Math.floor(((y_6 * y_2)) / (16)))), (((x_8 + (Math.floor(((x_7 * x_3)) / (16))))) + (Math.floor(((x_9 * y_3)) / (16)))), (((y_8 + (Math.floor(((y_7 * x_3)) / (16))))) + (Math.floor(((y_9 * y_3)) / (16))))), v_r_1), ks_5);
          segments_0 = t_0;
          continue grid_worker_1;
      }
    }
  }
  return grid_worker_0(arg_3, ks_6, k_4);
}

function p_0(arg_4, q_0, q_1, ks_7, k_5) {
  return tile_to_grid_0(new Cons_0(new Vec_1(0, 3, 3, 4), new Cons_0(new Vec_1(3, 4, 0, 8), new Cons_0(new Vec_1(0, 8, 0, 3), new Cons_0(new Vec_1(6, 0, 4, 4), new Cons_0(new Vec_1(4, 5, 4, 10), new Cons_0(new Vec_1(4, 10, 7, 6), new Cons_0(new Vec_1(7, 6, 4, 5), new Cons_0(new Vec_1(11, 0, 10, 4), new Cons_0(new Vec_1(10, 4, 9, 6), new Cons_0(new Vec_1(9, 6, 8, 8), new Cons_0(new Vec_1(8, 8, 4, 13), new Cons_0(new Vec_1(4, 13, 0, 16), new Cons_0(new Vec_1(0, 16, 6, 15), new Cons_0(new Vec_1(6, 15, 8, 16), new Cons_0(new Vec_1(8, 16, 12, 12), new Cons_0(new Vec_1(12, 12, 16, 12), new Cons_0(new Vec_1(10, 16, 12, 14), new Cons_0(new Vec_1(12, 14, 16, 13), new Cons_0(new Vec_1(12, 16, 13, 15), new Cons_0(new Vec_1(13, 15, 16, 14), new Cons_0(new Vec_1(14, 16, 16, 15), new Cons_0(new Vec_1(8, 12, 16, 10), new Cons_0(new Vec_1(8, 8, 12, 9), new Cons_0(new Vec_1(12, 9, 16, 8), new Cons_0(new Vec_1(9, 6, 12, 7), new Cons_0(new Vec_1(12, 7, 16, 6), new Cons_0(new Vec_1(10, 4, 13, 5), new Cons_0(new Vec_1(13, 5, 16, 4), new Cons_0(new Vec_1(11, 0, 14, 2), new Cons_0(new Vec_1(14, 2, 16, 2), new Nil_0())))))))))))))))))))))))))))))), arg_4, q_0, q_1, ks_7, k_5);
}

function q_2(arg_5, q_3, q_4, ks_8, k_6) {
  return tile_to_grid_0(new Cons_0(new Vec_1(0, 8, 4, 7), new Cons_0(new Vec_1(4, 7, 6, 7), new Cons_0(new Vec_1(6, 7, 8, 8), new Cons_0(new Vec_1(8, 8, 12, 10), new Cons_0(new Vec_1(12, 10, 16, 16), new Cons_0(new Vec_1(0, 12, 3, 13), new Cons_0(new Vec_1(3, 13, 5, 14), new Cons_0(new Vec_1(5, 14, 7, 15), new Cons_0(new Vec_1(7, 15, 8, 16), new Cons_0(new Vec_1(2, 16, 3, 13), new Cons_0(new Vec_1(4, 16, 5, 14), new Cons_0(new Vec_1(6, 16, 7, 15), new Cons_0(new Vec_1(0, 10, 7, 11), new Cons_0(new Vec_1(9, 13, 8, 15), new Cons_0(new Vec_1(8, 15, 11, 15), new Cons_0(new Vec_1(11, 15, 9, 13), new Cons_0(new Vec_1(10, 10, 8, 12), new Cons_0(new Vec_1(8, 12, 12, 12), new Cons_0(new Vec_1(12, 12, 10, 10), new Cons_0(new Vec_1(2, 0, 4, 5), new Cons_0(new Vec_1(4, 5, 4, 7), new Cons_0(new Vec_1(4, 0, 6, 5), new Cons_0(new Vec_1(6, 5, 6, 7), new Cons_0(new Vec_1(6, 0, 8, 5), new Cons_0(new Vec_1(8, 5, 8, 8), new Cons_0(new Vec_1(10, 0, 14, 11), new Cons_0(new Vec_1(12, 0, 13, 4), new Cons_0(new Vec_1(13, 4, 16, 8), new Cons_0(new Vec_1(16, 8, 15, 10), new Cons_0(new Vec_1(15, 10, 16, 16), new Cons_0(new Vec_1(13, 0, 16, 6), new Cons_0(new Vec_1(14, 0, 16, 4), new Cons_0(new Vec_1(15, 0, 16, 2), new Cons_0(new Vec_1(0, 0, 8, 0), new Cons_0(new Vec_1(12, 0, 16, 0), new Cons_0(new Vec_1(0, 0, 0, 8), new Cons_0(new Vec_1(0, 12, 0, 16), new Nil_0()))))))))))))))))))))))))))))))))))))), arg_5, q_3, q_4, ks_8, k_6);
}

function r_0(arg_6, q_5, q_6, ks_9, k_7) {
  return tile_to_grid_0(new Cons_0(new Vec_1(0, 0, 8, 8), new Cons_0(new Vec_1(12, 12, 16, 16), new Cons_0(new Vec_1(0, 4, 5, 10), new Cons_0(new Vec_1(0, 8, 2, 12), new Cons_0(new Vec_1(0, 12, 1, 14), new Cons_0(new Vec_1(16, 6, 11, 10), new Cons_0(new Vec_1(11, 10, 6, 16), new Cons_0(new Vec_1(16, 4, 14, 6), new Cons_0(new Vec_1(14, 6, 8, 8), new Cons_0(new Vec_1(8, 8, 5, 10), new Cons_0(new Vec_1(5, 10, 2, 12), new Cons_0(new Vec_1(2, 12, 0, 16), new Cons_0(new Vec_1(16, 8, 12, 12), new Cons_0(new Vec_1(12, 12, 11, 16), new Cons_0(new Vec_1(1, 1, 4, 0), new Cons_0(new Vec_1(2, 2, 8, 0), new Cons_0(new Vec_1(3, 3, 8, 2), new Cons_0(new Vec_1(8, 2, 12, 0), new Cons_0(new Vec_1(5, 5, 12, 3), new Cons_0(new Vec_1(12, 3, 16, 0), new Cons_0(new Vec_1(11, 16, 12, 12), new Cons_0(new Vec_1(12, 12, 16, 8), new Cons_0(new Vec_1(13, 13, 16, 10), new Cons_0(new Vec_1(14, 14, 16, 12), new Cons_0(new Vec_1(15, 15, 16, 14), new Nil_0()))))))))))))))))))))))))), arg_6, q_5, q_6, ks_9, k_7);
}

function s_0(arg_7, q_7, q_8, ks_10, k_8) {
  return tile_to_grid_0(new Cons_0(new Vec_1(0, 0, 4, 2), new Cons_0(new Vec_1(4, 2, 8, 2), new Cons_0(new Vec_1(8, 2, 16, 0), new Cons_0(new Vec_1(0, 4, 2, 1), new Cons_0(new Vec_1(0, 6, 7, 4), new Cons_0(new Vec_1(0, 8, 8, 6), new Cons_0(new Vec_1(0, 10, 7, 8), new Cons_0(new Vec_1(0, 12, 7, 10), new Cons_0(new Vec_1(0, 14, 7, 13), new Cons_0(new Vec_1(13, 13, 16, 14), new Cons_0(new Vec_1(14, 11, 16, 12), new Cons_0(new Vec_1(15, 9, 16, 10), new Cons_0(new Vec_1(16, 0, 10, 4), new Cons_0(new Vec_1(10, 4, 8, 6), new Cons_0(new Vec_1(8, 6, 7, 8), new Cons_0(new Vec_1(7, 8, 7, 13), new Cons_0(new Vec_1(7, 13, 8, 16), new Cons_0(new Vec_1(12, 16, 13, 13), new Cons_0(new Vec_1(13, 13, 14, 11), new Cons_0(new Vec_1(14, 11, 15, 9), new Cons_0(new Vec_1(15, 9, 16, 8), new Cons_0(new Vec_1(10, 16, 11, 10), new Cons_0(new Vec_1(12, 4, 10, 6), new Cons_0(new Vec_1(10, 6, 12, 7), new Cons_0(new Vec_1(12, 7, 12, 4), new Cons_0(new Vec_1(15, 5, 13, 7), new Cons_0(new Vec_1(13, 7, 15, 8), new Cons_0(new Vec_1(15, 8, 15, 5), new Nil_0())))))))))))))))))))))))))))), arg_7, q_7, q_8, ks_10, k_8);
}

function t_1(arg_8, q_9, q_10, ks_13, k_11) {
  return above_0(1, 1, arg_8, q_9, q_10, (p_1, p_2, p_3, ks_11, k_9) =>
    beside_0(1, 1, p_1, p_2, p_3, p_0, q_2, ks_11, k_9), (p_4, p_5, p_6, ks_12, k_10) =>
    beside_0(1, 1, p_4, p_5, p_6, r_0, s_0, ks_12, k_10), ks_13, k_11);
}

function u_0(arg_9, p_7, p_8, ks_15, k_13) {
  return cycle_0(arg_9, p_7, p_8, (a_1, b_0, c_0, ks_14, k_12) => {
    const x_10 = a_1.x_0;
    const y_10 = a_1.y_0;
    const x_11 = b_0.x_0;
    const y_11 = b_0.y_0;
    const x_12 = b_0.x_0;
    const y_12 = b_0.y_0;
    return q_2(new Vec_0((x_10 + x_11), (y_10 + y_11)), c_0, new Vec_0(((0) - x_12), ((0) - y_12)), ks_14, k_12);
  }, ks_15, k_13);
}

function nil_0(a_2, b_1, c_1, ks_16, k_14) {
  return () => k_14(new Nil_0(), ks_16);
}

function beside_0(m_0, n_0, a_3, b_2, c_2, p_9, q_11, ks_17, k_16) {
  const tmp_0 = (m_0 + n_0);
  const x_13 = b_2.x_0;
  const y_13 = b_2.y_0;
  return p_9(a_3, new Vec_0(Math.floor(((x_13 * m_0)) / tmp_0), Math.floor(((y_13 * m_0)) / tmp_0)), c_2, ks_17, (v_r_2, ks_18) => {
    const tmp_1 = (m_0 + n_0);
    const x_14 = b_2.x_0;
    const y_14 = b_2.y_0;
    const x_15 = a_3.x_0;
    const y_15 = a_3.y_0;
    const tmp_2 = (n_0 + m_0);
    const x_16 = b_2.x_0;
    const y_16 = b_2.y_0;
    return q_11(new Vec_0((x_15 + (Math.floor(((x_14 * m_0)) / tmp_1))), (y_15 + (Math.floor(((y_14 * m_0)) / tmp_1)))), new Vec_0(Math.floor(((x_16 * n_0)) / tmp_2), Math.floor(((y_16 * n_0)) / tmp_2)), c_2, ks_18, (v_r_3, ks_19) => {
      const res_0 = ks_19.arena.fresh(new Nil_0());
      function foreach_worker_0(l_2, ks_20, k_15) {
        foreach_worker_1: while (true) {
          switch (l_2.__tag) {
            case 0:  return () => k_15($effekt.unit, ks_20);
            case 1: 
              const head_2 = l_2.head_0;
              const tail_1 = l_2.tail_0;
              const s_1 = res_0.value;
              res_0.set(new Cons_0(head_2, s_1));
              /* prepare call */
              l_2 = tail_1;
              continue foreach_worker_1;
          }
        }
      }
      return foreach_worker_0(v_r_2, ks_19, (_0, ks_21) => {
        const s_2 = res_0.value;
        return reverseOnto_0(s_2, v_r_3, ks_21, (tmp_3, ks_22) =>
          () => k_16(tmp_3, ks_22));
      });
    });
  });
}

function above_0(m_1, n_1, a_4, b_3, c_3, p_10, q_12, ks_23, k_18) {
  const tmp_4 = (m_1 + n_1);
  const x_17 = c_3.x_0;
  const y_17 = c_3.y_0;
  const x_18 = a_4.x_0;
  const y_18 = a_4.y_0;
  const tmp_5 = (n_1 + m_1);
  const x_19 = c_3.x_0;
  const y_19 = c_3.y_0;
  return p_10(new Vec_0((x_18 + (Math.floor(((x_17 * n_1)) / tmp_4))), (y_18 + (Math.floor(((y_17 * n_1)) / tmp_4)))), b_3, new Vec_0(Math.floor(((x_19 * m_1)) / tmp_5), Math.floor(((y_19 * m_1)) / tmp_5)), ks_23, (v_r_4, ks_24) => {
    const tmp_6 = (m_1 + n_1);
    const x_20 = c_3.x_0;
    const y_20 = c_3.y_0;
    return q_12(a_4, b_3, new Vec_0(Math.floor(((x_20 * n_1)) / tmp_6), Math.floor(((y_20 * n_1)) / tmp_6)), ks_24, (v_r_5, ks_25) => {
      const res_1 = ks_25.arena.fresh(new Nil_0());
      function foreach_worker_2(l_3, ks_26, k_17) {
        foreach_worker_3: while (true) {
          switch (l_3.__tag) {
            case 0:  return () => k_17($effekt.unit, ks_26);
            case 1: 
              const head_3 = l_3.head_0;
              const tail_2 = l_3.tail_0;
              const s_3 = res_1.value;
              res_1.set(new Cons_0(head_3, s_3));
              /* prepare call */
              l_3 = tail_2;
              continue foreach_worker_3;
          }
        }
      }
      return foreach_worker_2(v_r_4, ks_25, (_1, ks_27) => {
        const s_4 = res_1.value;
        return reverseOnto_0(s_4, v_r_5, ks_27, (tmp_7, ks_28) =>
          () => k_18(tmp_7, ks_28));
      });
    });
  });
}

function cycle_0(arg_10, p_12, p_13, p_11, ks_34, k_24) {
  function b_blockBinding_0(a_5, b_4, c_4, ks_29, k_19) {
    const x_21 = a_5.x_0;
    const y_21 = a_5.y_0;
    const x_22 = b_4.x_0;
    const y_22 = b_4.y_0;
    const x_23 = b_4.x_0;
    const y_23 = b_4.y_0;
    const x_24 = c_4.x_0;
    const y_24 = c_4.y_0;
    const x_25 = c_4.x_0;
    const y_25 = c_4.y_0;
    return p_11(new Vec_0((((x_21 + x_22)) + x_24), (((y_21 + y_22)) + y_24)), new Vec_0(((0) - x_23), ((0) - y_23)), new Vec_0(((0) - x_25), ((0) - y_25)), ks_29, k_19);
  }
  function b_blockBinding_1(a_6, b_5, c_5, ks_30, k_20) {
    const x_26 = a_6.x_0;
    const y_26 = a_6.y_0;
    const x_27 = b_5.x_0;
    const y_27 = b_5.y_0;
    const x_28 = b_5.x_0;
    const y_28 = b_5.y_0;
    return p_11(new Vec_0((x_26 + x_27), (y_26 + y_27)), c_5, new Vec_0(((0) - x_28), ((0) - y_28)), ks_30, k_20);
  }
  function b_blockBinding_2(a_7, b_6, c_6, ks_31, k_21) {
    const x_29 = a_7.x_0;
    const y_29 = a_7.y_0;
    const x_30 = b_6.x_0;
    const y_30 = b_6.y_0;
    const x_31 = b_6.x_0;
    const y_31 = b_6.y_0;
    const x_32 = c_6.x_0;
    const y_32 = c_6.y_0;
    const x_33 = c_6.x_0;
    const y_33 = c_6.y_0;
    return p_11(new Vec_0((((x_29 + x_30)) + x_32), (((y_29 + y_30)) + y_32)), new Vec_0(((0) - x_31), ((0) - y_31)), new Vec_0(((0) - x_33), ((0) - y_33)), ks_31, k_21);
  }
  return above_0(1, 1, arg_10, p_12, p_13, (p_14, p_15, p_16, ks_32, k_22) =>
    beside_0(1, 1, p_14, p_15, p_16, p_11, b_blockBinding_0, ks_32, k_22), (p_17, p_18, p_19, ks_33, k_23) =>
    beside_0(1, 1, p_17, p_18, p_19, b_blockBinding_1, b_blockBinding_2, ks_33, k_23), ks_34, k_24);
}

function side_0(arg_11, q_13, q_14, ks_40, k_30) {
  function b_blockBinding_3(a_8, b_7, c_7, ks_37, k_27) {
    const x_34 = a_8.x_0;
    const y_34 = a_8.y_0;
    const x_35 = b_7.x_0;
    const y_35 = b_7.y_0;
    const x_36 = b_7.x_0;
    const y_36 = b_7.y_0;
    return above_0(1, 1, new Vec_0((x_34 + x_35), (y_34 + y_35)), c_7, new Vec_0(((0) - x_36), ((0) - y_36)), (p_20, p_21, p_22, ks_35, k_25) =>
      beside_0(1, 1, p_20, p_21, p_22, p_0, q_2, ks_35, k_25), (p_23, p_24, p_25, ks_36, k_26) =>
      beside_0(1, 1, p_23, p_24, p_25, r_0, s_0, ks_36, k_26), ks_37, k_27);
  }
  return above_0(1, 1, arg_11, q_13, q_14, (p_26, p_27, p_28, ks_38, k_28) =>
    beside_0(1, 1, p_26, p_27, p_28, nil_0, nil_0, ks_38, k_28), (p_29, p_30, p_31, ks_39, k_29) =>
    beside_0(1, 1, p_29, p_30, p_31, b_blockBinding_3, t_1, ks_39, k_29), ks_40, k_30);
}

function side_1(arg_12, q_15, q_16, ks_46, k_36) {
  function b_blockBinding_4(a_9, b_8, c_8, ks_43, k_33) {
    const x_37 = a_9.x_0;
    const y_37 = a_9.y_0;
    const x_38 = b_8.x_0;
    const y_38 = b_8.y_0;
    const x_39 = b_8.x_0;
    const y_39 = b_8.y_0;
    return above_0(1, 1, new Vec_0((x_37 + x_38), (y_37 + y_38)), c_8, new Vec_0(((0) - x_39), ((0) - y_39)), (p_32, p_33, p_34, ks_41, k_31) =>
      beside_0(1, 1, p_32, p_33, p_34, p_0, q_2, ks_41, k_31), (p_35, p_36, p_37, ks_42, k_32) =>
      beside_0(1, 1, p_35, p_36, p_37, r_0, s_0, ks_42, k_32), ks_43, k_33);
  }
  return above_0(1, 1, arg_12, q_15, q_16, (p_38, p_39, p_40, ks_44, k_34) =>
    beside_0(1, 1, p_38, p_39, p_40, side_0, side_0, ks_44, k_34), (p_41, p_42, p_43, ks_45, k_35) =>
    beside_0(1, 1, p_41, p_42, p_43, b_blockBinding_4, t_1, ks_45, k_35), ks_46, k_36);
}

function corner_0(arg_13, q_17, q_18, ks_49, k_39) {
  return above_0(1, 1, arg_13, q_17, q_18, (p_44, p_45, p_46, ks_47, k_37) =>
    beside_0(1, 1, p_44, p_45, p_46, nil_0, nil_0, ks_47, k_37), (p_47, p_48, p_49, ks_48, k_38) =>
    beside_0(1, 1, p_47, p_48, p_49, nil_0, u_0, ks_48, k_38), ks_49, k_39);
}

function corner_1(arg_14, q_19, q_20, ks_53, k_43) {
  function b_blockBinding_5(a_10, b_9, c_9, ks_50, k_40) {
    const x_40 = a_10.x_0;
    const y_40 = a_10.y_0;
    const x_41 = b_9.x_0;
    const y_41 = b_9.y_0;
    const x_42 = b_9.x_0;
    const y_42 = b_9.y_0;
    return side_0(new Vec_0((x_40 + x_41), (y_40 + y_41)), c_9, new Vec_0(((0) - x_42), ((0) - y_42)), ks_50, k_40);
  }
  return above_0(1, 1, arg_14, q_19, q_20, (p_50, p_51, p_52, ks_51, k_41) =>
    beside_0(1, 1, p_50, p_51, p_52, corner_0, side_0, ks_51, k_41), (p_53, p_54, p_55, ks_52, k_42) =>
    beside_0(1, 1, p_53, p_54, p_55, b_blockBinding_5, u_0, ks_52, k_42), ks_53, k_43);
}

function pseudocorner_0(arg_15, q_21, q_22, ks_60, k_50) {
  function b_blockBinding_6(a_11, b_10, c_10, ks_54, k_44) {
    const x_43 = a_11.x_0;
    const y_43 = a_11.y_0;
    const x_44 = b_10.x_0;
    const y_44 = b_10.y_0;
    const x_45 = b_10.x_0;
    const y_45 = b_10.y_0;
    return side_1(new Vec_0((x_43 + x_44), (y_43 + y_44)), c_10, new Vec_0(((0) - x_45), ((0) - y_45)), ks_54, k_44);
  }
  function b_blockBinding_7(a_12, b_11, c_11, ks_57, k_47) {
    const x_46 = a_12.x_0;
    const y_46 = a_12.y_0;
    const x_47 = b_11.x_0;
    const y_47 = b_11.y_0;
    const x_48 = b_11.x_0;
    const y_48 = b_11.y_0;
    return above_0(1, 1, new Vec_0((x_46 + x_47), (y_46 + y_47)), c_11, new Vec_0(((0) - x_48), ((0) - y_48)), (p_56, p_57, p_58, ks_55, k_45) =>
      beside_0(1, 1, p_56, p_57, p_58, p_0, q_2, ks_55, k_45), (p_59, p_60, p_61, ks_56, k_46) =>
      beside_0(1, 1, p_59, p_60, p_61, r_0, s_0, ks_56, k_46), ks_57, k_47);
  }
  return above_0(1, 1, arg_15, q_21, q_22, (p_62, p_63, p_64, ks_58, k_48) =>
    beside_0(1, 1, p_62, p_63, p_64, corner_1, side_1, ks_58, k_48), (p_65, p_66, p_67, ks_59, k_49) =>
    beside_0(1, 1, p_65, p_66, p_67, b_blockBinding_6, b_blockBinding_7, ks_59, k_49), ks_60, k_50);
}

function main_0(ks_62, k_66) {
  const tmp_8 = process.argv.slice(1);
  const tmp_9 = tmp_8.length;
  function toList_worker_0(start_0, acc_0, ks_61, k_51) {
    toList_worker_1: while (true) {
      if ((start_0 < (1))) {
        return () => k_51(acc_0, ks_61);
      } else {
        const tmp_10 = tmp_8[start_0];
        /* prepare call */
        const tmp_start_0 = start_0;
        const tmp_acc_0 = acc_0;
        start_0 = (tmp_start_0 - (1));
        acc_0 = new Cons_0(tmp_10, tmp_acc_0);
        continue toList_worker_1;
      }
    }
  }
  return toList_worker_0((tmp_9 - (1)), new Nil_0(), ks_62, (v_r_6, ks_63) => {
    switch (v_r_6.__tag) {
      case 1: 
        const n_str_0 = v_r_6.head_0;
        const tail_3 = v_r_6.tail_0;
        switch (tail_3.__tag) {
          case 0: 
            return RESET((p_68, ks_64, k_52) => {
              function go_0(index_1, acc_1, ks_70, k_59) {
                return RESET((p_69, ks_65, k_53) => {
                  const Exception_1 = {
                    raise_0: (exception_0, msg_0, ks_66, k_54) =>
                      SHIFT(p_69, (k_55, ks_67, k_56) =>
                        () => k_56(acc_1, ks_67), ks_66, undefined)
                  };
                  return charAt_0(n_str_0, index_1, Exception_1, ks_65, (c_12, ks_68) => {
                    let v_r_7 = undefined;
                    if ((c_12 >= (48))) {
                      v_r_7 = (c_12 <= (57));
                    } else {
                      v_r_7 = false;
                    }
                    let d_0 = undefined;
                    if (v_r_7) {
                      d_0 = ((c_12) - ((48)));
                    } else {
                      return SHIFT(p_68, (k_57, ks_69, k_58) => {
                        const tmp_11 = (function() { throw (("Not a valid digit: '" + (String.fromCodePoint(c_12))) + "' in base 10") })();
                        return () => k_58(tmp_11, ks_69);
                      }, ks_68, undefined);
                    }
                    return go_0((index_1 + (1)), ((((10) * acc_1)) + d_0), ks_68, k_53);
                  });
                }, ks_70, k_59);
              }
              const Exception_2 = {
                raise_0: (exception_1, msg_1, ks_71, k_60) =>
                  SHIFT(p_68, (k_61, ks_72, k_62) => {
                    const tmp_12 = (function() { throw "Empty string is not a valid number" })();
                    return () => k_62(tmp_12, ks_72);
                  }, ks_71, undefined)
              };
              return charAt_0(n_str_0, 0, Exception_2, ks_64, (v_r_8, ks_73) => {
                if (v_r_8 === (45)) {
                  return go_0(1, 0, ks_73, (v_r_9, ks_74) =>
                    () => k_52(((0) - v_r_9), ks_74));
                } else {
                  return go_0(0, 0, ks_73, k_52);
                }
              });
            }, ks_63, (n_2, ks_75) => {
              function enum_from_to_worker_0(from_0, ks_77, k_63) {
                enum_from_to_worker_1: while (true) {
                  if ((from_0 <= n_2)) {
                    /* prepare call */
                    const tmp_from_0 = from_0;
                    const tmp_k_2 = k_63;
                    k_63 = (v_r_10, ks_76) =>
                      () => tmp_k_2(new Cons_0(tmp_from_0, v_r_10), ks_76);
                    from_0 = (tmp_from_0 + (1));
                    continue enum_from_to_worker_1;
                  } else {
                    return () => k_63(new Nil_0(), ks_77);
                  }
                }
              }
              return enum_from_to_worker_0(1, ks_75, (v_r_11, ks_78) => {
                const acc_2 = ks_78.arena.fresh(new Nil_0());
                function foreach_worker_4(l_4, ks_79, k_64) {
                  switch (l_4.__tag) {
                    case 0:  return () => k_64($effekt.unit, ks_79);
                    case 1: 
                      const head_4 = l_4.head_0;
                      const tail_4 = l_4.tail_0;
                      if (((0) < head_4)) {
                        return cycle_0(new Vec_0(0, 0), new Vec_0(((640) + (0)), 0), new Vec_0(0, ((640) + (0))), pseudocorner_0, ks_79, (v_r_12, ks_80) => {
                          const s_5 = acc_2.value;
                          acc_2.set(new Cons_0(v_r_12, s_5));
                          return foreach_worker_4(tail_4, ks_80, k_64);
                        });
                      } else {
                        return cycle_0(new Vec_0(0, 0), new Vec_0(((640) + head_4), 0), new Vec_0(0, ((640) + head_4)), pseudocorner_0, ks_79, (v_r_13, ks_81) => {
                          const s_6 = acc_2.value;
                          acc_2.set(new Cons_0(v_r_13, s_6));
                          return foreach_worker_4(tail_4, ks_81, k_64);
                        });
                      }
                      break;
                  }
                }
                return foreach_worker_4(v_r_11, ks_78, (_2, ks_82) => {
                  const s_7 = acc_2.value;
                  const res_2 = ks_82.arena.fresh(new Nil_0());
                  function foreach_worker_5(l_5, ks_83, k_65) {
                    foreach_worker_6: while (true) {
                      switch (l_5.__tag) {
                        case 0:  return () => k_65($effekt.unit, ks_83);
                        case 1: 
                          const head_5 = l_5.head_0;
                          const tail_5 = l_5.tail_0;
                          const s_8 = res_2.value;
                          res_2.set(new Cons_0(head_5, s_8));
                          /* prepare call */
                          l_5 = tail_5;
                          continue foreach_worker_6;
                      }
                    }
                  }
                  return foreach_worker_5(s_7, ks_82, (_3, ks_84) => {
                    const s_9 = res_2.value;
                    switch (s_9.__tag) {
                      case 0: 
                        return list_len_0(new Nil_0(), ks_84, (v_r_14, ks_85) => {
                          const tmp_13 = $effekt.println(('' + v_r_14));
                          return () => k_66(tmp_13, ks_85);
                        });
                      case 1: 
                        const a_13 = s_9.head_0;
                        return list_len_0(a_13, ks_84, (v_r_15, ks_86) => {
                          const tmp_14 = $effekt.println(('' + v_r_15));
                          return () => k_66(tmp_14, ks_86);
                        });
                    }
                  });
                });
              });
            });
          default: 
            const tmp_15 = (function() { throw "Please provide argument \"n\"" })();
            return () => k_66(tmp_15, ks_63);
        }
        break;
      default: 
        const tmp_16 = (function() { throw "Please provide argument \"n\"" })();
        return () => k_66(tmp_16, ks_63);
    }
  });
}

(typeof module != "undefined" && module !== null ? module : {}).exports = $Fish = {
  main: () => RUN_TOPLEVEL(main_0)
};