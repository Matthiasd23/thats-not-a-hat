//
//  Card.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 13/03/2024.
//

import Foundation

struct Card<CardContent> {
    // isFaceup: wether the card is face up or not
    // rightArrow: Wether the arrow points to the right or left
    // content: emoji on the card
    var isFaceUp: Bool = true // to inspect at the beginning it should be face up
    var rightArrow: Bool           // right pointed card or left this should be decided when generating the card.
    var content: CardContent
    
    // returns direction string to save in chunk
    func directionValue() -> String {
        if rightArrow {
            return "right"
        }
        return "left"
    }
}
