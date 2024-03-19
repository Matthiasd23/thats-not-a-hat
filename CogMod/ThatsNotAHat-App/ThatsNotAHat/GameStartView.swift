//
//  GameStartView.swift
//  ThatsNotAHat
//
//  Created by UsabilityLab on 3/19/24.
//

import SwiftUI


// Game Start View
// First View that is shown after clicking "Play Now". Should give 1 card to the 2 bots and the player. Then gives another card to the player, to start the game.
struct GameStartView: View {
    
    var viewModel: ThatsNotAHatGame = ThatsNotAHatGame()
    
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: "Bot 1", gameStart: true) // bot 1
                Spacer()
                PlayerView(player: "Bot 2", gameStart: true) // bot 2
            }

            CardStackView(idle: true)
            PlayerView(player: "Player", isTurn: true, includeMsg: false, gameStart: true)
            
            
        }
        .background(Color("lightPink"))

    }
}


struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView()
    }
}
