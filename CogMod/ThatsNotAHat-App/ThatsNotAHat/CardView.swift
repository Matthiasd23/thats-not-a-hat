//
//  CardView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI


struct CardView: View {
    
    @State var content: String          // Emoji that is presented on the card
    @State var isFaceUp: Bool = false   // Wether it is facing up or down, needed when checking the card
    @State var arrow: String            // The arrow as an emoji pointing in a direction (maybe bool is better)
    @State var cardState: Bool = true // This i thought for having an acutal card there, or just a placeholder.
    @State var isSelected: Bool = false
    
    var body: some View {
        ZStack{
            if isSelected {
                RoundedRectangle(cornerRadius:20)
                    .stroke(Color.green, lineWidth: 7)
            }
            let shape = RoundedRectangle(cornerRadius: 20)
            if cardState == true {
                if isFaceUp == true {      // Some card state 1 is face up, 2 is face down and 3 is the placeholder
                    shape.fill().foregroundColor(.white)
                    shape.stroke(lineWidth:4)
                    
                    Text(content)
                } else { // 2 is face down
                    shape.fill().foregroundColor(Color("ThatsNotAHatPink"))
                    Text(arrow)
                }
            } else { // This case should be displayed when the player only has 1 card
                shape.fill().foregroundColor(Color("lightPink"))
                shape.stroke(style: StrokeStyle(lineWidth: 5, dash: [5]))
            }
            
        }.padding(.horizontal)
        .onTapGesture(perform: {isFaceUp = !isFaceUp}) //This should move the card to the next player according to logic, not flip over the card
        .aspectRatio(2/1, contentMode: .fit)
    }
}
