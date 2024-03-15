//
//  test_project_gamelogic.swift
//  test_project
//
//  Created by usabilitylab on 27/02/2024.
//

import Foundation


struct ThatsNotAHat<CardContent>{
    
    private var cards: Array<Card<CardContent>>
    private var players: Array<Player>
    private var sender: Player = Player(id: 99, name: "placeholder", score: 0, cardOne: Card(rightArrow: false, content: "nothing"))
    // private var passed_card: Card<String>?
    private var message: String?
    internal var model_bot1 = Model()  // we need the ACT-R Folder in the project for this to work
    internal var model_bot2 = Model() // Initializing a different model for each bot
    internal var deck = Deck()
    
    init() {
        // so this is basically the start of the game right? So we should also add those shown cards to the model memory, there should be some interaction possible for the player
        // to chose how long he wants to see the cards with a certain maximum i guess (or not if that is harder to implement)
        cards = []  // Isnt this empty afterwards aswell? as we never add anything
        // provide everyone with 3 cards, open - cardContentFactory
        var bot1 = Player(id: 1, name: "Bot 1", score: 0, cardOne: deck.getNewCard())
        var bot2 = Player(id: 2, name: "Bot 2", score: 0, cardOne: deck.getNewCard())
        var player = Player(id: 0, name: "Player", score: 0, cardOne: deck.getNewCard())
        
        var new_card = deck.getNewCard()
        // add the fourth to the player (player always starts)
        player.cardTwo = new_card
        
        players = [player, bot1, bot2]
        
        // Adding the cards to the bots declerative memory, bot1 his own card
        var newExperience = model_bot1.generateNewChunk(string: bot1.cardOne.content)
        newExperience.setSlot(slot: "playerID", value: bot1.ID())   // We need a slot that saves player ID or name, Card Content, and Arrow
        newExperience.setSlot(slot: "content", value: bot1.cardOne.content)
        newExperience.setSlot(slot: "arrow", value: bot1.cardOne.directionValue()) // is this correct? and also might be too much information for the models
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        //other bots card
        newExperience = model_bot1.generateNewChunk(string: bot2.cardOne.content) // names must be based on card content or smth unique to a card
        newExperience.setSlot(slot: "playerID", value: bot2.ID())
        newExperience.setSlot(slot: "content", value: bot2.cardOne.content)
        newExperience.setSlot(slot: "arrow", value: bot2.cardOne.directionValue())
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        //players card
        newExperience = model_bot1.generateNewChunk(string: player.cardOne.content)
        newExperience.setSlot(slot: "playerID", value: player.ID())
        newExperience.setSlot(slot: "content", value: player.cardOne.content)
        newExperience.setSlot(slot: "arrow", value: player.cardOne.directionValue())
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        //new introduced card
        newExperience = model_bot1.generateNewChunk(string: new_card.content)
        newExperience.setSlot(slot: "playerID", value: player.ID())
        newExperience.setSlot(slot: "content", value: new_card.content)
        newExperience.setSlot(slot: "arrow", value: new_card.directionValue())
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
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
    
    mutating func playerAccepts() {
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = sender.passCard()
        var receiver = players[receiver_id]
        // ------------------------------------------ \\
        // addCard to receiver
        receiver.addCard(new_card: passed_card)
        // reinforce things
        let newExperience = model_bot1.generateNewChunk(string: passed_card.content)
        newExperience.setSlot(slot: "playerID", value: receiver.ID())
        newExperience.setSlot(slot: "content", value: passed_card.content)
        newExperience.setSlot(slot: "arrow", value: passed_card.directionValue())
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        // After accepting the player becomes the sender
        sender = players[0]
    }
    
    mutating func playerDeclines() { // ADD timer for the models (with a max so it cant be exploited)
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
        if checkMessageWithCard(card: passed_card) {
            // sender correct
            receiver.addToScore()
            checkForLoser()

            // Introduce new card with cardContentFactory (this should be moved to model (maybe create a separate struct/file)
            // TEMP commented out so xCode can create a build: var new_card = cardContentFactory()

            receiver.addCard(new_card: new_card)
            // Do model things - reinforcing
            let newExperience = model_bot1.generateNewChunk(string: new_card.content)
            newExperience.setSlot(slot: "playerID", value: receiver.ID())
            newExperience.setSlot(slot: "content", value: new_card.content)
            newExperience.setSlot(slot: "arrow", value: new_card.directionValue())
            // A slot that holds info if the card is in the game or not could be an idea, maybe makes it too easy for the bots
            model_bot1.dm.addToDM(newExperience)
            model_bot2.dm.addToDM(newExperience)
            
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
            let newExperience = model_bot1.generateNewChunk(string: new_card.content)
            newExperience.setSlot(slot: "playerID", value: sender.ID())
            newExperience.setSlot(slot: "content", value: new_card.content)
            newExperience.setSlot(slot: "arrow", value: new_card.directionValue())
            // A slot that holds info if the card is in the game or not could be an idea, maybe makes it too easy for the bots
            model_bot1.dm.addToDM(newExperience)
            model_bot2.dm.addToDM(newExperience)
            
            // SENDER STAYS SENDER
        }
    }
    
    // we need now the control options for the model.
}
