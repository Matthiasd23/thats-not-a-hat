//
//  Deck.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 15/03/2024.
//

import Foundation

struct Deck {
    
    var cards_outofplay: Array<String> = ["💊", "⚔️"] // just added those 2 so we start with an array of 5 out of play cards for presentation.
    var cards_inplay: Array<String> = []
    
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
        cards_inplay.append(emoji)
    }
    
    mutating func remove_from_deck(emoji: String) {
        if let index = cards_inplay.firstIndex(of: emoji){
            cards_inplay.remove(at: index)
        }
        cards_outofplay.append(emoji)
    }
    
    mutating func getNewCard() -> Card<String> {
        return Card(isFaceUp: true, rightArrow: directionFactory(), content: cardContentFactory())
    }
}
