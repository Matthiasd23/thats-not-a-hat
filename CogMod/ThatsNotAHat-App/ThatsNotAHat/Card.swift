//
//  Card.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 13/03/2024.
//

import Foundation

struct Card<CardContent> {               // Not sure if we need more variables with the card,
    var isFaceUp: Bool = true // to inspect at the beginning it should be face up
    var isCorrect: Bool = true // used to later check if the said card and the actual card emoji match
    var rightArrow: Bool           // right pointed card or left this should be decided when generating the card.
    var content: CardContent
}
