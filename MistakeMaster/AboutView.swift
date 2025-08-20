//
//  AboutView.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 8/14/25 for MistakeMaster
//

import SwiftUI

struct AboutView: View {
    @Binding var viewPath: NavigationPath
    @EnvironmentObject var globalTimer: GlobalTimer
    
    var nullFunc: () -> Void = {}
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            MainMenuGradientBackground(col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2)
            VStack {
                Button {
                    dismiss()
                }
                label: {
                    Text("Back")
                        .labelMod(100, 50, globalTimer.time - AppGlobals.waveOffset, textPadding: 12)
                }
                .offset(x: -122)
                .buttonStyle(DefaultButtonStyle())
                VStack {
                    Text("--About--")
                        .font(.custom("futura", size: 65))
                        .bold()
                    Text("MistakeMaster was created by a physics teacher and developed by a physics student with the goal of creating an effective tool for studying AP Physics 1.")
                        .font(.custom("futura", size: 19))
                        .frame(width: 310, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text("We believe that a student's wrong answer is just as valuable as their right answer. With that, our system adapts to your wrong answers, queuing up questions that address misconceptions in a user's knowledge.")
                        .font(.custom("futura", size: 19))
                        .frame(width: 310, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    (Text("This is the first version of MistakeMaster, and if you found any bugs or have any feedback or ideas for future updates, feel free to reach out to us at:") + Text(" MistakeMasterAPPhysics1@gmail.com")                        .font(.custom("futura", size: 16)))
                        .font(.custom("futura", size: 19))
                        .frame(width: 310, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text("Happy Mastering :)")
                        .font(.custom("futura", size: 30))
                        .padding(1)
                }
                .labelMod(350, 650, globalTimer.time)
                .padding(40)
                Rectangle()
                    .fill(.clear)
                    .frame(height: 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    }
}

#Preview {
    AboutView(viewPath: .constant(NavigationPath()))
        .environmentObject(GlobalTimer())
}
