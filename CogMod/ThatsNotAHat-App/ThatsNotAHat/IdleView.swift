//
//  IdleView.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 13/03/2024.
//

import SwiftUI

struct IdleView: View {
    @ObservedObject var viewModel: ThatsNotAHatGame
    
    var body: some View {
        VStack {
            HStack{
                PlayerView(player: viewModel.players[1]) // bot 1
                Spacer()
                PlayerView(player: viewModel.players[2]) // bot 2
            }
            CardStackView(idle: true)
            PlayerView(player: viewModel.players[0]) // This should be the player
            
        }
        .background(Color("lightPink"))
    }
}

struct IdleView_Previews: PreviewProvider {
    static var previews: some View {
        IdleView(viewModel: ThatsNotAHatGame())
    }
}
