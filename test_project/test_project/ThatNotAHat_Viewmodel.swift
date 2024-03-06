//
//  ThatNotAHat_Viewmodel.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import SwiftUI

class ThatNotAHatGame {
    // we probably need to move this to the model
    private static var emojis = ["🐶", "🐱", "🐷", "🐔", "🐥", "🦄", "🐝", "🦧", "🐊", "🐳",
                         "🌳", "🌿", "🍄", "🌝", "🌚", "⭐️", "🌈", "🔥", "💧", "☃️",
                         "☂️", "🍎", "🍇", "🫐", "🥥", "🍆", "🥝", "🌶", "🥦", "🥕",
                         "🍔", "🍟", "🍕", "🌮", "🍙", "🎂", "🍫", "🍩", "🍪", "🥛",
                         "☕️", "🍺", "🍾", "🍷", "🥃", "⚽️", "🏈", "🎾", "🎱", "🥏",
                         "🪁", "🛹", "⛷", "🛼", "🪂", "🏋️‍♀️", "🏆", "🥇", "🎷", "🪕",
                         "🎻", "🎸", "🎯", "🎳", "🎮", "🚗", "🚒", "🚜", "🚃", "✈️"]
    
    private static func selectAndRemove() -> String {
        guard !emojis.isEmpty else { return "empty" }
        
        let index = Int.random(in: 0..<emojis.count)
        return emojis.remove(at: index)
    }
    
    private static func randomDirection() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    private var model = ThatsNotAHat<String>(cardContentFactory: ThatNotAHatGame.selectAndRemove, directionFactory: ThatNotAHatGame.randomDirection)
    
    func acceptCard() {
        model.acceptCard()
    }
    
    func declineCard() {
        model.declineCard()
    }
}
