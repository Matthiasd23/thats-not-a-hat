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
    var cardOne: Card<String>   // Type could be different (we use CardContent, which is a 'dont care, could be anything', but for now we use string
    var cardTwo: Card<String>? // Use a 'special card in the model' that represents the card that is passed around
    
    // directions:
    // from players[0] to the left: players[1]      to the right: players[2]
    // from players[1] to the left: players[2]      to the right: players[0]
    // from players[2] to the left: players[0]      to the right: players[1]
    // the sender is the player
    private func determineReceiver(direction: Bool) -> Int {
        // direction (Bool): true = right, false = left
        // this function returns the index corresponding to the receiver in players[index]
        if direction {
            return id == 0 ? 2 : id - 1
        } else {
            return id == 2 ? 0 : id + 1
        }
    }
    
    func passCard(card: Card<String>){            // Choosing what to say, could be called passCard or smth
        // just using a placeholder right now
        var receiver = determineReceiver(direction: card.rightArrow)
    }
    func decisionCard(){        // Deciding weither to accept or decline the card (for the bots? )
        
    }
    func acceptCard(){          // Accepting the card
        // Receiver reinforces chunk
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
