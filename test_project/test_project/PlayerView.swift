//
//  PlayerView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI

// separate file
struct PlayerView: View{
    @State var player : String
    @State var isTurn: Bool = false
    @State var cardNum: Int = 1  // This i think will be needed to decide weather the card is there or it should just be the indicated space. This needs to be a bit more
    
    var body: some View{
        VStack{
            Text(player) // Maybe make it so a player can enter its name?
            CardView(content: "🍎", arrow: "➡️", isSelected: isTurn)
            CardView(content: "🍔", arrow: "⬅️")
        }
    }
}
