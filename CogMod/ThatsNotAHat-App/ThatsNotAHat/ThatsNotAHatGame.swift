//
//  ThatNotAHat_Viewmodel.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import SwiftUI


class ThatsNotAHatGame: ObservableObject {
    
    @Published private var model = ThatsNotAHat<String>()
    
    var players: Array<Player> {return model.players}
    var message: String {return model.message}
    var card_options: Array<String> { return model.deck.cards_outofplay }
    
    // MARK: Intent
    
    func startGame() {
        
    }
    
    func playerAccepts() {
        print("playerAccepts in viewModel")
        model.playerAccepts()
    }
    
    func playerDeclines() {
        print("playerDeclines in viewModel")
        model.playerDeclines()
    }
    
    
}
