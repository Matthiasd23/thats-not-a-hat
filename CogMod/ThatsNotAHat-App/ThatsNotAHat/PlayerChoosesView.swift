//
//  PlayerChoosesView.swift
//  test_project
// strg+alt+enter to open preview again
//  Created by usabilitylab on 21/02/2024.
//

import SwiftUI

// PlayerChoosesView (player chooses either accept/decline)
struct PlayerChoosesView: View {
    
    @ObservedObject var viewModel: ThatsNotAHatGame
//   private let viewModel: ThatsNotAHatGame
    
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: viewModel.players[1]) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2]) // bot 2
            }
            CardStackView(idle: false)
            PlayerView(player: viewModel.players[0]) // This should be the player
           
            HStack{
                Button(action: {} , label: {Text("Accept")}).padding(.horizontal)
                    .onTapGesture{
                        print("View accepts...")
                        viewModel.playerAccepts()
                    }
                Spacer()
                Button(action: {} , label: {Text("Decline")}).padding(.horizontal)
                    .onTapGesture{
                        print("View declines...")
                        viewModel.playerDeclines()
                        
                    }
            }
        }
        .background(Color("lightPink"))
    }
}

struct PlayerChoosesView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerChoosesView(viewModel: ThatsNotAHatGame())
    }
}
