structure Main = struct
  fun main (_,args) =
    let val _ = Minimax.run (tl args) in
      OS.Process.success
    end
end
