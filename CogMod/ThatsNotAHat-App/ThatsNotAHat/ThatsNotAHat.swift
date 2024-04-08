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
    internal var deck: Deck
    private(set) var options: Array<String> = []
    var loserFound: Bool = false
    
    init() {
        deck = Deck()
        
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
                bot.addToDM(card: player.cardOne, player_id: player.ID(), claim: player.cardOne.content)
                // strengthn the first card so they dont make a mistake immediately
                bot.addToDM(card: player.cardOne, player_id: player.ID(), claim: player.cardOne.content)
                if player.cardTwo != nil {
                    bot.addToDM(card: player.cardTwo!, player_id: player.ID(), claim: player.cardTwo!.content)
                    
                }
            }
        }
        // Player always starts as the sender
        players[senderID].isTurn = true
        options = makeOptions()
    }
    
    
    // Checks if one player has reached 3 cards (loses)
    mutating func checkForLoser() {
        let loser = players.max(by: { $0.score < $1.score })
        // below checks if the loser 'exists', if no loser it says 0
        if loser?.score ?? 0 >= 10 {
            loserFound = true
        }
    }
    
    func getLoser() -> Int {
        return players.max(by: { $0.score < $1.score })!.id
    }
    
    // Checks whether the player passed the right card, and removes it from the 'deck
    mutating func checkMessageWithCard(card: Card<String>, id: Int) -> Bool {
        deck.remove_from_deck(emoji: card.content)
        return players[id].message == card.content
    }
    
    mutating func updatePlayerMessage(claim: String, id: Int){
        players[id].message = claim
    }
    
    mutating func flipCards(){
        print("flipping cards is called..")
        // at the start of the game flip the cards face down
        for i in 0..<3 {
            players[i].cardOne.isFaceUp = false
            if players[i].cardTwo != nil {
                players[i].cardTwo?.isFaceUp = false
            }
        }
    }
    
    // Used to change the bool of player decision so we can use it for changing the view
    mutating func togglePlayerDecision(id:Int){
        players[id].decision.toggle()
    }
    
    mutating func playerAccepts() {
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        players[senderID].isTurn = false
        let (receiver_id, passed_card) = players[senderID].passCard() //sender.passCard()
        
        // ------------------------------------------ \\
        
        // addCard to receiver (player in this case)
        players[receiver_id].cardTwo = passed_card
        // reinforce things, the sender (bot) reinforces and bystander
        for bot in players.dropFirst() {
            bot.updateMemory(botID: Double(receiver_id)) // This should update the first card of the bot
            bot.addToDM(card: passed_card, player_id: players[receiver_id].ID(), claim: message)
            // TODO: Make sure this is the message saved before the player accepts the card
        }
        
        // After accepting the player becomes the sender
        senderID = players[0].id
        players[senderID].isTurn = true
    }
    
    mutating func playerDeclines() { // ADD timer for the models (with a max so it cant be exploited)
        players[senderID].isTurn = false
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = players[senderID].passCard()
        
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
            players[receiver_id].cardTwo = new_card
            print("NEW CARD RECEIVED: \(new_card)")
            
            
            // Do model things - reinforcing
            // Currently only the new card gets reinforced
            for bot in players.dropFirst() {
                bot.updateMemory(botID: Double(receiver_id))
                bot.addToDM(card: new_card, player_id: players[receiver_id].ID(), claim: message)
            }
            
            // RECEIVER BECOMES SENDER
            senderID = receiver_id
            players[senderID].isTurn = true
        }
        else
        {
            // receiver is correct
            players[senderID].addToScore()
            checkForLoser()
            players[senderID].cardTwo = new_card
            // Update Bots
            for bot in players.dropFirst() {
                bot.updateMemory(botID: Double(senderID))
                bot.addToDM(card: new_card, player_id: players[senderID].ID(), claim: message)
            }
            
            // SENDER STAYS SENDER
            players[senderID].isTurn = true
        }
        options = makeOptions()
    }
    
    // we need now the control options for the model.
    mutating func botDecision() {
        // either player or the other model passed the card, and one model is the reciever.
        players[senderID].isTurn = false // players turn ends as soon as he passes the card
        let (receiver_id, passed_card) = players[senderID].passCard()
        print("This is the sender ID Claim ",players[senderID].message)
        
        // model makes a retrieval and then checks wether its the same
        let model_decision = players[receiver_id].decisionCard(passed_card: passed_card, player_id: players[senderID].ID(), claim: players[senderID].message)
        
        if model_decision {
            // update its other card, switch cards in possesion and update second bot
            players[receiver_id].addCard(new_card: passed_card)
            
            // reinforce things, both bots update
            for bot in players.dropFirst() {
                bot.updateMemory(botID: Double(receiver_id))
                bot.addToDM(card: passed_card, player_id: players[receiver_id].ID(), claim: message)
            }
            
            // After accepting the player becomes the sender
            senderID = players[receiver_id].id
            players[senderID].isTurn = true
            // The other ones have to be set to false at those points aswell.
            
        }else{
            // check who is correct, remove card, introduce new card, update both bots.
            let new_card = deck.getNewCard()
            if checkMessageWithCard(card: passed_card, id: senderID){
                
                // sender correct
                players[receiver_id].addToScore()
                checkForLoser()
                
                // ADD NEW CARD, SHOULD BE VISIBLE FIRST (before the player presses a button (ready))
                players[receiver_id].cardTwo = new_card
                // Do model things - reinforcing
                for bot in players.dropFirst() {
                    bot.updateMemory(botID: Double(receiver_id))
                    bot.addToDM(card: new_card, player_id: players[receiver_id].ID(), claim: message)
                }
                
                // RECEIVER BECOMES SENDER
                senderID = receiver_id
            }
            else
            {
                // receiver is correct, sender stays the same player
                players[senderID].addToScore()
                checkForLoser()
                players[senderID].addCard(new_card: new_card)
                // Update Bots
                for bot in players.dropFirst() {
                    bot.updateMemory(botID: Double(senderID))
                    bot.addToDM(card: new_card, player_id: players[senderID].ID(), claim: message)
                    
                    // TODO: Maybe here we get to a problem if we do not change sender that the game stops playing, but I am not sure.
                }
                
            }
            options = makeOptions()
            players[senderID].isTurn = true
        }
    }
    
    
    mutating func botGuess(id:Int) -> String{
        // Retrieves the chunk with the highest activations, used to change the message of the bots
        let chunk = players[id].retrieveChunk(card: players[id].cardOne, player_id: Double(id))
        if chunk != nil {
            // TODO: Fix retrieval requests for slotvalues being Value and not string
            // temporary fix?
            let guessString = "\(chunk!.slotValue(slot: "content")!)"
            return guessString
        } else {
            return "No Chunk Retrieved"
        }
    }
    
    mutating func updateClaimMessage(claim: String) {
        message = claim
    }
    
    mutating func makeOptions() -> [String] {
        var options = deck.cards_inplay
        if let random = deck.cards_outofplay.randomElement() {
            options.append(random)
        }
        //print("Options: \(options)")
        return options
    }
    
    mutating func reset() {
        deck = Deck()
        
        // Creating bot one, the model is on the Player
        let bot1 = Player(id: 1, name: "Bot 1", score: 0, cardOne: deck.getNewCard(), isTurn: false)
        // Creating bot two, the model is on the Player
        let bot2 = Player(id: 2, name: "Bot 2", score: 0, cardOne: deck.getNewCard(), isTurn: false)
        var player = Player(id: 0, name: "Player", score: 0, cardOne: deck.getNewCard(), isTurn: false)
        
        let new_card = deck.getNewCard()
        // add the fourth to the player (player always starts)
        player.addCard(new_card: new_card)
        
        players = [player, bot1, bot2]
        
        // dropFirst returns an array without the first element
        for bot in players.dropFirst() {
            for player in players {
                bot.addToDM(card: player.cardOne, player_id: player.ID(), claim: player.cardOne.content)
                if player.cardTwo != nil {
                    bot.addToDM(card: player.cardTwo!, player_id: player.ID(), claim: player.cardTwo!.content)
                }
            }
        }
        senderID = 0
        // Player always starts as the sender
        players[senderID].isTurn = true
        options = makeOptions()
        loserFound = false
    }
}
