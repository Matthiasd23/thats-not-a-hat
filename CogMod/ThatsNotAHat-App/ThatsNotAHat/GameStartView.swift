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
    
    // here the possible guesses should be added, right now it's hardcoded with random emojis. A function should be made for these to be determined. One that's the actual card and the rest previous cards or random cards.
    @State private var emoji_one = "😎"
    @State private var emoji_two = "🍕"
    @State private var emoji_three = "🔥"
    @State private var emoji_four = "🪁"
    @State private var emoji_five = "✈️"
    @State private var previewGuessItem = ""
    @State private var guessItem = ""
    
    var body: some View {
        VStack {
            HStack{
                PlayerView(player: viewModel.players[1], gameStart: true) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2], gameStart: true) // bot 2
            }
            CardStackView(idle: true) // middle card stack
            PlayerView(player: viewModel.players[0], includeMsg: false, gameStart: true)
    
            // ready button to start the game after examining your cards
            if(showReadyButton == true) {
                Button("Ready!") {
                    viewModel.startGame()
                    self.showReadyButton = false
                    self.showGuessOptions = true
                }
            }
            
            if(showGuessOptions == true) {
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {guessItem = emoji_one} , label: {Text(emoji_one)}).padding(.horizontal) // Make the actions
                        Spacer()
                        Button(action: {guessItem = emoji_two} , label: {Text(emoji_two)}).padding(.horizontal)
                        Spacer()
                        Button(action: {guessItem = emoji_three} , label: {Text(emoji_three)}).padding(.horizontal)
                        Spacer()
                        Button(action: {guessItem = emoji_four} , label: {Text(emoji_four)}).padding(.horizontal)
                        Spacer()
                        Button(action: {guessItem = emoji_five} , label: {Text(emoji_five)}).padding(.horizontal)
                    }
                    Spacer()
                    if(guessItem != "") {
                        Button(guessItem) {
                            self.showGuessOptions = false
                            self.showReadyButton = true // temp, just so that it goes back to starting state
                            previewGuessItem = guessItem
                        }
                        Text("Confirm")
                    }
                    Spacer()
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
