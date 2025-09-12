structure Main = struct
  fun main (_,args) =
    let val _ = FactorialAccumulator.run (tl args) in
      OS.Process.success
    end
end
