import UIKit

class NormalModeViewController: UIViewController  {

    @IBOutlet weak var wordsLeft: UIProgressView!
    var totalNumberOfWordsToBeShown = 0
    
    var game: AstroLingo = AstroLingo()
    
    @IBOutlet var fallingWords: [UILabel]!
                
    @IBOutlet weak var scoreCounter: UILabel!
    
    @IBOutlet weak var correctAnswersCounter: UILabel!
    
    @IBOutlet weak var wrongAnswersCounter: UILabel!
        
    @IBOutlet weak var inputTextField: UITextField!
    
    
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
        sender.text = sender.text?.lowercased() //convert all input in the textfield to lowercase
        if game.checkIfWordCanBeFound(wordToBeChecked: sender.text!) {
            sender.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else {
            sender.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
  
    
    @IBAction func wordIsEntered(_ sender: UITextField) {
//        if(sender.text!.count>0) {
            game.enterWord(playersWord: sender.text!)
            
//        }
        if game.isOver() {
            performSegue(withIdentifier: "endOfGame", sender: self)
        }
        else {
           sender.text = ""
           updateScreen()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationViewController = segue.destination as? endOfGameViewController
        
        destinationViewController?.score = self.game.score
        destinationViewController?.livesLeft = self.game.player.getLives()
        destinationViewController?.correctAnswers=self.game.correctAnswersEntered
        destinationViewController?.incorrectAnswers = self.game.wrongAnswersEntered
        
        if game.player.getLives() > 0 {
            destinationViewController?.didWin = true
        }
        else {
            destinationViewController?.didWin = false
        }//for hard mode make option for a draw. ie compare the player scores instead of the lives
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.autocorrectionType = .no
        inputTextField.enablesReturnKeyAutomatically = true
        inputTextField.becomeFirstResponder()
        inputTextField.isEnabled = true
        inputTextField.clearButtonMode = .always
        inputTextField.placeholder = "Let's play😎"
        inputTextField.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            

        totalNumberOfWordsToBeShown = game.numberOfWordsLeft
        updateScreen()

    }
}
