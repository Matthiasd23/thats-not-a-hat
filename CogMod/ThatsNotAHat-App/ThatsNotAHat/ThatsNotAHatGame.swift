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
        // Should flip over all the cards and then give the player the option to start choosing what card he wants to send
        model.flipCards()
        print(model.players[0].cardOne)
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
        print("Passing a card from player to bot, or bot to bot")
        // This should be passing the card on to the next player(from player to bot or bot to bot), but it only works if we print the players from inside the botDecision function and not here \
        model.botDecision()
        print(players)
        
    }
    
}
