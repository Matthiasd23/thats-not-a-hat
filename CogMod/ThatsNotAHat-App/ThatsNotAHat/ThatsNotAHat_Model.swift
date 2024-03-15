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
    private var passed_card: Card<String>?
    private var message: String?
    internal var model_bot1 = Model()  // we need the ACT-R Folder in the project for this to work
    internal var model_bot2 = Model() // Initializing a different model for each bot
    
    
    init(cardContentFactory: () -> CardContent, directionFactory: () -> Bool) {
        // so this is basically the start of the game right? So we should also add those shown cards to the model memory, there should be some interaction possible for the player
        // to chose how long he wants to see the cards with a certain maximum i guess (or not if that is harder to implement)
        cards = []  // Isnt this empty afterwards aswell? as we never add anything
        // provide everyone with 3 cards, open - cardContentFactory
        var bot1 = Player(id: 1, name: "Bot 1", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory() as! String))
        var bot2 = Player(id: 2, name: "Bot 2", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory() as! String))
        var player = Player(id: 0, name: "Player", score: 0, cardOne: Card(rightArrow: directionFactory(), content: cardContentFactory() as! String))
        
        var new_card = Card(rightArrow: false, content: cardContentFactory() as! String)
        // add the fourth to the player (player always starts)
        player.cardTwo = new_card
        
        players = [player, bot1, bot2]
        
        // Adding the cards to the bots declerative memory, bot1 his own card
        let newExperience = model_bot1.generateNewChunk(string: bot1.cardOne.content)
        newExperience.setSlot(slot: "playerID", value: bot1.id)   // We need a slot that saves player ID or name, Card Content, and Arrow
        newExperience.setSlot(slot: "content", value: bot1.cardOne.content)
        newExperience.setSlot(slot: "arrow", value: bot1.cardOne.rightArrow) // is this correct? and also might be too much information for the models
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        //other bots card
        let newExperience = model_bot1.generateNewChunk(string: bot2.cardOne.content) // names must be based on card content or smth unique to a card
        newExperience.setSlot(slot: "playerID", value: bot2.id)
        newExperience.setSlot(slot: "content", value: bot2.cardOne.content)
        newExperience.setSlot(slot: "arrow", value: bot2.cardOne.rightArrow)
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        //players card
        let newExperience = model_bot1.generateNewChunk(string: player.cardOne.content)
        newExperience.setSlot(slot: "playerID", value: player.id)
        newExperience.setSlot(slot: "content", value: player.cardOne.content)
        newExperience.setSlot(slot: "arrow", value: player.cardOne.rightArrow)
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
        
        //new introduced card
        let newExperience = model_bot1.generateNewChunk(string: player.cardTwo.content)
        newExperience.setSlot(slot: "playerID", value: player.id)
        newExperience.setSlot(slot: "content", value: player.cardTwo.content)
        newExperience.setSlot(slot: "arrow", value: player.cardTwo.rightArrow)
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
    func checkMessageWithCard() -> Bool {
        return message == passed_card?.content
    }

    func loadModel(filename: String){
        // Do we need this? depends on if we want to use actual ACT-R or more a pseudo implimentation, i would suggest using smth similar to PD3 so no
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
        newExperience.setSlot(slot: "playerID", value: receiver.id)
        newExperience.setSlot(slot: "content", value: passed_card.content)
        newExperience.setSlot(slot: "arrow", value: passed_card.rightArrow)
        model_bot1.dm.addToDM(newExperience)
        model_bot2.dm.addToDM(newExperience)
    }
    
    mutating func playerDeclines() {
        // ------------------------------------------ \\ double code
        // Either bot 1 or bot 2 passed the card (sender)
        // player is receiver
        let (receiver_id, passed_card) = sender.passCard()
        var receiver = players[receiver_id]
        // Introduce new card with cardContentFactory (this should be moved to model (maybe create a separate struct/file)
        // either way a new card is introduced, the only difference is who gets the card
        var new_card = cardContentFactory()
        // ------------------------------------------ \\
        // Card must be shown
        if checkMessageWithCard() {
            // sender correct
            receiver.addToScore()
            checkForLoser()

            // Introduce new card with cardContentFactory (this should be moved to model (maybe create a separate struct/file)
            // TEMP commented out so xCode can create a build: var new_card = cardContentFactory()

            receiver.addCard(new_card: new_card)
            // Do model things - reinforcing
            let newExperience = model_bot1.generateNewChunk(string: new_card.content)
            newExperience.setSlot(slot: "playerID", value: receiver.id)
            newExperience.setSlot(slot: "content", value: new_card.content)
            newExperience.setSlot(slot: "arrow", value: new_card.rightArrow)
            // A slot that holds info if the card is in the game or not could be an idea, maybe makes it too easy for the bots
            model_bot1.dm.addToDM(newExperience)
            model_bot2.dm.addToDM(newExperience)
        }
        else {
            // receiver is correct
            sender.addToScore()
            checkForLoser()
            sender.addCard(new_card: new_card)
            // Update Bots
            let newExperience = model_bot1.generateNewChunk(string: new_card.content)
            newExperience.setSlot(slot: "playerID", value: sender.id)
            newExperience.setSlot(slot: "content", value: new_card.content)
            newExperience.setSlot(slot: "arrow", value: new_card.rightArrow)
            // A slot that holds info if the card is in the game or not could be an idea, maybe makes it too easy for the bots
            model_bot1.dm.addToDM(newExperience)
            model_bot2.dm.addToDM(newExperience)
        }
    }
    
    // we need now the control options for the model.
}
