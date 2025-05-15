structure Main = struct 
  fun main (_,args) = 
    let val _ = EvenoddGoto.run (tl args) in 
      OS.Process.success
    end 
end
