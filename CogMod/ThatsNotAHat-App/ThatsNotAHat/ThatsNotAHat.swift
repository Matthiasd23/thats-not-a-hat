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
                bot.addToDM(card_content: player.cardOne.content, player_id: player.ID(), arrow: player.cardOne.directionValue())
                if player.cardTwo != nil {
                    bot.addToDM(card_content: player.cardTwo!.content, player_id: player.ID(), arrow: player.cardTwo!.directionValue())
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
        // reinforce things, the sender (bot) reinforces (the receiver as well IF IT IS A BOT, but this function is for the player)
        sender.addToDM(card_content: passed_card.content, player_id: receiver.ID(), arrow: passed_card.directionValue())
        
        
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
                bot.addToDM(card_content: new_card.content, player_id: receiver.ID(), arrow: new_card.directionValue())
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
                bot.addToDM(card_content: new_card.content, player_id: sender.ID(), arrow: new_card.directionValue())
            }
            
            // SENDER STAYS SENDER
        }
    }
    
    // we need now the control options for the model.
}
