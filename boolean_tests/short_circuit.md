# Short Circuiting

## Languages

| Language | Behaviour | Notes                                                 |
| -------- | --------- | ----------------------------------------------------- |
| Scc      | no        | no primitive booleans, works when directly using ifs  |
| Rust     | yes       | `&` and `\|` force evaluation, `&&` and `\|\|` do not |
| SmlMlton | yes       |                                                       |
| SmlNj    | yes       |                                                       |
| OCaml    | yes       |                                                       |
| Effekt   | yes       |                                                       |
| Koka     | yes       |                                                       |

## Benchmarks

| Bench                | Usage | Notes                                            |
| -------------------- | ----- | ------------------------------------------------ |
| Ack                  | None  |                                                  |
| Cryptarithm1         | None  |                                                  |
| FactorialAccumulator | None  |                                                  |
| Lcss                 | None  |                                                  |
| Motzkin              | None  |                                                  |
| SudanGoto            | None  |                                                  |
| AckGoto              | None  |                                                  |
| Deriv                | None  |                                                  |
| Fib                  | None  |                                                  |
| Life                 | Yes   | uses boolean or in list.exists                   |
| MotzkinGoto          | None  |                                                  |
| SumRange             | None  |                                                  |
| Boyer                | Yes   | uses boolean and with complex functions          |
| Divrec               | None  |                                                  |
| Fish                 | None  |                                                  |
| LookupTree           | None  |                                                  |
| Nqueens              | Yes   | uses boolean and with complex functions          |
| TailFib              | None  |                                                  |
| EraseUnused          | None  |                                                  |
| Gcd                  | None  |                                                  |
| MatchOptions         | None  |                                                  |
| Perm                 | None  |                                                  |
| Tak                  | None  |                                                  |
| Constraints          | Yes   | uses boolean nd on integer comparisons           |
| Evenodd              | Yes   | uses boolean and which should always return true |
| Integer              | None  |                                                  |
| Merge                | None  |                                                  |
| Primes               | None  |                                                  |
| TakGoto              | None  |                                                  |
| Cpstak               | None  |                                                  |
| EvenoddGoto          | Yes   | uses boolean and which should always return true |
| IterateIncrement     | None  |                                                  |
| Minimax              | Yes   | uses both and and or within list comprehensions  |
| Sudan                | None  |                                                  |
| Takl                 | None  |                                                  |
