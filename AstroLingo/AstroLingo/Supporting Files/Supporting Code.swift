import Foundation

extension Dictionary{
    mutating func collectElements(from another: inout [Key : Value], whichAre numberOfCopies: Int) -> Bool{//-> [Key: Value] {
        var didSucceed = false
        var count = numberOfCopies
        
        for (key,value) in another {
            if count != 0 {
                self[key] = value
                another.removeValue(forKey: key)
                count -= 1
                didSucceed = true
            }
        }
        return didSucceed
    }
    
    func printDictionary() {
        for (key, value) in self {
            print("\(key):\t\(value)\n")
        }
        print("=========================================================\n")
    }
}
