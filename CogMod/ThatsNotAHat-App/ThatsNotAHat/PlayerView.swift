//
//  PlayerView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI

// nseparate file
struct PlayerView: View{
    @State var player : String
    @State var isTurn: Bool = false
    @State var cardNum: Int = 1  // This i think will be needed to decide wether the card is there or it should just be the indicated space. This needs to be a bit more
    @State var includeMsg: Bool = true
    @State var gameStart: Bool = false // can be used for the first turn, where cards need to be shown to the player.
    
    // only if isTurn the player will have 2 cards. We can use this
    
    var body: some View{
        VStack{
            Text(player) // Maybe make it so a player can enter its name?
            
            if gameStart == true { // When the game starts, all cards are faced up
                CardView(content: "🍎", isFaceUp: true, arrow: "⬅️", isSelected: isTurn)
                if isTurn {
                    // Add the second card
                    CardView(content: "🍔", isFaceUp: true, arrow: "⬅️", cardState: true )
                    if includeMsg {
                        // Add a text view
                        MessageView()
                    }
                }
                else{ // no card or empty card: this could be removed as well
                    CardView(content: "", arrow: "", cardState: false)
                }
                
            }
            else {
                
                CardView(content: "🍎", arrow: "⬅️", isSelected: isTurn)
                if isTurn {
                    // Add the second card
                    CardView(content: "🍔", arrow: "⬅️", cardState: true )
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
        // We need some ScoreView as well
    }
}
