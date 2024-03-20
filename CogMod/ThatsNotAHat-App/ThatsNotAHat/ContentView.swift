//
//  ContentView.swift
//  ThatsNotAHat
//
//  Created by UsabilityLab on 2/21/24.
//

import SwiftUI


struct ContentView: View {
    @State private var showInfo = false
    
    var body: some View {
        NavigationView{
            VStack() {
                HStack {
                    Image(systemName: "lamp.table.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                    Image(systemName: "globe.desk.fill")
                        .imageScale(.large)
                        .foregroundColor(.orange)
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundColor(.green)
                }
                .padding()
                HStack {
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                    Image(systemName: "airplane")
                        .imageScale(.large)
                        .foregroundColor(.purple)
                    Image(systemName: "sailboat.fill")
                        .imageScale(.large)
                        .foregroundColor(.yellow)
                }
                .padding()
                //Play Now Button: currently brings you to GameStartView. It should
                NavigationLink(destination:PlayerChoosesView()) {
                    Text("Play Now")
                }
                .padding()
                Button("Info"){
                    showInfo.toggle()
                }
                if showInfo {
                    Text("Project Created by Matthias, Tim and Rover for the course Cognitive Modelling: Complex Behaviour. Game explanation: ")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
