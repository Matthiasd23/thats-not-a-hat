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
    @State private var showCards = true
    @State private var botTurn = false
    
    // here the possible guesses should be added, right now it's hardcoded with random emojis. A function should be made for these to be determined. One that's the actual card and the rest previous cards or random cards.
    @State private var emoji_one = "😎"
    @State private var emoji_two = "🍕"
    @State private var emoji_three = "🔥"
    @State private var emoji_four = "🪁"
    @State private var emoji_five = "✈️"
    @State private var guessItem = ""
    
    var body: some View {
        VStack {
            HStack{
                PlayerView(player: viewModel.players[1], gameStart: false) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2], gameStart: false) // bot 2
            }
            CardStackView(idle: true) // middle card stack
            
            //Flips card when 'Ready!' is pressed
            if (showCards == true) {
                PlayerView(player: viewModel.players[0], includeMsg: false, gameStart: true)
            }
            else {
                PlayerView(player: viewModel.players[0], includeMsg: false, gameStart: false)
            }
    
            // ready button to start the game after examining your cards
            if(showReadyButton == true) {
                Button("Ready!") {
                    viewModel.startGame()
                    showCards = false
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
                    
                    MessageView()
                    
                    // Shows the current selected guess, confirm can be pressed to validate the guess.
                    if(guessItem == "") || (guessItem != "") {
                        Button(guessItem) {

                        }
                        .frame(width: 40.0, height: 50.0)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
                        
                        Button("Confirm") {
                            self.showGuessOptions = false
                            self.botTurn = true
                        }
                        .padding()
                    }
                }
            }
            if(botTurn == true) {
                // Would be nice as a UI experience to make it so that you have to swipe the card in the direction of the arrow.
                
                // retrieve their card first, save it as variable
                // check memory to see if card given is correct
                // update saved card with the new card gathered from previous person's turn. Also, announce the card that is passed on.
                Button("Bot's Turn") {
                    self.showGuessOptions = true // temporary solution, need to implement all the bots things
                    self.botTurn = false
                    //self.showReadyButton = true // temp, just so that it goes back to starting state
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
