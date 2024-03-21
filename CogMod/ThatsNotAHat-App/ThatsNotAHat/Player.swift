//
//  Player.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 13/03/2024.
//

import Foundation

// This struct is probably needed for the logic - not sure how important the link to the view would be
struct Player {
    var id: Int
    var name: String
    var score: Int
    // cardOne should always be the oldest card.
    var cardOne: Card<String>   // Type could be different (we use CardContent, which is a 'dont care, could be anything', but for now we use string
    var cardTwo: Card<String>? // Use a 'special card in the model' that represents the card that is passed around
    var isTurn: Bool
    var model: Model?
    var message: String = ""
    
    init(id: Int, name: String, score: Int, cardOne: Card<String>, cardTwo: Card<String>? = nil, isTurn: Bool = false) {
        self.id = id
        self.name = name
        self.score = score
        self.cardOne = cardOne
        self.cardTwo = cardTwo
        self.isTurn = isTurn
        if id != 0 {
            self.model = Model()
        }
    }
    
    // directions:
    // from players[0] to the left: players[1]      to the right: players[2]
    // from players[1] to the left: players[2]      to the right: players[0]
    // from players[2] to the left: players[0]      to the right: players[1]
    
    private func determineReceiver(direction: Bool) -> Int {
        // direction (Bool): true = right, false = left
        // this function returns the index corresponding to the receiver in players[index]
        if direction {
            return id == 0 ? 2 : id - 1
        } else {
            return id == 2 ? 0 : id + 1
        }
    }
    
    mutating func passCard() -> (Int, Card<String>){
        // Choosing what to say, could be called passCard or smth
        // just using a placeholder right now
        let receiver = determineReceiver(direction: cardOne.rightArrow)
        let passed_card = cardOne
        // cardTwo should never be nil in this case, otherwise a default (wrong) card will be shown
        cardOne = cardTwo ?? Card(isFaceUp: true, rightArrow: true, content: "Something went wrong")
        cardTwo = nil
        return (receiver, passed_card)
    }
    
    mutating func addCard(new_card: Card<String>) {
        cardTwo = new_card
    }
    
    func ID() -> Double {
        return Double(id)
    }
    
    mutating func addToScore() {
        score += 1
    }
    
    func decisionCard(){
        // Retrieve activation of Chunk: id: sender.id, arrow: known
        
        // highest activation
        
    }
    
    // Never called by player
    func addToDM(card: Card<String>, player_id: Double) {
        model?.dm.addToDM(createChunk(card: card, player_id: player_id))
    }
    
    mutating func acceptCard(passed_card: Card<String>, player_id: Double){          // Accepting the card
        // retrieve new card before reinforcing new chunk
        let card_to_pass = retrieveChunk(card: cardOne, player_id: ID())
        // Receiver reinforces chunk
        addToDM(card: passed_card, player_id: player_id)
        
        // return a message that w
        if card_to_pass == nil {
            self.message = dealWithUncertainty()
        } else {
            self.message = "I have a " + card_to_pass?.slotValue(slot: "content")
        }
    }
    
    func dealWithUncertainty() -> String {
        return "I don't know..."
    }
            
    func declineCard() {        // Declining the card
        // Receiver says no
        // Appoint a 'loser'
        // Introduce new card, assign it to the loser
        // Everyone reinforces
    }
    
    private func createChunk(card: Card<String>, player_id: Double, recall: Bool = false) -> Chunk {
        // if recall is true, the goal is to recall whether the player actually has the card that is said - leave the content empty
        let chunk = model!.generateNewChunk(string: card.content)
        if recall == false {
            chunk.setSlot(slot: "content", value: card.content)
        }
        chunk.setSlot(slot: "playerID", value: player_id)
        chunk.setSlot(slot: "direction", value: card.directionValue())
        return chunk
    }
    
    func retrieveChunk(card: Card<String>, player_id: Double) -> Chunk? {
        // recall card
        let (latency, optionalChunk) = model!.dm.retrieve(chunk: createChunk(card: card, player_id: player_id, recall: true))
        // add latency to the model
        model!.time += latency
        return optionalChunk
    }
    
}
