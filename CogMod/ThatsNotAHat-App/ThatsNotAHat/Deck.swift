//
//  Deck.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 15/03/2024.
//

import Foundation

struct Deck {
    // cards_outofplay: All the cards that got removed from playing because of mistakes
    // cards_inplay: cards that are currently circling around, important to keep track of what cards need to be shown to the player to choose from
    // emojis: list of emojies that can become card content
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
    
    // removes a random emoji from the list and stores it in cards in play
    private mutating func cardContentFactory() -> String {
        guard !emojis.isEmpty else { return "empty" }
        
        let index = Int.random(in: 0..<emojis.count)
        let emoji = emojis.remove(at: index)
        store(emoji: emoji)
        return emoji
    }
    
    // randomly assign an arrow to a card
    private func directionFactory() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    // saving the emojies in the inplay list
    private mutating func store(emoji: String) {
        cards_inplay.append(emoji)
    }
    
    // removing from inplay and put into outofplay
    mutating func remove_from_deck(emoji: String) {
        if let index = cards_inplay.firstIndex(of: emoji){
            cards_inplay.remove(at: index)
        }
        cards_outofplay.append(emoji)
    }
    
    // creating a new card based on the other fucntions above
    mutating func getNewCard() -> Card<String> {
        return Card(isFaceUp: true, rightArrow: directionFactory(), content: cardContentFactory())
    }
}
