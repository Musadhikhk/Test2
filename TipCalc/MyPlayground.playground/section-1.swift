

import Foundation

class Closures {
    
     var names = ["Angry", "Hungry", "Ewa", "Barry", "Daniella"]
    func sortArray (){

        
        println(names.filter{ $0.hasSuffix("ry") })
    }
    
    func memoize<T: Hashable, U>(body: ((T)->U, T) -> U) -> (T)->U {
        var memo = Dictionary<T, U>()
        var result: ((T)->U)!
        result = { x in
            if let q = memo[x] { return q }
            let r = body(result, x)
            memo[x] = r
            return r
        }
        return result
    }
    
    let fib = memoize {
        fib, n in
        return x < 2 ? Double(n) : fib(n - 2) + fib(n - 1)
    }
}



var clos = Closures()
clos.sortArray()

