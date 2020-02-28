//
//  endOfGameViewController.swift
//  AstroLingo
//
//  Created by B.N. Ogum on 28/02/2020.
//  Copyright © 2020 B.N. Ogum. All rights reserved.
//

import UIKit

class endOfGameViewController: UIViewController {

    var didWin: Bool? = nil
    var score = 0
    var livesLeft = 0
    var correctAnswers = 0
    var incorrectAnswers = 0
    
    @IBOutlet weak var congratulatoryText: UILabel!
    
    @IBOutlet weak var scoreBoard: UILabel!
    
    @IBOutlet weak var correctWords: UILabel!
    
    @IBOutlet weak var incorrectWords: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if didWin == nil {
            //game is a draw
        }
        else if didWin! {
            //game won
            let victoryEmojis = ["😃","🙃","😎","🥳","🤠","👽","🧑‍🚀","💪"]
            let randomEmoji = victoryEmojis[Int.random(in: 0..<victoryEmojis.count)]
            congratulatoryText.text = randomEmoji + "Congratulations!!"
        }
        else {
            let defeatEmojis = ["😒","🤨","😖","😫","😭","🤧","🧠","👀"]
            let randomEmoji = defeatEmojis[Int.random(in: 0..<defeatEmojis.count)]
            congratulatoryText.text = randomEmoji + "You were defeated!!!"
        }
        
        scoreBoard.text = "Score: \(score)"
        correctWords.text = "Correct Words: \(correctAnswers)"
        incorrectWords.text = "Incorrect Words: \(incorrectAnswers)"
        
    }
    
    
    

 
}
