//
//  MainMenuView.swift
//  MistakeMaster
//
//  Created by 3 Kings on 6/8/25.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(AppGlobals.BGColor1)
                .ignoresSafeArea()
            VStack {
                Text("MistakeMaster")
                    .labelMod(300, 200, 3)
                Text("Quiz")
                    .labelMod(300, 100, 3)
            }
        }
    }
}

#Preview {
    MainMenuView()
}
