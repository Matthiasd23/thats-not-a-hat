//
//  PlayerChoosesView.swift
//  test_project
// strg+alt+enter to open preview again
//  Created by usabilitylab on 21/02/2024.
//

import SwiftUI

// PlayerChoosesView (player chooses either accept/decline)
struct PlayerChoosesView: View {
    
    
    var viewModel: ThatNotAHatGame = ThatNotAHatGame()
    
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: "Bot 1", isTurn: true) // bot 1
                Spacer()
                PlayerView(player: "Bot 2") // bot 2
            }
            CardStackView()
            PlayerView(player: "Player") // This should be the player
           
            // Idk if this is the correct place to make the call for which HStack to call, but yeah should then be made here
            // I think we might need 3 different views
            HStack{
                Button(action: {} , label: {Text("Accept")}).padding(.horizontal).onTapGesture{viewModel.playerAccepts()} // Make the actions
                Spacer()
                Button(action: {} , label: {Text("Decline")}).padding(.horizontal)
                    .onTapGesture{viewModel.playerDeclines()}
            }
        }
        .background(Color("lightPink"))
    }
}



struct PlayerChoosesView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerChoosesView()
    }
}
