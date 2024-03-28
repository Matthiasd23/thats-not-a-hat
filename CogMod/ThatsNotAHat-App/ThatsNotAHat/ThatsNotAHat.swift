//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation


struct ThatsNotAHat<CardContent>{
    
    private(set) var players: Array<Player>
    // DONE: I think sender should be the id, so we can use the actual player variables and those then change instead of an extra one
    // private(set) var sender: Player = Player(id: 99, name: "placeholder", score: 0, cardOne: Card(rightArrow: false, content: "nothing"))
    private(set) var senderID: Int = 0
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
        // Player always starts as the sender
        players[senderID].isTurn = true
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
    func checkMessageWithCard(card: Card<String>, id: Int) -> Bool {
        return players[id].message == card.content
    }
    
    mutating func updatePlayerMessage(claim: String, id: Int){
        players[id].message = claim
    }
    
    mutating func flipCards(){
        // at the start of the game flip the cards face down
        players[0].cardOne.isFaceUp = true
        for i in 0..<3 {
            players[i].cardOne.isFaceUp = true
            if players[i].cardTwo != nil {
                players[i].cardTwo?.isFaceUp = true
            }
        }
    }
    // Used to change the bool of player decision so we can use it for changing the view
    mutating func togglePlayerDecision(id:Int){
        players[id].decision.toggle()
    }
    // THIS FUNCTION IS (FOR NOW) ONLY CALLED BY THE PLAYER THROUGH VIEWMODEL, IF WE WANT TO GENERALIZE IT, IT SHOULD BE CHANGED
    mutating func playerAccepts() {
        print("Accepting...")
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = players[senderID].passCard() //sender.passCard()
        
        // ------------------------------------------ \\
        
        // addCard to receiver (player in this case)
        players[receiver_id].addCard(new_card: passed_card)
        // reinforce things, the sender (bot) reinforces and bystander
        for bot in players.dropFirst() {
            bot.addToDM(card: passed_card, player_id: players[receiver_id].ID())
        }
        
        // After accepting the player becomes the sender
        senderID = players[0].id
    }
    
    mutating func playerDeclines() { // ADD timer for the models (with a max so it cant be exploited)
        print("Declining...")
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = players[senderID].passCard()
        
        // Introduce new card with cardContentFactory (this should be moved to model (maybe create a separate struct/file)
        // either way a new card is introduced, the only difference is who gets the card
        let new_card = deck.getNewCard()
        // ------------------------------------------ \\
        // Card must be shown
        if checkMessageWithCard(card: passed_card, id: senderID)
        {
            // sender correct
            players[receiver_id].addToScore()
            checkForLoser()
            
            // ADD NEW CARD, SHOULD BE VISIBLE FIRST (before the player presses a button (ready))
            players[receiver_id].addCard(new_card: new_card)
            // Do model things - reinforcing
            for bot in players.dropFirst() {
                bot.addToDM(card: new_card, player_id: players[receiver_id].ID())
            }
            
            // RECEIVER BECOMES SENDER
            senderID = receiver_id
        }
        else
        {
            // receiver is correct
            players[senderID].addToScore()
            checkForLoser()
            players[senderID].addCard(new_card: new_card)
            // Update Bots
            for bot in players.dropFirst() {
                bot.addToDM(card: new_card, player_id: players[senderID].ID())
        }
            
            // SENDER STAYS SENDER
        }
        
        players[senderID].isTurn = true
    }
    
    // we need now the control options for the model.
    mutating func botDecision() {
        // either player or the other model passed the card, and one model is the reciever.
        players[senderID].isTurn = false // players turn ends as soon as he passes the card
        let (reciever_id, passed_card) = players[senderID].passCard()
        
        
        // model makes a retrival and then checks wether its the same
        let model_decision = players[reciever_id].decisionCard(passed_card: passed_card, player_id: players[senderID].ID(), claim: players[reciever_id].message)
        
        // currently it randomly Accepts(True) or Declines(False)
        if model_decision{
            // update its other card, switch cards in possesion and update second bot
            players[reciever_id].addCard(new_card: passed_card)
            // reinforce things, both bots update
            for bot in players.dropFirst() {
                bot.addToDM(card: passed_card, player_id: players[reciever_id].ID())
            }
            
            // After accepting the player becomes the sender
            senderID = players[reciever_id].id
            players[senderID].isTurn = true
            // The other ones have to be set to false at those points aswell.
            
            
            
        }else{
            // check who is correct, remove card, introduce new card, update both bots.
            let new_card = deck.getNewCard()
            print(passed_card.content, players[senderID].message)
            if checkMessageWithCard(card: passed_card,id: senderID){
                
                // sender correct
                players[reciever_id].addToScore()
                checkForLoser()
                
                // ADD NEW CARD, SHOULD BE VISIBLE FIRST (before the player presses a button (ready))
                players[reciever_id].cardTwo = new_card
                // Do model things - reinforcing
                for bot in players.dropFirst() {
                    bot.addToDM(card: new_card, player_id: players[reciever_id].ID())
                }
                
                // RECEIVER BECOMES SENDER
                senderID = reciever_id
            }
            else
            {
                // receiver is correct, sender stays the same player
                players[senderID].addToScore()
                checkForLoser()
                players[senderID].addCard(new_card: new_card)
                // Update Bots
                for bot in players.dropFirst() {
                    bot.addToDM(card: new_card, player_id: players[senderID].ID())
                    
                    // TODO: Maybe here we get to a problem if we do not change sender that the game stops playing, but I am not sure.
                }
                
            }
            players[senderID].isTurn = true
        }                            
        func botGuess(id:Int){
            // Retrieves the chunk with the highest activations, used to change the message of the bots
            let chunk = players[id].retrieveChunk(card: players[id].cardOne, player_id: Double(id))
            if chunk != nil {
                players[id].message = chunk!.slotValue(slot: "content")
            }
            
            
        }
    }
}
