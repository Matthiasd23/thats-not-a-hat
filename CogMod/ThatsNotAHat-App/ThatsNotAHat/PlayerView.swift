//
//  PlayerView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI

// nseparate file
struct PlayerView: View{
    var player : Player
    
    // only if isTurn the player will have 2 cards. We can use this
    
    var body: some View{
        VStack{
            Text(player.name) // Maybe make it so a player can enter its name?
            CardView(content: player.cardOne.content, arrow: "⬅️", isSelected: player.isTurn)
            if player.isTurn {
                // Add the second card
                CardView(content: player.cardTwo!.content, arrow: "⬅️", cardState: true)
                // Add a text view
                MessageView()
            }
            else{ // no card or empty card: this could be removed as well
                CardView(content: "", arrow: "", cardState: false)
            }
        }
        // We need some ScoreView as well
    }
}
