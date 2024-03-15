//
//  Deck.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 15/03/2024.
//

import Foundation

struct Deck {
    
    var cards_outofplay: Array<String> = []
    // we probably need to move this to the model
    private var emojis = ["🐶", "🐱", "🐷", "🐔", "🐥", "🦄", "🐝", "🦧", "🐊", "🐳",
                                 "🌳", "🌿", "🍄", "🌝", "🌚", "⭐️", "🌈", "🔥", "💧", "☃️",
                                 "☂️", "🍎", "🍇", "🫐", "🥥", "🍆", "🥝", "🌶", "🥦", "🥕",
                                 "🍔", "🍟", "🍕", "🌮", "🍙", "🎂", "🍫", "🍩", "🍪", "🥛",
                                 "☕️", "🍺", "🍾", "🍷", "🥃", "⚽️", "🏈", "🎾", "🎱", "🥏",
                                 "🪁", "🛹", "⛷", "🛼", "🪂", "🏋️‍♀️", "🏆", "🥇", "🎷", "🪕",
                                 "🎻", "🎸", "🎯", "🎳", "🎮", "🚗", "🚒", "🚜", "🚃", "✈️"]
    
    private mutating func cardContentFactory() -> String {
        guard !emojis.isEmpty else { return "empty" }
        
        let index = Int.random(in: 0..<emojis.count)
        let emoji = emojis.remove(at: index)
        store(emoji: emoji)
        return emoji
    }
    
    private func directionFactory() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    private mutating func store(emoji: String) {
        cards_outofplay.append(emoji)
    }
    
    mutating func getNewCard() -> Card<String> {
        return Card(rightArrow: directionFactory(), content: cardContentFactory())
    }
}
