//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation


struct ThatsNotAHat<CardContent>{
    
    private var cards: Array<Card<CardContent>>
    private var players: Array<Player>
    private var sender: Player = Player(id: 99, name: "placeholder", score: 0, cardOne: Card(rightArrow: false, content: "nothing"))
    private var passed_card: Card<String>?
    private var message: String?
    
    
    init(cardContentFactory: () -> CardContent, directionFactory: () -> Bool) {
        cards = []
        // provide everyone with 3 cards, open - cardContentFactory
        var bot1 = Player(id: 1, name: "Bot 1", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory() as! String))
        var bot2 = Player(id: 2, name: "Bot 2", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory() as! String))
        var player = Player(id: 0, name: "Player", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory() as! String))
        
        var new_card = Card(rightArrow: false, content: cardContentFactory() as! String)
        // add the fourth to the player (player always starts)
        player.cardTwo = new_card
        
        players = [player, bot1, bot2]
        
    }
    
    // Checks if one player has reached 3 cards (loses)
    func checkForLoser() {
        let loser = players.max(by: { $0.score < $1.score })
        // below checks if the loser 'exists', if no loser it says 0
        if loser?.score ?? 0 >= 3 {
            // End game
        }
        return
    }
    
    // Checks whether the player passed the right card
    func checkMessageWithCard() -> Bool {
        return message == passed_card?.content
    }

    func loadModel(filename: String){
        // Do we need this?
    }
    
    mutating func playerAccepts() {
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = sender.passCard()
        var receiver = players[receiver_id]
        // ------------------------------------------ \\
        // addCard to receiver
        receiver.addCard(new_card: passed_card)
        // reinforce things
    }
    
    mutating func playerDeclines() {
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = sender.passCard()
        var receiver = players[receiver_id]
        // ------------------------------------------ \\
        // Card must be shown
        if checkMessageWithCard() {
            // sender correct
            receiver.addToScore()
            checkForLoser()
            // Introduce new card with cardContentFactory (this should be moved to model (maybe create a separate struct/file)
            var new_card = cardContentFactory()
            // Do model things - reinforcing
        }
        else {
            // receiver is correct
            sender.addToScore()
            checkForLoser()
        }
    }
}
