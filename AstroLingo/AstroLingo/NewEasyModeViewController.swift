
import UIKit

class testModeViewController: UIViewController {

    var totalNumberOfWordsToBeShown = 0
    var game = AstroLingo()
    
    
    @IBOutlet weak var wordsLeft: UIProgressView!
    
    
    @IBOutlet weak var astrolingo: AstrolingoView!
    
    
    @IBOutlet var options: [UIButton]!
    
    @IBOutlet weak var scoreCounter: UILabel!
    
    @IBOutlet weak var correctAnswersCounter: UILabel!
      
      @IBOutlet weak var wrongAnswersCounter: UILabel!
    
    
    @IBAction func buttonclicked(_ sender: UIButton) {
        game.enterWord(playersWord: sender.currentTitle!)
        
        if game.isOver() {
            performSegue(withIdentifier: "endOfGame", sender: self)
        }
        else {
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
           
        
    func fillUpAsteroids()  {
        let temp = game.getFallingWords()
        
        for x in 0..<astrolingo.fallingWords.count {
            astrolingo.addAsteroid(withWord: temp[x])
            print("Asteroid added to screen")
        }
        
        if game.numberOfWordsLeft < 1 {
            
        }
    }
    
    
    func fillUpOptions() {
        var temp = Array(game.fallingWords.values)
        temp.shuffle()
        for x in 0..<game.fallingWords.count {
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
        astrolingo.addAsteroid(withWord: "Hello")
        
    }
}
