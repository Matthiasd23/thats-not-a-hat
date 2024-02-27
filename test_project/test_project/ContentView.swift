//
//  ContentView.swift
//  test_project
// strg+alt+enter to open preview again
//  Created by usabilitylab on 21/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            HStack{
                PlayerView(player: "Bot 1") // bot 1
                Spacer()
                PlayerView(player: "Bot 2") // bot 2
            }
            CardStack()
            PlayerView(player: "Player") // This should be the player
           
            // Idk if this is the correct place to make the call for which HStack to call, but yeah should then be made here
            HStack{
                Button(action: {} , label: {Text("Accept")}).padding(.horizontal) // Make the actions
                Spacer()
                Button(action: {} , label: {Text("Decline")}).padding(.horizontal)
            }
        }

    }
}


struct CardView: View{
    @State var content: String          // Emoji that is presented on the card
    @State var isFaceUp: Bool = false   // Wether it is facing up or down, needed when checking the card
    @State var arrow: String            // The arrow as an emoji pointing in a direction (maybe bool is better)
    @State var cardState: Bool = true // This i thought for having an acutal card there, or just a placeholder.
    
    var body: some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if cardState == true {
                if isFaceUp == true {      // Some card state 1 is face up, 2 is face down and 3 is the placeholder
                    shape.fill().foregroundColor(.blue)
                    shape.stroke(lineWidth:4)
                    
                    Text(content)
                } else { // 2 is face down
                    shape.fill()
                    Text(arrow)
                }
            } else { // This case should be displayed when the player only has 1 card
                shape.fill().foregroundColor(.white)
                shape.stroke(style: StrokeStyle(lineWidth: 5, dash: [5]))
            }
            
        }.padding(.horizontal)
        .onTapGesture(perform: {isFaceUp = !isFaceUp}) //This should move the card to the next player according to logic, not flip over the card
        .aspectRatio(2/1, contentMode: .fit)
    }
}

struct CardStack: View { //My idea would be like to do multiple cards overlapping for now its just one card. This is very ugly at the moment but helps put border between the bots
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.red)
            .padding(.all)
            .aspectRatio(2/3,contentMode: .fit)
    }
}

struct PlayerView: View{
    @State var player : String
    @State var cardNum: Int = 1  // This i think will be needed to decide weather the card is there or it should just be the indicated space. This needs to be a bit more
    var body: some View{
        VStack{
            Text(player) // Maybe make it so a player can enter its name?
            CardView(content: "🍎", arrow: "➡️")
            CardView(content: "🍔", arrow: "⬅️")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
