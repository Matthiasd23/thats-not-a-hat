//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation

struct ThatsNotAHat<CardContent>{
    private var cards: Array<Card>
    
    
    
    func passCard(){            // Choosing what to say, could be called passCard or smth
        
    }
    
    func decisionCard(){        // Deciding weither to accept or decline the card
        
    }
    
    struct Card {               // Not sure if we need more variables with the card,
        var isFaceUp: Bool = true // to inspect at the beginning it should be face up
        var isCorrect: Bool = true // used to later check if the said card and the actual card emoji match
        var rightArrow: Bool           // right pointed card or left this should be decided when generating the card.
        var content: CardContent
    }
}
