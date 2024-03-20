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
    
    func decisionCard(){        // Deciding wether to accept or decline the card (for the bots? )
        // Retrieve activation of Chunk: id: sender.id, arrow: known
        // highest activation
        
    }
    
    func addToDM(card_content: String, player_id: Double, arrow: String) {
        let chunk = model?.generateNewChunk(string: card_content)
        chunk?.setSlot(slot: "content", value: card_content)
        chunk?.setSlot(slot: "playerID", value: player_id)
        chunk?.setSlot(slot: "direction", value: arrow)
        model?.dm.addToDM(chunk!)
    }
    
    func acceptCard(passed_card: Card<String>, player_id: Double){          // Accepting the card
        // retrieve new card before reinforcing new chunk
        
        // Retrieve own card to pass
        
        // Receiver reinforces chunk
        addToDM(card_content: passed_card.content, player_id: player_id, arrow: passed_card.directionValue())
        // Sender reinforces chunk
        // Bystander decides whether to reinforce or not/do something else
    }
            
    func declineCard() {        // Declining the card
        // Receiver says no
        // Appoint a 'loser'
        // Introduce new card, assign it to the loser
        // Everyone reinforces
    }
    
}
