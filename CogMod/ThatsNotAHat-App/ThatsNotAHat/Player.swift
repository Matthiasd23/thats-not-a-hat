//
//  Player.swift
//  ThatsNotAHat
//
//  Created by usabilitylab on 13/03/2024.
//

import Foundation

// This is the player struct, that holds the information about the player and the two bots.
// Stored information:
// ID: ID of the player [0,1,2]
// Name: Name given to the player. Idea was to later incorporate that the player can choose their name
// Score: Keeps track of the mistakes made by a player/bot
// cardOne: Card in the first slot (longer held card)
// cardTwo: always nil except isTurn = True
// isTurn: Boolean that tracks whos turn it is
// model: only bots have this, and it initializes an ACT-R model
// message: String containing the claim of what card is being passed
// decision: Boolean tracking whether the human player has to accept or decline a passed card. Used for the View to show correct buttons
// currentTime: tracking the current time
// maxTimeElapsed: Maximum time that gets added to the model if player takes longer

struct Player {
    var id: Int
    var name: String
    var score: Int
    // cardOne should always be the oldest card.
    var cardOne: Card<String>   // Type could be different (we use CardContent, which is a 'dont care, could be anything', but for now we use string
    var cardTwo: Card<String>? // Use a 'special card in the model' that represents the card that is passed around
    var isTurn: Bool
    var model = Model()
    var message: String = ""
    // TODO: My idea is to use this variable to update the view to show the accept/decline button it is always supposed to be false for the bots and only true if the player has to make a decision.
    var decision = false
    var currentTime = Date()
    var maxTimeElapsed: Double
    
    
    init(id: Int, name: String, score: Int, cardOne: Card<String>, cardTwo: Card<String>? = nil, isTurn: Bool = false, maxTimeElapsed: Double = 6.0) {
        self.id = id
        self.name = name
        self.score = score
        self.cardOne = cardOne
        self.cardTwo = cardTwo
        self.isTurn = isTurn
        self.maxTimeElapsed = maxTimeElapsed
    }
    
    // directions:
    // from players[0] to the left: players[1]      to the right: players[2]
    // from players[1] to the left: players[2]      to the right: players[0]
    // from players[2] to the left: players[0]      to the right: players[1]
    
    // function that returns the ID of the receiver
    func determineReceiver(direction: Bool) -> Int {
        // direction (Bool): true = right, false = left
        // this function returns the index corresponding to the receiver in players[index]
        if direction {
            return id == 0 ? 2 : id - 1
        } else {
            return id == 2 ? 0 : id + 1
        }
    }
    
    // Function that passes the cardOne of a player to the correct person
    mutating func passCard() -> (Int, Card<String>){
        let receiver = determineReceiver(direction: cardOne.rightArrow)
        let passed_card = cardOne
        // cardTwo should never be nil in this case, otherwise a default (wrong) card will be shown
        cardOne = cardTwo ?? Card(isFaceUp: true, rightArrow: true, content: "Something went wrong")
        cardTwo = nil
        return (receiver, passed_card)
    }
    
    // adding a card to the cardTwo slot
    mutating func addCard(new_card: Card<String>) {
        cardTwo = new_card
    }
    
    // returns the id
    func ID() -> Double {
        return Double(id)
    }
    
    // adds one to the score
    mutating func addToScore() {
        score += 1
    }
    
    mutating func decisionCard(passed_card: Card<String>, player_id: Double, claim: String) -> Bool {
        // passed_card: the actual card that is being passed
        // player_id: person who passed the card
        // claim: What the sender thought is on the card
        // This function checks if what the sender said is on the card and what the reciever thinks is on the card match or not
        // the receiver makes a retrieval request based on the sender ID and the Arrow on the card

        // card needs to be passed as an argument but is not used in the retrieval request!
        let retrieved_chunk = retrieveChunk(card: passed_card, player_id: player_id)
        let retrieved_content = retrieved_chunk?.slotValue(slot: "content")
        if retrieved_chunk != nil {
            print("Retrieved Content: \(retrieved_content!), Claim:\(claim), Actual Content \(passed_card.content)")
            // Forcing retrieved content into a string
            let myBool = "\(retrieved_content!)" == "\(claim)"
            
            if myBool{
                print("\(name) accepts")
                // acceptCard(passed_card: passed_card, player_id: player_id, claim: claim)
                return true

            }else{
                print("\(name) declines")
                return false
            }
        }
        // 80% of the time it should return false (if he doesnt know, rather defect than accept)
        return arc4random_uniform(100) < 20
    }
    
