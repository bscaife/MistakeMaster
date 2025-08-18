//
//  ChallengeView.swift
//  MistakeMaster
//
//  Created by 3 Kings on 8/3/25.
//

import SwiftUI

struct ProgressBar: View {
    let progressFac: CGFloat
    let col1: Color
    let col2: Color
    let col3: Color
    let col4: Color // outlineColor
    var lineOverlay = true
    var outlineWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(col3, lineWidth: outlineWidth * 2)
                .frame(width: UIScreen.main.bounds.width * 1, height: 50)
                .overlay(
                    ZStack {
                        Rectangle()
                            .foregroundStyle(col2)
                        ZStack {
                            Rectangle()
                                .foregroundStyle(col1)
                                .offset(x: -(UIScreen.main.bounds.width) * (1.0 - progressFac))
                            Rectangle()
                                .foregroundStyle(LinearGradient(colors: [col1, col4], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                                .offset(x: -(UIScreen.main.bounds.width) * (1.0 - progressFac))
                                .mask {
                                    if lineOverlay {
                                        ProgressBarParticleView()
                                            .frame(height: 60)
                                            .offset(y: -165)
                                    }
                                }
                                .opacity(0.5)
                        }
                        Rectangle()
                            .foregroundStyle(LinearGradient(colors: [.clear, col3], startPoint: UnitPoint(x: 0, y: 0.4), endPoint: UnitPoint(x: 0, y: 1)))
                            .opacity(0.3)
                    }
                )
            
                .frame(width: UIScreen.main.bounds.width)
        }
        
        
    }
}

struct ChallengeView: View {
    @Binding var viewPath: NavigationPath
    var qSet: [Question]
    @State var time = 0.0
    @State var selection = 1
    @State private var timer = Timer.publish(every: (1 / AppGlobals.fps), on: .main, in: .common).autoconnect()
    @State var alert = AlertContext.exit
    @State var showAlert = false
    
    // every challenge set is 60 questions
    @State var answersElimedArray: [[Bool]] = Array(repeating: [false, false, false, false], count: 60)
    @State var answerSelectionArray: [Int] = Array(repeating: -1, count: 60)
    
    @State var testStats = Stats()
    
    @Binding var info: InfoList
    var chapter: Int
    
