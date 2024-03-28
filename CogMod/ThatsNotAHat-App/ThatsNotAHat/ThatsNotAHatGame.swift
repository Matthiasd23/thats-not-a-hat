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
    
    func updateMessage(claim: String, id: Int){
        model.updatePlayerMessage(claim: claim, id:id)
    }
    
    func playerAccepts() {
        print("playerAccepts in viewModel")
        model.playerAccepts()
        model.togglePlayerDecision(id: 0)
    }
    
    func playerDeclines() {
        print("playerDeclines in viewModel")
        model.playerDeclines()
        model.togglePlayerDecision(id: 0)
    }
    
    func passingCard() {
        print("Passing a card from player to bot, or bot to bot")
        // This should be passing the card on to the next player(from player to bot or bot to bot), but it only works if we print the players from inside the botDecision function and not here \
        model.botDecision()
    }
    
    func botPlay(){
        // So this should be executed when it is not the players turn currently bound to pressing the bots turn button.
        // The bot either passes to the player or a bot, depending on this it needs to call a different function
        let turnID = determineTurn()
        let passDirection = players[turnID].cardOne.rightArrow
        let recieverID = players[turnID].determineReceiver(direction: passDirection)
        // update message of sender
        let guess = model.botGuess(turnID)
        model.updatePlayerMessage(claim: <#T##String#>, id: <#T##Int#>)
        
        // if the player is the reciever
        if recieverID == 0 {
            model.togglePlayerDecision(id: recieverID)
            // In this case we need to update the viewmodel so that the player can accept or decline
        }else{ //Bot recieves
            model.botDecision()
            print(recieverID)
        }
    }
    
    func determineTurn () -> Int {
        // Loop through players and return id of player where isTun == true
        for player in players {
            if player.isTurn == true {
                return player.id
            }
        }
        return 99 // this case should not happen
    }
    
}
