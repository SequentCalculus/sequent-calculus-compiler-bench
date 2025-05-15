structure Main = struct 
  fun main (_,args) = 
    let val _ = FibonacciRecursive.run (tl args) in 
      OS.Process.success
    end 
end
