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
    
    var isTurn: Bool = false
    var includeMsg: Bool = true
    var gameStart: Bool = false // can be used for the first turn, where cards need to be shown to the player.
    
    var body: some View{
        VStack{
            HStack {
                Text(player.name) // Maybe make it so a player can enter its name?
                Text("-score: " + String(player.score))
            }
            CardView(content: player.cardOne.content, isFaceUp: gameStart, arrow: getArrow(rightArrow: player.cardOne.rightArrow, isBot: player.id != 0), isSelected: player.isTurn)
            if isTurn {
                // Add the second card
                CardView(content: player.cardTwo!.content, isFaceUp:gameStart, arrow: getArrow(rightArrow: player.cardTwo!.rightArrow, isBot: player.id != 0), cardState: true)
                if includeMsg {
                    MessageView()
                }
            }
            else{
                CardView(content: "", arrow: "", cardState: false)
            }
        }
    }
}