    // Never called by player, adding a chunk to declarative memory
    func addToDM(card: Card<String>, player_id: Double, claim: String) {
        model.dm.addToDM(createChunk(card: card, player_id: player_id, claim: claim))
        model.time += 1.0 // Adding things into DM takes a little bit of time.
    }
    
    // Since we use retrieve the 'next' card first, we should either return this card in the function, or make an additional variable card_to_pass in the player, which is set to nil afterwards
//    mutating func acceptCard(passed_card: Card<String>, player_id: Double, claim: String) {          // Accepting the card
        // retrieve new card before reinforcing new chunk
//        let card_to_pass = retrieveChunk(card: cardOne, player_id: ID())
        // Receiver reinforces chunk
//        addToDM(card: passed_card, player_id: player_id, claim: claim)
        
        // return a message that
//        if card_to_pass == nil {
//            self.message = dealWithUncertainty()
//        } else {
//            self.message = "\(String(describing: card_to_pass!.slotValue(slot: "content")))" // I have a
//        }
//    }
    
    
    
    func dealWithUncertainty() -> String {
        // I guess here we can implement multiple strategies, but i would suggest that if we dont retrieve any card, we just randomly say one for now.
        return "I don't know..."
    }
            
    // create a new chunk either to add to DM or used for a retrieval request
    private func createChunk(card: Card<String>, player_id: Double, claim: String, recall: Bool = false) -> Chunk {
        // card: card that should be added to DM
        // player_id: the player to which the card belongs
        // claim: Content of the card / claim what someone said is on the card
        // recall: Boolean wether this function call is used as retrival request or not basically
        // if recall is true, the goal is to recall whether the player actually has the card that is said - leave the content empty
        let chunk = model.generateNewChunk(string: claim)
        if recall == false {
            chunk.setSlot(slot: "content", value: claim)
        }
        chunk.setSlot(slot: "playerID", value: player_id)
        chunk.setSlot(slot: "direction", value: card.directionValue())
        return chunk
    }
    
    // retrieve Chunk from DM
    func retrieveChunk(card: Card<String>, player_id: Double) -> Chunk? {
        // card: Card to retrieve
        // player_id: position from where the cards should be retrieved
        let (latency, optionalChunk) = model.dm.retrieve(chunk: createChunk(card: card, player_id: player_id, claim: card.content, recall: true))
        // add latency to the model
        model.time += latency
        return optionalChunk
    }
    
    
    // Retrieve the card the person at ID has, and add it to declarative memory
    func updateMemory(botID: Double, strength: Int = 1) {
        // botID: position which persons card should be retrieved and reinforced
        // strength: How often the retrived chunk schould be addd to DM, in other terms how strongly the chunk should be reinforced
        let old_card = retrieveChunk(card: self.cardOne, player_id: botID)
        if old_card == nil {
            return
        }
        let dir = directionToBool(direction: "\(old_card!.slotValue(slot: "direction")!)")
        let temp_card = Card(rightArrow: dir , content: "\(old_card!.slotValue(slot: "content")!)")
        // Add it to declarative memory
        print("Temporary Card: Bot",self.id, old_card, botID)
        for _ in 1..<strength+1 {
            print("Adding..")
            self.addToDM(card: temp_card, player_id: botID, claim: temp_card.content)
        }
    }
    
    //function to get a Boolean from a direction string (left -> false, right -> true)
    func directionToBool(direction:String) -> Bool {
        if direction == "right"{ // Convert the string into a boolean
            return true
        }
        return false
    }
    
    // updates the time of the models
    func updateTime() {
        print(elapsedTime())
        model.time += elapsedTime()
    }
    
    
    mutating func startTimer() {
        currentTime = Date()
    }
    
    private func elapsedTime() -> Double {
        return min(Double(Date().timeIntervalSince(currentTime)), maxTimeElapsed)
    }
    
}
