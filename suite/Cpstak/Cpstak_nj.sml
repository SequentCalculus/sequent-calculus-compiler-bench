structure Main = struct
  fun main (_,args) =
    let val _ = Cpstak.run (tl args) in
      OS.Process.success
    end
end
