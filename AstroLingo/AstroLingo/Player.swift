import Foundation

class Player  {
    /*
        live
         wordEntered
    */
    
    private var lives: Int
    var wordEntered: String
    
    init() {
        lives = 10
        wordEntered = ""
    }
    
    func decreaseLive() {
        lives -= 1
    }
    
    func getLives() -> Int   {
        return lives
    }
    
    func enterWord(wordEntered: String) {
        self.wordEntered = wordEntered
    }
    
    func getEnteredWord() -> String {
        return wordEntered
    }
    
    /// <#Description#> pass "correctWord" if word is entered correctly
    ///pass"incorrectWord" if wrong word is entered
    /// - Parameter status: <#status description#>
    func update(with status: String)  {
        switch status {
        case "correctWord":
            break //TODO: [FIX THE LIVES SYSTEM]
        case "incorrectWord":
            lives -= 1
        default:
             print("Player could not update his score")
        }
    }
    
}

