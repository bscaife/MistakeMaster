//
//  Summary.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 7/29/25 for MistakeMaster.
//

import SwiftUI

struct SummaryTextMod: ViewModifier {
    let size: CGFloat
    let isCentered: Bool
    let col1: Color
    func body(content: Content) -> some View {
        content
            .font(.custom("futura", size: CGFloat(size)))
            .frame(maxWidth: 340, maxHeight: 200, alignment: isCentered ? .center : .leading)
            .fixedSize(horizontal: false, vertical: true)
            .minimumScaleFactor(0.5)
            .foregroundStyle(col1)
            .multilineTextAlignment(isCentered ? .center : .leading)
    }
}


extension View {
    func summaryTextMod(_ size: Int, isCentered: Bool = false, col1: Color) -> some View {
        self.modifier(SummaryTextMod(size: CGFloat(size), isCentered: isCentered, col1: col1))
    }
}

struct CheckeredPattern: View {
    let squareSize: CGFloat = UIScreen.main.bounds.width / 8
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...20, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0...7, id: \.self) { j in
                        Rectangle()
                            .frame(width: squareSize, height: squareSize)
                            .foregroundStyle((i + j) % 2 == 0 ? .white : .clear)
                    }
                }
            }
        }
    }
}

struct CheckeredBackground: View {
    var time: CGFloat
    let col1: Color
    let looopingFac = 0.5
    
    var body: some View {
        Rectangle()
            .fill(AppGlobals.buttonCol2)
            .ignoresSafeArea()
        ZStack {
            CheckeredPattern()
                .ignoresSafeArea()
                .opacity(0.1)
                .blendMode(.colorDodge)
                .offset(x: (time * 40).truncatingRemainder(dividingBy: UIScreen.main.bounds.width * looopingFac))
            CheckeredPattern()
                .ignoresSafeArea()
                .opacity(0.1)
                .blendMode(.colorDodge)
                .offset(x: -UIScreen.main.bounds.width + (time * 40).truncatingRemainder(dividingBy: UIScreen.main.bounds.width * looopingFac))
            CheckeredPattern()
                .ignoresSafeArea()
                .opacity(0.1)
                .blendMode(.colorDodge)
                .offset(x: UIScreen.main.bounds.width + (time * 40).truncatingRemainder(dividingBy: UIScreen.main.bounds.width * looopingFac))
        }
        .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0.7, z: -0.25))
        .scaleEffect(1.25)
        .offset(y: -200)
        
        Rectangle()
            .foregroundStyle(LinearGradient(colors: [col1, .clear, .clear, .clear, .clear, col1], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
            .opacity(0.5)
    }
}


struct Summary: View {
    @Binding var viewPath: NavigationPath
    
    var roundStats: Stats
    var endedEarly: Bool = false
    var isPathDiagnostic: Bool = true
    @State var isItHere: Bool = false
    var coords: [Int]
    @State var nextCoords: [Int] = [1, 1]
    @State var showNext = false
    
    @Binding var info: InfoList
    var quizMode: QuizMode
    
    @EnvironmentObject var globalTimer: GlobalTimer
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            CheckeredBackground(time: globalTimer.time, col1: AppGlobals.textColor)
            
