structure Main = struct 
  fun main (_,args) = 
    let val _ = Gcd.run (tl args) in 
      OS.Process.success
    end 
end
