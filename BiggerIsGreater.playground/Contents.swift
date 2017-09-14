// A Quick playground to calculate the next bigger lexicographical arrangement of a string
import UIKit

extension String {
    func lexicographicalValue() -> Int64 {
        var val : Int64 = 0
        var val_magnitude = 1
        for scalar in self.unicodeScalars.reversed() {
            print(scalar.value)
            val += (Int64(val_magnitude) * Int64(scalar.value-64))
            val_magnitude = val_magnitude * 100
        }
        return val
    }
    
    func lexicographicalArray() -> [Int64] {
        let arr = Array(self).map {
            String($0).lexicographicalValue()
        }
        return arr
    }
    
    init(lexicographicalArray:[Int64]) {
        var string = ""
        for lex in lexicographicalArray {
            string.append(Character.init(Unicode.Scalar.init(UInt32(lex+64))!))
        }
        self = string
    }
    
    func nextBiggest() -> String {
        return String.init(lexicographicalArray:self.nextBiggestLexicographicalArray())
    }
    
    func nextBiggestLexicographicalArray() -> [Int64] {
        
        func findPreviousSmallestCharIndex(index:Int)->Int {
            var result = NSNotFound
            let subarray = self.lexicographicalArray()[0...index]
            for i in (0...subarray.count-1).reversed() {
                if self.lexicographicalArray()[i] < self.lexicographicalArray()[index] {
                    result = i
                    break
                }
            }
            return result
        }
        
        func minimize(array:[Int64],after index:Int) -> [Int64] {
            var newArray:[Int64] = []
            let start = array[0...index]
            newArray.append(contentsOf: start)
            let sorted = array[(index+1)...].sorted { $0 < $1 }
            newArray.append(contentsOf: sorted)
            return newArray
        }
        
        var startingPoint = self.count
        var swapWithIndex = NSNotFound
        repeat {
            startingPoint -= 1
            swapWithIndex = findPreviousSmallestCharIndex(index: startingPoint)
        } while swapWithIndex == NSNotFound && startingPoint > 0
        
        
        if swapWithIndex == NSNotFound && startingPoint == 0 {
            return self.lexicographicalArray()
        }
        var array = self.lexicographicalArray()
        array.swapAt(startingPoint, swapWithIndex)
        
        return minimize(array: array, after: swapWithIndex)
    }
    
}

//Testing
"abdc".nextBiggest()
"abc".nextBiggest()
"cajfb".nextBiggest()
"cafjb".nextBiggest()
"abec".nextBiggest()
"aba".nextBiggest()
"rubegwecfawoo".nextBiggest()
let result = "abckfenvi".nextBiggest()
"abckfevni".lexicographicalValue()
result.lexicographicalValue()
