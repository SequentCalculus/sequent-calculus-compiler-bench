structure Main = struct 
  fun main (_,args) = 
    let val _ = Takl.run (tl args) in 
      OS.Process.success
    end 
end
