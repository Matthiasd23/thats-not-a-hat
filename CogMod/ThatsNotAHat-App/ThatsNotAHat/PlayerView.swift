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
    
    @State var isTurn: Bool = false
    @State var cardNum: Int = 1  // This i think will be needed to decide wether the card is there or it should just be the indicated space. This needs to be a bit more
    @State var includeMsg: Bool = true
    @State var gameStart: Bool = false // can be used for the first turn, where cards need to be shown to the player.
    
    var body: some View{
        VStack{
            Text(player.name) // Maybe make it so a player can enter its name?
            CardView(content: player.cardOne.content, isFaceUp: gameStart, arrow: getArrow(rightArrow: player.cardOne.rightArrow, isBot: player.id != 0), isSelected: player.isTurn)
            if isTurn {
                // Add the second card
                CardView(content: player.cardTwo!.content, isFaceUp:gameStart, arrow: getArrow(rightArrow: player.cardTwo!.rightArrow, isBot: player.id != 0), cardState: true)
                if includeMsg {
                    // Add a text view
                    MessageView()
                }
            }
            else{ // no card or empty card: this could be removed as well
                CardView(content: "", arrow: "", cardState: false)
            }
        }
    }
}
