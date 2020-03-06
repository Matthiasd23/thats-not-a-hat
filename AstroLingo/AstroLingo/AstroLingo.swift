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
    
    let m = Model()
    
    init() {
        score = 0
        numberOfWordsLeft = 10 //TODO: [What is the Starting number of Words Left?]
        maxNumberOfWordsOnScreen = 3
        correctAnswersEntered = 0
        wrongAnswersEntered = 0
        player = Player()
        wordDictionary = ["1":["one","een"],
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
                         "22":["twenty two","tweeentwintig"],
                         "23":["twenty three","drieentwintig"],
                         "24":["twenty four","vierentwintig"],
                         "25":["twenty five","vijfentwintig"],
                         "26":["twenty six","zesentwintig"],
                         "27":["twenty seven","zevenentwintig"] ]
            
//
//
//
//
//            ["dog":["dog"], "cat":["cat"], "horse":["horse"], "lion":["lion"], "elephant":["elephant"], "ostrich":["ostrich"], "jaguar":["jaguar"], "panda":["panda"], "snail":["snail"], "monkey":["monkey"], "goose":["goose"]]
        //adding words to declarative memory
        for (number, items) in wordDictionary {
            let x = Chunk(s: "we" + number, m: m)
            x.setSlot(slot: "isa", value: "translation") // creating chunk type
            x.setSlot(slot: "numerical", value: number) // creating first slot with numerical values
            x.setSlot(slot: "english", value: items[0]) // creating second slot with english word
            x.setSlot(slot: "dutch", value: items[1]) // creating third slot with dutch translation
            x.setSlot(slot: "learned", value: "new")  // defining whether chunk was used before
            m.dm.addToDM(x)
        }
        m.dm.activationNoise = 0.0 // setting activation noise to 0
        fallingWords = [:]
    }
    //creating function for retrieving next word
    func nextWord(lower: Double, higher: Double) -> Chunk { // finding optimal chunk for retrieval
        var lowestInRange: Chunk? = nil //defining variable to save chunk with best activation levels
        var lowestInRangeValue: Double = 10000 //defining variable to save the lowest value in the range
        var lowerThanLower: [Chunk] = [] //defining variable for saving chunk lower than opimal retrieval values
        for (_,chunk) in m.dm.chunks { //retrieving chunk from declarative memory
            let act = chunk.activation() //retrieving activation of chunk
            if act >= lower  && act < lowestInRangeValue { //checking if value in range exists, if so save it
                lowestInRangeValue = act
                lowestInRange = chunk
            } else if act < lower { //otherwise if value lower than this activation exists safe it
                lowerThanLower.append(chunk)
            }
        }
        if (lowestInRange != nil && lowestInRangeValue <= higher) { //return lowest in range
            return lowestInRange!
        } else
            if !lowerThanLower.isEmpty { //return random chunk if value lowerThanLower
                return lowerThanLower[Int(arc4random_uniform(UInt32(lowerThanLower.count)))]
        } else { //if non of the above is true return lowest value
            return lowestInRange!
        }
        
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
    
    func enterWord(wordToBeMatched key: String, playersWord value: String) {
        var wordIsCorrect = false
        
        if fallingWords[key]?.contains(value) ?? false{
            fallingWords.removeValue(forKey: key)
            fillFallingWords()
            wordIsCorrect = true
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
    
    func isOver() -> Bool {//game is over
        if numberOfWordsLeft < 1 || player.getLives() < 1{
            return true
        }
        return false
    }
}
