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
    @State private var showReadyButton = true //ready button to start the game after you got shown your first set of cards or the new card.
    @State private var showGuessOptions = false
    
    var body: some View {
        VStack {
            HStack{
                PlayerView(player: viewModel.players[1], gameStart: true) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2], gameStart: true) // bot 2
            }
            CardStackView(idle: true)
            PlayerView(player: viewModel.players[0], includeMsg: false, gameStart: true)
    
            if(showReadyButton == true) {
                Button("Ready!") {
                    viewModel.startGame()
                    self.showReadyButton = false
                    self.showGuessOptions = true
                }
            }
            
            if(showGuessOptions == true) {
                HStack{
                    Button(action: {} , label: {Text("😎")}).padding(.horizontal) // Make the actions
                    Spacer()
                    Button(action: {} , label: {Text("Emoji_two")}).padding(.horizontal)
                    Spacer()
                    Button(action: {} , label: {Text("Emoji_three")}).padding(.horizontal)
                    Spacer()
                    Button(action: {} , label: {Text("Emoji_four")}).padding(.horizontal)
                    Spacer()
                    Button(action: {} , label: {Text("Emoji_five")}).padding(.horizontal)
                }
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
