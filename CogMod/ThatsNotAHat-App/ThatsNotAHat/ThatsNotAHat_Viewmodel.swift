//
//  ThatNotAHat_Viewmodel.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import SwiftUI


class ThatNotAHatGame {
    
    // This function displays the right arrows for the player
    private static func getArrow(rightArrow: Bool, isBot: Bool) -> String {
        if isBot {
            return rightArrow ? "⬅️" : "➡️"
        }
        return rightArrow ? "➡️" : "⬅️"
    }
    
    private var model = ThatsNotAHat<String>()
    
    func playerAccepts() {
        model.playerAccepts()
    }
    
    func playerDeclines() {
        
    }
}