            Group {
                Rectangle()
                    .stroke(AppGlobals.textColor, lineWidth: 10)
                    .fill(AppGlobals.buttonCol2)
                    .frame(width: 360, height: showNext ? 400 : 380)
                    .shadow(color: AppGlobals.textColor, radius: 10, x: 0, y: 5)
                    .background (
                        RoundedRectangle(cornerRadius: 170)
                            .frame(width: 550, height: 600)
                            .foregroundStyle(AppGlobals.buttonCol2)
                            .blur(radius: 100)
                    )
                VStack {
                    Text("Good Job!")
                        .frame(width: 350)
                        .summaryTextMod(62, isCentered: true, col1: AppGlobals.textColor)
                        .bold()
                        .padding(-10)
                    Separator(col1: AppGlobals.textColor, width: 350, height: 4)
                    (Text("You scored") + Text(" \(Int(roundStats.getScoreFac() * 100.0 + 0.5))%").bold() + Text(" on this study set!"))
                        .summaryTextMod(29, isCentered: false, col1: AppGlobals.textColor)
                    (Text("----------- Time:") + Text(" \(roundStats.getTimeFormatted())").bold() + Text(" -----------"))
                        .summaryTextMod(29, isCentered: false, col1: AppGlobals.textColor)
                    HStack() {
                        if showNext {
                            Button {
                                viewPath.removeLast(2)
                                
                                DispatchQueue.main.async {
                                    if quizMode == .chapterDiagnostic {
                                        QuestionLoader.goToChapterQuestions(i: info, unit: nextCoords[0], chapter: nextCoords[1], viewPath: $viewPath)
                                    }
                                    else if quizMode == .mathIntentional {
                                        QuestionLoader.goToMathMisconception(i: info, unit: nextCoords[0], chapter: nextCoords[1], viewPath: $viewPath)
                                    }
                                }
                            }
                            label: {
                                Text("Next")
                                    .labelMod(108, 80, 0, textPadding: 10)
                            }
                            .buttonStyle(DefaultButtonStyle())
                        }
                        Button {
                            viewPath.removeLast(2)
                            DispatchQueue.main.async {
                                switch quizMode {
                                case .chapterDiagnostic:
                                    QuestionLoader.goToChapterQuestions(i: info, unit: coords[0], chapter: coords[1], viewPath: $viewPath)
                                case .misconceptionIntentional:
                                    QuestionLoader.goToMisconceptionIntentional(i: info, unit: coords[0], chapter: coords[1], misc: coords[2], viewPath: $viewPath)
                                case .unitDiagnostic:
                                    QuestionLoader.goToUnitDiagnostic(i: info, unit: coords[0], chapter: coords[1], viewPath: $viewPath)
                                case .mathIntentional:
                                    QuestionLoader.goToMathMisconception(i: info, unit: coords[0], chapter: coords[1], viewPath: $viewPath)
                                }
                            }
                        }
                        label: {
                            Text("Again")
                                .labelMod(showNext ? 108 : 168, 80, 0, textPadding: 10)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            viewPath.removeLast(2)
                        }
                        label: {
                            Text("Menu")
                                .labelMod(showNext ? 108 : 168, 80, 0, textPadding: 10)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    // this hstack is mysteriously off-center and I can't find whatever alignment thing is causing it so we're doing a tiny offset for now
                    .animation(nil, value: showNext)
                    .offset(x: -3)
                    if showNext {
                        (Text("Next up: ") + Text(info.getChArray()[nextCoords[0]][nextCoords[1]].getAdjustedName()).bold())
                            .summaryTextMod(18, isCentered: false, col1: AppGlobals.textColor)
                            .padding(.vertical, 5)
                            .offset(y: 12)
                    }
                }
            }
            .hoverMod(globalTimer.time, 0.5)
            .scaleEffect(isItHere ? 1 : 0)
            .blur(radius: isItHere ? 0 : 10)
            .animation(.timingCurve(0.0, 0.8, 0.2, 1.0, duration: 1.25 * AppGlobals.getAnimSpeed()), value: isItHere)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .statusBar(hidden: true)
        .onAppear {
            SoundManager.playMP3("whoosh")
            isItHere = true
            checkIfShowNext()
        }
    }
    
    // non-void function in case i decide to animate the showsNext boolean value for whatever reason
    func checkIfShowNext() {
        if (quizMode == .chapterDiagnostic && !(coords[0] >= info.getChArray().count - 1 && coords[1] >= info.getChArray()[coords[0]].count - 1)) || (quizMode == .mathIntentional && coords[0] < info.getChArray()[coords[0]].count - 1) {
            showNext = true
            setnextChapterCoords()
        }
    }
    
    func setnextChapterCoords() {
        if coords[1] >= info.getChArray()[coords[0]].count - 1 {
            nextCoords = [coords[0] + 1, 0]
        }
        else {
            nextCoords = [coords[0], coords[1] + 1]
        }
    }
}

#Preview {
    Summary(viewPath: .constant(NavigationPath()), roundStats: Stats(answersCorrect: 7, answersIncorrect: 11), coords: [0, 9], info: .constant(InfoList()), quizMode: QuizMode.mathIntentional)
        .environmentObject(GlobalTimer())
}
