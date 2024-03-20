//
//  PassCardView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI


// PassCardView (player chooses either accept/decline)
struct PassCardView: View {
    
    private var viewModel: ThatsNotAHatGame = ThatsNotAHatGame()
//    private let viewModel: ThatsNotAHatGame
    
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: viewModel.players[1]) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2]) // bot 2
            }
            CardStackView(idle: false)
            PlayerView(player: viewModel.players[0])
            
            // Access the cards out of play through viewModel.deck
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
        .background(Color("lightPink"))

    }
}


struct PassCardView_Previews: PreviewProvider {
    static var previews: some View {
        PassCardView()
    }
}



