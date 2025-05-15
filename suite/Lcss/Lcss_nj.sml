structure Main = struct 
  fun main (_,args) = 
    let val _ = Lcss.run (tl args) in 
      OS.Process.success
    end 
end
