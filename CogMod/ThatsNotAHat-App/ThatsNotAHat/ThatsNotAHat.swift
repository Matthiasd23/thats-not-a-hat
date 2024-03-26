//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation


struct ThatsNotAHat<CardContent>{
    
    private(set) var players: Array<Player>
    private(set) var sender: Player = Player(id: 99, name: "placeholder", score: 0, cardOne: Card(rightArrow: false, content: "nothing"))
    // private var passed_card: Card<String>?
    private(set) var message: String = "No message"
    internal var deck = Deck()
    
    init() {
        // Creating bot one, the model is on the Player
        let bot1 = Player(id: 1, name: "Bot 1", score: 0, cardOne: deck.getNewCard())
        // Creating bot two, the model is on the Player
        let bot2 = Player(id: 2, name: "Bot 2", score: 0, cardOne: deck.getNewCard())
        var player = Player(id: 0, name: "Player", score: 0, cardOne: deck.getNewCard())
        
        let new_card = deck.getNewCard()
        // add the fourth to the player (player always starts)
        player.addCard(new_card: new_card)
        
        players = [player, bot1, bot2]
        
        // dropFirst returns an array without the first element
        for bot in players.dropFirst() {
            for player in players {
                bot.addToDM(card: player.cardOne, player_id: player.ID())
                if player.cardTwo != nil {
                    bot.addToDM(card: player.cardTwo!, player_id: player.ID())
                }
            }
        }
    }
    
    // Checks if one player has reached 3 cards (loses)
    func checkForLoser() {
        let loser = players.max(by: { $0.score < $1.score })
        // below checks if the loser 'exists', if no loser it says 0
        if loser?.score ?? 0 >= 3 {
            // End game, probably best to end a game over screen with who lost
        }
        return
    }
    
    // Checks whether the player passed the right card
    func checkMessageWithCard(card: Card<String>) -> Bool {
        return message == card.content
    }
    
    func loadModel(filename: String){
        // Do we need this? depends on if we want to use actual ACT-R or more a pseudo implementation, i would suggest using smth similar to PD3 so no
    }
    // THIS FUNCTION IS (FOR NOW) ONLY CALLED BY THE PLAYER THROUGH VIEWMODEL, IF WE WANT TO GENERALIZE IT, IT SHOULD BE CHANGED
    mutating func playerAccepts() {
        print("Accepting...")
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = sender.passCard()
        var receiver = players[receiver_id]
        // ------------------------------------------ \\
        
        // addCard to receiver (player in this case)
        receiver.addCard(new_card: passed_card)
        // reinforce things, the sender (bot) reinforces and bystander
        for bot in players.dropFirst() {
            bot.addToDM(card: passed_card, player_id: receiver.ID())
        }
        
        // After accepting the player becomes the sender
        sender = players[0]
    }
    
    mutating func playerDeclines() { // ADD timer for the models (with a max so it cant be exploited)
        print("Declining...")
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = sender.passCard()
        var receiver = players[receiver_id]
        // Introduce new card with cardContentFactory (this should be moved to model (maybe create a separate struct/file)
        // either way a new card is introduced, the only difference is who gets the card
        let new_card = deck.getNewCard()
        // ------------------------------------------ \\
        // Card must be shown
        if checkMessageWithCard(card: passed_card)
        {
            // sender correct
            receiver.addToScore()
            checkForLoser()
            
            // ADD NEW CARD, SHOULD BE VISIBLE FIRST (before the player presses a button (ready))
            receiver.addCard(new_card: new_card)
            // Do model things - reinforcing
            for bot in players.dropFirst() {
                bot.addToDM(card: new_card, player_id: receiver.ID())
            }
            
            // RECEIVER BECOMES SENDER
            sender = receiver
        }
        else
        {
            // receiver is correct
            sender.addToScore()
            checkForLoser()
            sender.addCard(new_card: new_card)
            // Update Bots
            for bot in players.dropFirst() {
                bot.addToDM(card: new_card, player_id: sender.ID())
            }
            
            // SENDER STAYS SENDER
        }
    }
    
    // we need now the control options for the model.
    mutating func botDecision() {
        // either player or the other model passed the card, and one model is the reciever.
        let (reciever_id, passed_card) = sender.passCard()
        var receiver = players[reciever_id]
        
        // model makes a retrival and then checks wether its the same
        let model_decision = receiver.decisionCard(passed_card: passed_card, player_id: sender.ID(), claim: message)
        
        // currently it randomly Accepts(True) or Declines(False)
        if model_decision{
            // update its other card, switch cards in possesion and update second bot
            receiver.addCard(new_card: passed_card)
            // reinforce things, both bots update
            for bot in players.dropFirst() {
                bot.addToDM(card: passed_card, player_id: receiver.ID())
            }
            
            // After accepting the player becomes the sender
            sender = players[0]
            
        }else{
            // check who is correct, remove card, introduce new card, update both bots.
            let new_card = deck.getNewCard()
            
            if checkMessageWithCard(card: passed_card){
                // sender correct
                receiver.addToScore()
                checkForLoser()
                
                // ADD NEW CARD, SHOULD BE VISIBLE FIRST (before the player presses a button (ready))
                receiver.addCard(new_card: new_card)
                // Do model things - reinforcing
                for bot in players.dropFirst() {
                    bot.addToDM(card: new_card, player_id: receiver.ID())
                }
                
                // RECEIVER BECOMES SENDER
                sender = receiver
            }
            else
            {
                // receiver is correct, sender stays the same player
                sender.addToScore()
                checkForLoser()
                sender.addCard(new_card: new_card)
                // Update Bots
                for bot in players.dropFirst() {
                    bot.addToDM(card: new_card, player_id: sender.ID())
                    
                    // TODO: Maybe here we get to a problem if we do not change sender that the game stops playing, but I am not sure.
                }
                
                
            }
            
        }
    }
}