    @EnvironmentObject var globalTimer: GlobalTimer
    @State var timeRef: Double = 0.0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ZStack {
                QBackground(col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2)
                    .blur(radius: 3)
                VStack {
                    CustomToolbar(showAlert: $showAlert, alert: $alert, time: globalTimer.time, eventTime: -1.0)
                        .padding(-10)
                    TabView(selection: $selection) {
                        ForEach(qSet.indices, id: \.self) { q in
                            let question = qSet[q]
                            ZStack {
                                LazyVStack(spacing: 8) {
                                    Text(question.question)
                                        .labelMod(350, 250, globalTimer.time, textPadding: question.question.count > 250 ? 10.0 : 20.0)
                                    ForEach(0..<4) {i in
                                        HStack {
                                            // answer buttons
                                            Button {
                                                if !answersElimedArray[q][i] && !showAlert {
                                                    answerSelectionArray[q] = i
                                                }
                                            } label: {
                                                Text(question.answers[i])
                                                    .labelMod(300, 90, globalTimer.time + (Double(i) * AppGlobals.waveOffset), isElim: answersElimedArray[q][i], textPadding: question.answers[i].count >= 80 ? 8.0 : 20.0)
                                            }
                                            .buttonStyle(DefaultButtonStyle())
                                            .animation(.timingCurve(0.05, 0.95, 0.05, 0.95, duration: 0.5 * AppGlobals.getAnimSpeed()), value: answersElimedArray[q][i])
                                            
                                            // answer eliminator buttons
                                            Button {
                                                if !showAlert {
                                                    answersElimedArray[q][i].toggle()
                                                    if answerSelectionArray[q] == i {
                                                        answerSelectionArray[q] = -1
                                                    }
                                                }
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundStyle(AppGlobals.isLighterTheme() ? AppGlobals.buttonCol2 : AppGlobals.buttonCol1)
                                                    .hoverMod(time + (Double(i) * AppGlobals.waveOffset), 1)
                                                    .padding(5)
                                            }
                                            .buttonStyle(DefaultButtonStyle())
                                        }
                                    }
                                }
                                ForEach(0..<4) {i in
                                    SelectedIndicator(col1: AppGlobals.textColor, time: globalTimer.time, w: i == answerSelectionArray[q] ? 300 : -10, h: i == answerSelectionArray[q] ? 90 : -10, spaceFac: 0.02)
                                        .hoverMod(globalTimer.time + AppGlobals.waveOffset * CGFloat(i), 1)
                                        .offset(x: -30, y: CGFloat(-18 + (90 + 8) * i))
                                        .animation(.timingCurve(0.0, 0.8, 0.2, 1.0, duration: 0.4 * AppGlobals.getAnimSpeed()), value: answerSelectionArray[q])
                                }
                            }
                            .tag(q + 1)
                        }
                        Button {
                            alert = AlertContext.submitChallenge
                            showAlert = true
                        }
                        label: {
                            Text("Submit and grade")
                                .labelMod(325, 150, time)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .tag(qSet.count + 1)
                    }
                    .frame(height: 750)
                    ZStack {
                        ProgressBar(progressFac: CGFloat(selection) / CGFloat(qSet.count), col1: AppGlobals.buttonCol1, col2: AppGlobals.buttonCol2, col3: AppGlobals.isLighterTheme() ? AppGlobals.textColor : AppGlobals.buttonCol2, col4: AppGlobals.isLighterTheme() ? AppGlobals.buttonCol2 : AppGlobals.buttonOutlineColor)
                            .offset(y: 10)
                        Button {
                            alert = AlertContext.questionSelect
                            showAlert = true
                        } label: {
                            Text("\(min(selection, 60))")
                                .frame(width: 95, height: 95)
                                .bold()
                                .font(.custom("futura", size: 30))
                                .foregroundStyle(AppGlobals.textColor)
                                .background (
                                    ZStack {
                                        Circle()
                                            .fill(AppGlobals.buttonCol2)
                                            .stroke(AppGlobals.isLighterTheme() ? AppGlobals.textColor : AppGlobals.buttonCol2, lineWidth: 7)
                                        Circle()
                                            .fill(AppGlobals.buttonCol1)
                                            .stroke(AppGlobals.isLighterTheme() ? AppGlobals.textColor : AppGlobals.buttonCol2, lineWidth: 7)
                                            .mask {
                                                Rectangle()
                                                    .fill(.white)
                                                    .frame(width: UIScreen.main.bounds.width, height: 200)
                                                    .offset(x: UIScreen.main.bounds.width * 0.41 - (UIScreen.main.bounds.width) * (1.0 - (CGFloat(selection) / CGFloat(qSet.count))))
                                                    .animation(.easeOut(duration: 0.5 * AppGlobals.getAnimSpeed()), value: selection)
                                            }
                                        Circle()
                                            .foregroundStyle(RadialGradient(colors: [.clear, .black], center: UnitPoint(x: 0.65, y: 0.3), startRadius: 30.0, endRadius: 100.0))
                                            .opacity(0.6)
                                    }
                                    
                                )
                                .animation(nil, value: selection)
                        }
                        .offset(x: UIScreen.main.bounds.width * -0.41, y: -12)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .animation(.easeOut(duration: 0.5 * AppGlobals.getAnimSpeed()), value: selection)
                    .padding(-20)
                }
            }
            .alertOverlayMod(showAlert)
            
            PopUpWindow(alert: alert, showAlert: $showAlert, viewPath: $viewPath, time: globalTimer.time, answerArray: answerSelectionArray, answerSelection: $selection, questionsLeft: qSet.count - (answerSelectionArray.filter {$0 != -1 }).count, endRoundFunc: endRound, recordStatsFunc: recordStats, isOnChallenge: true)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            alert = .challengeExplanation
            timeRef = globalTimer.time
            if !(info.testProgressArray[chapter].isClearSave()) {
                answerSelectionArray = info.testProgressArray[chapter].answerSelectionArray
                answersElimedArray = info.testProgressArray[chapter].answersElimedArray
            }
            else {
                showAlert = true
            }
        }
        .onChange(of: selection) {
            // very quick patch in short time to reduce lag from the 60 buttons in the question select
            if alert == .questionSelect {
                alert = .settings
            }
        }
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
        .toolbar(.hidden)
        .animation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.7 * AppGlobals.getAnimSpeed()), value: showAlert)
    }
    
    func endRound() {
        var breakdownArray: [WrongAnswerBreakdown] = []
        for i in qSet.indices {
            if qSet[i].correctAnswer != answerSelectionArray[i] {
                if answerSelectionArray[i] != -1 {
                    breakdownArray.append(WrongAnswerBreakdown(question: qSet[i], answer: answerSelectionArray[i], id: i))
                }
                testStats.tallyIncorrectAnswer()
            }
            else {
                testStats.tallyCorrectAnswer()
            }
        }
        recordStats(includingHighscore: true)
        info.testProgressArray[chapter].clearSave()
        viewPath.append(Route.challengeSummary(stats: testStats, breakdownArray: breakdownArray))
    }
    
    func recordStats(includingHighscore: Bool = false) {
        testStats.setSecondsElapsed(Int(globalTimer.time - timeRef))
        info.unitInfoArray[chapter].addTotalTime(testStats.secondsElapsed)
        if includingHighscore {
            info.unitInfoArray[chapter].updateHighestScoreChallenge(testStats.getScoreFac())
        }
        else {
            info.testProgressArray[chapter].answerSelectionArray = answerSelectionArray
            info.testProgressArray[chapter].answersElimedArray = answersElimedArray
        }
    }
}

#Preview {
    ChallengeView(viewPath: .constant(NavigationPath()), qSet: unpackQuestions(
        fileName: "Unit_1_Challenge_60Q",
        subdirectory: "Subjects/AP Physics/Unit 1 Kinematics", loadDiagnosticType: false), info: .constant(InfoList()), chapter: 0)
    .environmentObject(GlobalTimer())
}
