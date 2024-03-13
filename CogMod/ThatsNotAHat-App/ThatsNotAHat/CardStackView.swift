//
//  CardStackView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI

// separate file
struct CardStackView: View { //My idea would be like to do multiple cards overlapping for now its just one card. This is very ugly at the moment but helps put border between the bots
    var idle: Bool
    
    let colors: [Color] = [.red, .green, .blue, .orange, .yellow, .pink, .purple, Color("ThatsNotAHatPink"), Color("cottonCandy")]
    
    @State private var stack_color = Color("ThatsNotAHatPink")
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(stack_color)
            .padding(.all)
            .aspectRatio(2/3,contentMode: .fit)
            .onTapGesture{
                if idle {
                    self.stack_color = self.colors.randomElement() ?? Color("ThatsNotAHatPink")
                }
            }
    }
}

