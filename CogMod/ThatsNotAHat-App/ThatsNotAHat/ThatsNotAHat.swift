//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation


struct ThatsNotAHat<CardContent>{
    // players: is an array of all the players in the game
    // senderID: is the integer ID of the player
    // message: String containing the last message used by a player
    // deck: The deck of cards
    // options: the option, from where randomly selected items are shown to the player to choose from for passing the card
    // loserFound: a boolean if someone has lost the game. Used to end the game
    private(set) var players: Array<Player>
    private(set) var senderID: Int = 0
    private(set) var message: String = "No message"
    internal var deck: Deck
    private(set) var options: Array<String> = []
    var loserFound: Bool = false
    
    init() {
        // initializing the players, deck and dealing the first cards to the players. Also starts adding the cards to decleratve memory
        deck = Deck()
        // Creating the player
        var player = Player(id: 0, name: "Player", score: 0, cardOne: deck.getNewCard())
        // Creating bot one, the model is in the Player
        let bot1 = Player(id: 1, name: "Bot 1", score: 0, cardOne: deck.getNewCard())
        // Creating bot two, the model is in the Player
        let bot2 = Player(id: 2, name: "Bot 2", score: 0, cardOne: deck.getNewCard())

        
        let new_card = deck.getNewCard()
        // add the fourth to the player (player always starts)
        player.addCard(new_card: new_card)
        
        players = [player, bot1, bot2]
        
        // Loop through the bots and add the cards to their declarative memory.
        for index in 1..<players.count {
            for player in players {
                players[index].addToDM(card: player.cardOne, player_id: player.ID(), claim: player.cardOne.content)
                // strengthn the first card so they dont make a mistake immediately
                players[index].updateMemory(botID: Double(index), strength: 2)
                // This is true for the player, so the bots add the second card also to declarative memory
                if player.cardTwo != nil {
                    players[index].addToDM(card: player.cardTwo!, player_id: player.ID(), claim: player.cardTwo!.content)
                    
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
        if loser?.score ?? 0 >= 5 {
            loserFound = true
        }
    }
    
    func getLoser() -> Int {
        // Returns the ID of the losing player
        return players.max(by: { $0.score < $1.score })!.id
    }
    
    // Checks whether the player passed the right card, and removes it from the 'deck
    mutating func checkMessageWithCard(card: Card<String>, id: Int) -> Bool {
        deck.remove_from_deck(emoji: card.content)
        return players[id].message == card.content
    }
    
    // Updates the message of the player that this is called for.
    mutating func updatePlayerMessage(claim: String, id: Int){
        players[id].message = claim
    }
    
    // Turns all the cards face down.
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
    // Turns the decision bool in the player to 0
    mutating func turnOffDecision(){
        players[0].decision = false
    }
    
    // This function is called when the player accepts a card:
    // Player is the reciever, it adds the card into the players second slot and updates the declerative memory of the bots
    // Also updates the isTurn variable accordingly along with the senderID
    mutating func playerAccepts() {
        players[senderID].isTurn = false
        // Find the receiver and what card is to be passed
        let (receiver_id, passed_card) = players[senderID].passCard()
        
        // addCard to receiver (player in this case)
        players[receiver_id].cardTwo = passed_card
        // reinforce things, the sender (bot) reinforces and bystander
        for index in 1..<players.count {
            players[index].updateMemory(botID: Double(receiver_id), strength: 3) // This should update the first card of the bot
            players[index].addToDM(card: passed_card, player_id: players[receiver_id].ID(), claim: message)
        }
        
        // After accepting the player becomes the sender
        senderID = players[0].id
        players[senderID].isTurn = true
        
    }
    
    // This function is called when the player declines a card:
    // Player is receiver, one of the bots is the sender
    // determines who was correct and updates the gamestate accordingly
    mutating func playerDeclines() {
        players[senderID].isTurn = false
        // determines the receiver id (0 in this case) and what card is passed
        let (receiver_id, passed_card) = players[senderID].passCard()
        
        // a new card is introduced regardless of who is correct, just changes who receives this new card
        let new_card = deck.getNewCard()
        // ------------------------------------------ \\
        // We check if the claim of the sender and the content of the card is the same
        // if this is True the sender is correct, if it is false the receiver is correct
        if checkMessageWithCard(card: passed_card, id: senderID)
        {
            // sender correct, so reciever gets +1 to score
            players[receiver_id].addToScore()
            checkForLoser()
            
            // Add the new card, face up until player presses the button.
            players[receiver_id].addCard(new_card: new_card)
            print("NEW CARD RECEIVED: \(new_card)")
            

            // First update what the bots think the person has that gets the new card, and then add new card to their declarative memory
            for index in 1..<players.count {
                players[index].updateMemory(botID: Double(receiver_id), strength: 2)
                players[index].addToDM(card: new_card, player_id: players[receiver_id].ID(), claim: message)
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
            players[senderID].addCard(new_card: new_card)
            
            // First update what the bots think the person has that gets the new card, and then add new card to their declarative memory
            for index in 1..<players.count {
                players[index].addToDM(card: players[index].cardOne, player_id: players[index].ID(), claim: players[index].cardOne.content)
                players[index].updateMemory(botID: Double(senderID), strength: 2)
                players[index].addToDM(card: new_card, player_id: players[senderID].ID(), claim: message)
            }
            
            // SENDER STAYS SENDER
            players[senderID].isTurn = true
        }
        // update the options the player can choose from
        options = makeOptions()
    }
    
    
    
    // This function handles the decision making of the bots.
    // Player or bot passes a card to a bot, bot has to decide whether to accept or decling
    mutating func botDecision() {
        // players turn ends as soon as he passes the card
        players[senderID].isTurn = false
        
        //determine who receives the card, and what card is passed
        let (receiver_id, passed_card) = players[senderID].passCard()
        print("This is the sender ID Claim ",players[senderID].message)
        
        // bot makes the decision based on what it thinks the person has as card.one and compares that with the claim of the sender
        // returns True if it agrees = accept, False if it does not agree = decline
        let model_decision = players[receiver_id].decisionCard(passed_card: passed_card, player_id: players[senderID].ID(), claim: players[senderID].message)
        if model_decision {
            // Accept:
            // Adding the new card to the receiver
            players[receiver_id].addCard(new_card: passed_card)
            
            // both bots update the first card the receiver has and then add the new card to DM
            for index in 1..<players.count {
                players[index].updateMemory(botID: Double(receiver_id), strength: 2)
                players[index].addToDM(card: passed_card, player_id: players[receiver_id].ID(), claim: message)
            }
            
            // After accepting the receiver becomes the sender
            senderID = players[receiver_id].id
            players[senderID].isTurn = true
            // Update the message of the model based ont the senders message
            message = players[senderID].message
            
        }else{
            // model_decision = False, so bot declines
            // new card gets introduced, checked who made a mistake, score added and card given to that player
            let new_card = deck.getNewCard()
            if checkMessageWithCard(card: passed_card, id: senderID){
                
                // sender correct, receiver made the mistake
                players[receiver_id].addToScore()
                checkForLoser()
                
                // Add the new card to the player who made the mistake
                players[receiver_id].cardTwo = new_card
                // both bots update the first card the receiver has and then add the new card to DM
                for index in 1..<players.count {
                    players[index].updateMemory(botID: Double(receiver_id), strength: 2)
                    players[index].addToDM(card: new_card, player_id: players[receiver_id].ID(), claim: new_card.content)
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
                for index in 1..<players.count {
                    // Here we add the actual card to the DM again, because the sender retrieved the wrong card which means the card with the highest activation is wrong
                    // so updateMemory would further increase the strength of that card. This is still not working 100% maybe more reinforcement is needed
                    players[index].addToDM(card: players[index].cardOne, player_id: players[index].ID(), claim: players[index].cardOne.content)
                    players[index].addToDM(card: players[index].cardOne, player_id: players[index].ID(), claim: players[index].cardOne.content)
                    players[index].updateMemory(botID: Double(senderID), strength: 2)
                    players[index].addToDM(card: new_card, player_id: players[senderID].ID(), claim: new_card.content)
                }
                
            }
            // Update the card options shown to the player and update the sender
            options = makeOptions()
            players[senderID].isTurn = true
        }
    }
    
    // This function is called when the bots have to pass on their cards.
    // Returns the content of the card they think they are passing, or "No Chunk Retrieved"
    mutating func botGuess(id:Int) -> String{
        // Retrieves the chunk with the highest activations, used to change the message of the bots
        let chunk = players[id].retrieveChunk(card: players[id].cardOne, player_id: Double(id))
        if chunk != nil {
            // Forcing the chunk into a string and also force the unpacking. Done because we could not find another way to compare a Value? with a String
            let guessString = "\(chunk!.slotValue(slot: "content")!)"
            return guessString
        } else {
            return "No Chunk Retrieved"
        }
    }
    
    // Start the timer to measure how long the player took to decide
    mutating func startTimers() {
        for index in 1..<players.count {
            players[index].startTimer()
        }
    }
    // update the model according time passed
    mutating func updateModelTime() {
        for index in 1..<players.count {
            players[index].updateTime()
        }
    }
    
    // Updating the message
    mutating func updateClaimMessage(claim: String) {
        message = claim
    }
    
    // Updating the cards that are shown to the player based on cards that have been seen and the ones that are in play
    mutating func makeOptions() -> [String] {
        var options = deck.cards_inplay
        if let random = deck.cards_outofplay.randomElement() {
            options.append(random)
        }
        //print("Options: \(options)")
        return options
    }
    
    // reset the game to start again
    mutating func reset() {
        // Initiating new deck
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
        for index in 1..<players.count {
            for player in players {
                players[index].addToDM(card: player.cardOne, player_id: player.ID(), claim: player.cardOne.content)
                if player.cardTwo != nil {
                    players[index].addToDM(card: player.cardTwo!, player_id: player.ID(), claim: player.cardTwo!.content)
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
