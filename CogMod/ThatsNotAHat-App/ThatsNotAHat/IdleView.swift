//
//  IdleView.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 13/03/2024.
//

import SwiftUI

struct IdleView: View {
    var viewModel: ThatsNotAHatGame = ThatsNotAHatGame()
    
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: "Bot 1") // bot 1
                Spacer()
                PlayerView(player: "Bot 2") // bot 2
            }
            CardStackView(idle: true)
            PlayerView(player: "Player") // This should be the player
            
        }
        .background(Color("lightPink"))
    }
}

struct IdleView_Previews: PreviewProvider {
    static var previews: some View {
        IdleView()
    }
}
