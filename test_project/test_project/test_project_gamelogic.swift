//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation

struct ThatsNotAHat<CardContent>{
    private var cards: Array<Card>
    
    init(cardContentFactory: () -> CardContent) {
        cards = []
        // provide everyone with 3 cards, open - cardContentFactory
        // add the fourth to the player (player always starts) c
        
    }
    
    func passCard(){            // Choosing what to say, could be called passCard or smth
        
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
        var cardTwo: Card
    }
}
