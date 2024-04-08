//
//  PlayerView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI

// nseparate file
struct PlayerView: View{
    
    // This function displays the right arrows for the player
    private func getArrow(rightArrow: Bool, isBot: Bool) -> String {
        if isBot {
            return rightArrow ? "⬅️" : "➡️"
        }
        return rightArrow ? "➡️" : "⬅️"
    }
    
    var player : Player
    var includeMsg: Bool = true
    var body: some View{
        VStack{
            HStack {
                Text(player.name) // Maybe make it so a player can enter its name?
                Text("-score: " + String(player.score))
            }
            CardView(content: player.cardOne.content, isFaceUp: player.cardOne.isFaceUp, arrow: getArrow(rightArrow: player.cardOne.rightArrow, isBot: (player.id != 0)), isSelected: player.isTurn)
            if player.isTurn {
                // Add the second card
                CardView(content: player.cardTwo!.content, isFaceUp: player.cardTwo!.isFaceUp, arrow: getArrow(rightArrow: player.cardTwo!.rightArrow, isBot: (player.id != 0)), cardState: true)
                if includeMsg {
                    MessageView()
                }
            }
            else{
                CardView(content: "", isFaceUp: false, arrow: "", cardState: false)
            }
        }
    }
}
