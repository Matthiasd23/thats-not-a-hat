//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation

struct ThatsNotAHat<CardContent>{
    
    private var cards: Array<Card>
    private var players: Array<Player>
    
    init(cardContentFactory: () -> CardContent, directionFactory: () -> Bool) {
        cards = []
        // provide everyone with 3 cards, open - cardContentFactory
        var bot1 = Player(name: "Bot 1", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory()))
        var bot2 = Player(name: "Bot 2", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory()))
        var player = Player(name: "Player", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory()))
        
        var new_card = Card(rightArrow: false, content: cardContentFactory())
        // add the fourth to the player (player always starts)
        player.cardTwo = new_card
        
        players = [player, bot1, bot2]
        
        
    }
    
    // directions:
    // from players[0] to the left: players[1]      to the right: players[2]
    // from players[1] to the left: players[2]      to the right: players[0]
    // from players[2] to the left: players[0]      to the right: players[1]
    func determineReceiver(sender: Int, direction: Bool) -> Int {
        // direction (Bool): true = right, false = left
        // this function returns the index corresponding to the receiver in players[index]
        if direction {
            return sender == 0 ? 2 : sender - 1
        } else {
            return sender == 2 ? 0 : sender + 1
        }
    }

    func loadModel(filename: String){
        // Do we need this?
    }
    // The functions below should probably belong to the player (struct)
    //-----------------------------------------------------------------------------------------
    func passCard(card: Card){            // Choosing what to say, could be called passCard or smth
        // just using a placeholder right now
        let sender = 0
        var receiver = players[determineReceiver(sender: sender, direction: card.rightArrow)]
    }
    func decisionCard(){        // Deciding weither to accept or decline the card (for the bots? )
        
    }
    func acceptCard(){          // Accepting the card
        // Receiver reinforces chunk
        // Sender reinforces chunk
        // Bystander decides whether to reinforce or not/do something else
    }
    func declineCard() {        // Declining the card
        // Receiver says no
        // Appoint a 'loser'
        // Introduce new card, assign it to the loser
        // Everyone reinforces
    }
    //-----------------------------------------------------------------------------------------
    struct Card {               // Not sure if we need more variables with the card,
        var isFaceUp: Bool = true // to inspect at the beginning it should be face up
        var isCorrect: Bool = true // used to later check if the said card and the actual card emoji match
        var rightArrow: Bool           // right pointed card or left this should be decided when generating the card.
        var content: CardContent
    }
    
    // This struct is probably needed for the logic - not sure how important the link to the view would be
    struct Player {
        var name: String
        var score: Int
        var cardOne: Card
        var cardTwo: Card?
    }
}
