//
//  CardView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI


struct CardView: View {
    
    var content: String          // Emoji that is presented on the card
    var isFaceUp: Bool   // Wether it is facing up or down, needed when checking the card
    var arrow: String            // The arrow as an emoji pointing in a direction (maybe bool is better)
    var cardState: Bool = true // This i thought for having an acutal card there, or just a placeholder.
    var isSelected: Bool = false
    
    var body: some View {
        ZStack{
            if isSelected {
                RoundedRectangle(cornerRadius:20)
                    .stroke(Color.white, lineWidth: 15)
            }
            let shape = RoundedRectangle(cornerRadius: 20)
            if cardState == true {
                if isFaceUp == true {
                    shape.fill().foregroundColor(.white)
                    shape.stroke(lineWidth:4)
                    
                    Text(content).font(.largeTitle)
                } else { // 2 is face down
                    shape.fill().foregroundColor(Color("ThatsNotAHatPink"))
                    Text(arrow).font(.largeTitle)
                }
            } else { // This case should be displayed when the player only has 1 card
                shape.fill().foregroundColor(Color("lightPink"))
                shape.stroke(style: StrokeStyle(lineWidth: 5, dash: [5]))
            }
            
        }.padding(.horizontal)
//            .onTapGesture(perform: {
//                isFaceUp = !isFaceUp
//            })
        .aspectRatio(2/1, contentMode: .fit)
    }
}
