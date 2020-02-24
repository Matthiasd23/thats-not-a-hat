import UIKit

class NormalModeViewController: UIViewController  {

    @IBOutlet weak var wordsLeft: UIProgressView!
    var totalNumberOfWordsToBeShown = 0
    
    var game: AstroLingo = AstroLingo()
    
    @IBOutlet var fallingWords: [UILabel]!
                
    @IBOutlet weak var scoreCounter: UILabel!
    
    @IBOutlet weak var correctAnswersCounter: UILabel!
    
    @IBOutlet weak var wrongAnswersCounter: UILabel!
        
    
    @IBOutlet weak var endOfGamePopUp: UILabel!
    
    
    @IBOutlet weak var inputTextField: UITextField!
//    {
//        didSet {
//
//            if inputTextField.text!.count > 1
//            {
//                game.enterWord(playersWord: inputTextField.text!)
//
//                updateScreen()
//
//                if game.numberOfWordsLeft < 1 {
//                    gameOverScreenForSuccess()
//                }
//            }
//
//        }
        
        
        
//    }
    
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
    
    
    func updateScreen() {
        wordsLeft.progress = Float(totalNumberOfWordsToBeShown-game.numberOfWordsLeft)/Float(totalNumberOfWordsToBeShown)
        
       
        scoreCounter.text = "Score: \(game.score)"
        correctAnswersCounter.text = "Correct Answers: \(game.correctAnswersEntered)"
        wrongAnswersCounter.text = "Wrong Anwers: \(game.wrongAnswersEntered)"
        game.fillFallingWords()
        fillUpAsteroids()
    }
    

    @IBAction func wordIsEdited(_ sender: UITextField) {
        
        if game.checkIfWordCanBeFound(wordToBeChecked: sender.text!) {
            sender.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else {
            sender.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        
        
//        sender.color
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        inputTextField.autocorrectionType = .no
        inputTextField.enablesReturnKeyAutomatically = true
        inputTextField.becomeFirstResponder()
        inputTextField.isEnabled = true
        inputTextField.clearButtonMode = .always
        inputTextField.placeholder = "Let's play😎"
        
        
        
        
        totalNumberOfWordsToBeShown = game.numberOfWordsLeft
        updateScreen()
        
        print("Tag 2")
        
        

       
    }
    
    
    
    
        

}
