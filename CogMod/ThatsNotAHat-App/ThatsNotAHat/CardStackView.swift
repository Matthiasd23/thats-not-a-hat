//
//  CardStackView.swift
//  test_project
//
//  Created by UsabilityLab on 2/28/24.
//

import SwiftUI

// separate file
struct CardStackView: View { //My idea would be like to do multiple cards overlapping for now its just one card. This is very ugly at the moment but helps put border between the bots
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color("ThatsNotAHatPink"))
            .padding(.all)
            .aspectRatio(2/3,contentMode: .fit)
    }
}

