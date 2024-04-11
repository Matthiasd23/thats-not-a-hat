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
    var card_options: Array<String> { return model.options }
    var loserFound: Bool { return model.loserFound }
    
    func getLoser() -> String {
        if loserFound {
            let loser = model.getLoser()
            if loser == 0 {
                return "It is you, you are the loser."
            }
            else{
                return "Bot \(loser)"
            }
        }else{
            return "Something went wrong..."
        }
    }
    
    // MARK: Intent
    
    
    // This is called at the beginning of the game to start the timers and turn the cards face down
    // Should flip over all the cards and then give the player the option to start choosing what card he wants to send
    func startGame() {
        model.flipCards()
        model.startTimers()
    }
    
    //function to turn the cards face down
    func flipCards(){
        model.flipCards()
    }
    
    // updates both the message of the player and the model
    func updateMessage(claim: String, id: Int){
        model.updatePlayerMessage(claim: claim, id:id)
        model.updateClaimMessage(claim: claim)
    }
    
    // called when the player presses the accept button
    func playerAccepts() {
        model.togglePlayerDecision(id: 0)
        model.updateModelTime()
        model.playerAccepts()
        model.startTimers()
    }
    // called when the player presses the decline button
    func playerDeclines() {
        model.togglePlayerDecision(id: 0)
        model.updateModelTime()
        model.playerDeclines()
        model.startTimers()
    }
    
    // passes the card
    func passingCard() {
        model.updateModelTime()
        model.botDecision()
        model.startTimers()
    }
    // This function is called when it is the bots turn. So either the bot passes to another bot or to the player
    func botPlay(){
        // So this should be executed when it is not the players turn currently bound to pressing the bots turn button.
        // The bot either passes to the player or a bot, depending on this it needs to call a different function
        model.turnOffDecision()
        let turnID = determineTurn()
        let passDirection = players[turnID].cardOne.rightArrow
        let receiverID = players[turnID].determineReceiver(direction: passDirection)
        // update message of sender
        let guess = model.botGuess(id:turnID)
        updateMessage(claim: guess, id: turnID)
        print("Model Message:", model.message)
        
        // if the player is the receiver
        if receiverID == 0 {
            // In this case we need to update the viewmodel so that the player can accept or decline
            model.togglePlayerDecision(id: receiverID)
        }else{
            //Bot receives
            model.turnOffDecision()
            model.botDecision()
        }
    }
    
    // Function to determine whose turn it is
    func determineTurn () -> Int {
        if model.loserFound {
            // Return to contentView with a message
        }
        // Loop through players and return id of player where isTun == true
        for player in players {
            if player.isTurn == true {
                return player.id
            }
        }
        return 99 // this case should not happen
    }
    
    func reset() {
        model.reset()
    }
    
    func getMessage() -> String {
        return players[determineTurn()].message
    }

    
}
