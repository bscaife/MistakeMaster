//
//  test.swift
//  MistakeMaster
//
//  Created by 3 Kings on 8/12/25.
//

import SwiftUI

struct test: View {
    var body: some View {
        TabView {
            ForEach(0...3, id: \.self) {i in
                Rectangle()
                    .frame(width: 30, height: 30)
                    .tag(i)
            }
            .padding(.horizontal, -100)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    test()
}
