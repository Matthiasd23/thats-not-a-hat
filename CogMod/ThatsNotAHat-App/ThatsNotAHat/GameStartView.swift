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
    
    @ObservedObject var viewModel: ThatsNotAHatGame
//    private let viewModel: ThatsNotAHatGame : This might be a fix for the data being carried over - the code above creates a new class, instead we would have to pass one viewModel class around
    
    var body: some View {
        VStack {
            HStack{
                PlayerView(player: viewModel.players[1], gameStart: true) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2], gameStart: true) // bot 2
            }
            CardStackView(idle: true)
            PlayerView(player: viewModel.players[0], includeMsg: false, gameStart: true)
    
            Button(action: {}, label: {Text("Ready!")}).onTapGesture {
                print("Starting the Game")
                viewModel.startGame()
            }
        }
        .background(Color("lightPink"))

    }
}


struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(viewModel: ThatsNotAHatGame())
    }
}
