import UIKit

class EasyModeViewController: UIViewController {
    
    @IBOutlet weak var wordsLeft: UIProgressView!
    var totalNumberOfWordsToBeShown = 0
    
    var game: EasyMode = EasyMode()
    @IBOutlet var fallingWords: [UILabel]!
        
    @IBOutlet var options: [UIButton]!
        
    @IBOutlet weak var scoreCounter: UILabel!
    

    
    @IBOutlet weak var correctAnswersCounter: UILabel!
    
    @IBOutlet weak var wrongAnswersCounter: UILabel!
        
    
    @IBOutlet weak var endOfGamePopUp: UILabel!
    
    @IBAction func wordIsTouched(_ sender: UIButton) {
        //TODO: [Change this function from a touch to a swipe]
        
        game.enterWord(playersWord: sender.currentTitle! )
        
        updateScreen()
        
        if game.numberOfWordsLeft < 1 {
            gameOverScreenForSuccess()
        }
        
        
        
            
        
        
    }
    
    func gameOverScreenForSuccess() {
        endOfGamePopUp.text = "Victory!!!🙂\nScore: \(game.score) \nCA: \(game.correctAnswersEntered) WA: \(game.wrongAnswersEntered)"//TODO: [Change this output to something more suitable]
        endOfGamePopUp.isHidden = false
    }
    
    func gameOverScreenforFail()  {
        
        
    }
    
    
    
    func fillUpAsteroids()  {
        let temp = game.getFallingWords()
        
        for x in 0..<fallingWords.count {
            fallingWords[x].text = temp[x]
        }
        
        if game.numberOfWordsLeft < 1 {
            
        }
    }
    
    
    func fillUpOptions() {
        var temp = Array(game.fallingWords.values)
        temp.shuffle()
        for x in 0..<fallingWords.count {
            var randomIndex: Int
            if temp[x].count > 0 {
                randomIndex = Int.random(in: 0..<temp[x].count)
                
                options[x].setTitle(temp[x][ randomIndex ], for: UIControl.State.normal)
            }
            else {
                options[x].setTitle("", for: UIControl.State.normal)
            }
        }
    }
    
    func updateScreen() {
        wordsLeft.progress = Float(totalNumberOfWordsToBeShown-game.numberOfWordsLeft)/Float(totalNumberOfWordsToBeShown)
        
        scoreCounter.text = "Score: \(game.score)"
        correctAnswersCounter.text = "Correct Answers: \(game.correctAnswersEntered)"
        wrongAnswersCounter.text = "Wrong Anwers: \(game.wrongAnswersEntered)"
        game.fillFallingWords()
        fillUpAsteroids()
        fillUpOptions()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalNumberOfWordsToBeShown = game.numberOfWordsLeft
        
        updateScreen()
        
        
    }

    
    
    
}


