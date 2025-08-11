structure Main = struct
  fun main (_,args) =
    let val _ = Life.run (tl args) in
      OS.Process.success
    end
end
