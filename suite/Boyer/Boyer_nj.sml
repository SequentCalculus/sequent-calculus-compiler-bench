structure Main = struct 
  fun main (_,args) = 
    let val _ = Boyer.run (tl args) in 
      OS.Process.success
    end 
end
