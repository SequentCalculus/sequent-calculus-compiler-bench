structure Main = struct
  fun main (_,args) =
    let val _ = Cryptarithm1.run (tl args) in
      OS.Process.success
    end
end
