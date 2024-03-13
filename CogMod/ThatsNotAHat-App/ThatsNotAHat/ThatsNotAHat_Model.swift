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
    private var passed_card: Card<String>
    
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

    func loadModel(filename: String){
        // Do we need this?
    }
    
    func playerAccepts() {
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        sender.passCard()
        
    }
    
}
