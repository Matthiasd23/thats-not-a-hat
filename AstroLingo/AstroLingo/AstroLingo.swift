import Foundation

class AstroLingo {
    /*
        number of words
        Correct Answers
        Wrong Answers
        Player()
        fallingWords[](): Dictionary of all the words on the screen
         
     */
    var score : Int
    var maxNumberOfWordsOnScreen : Int
    
    var numberOfWordsLeft: Int
    var correctAnswersEntered: Int
    var wrongAnswersEntered: Int
    var player: Player
    var fallingWords: [String:[String]]
    var wordDictionary: [String:[String]] //wordDictionary[](): Dictionary of all the words available for the game
    
    init() {
        score = 0
        numberOfWordsLeft = 10 //TODO: [What is the Starting number of Words Left?]
        maxNumberOfWordsOnScreen = 3
        correctAnswersEntered = 0
        wrongAnswersEntered = 0
        player = Player()
        wordDictionary = [ "1":["one","een"],
                         "2":["two","twee"],
                         "3":["three","drie"],
                         "4":["four","vier"],
                         "5":["five","vijf"],
                         "6":["six","zes"],
                         "7":["seven","zeven"],
                         "8":["eight","acht"],
                         "9":["nine","negen"],
                         "10":["ten","tien"],
                         "11":["eleven","elf"],
                         "12":["twelve","twaalf"],
                         "13":["thirteen","dertien"],
                         "14":["fourteen","veertien"],
                         "15":["fifteen","vijftien"],
                         "16":["sixteen","zestien"],
                         "17":["seventeen","zeventien"],
                         "18":["eighteen","achttien"],
                         "19":["nineteen","negentien"],
                         "20":["twenty","twintig"],
                         "21":["twenty one","eenentwintig"],
                         "22":["twenty two"],
                         "23":["twenty three"],
                         "24":["twenty four"],
                         "25":["twenty five"],
                         "26":["twenty six"],
                         "27":["twenty seven"] ]
            
//
//
//
//
//            ["dog":["dog"], "cat":["cat"], "horse":["horse"], "lion":["lion"], "elephant":["elephant"], "ostrich":["ostrich"], "jaguar":["jaguar"], "panda":["panda"], "snail":["snail"], "monkey":["monkey"], "goose":["goose"]]
            
        fallingWords = [:]
    }
    
    func fillFallingWords()  {
        if wordDictionary.isEmpty {
            numberOfWordsLeft = 0 //TODO: [check this line of code]
        }
        else {
            let numberOfWordsToBeFilled = maxNumberOfWordsOnScreen-fallingWords.keys.count
            if fallingWords.collectElements(from: &wordDictionary, whichAre: numberOfWordsToBeFilled) {
//                show()
            }
        }
    }
    
    
    func show()  {
        for key in fallingWords.keys
        {
            print("\(key) \n")
        }
        print("==================================\n")
        print("live:\t \(player.getLives())\n")
        print("Number of words left: \t \(self.numberOfWordsLeft)")
        print("Correct Answers Entered: \t\(self.correctAnswersEntered)")
        print("Wrong Answers Entered: \t\(self.wrongAnswersEntered)")
        print("=========================================\n")
    }
    
    func enterWord(playersWord: String) {
        
        player.enterWord(wordEntered: playersWord)
        var wordIsCorrect = false
        
        for (key,values) in fallingWords {
            if values.contains(player.getEnteredWord()) {
                wordIsCorrect = true
                fallingWords.removeValue(forKey: key)
                fillFallingWords()
            }
        }
        
        if wordIsCorrect {
            player.update(with: "correctWord")
            numberOfWordsLeft-=1
            print("Translation correct\n")
            correctAnswersEntered += 1
        }
        else {
            player.update(with: "incorrectWord")
            print("Incorrect Translation\n")
            wrongAnswersEntered += 1
        }
        
        
    }
    
    func getFallingWords() -> [String]
    {
        return Array(fallingWords.keys)
    }
    
    func checkIfWordCanBeFound(wordToBeChecked: String) -> Bool
    {
        for words in fallingWords.values {
            for eachTranslations in words {
                if eachTranslations.hasPrefix(wordToBeChecked) {
                    return true
                }
            }
        }
        return false
    }
}
