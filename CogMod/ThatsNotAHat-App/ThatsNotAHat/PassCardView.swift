//
//  PassCardView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI


// PassCardView (player chooses either accept/decline)
struct PassCardView: View {
    
    var viewModel: ThatsNotAHatGame = ThatsNotAHatGame()
    
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: "Bot 1") // bot 1
                Spacer()
                PlayerView(player: "Bot 2") // bot 2
            }
            CardStackView(idle: false)
            PlayerView(player: "Player", isTurn: true) // This should be the player            // Idk if this is the correct place to make the call for which HStack to call, but yeah should then be made here
            
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



