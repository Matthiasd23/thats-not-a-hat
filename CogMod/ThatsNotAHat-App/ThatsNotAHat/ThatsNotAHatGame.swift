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
        //model.proxyStart()
    }
    
    func playerAccepts() {
        print("playerAccepts in viewModel")
        model.playerAccepts()
    }
    
    func playerDeclines() {
        print("playerDeclines in viewModel")
        model.playerDeclines()
    }
    
    func passingCard() {
        print("Passing a card")
        print("\(players[0])")
        // This passes the card from the player or a bot to a bot, and afterwards it is not in the players "inventory anymore" \
        model.botDecision()
        print("\(players[0])")
    }
    
}
