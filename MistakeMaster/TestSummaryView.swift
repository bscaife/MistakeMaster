//
//  TestSummaryView.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 8/4/25 for MistakeMaster
//

import SwiftUI

struct incorrectAnswerBreakdown: View {
    var question: Question
    var answerSelected: Int
    let id: Int
    let width: CGFloat = 300
    let textPadding: CGFloat = 10.0
    
    let col1: Color // buttonCol1
    let col2: Color // text
    let col3: Color // outline
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Question \(id + 1): " + question.question)
                .frame(width: width - textPadding * 2, height: 100 - textPadding * 2)
                .font(.custom("futura", size: 24))
                .minimumScaleFactor(0.1)
                .padding(textPadding)
                .foregroundStyle(col2)
                .background (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(col3, lineWidth: 2)
                        .fill(col1)
                        .padding(2)
                )
            HStack(spacing: 5) {
                VStack {
                    Text("You answered:")
                        .frame(width: width / 2 - 2.5 - textPadding * 2, height: 40 - textPadding )
                        .font(.custom("futura", size: 16))
                        .foregroundStyle(col2)
                    Text(answerSelected == -1 ? "(Unanswered)" : question.answers[answerSelected])
                        .frame(width: width / 2 - 2.5 - textPadding * 2, height: 50 - textPadding)
                        .font(.custom("futura", size: 50))
                        .foregroundStyle(col2)
                        .minimumScaleFactor(0.1)
                }
                .padding(textPadding)
                .background (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(col3, lineWidth: 2)
                        .fill(col1)
                        .padding(2)
                    )
                VStack {
                    Text("Correct Answer:")
                        .frame(width: width / 2 - 5 - textPadding * 2, height: 40 - textPadding)
                        .font(.custom("futura", size: 16))
                        .foregroundStyle(col2)
                    Text( question.answers[question.correctAnswer])
                        .frame(width: width / 2 - 5 - textPadding * 2, height: 50 - textPadding)
                        .font(.custom("futura", size: 50))
                        .foregroundStyle(col2)
                        .minimumScaleFactor(0.1)
                }
                .padding(textPadding)
                .background (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(col3, lineWidth: 2)
                        .fill(col1)
                        .padding(2)
                    )
            }
            Text(question.explanation)
                .frame(width: width - textPadding * 2, height: 100 - textPadding * 2)
                .font(.custom("futura", size: 24))
                .foregroundStyle(col2)
                .minimumScaleFactor(0.1)
                .padding(textPadding)
                .background (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(col3, lineWidth: 2)
                        .fill(col1)
                        .padding(2)
                )
        }
//        VStack {
//            Text("Question: " + question.question)
//        }
    }
}

struct TestSummaryView: View {
    @Binding var viewPath: NavigationPath
    let testStats: Stats
    let wrongBreakdownArray: [WrongAnswerBreakdown]
    @State var isItHere: Bool = false
    
    @EnvironmentObject var globalTimer: GlobalTimer
    
    var body: some View {
        ZStack {
            CheckeredBackground(time: globalTimer.time, col1: AppGlobals.textColor)
            VStack(spacing: 15) {
                ZStack {
                    Rectangle()
                        .stroke(AppGlobals.textColor, lineWidth: 10)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 360, height: 250)
                        .shadow(color: AppGlobals.textColor, radius: 10, x: 0, y: 5)
                    VStack {
                        (Text("\(testStats.getAnswersCorrect())/60").bold() + Text(" (\(Int(testStats.getScoreFac() * 100.0 + 0.5))%)"))
                            .font(.custom("futura", size: 60))
                            .foregroundStyle(AppGlobals.textColor)
                            .frame(maxWidth: 340, maxHeight: 80)
                            .minimumScaleFactor(0.8)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(-5)
                        Text(getAcknowledgement(testStats.getScoreFac()))
                            .font(.custom("futura", size: 25))
                            .foregroundStyle(AppGlobals.textColor)
                            .padding(0)
                            .frame(maxWidth: 340, maxHeight: 30)
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(-12)
                        Text("Time: \(testStats.getTimeFormatted())")
                            .font(.custom("futura", size: 30))
                            .foregroundStyle(AppGlobals.textColor)
                            .frame(width: 330, alignment: .leading)
                            .padding(1)
                        HStack(spacing: 0) {
                            Text("--")
                                .font(.custom("futura", size: 20))
                                .foregroundStyle(AppGlobals.textColor)
                                .frame(width: 25, height: 100, alignment: .topLeading)
                            Text(getTimeAcknowledgement(testStats.getSecondsElapsed()))
                                .font(.custom("futura", size: 17))
                                .foregroundStyle(AppGlobals.textColor)
                                .frame(width: 300, height: 90, alignment: .topLeading)
                        }
                        .padding(-15)
                    }
                }
                .hoverMod(globalTimer.time, 0.5)
                .scaleEffect(isItHere ? 1 : 0)
                .blur(radius: isItHere ? 0 : 10)
                .animation(.timingCurve(0.0, 0.8, 0.2, 1.0, duration: 1.25 * AppGlobals.getAnimSpeed()), value: isItHere)
                ZStack {
                    Rectangle()
                        .stroke(AppGlobals.textColor, lineWidth: 10)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 360, height: showMissedQuestionsTuple().0 ? 490 : 200)
                        .shadow(color: AppGlobals.textColor, radius: 10, x: 0, y: 5)
                    VStack {
                        Text(showMissedQuestionsTuple().1)
                            .font(.custom("futura", size: 28))
                            .underline()
                            .foregroundStyle(AppGlobals.textColor)
                            .frame(maxWidth: 330, maxHeight: 100, alignment: .leading)
                            .padding(showMissedQuestionsTuple().0 ? -35 : -10)
                            .offset(y: showMissedQuestionsTuple().0 ? 0 : -6)
                        if showMissedQuestionsTuple().0 {
                            ZStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        Spacer()
                                        ForEach(wrongBreakdownArray) { w in
                                            incorrectAnswerBreakdown(question: w.getQuestion(), answerSelected: w.getAnswer(), id: w.getId(), col1: AppGlobals.buttonCol1, col2: AppGlobals.textColor, col3: AppGlobals.buttonOutlineColor)
                                        }
                                    }
                                }
                                Rectangle()
                                    .foregroundStyle(LinearGradient(colors: [AppGlobals.buttonCol2, .clear, .clear, .clear, .clear, .clear, .clear, .clear, .clear, AppGlobals.buttonCol2], startPoint: UnitPoint(x: -0.05, y: 0), endPoint: UnitPoint(x: 1.05, y: 0)))
                                    .allowsHitTesting(false)
                                    .frame(height: 300)
                            }
                            .frame(width: 360, height: 360)
                            .padding(-18)
                        }
                        Button {
                            viewPath.removeLast(2)
                        } label: {
                            Text("Ok")
                                .labelMod(125, 80, 0)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .offset(y: showMissedQuestionsTuple().0 ? -8 : -10)
                    }
                }
                .hoverMod(globalTimer.time + AppGlobals.waveOffset, 0.5)
                .scaleEffect(isItHere ? 1 : 0)
                .blur(radius: isItHere ? 0 : 10)
                .animation(.timingCurve(0.0, 0.8, 0.2, 1.0, duration: 1.25 * AppGlobals.getAnimSpeed()), value: isItHere)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .statusBar(hidden: true)
        .onAppear {
            SoundManager.playMP3("whoosh")
            isItHere = true
        }
    }
    
    func showMissedQuestionsTuple() -> (Bool, String) {
        if testStats.answersCorrect == 60 {
            return (false, "You aced it! No notes :D")
        }
        if testStats.getAnswersCorrect() == 0 && wrongBreakdownArray.count == 0 {
            return (false, "You didn't answer any questions lmao")
        }
        if wrongBreakdownArray.count == 0 {
            return (false, "You got every question right that you answered :)")
        }
        return (true, "Here's what you missed:")
    }
    
    func getAcknowledgement(_ fac: Double) -> String {
        if fac == 1 {
            return "------------------ Perfect! ------------------"
        }
        if fac >= 0.9 {
            return "---------------- Impressive! ----------------"
        }
        if fac >= 0.8 {
            return "----------------- Great Job! -----------------"
        }
        if fac >= 0.7 {
            return "------------------ Not bad! ------------------"
        }
        if fac >= 0.6 {
            return "--------- Could use some practice.. ---------"
        }
        return "------------ Needs improvement.. ------------"
    }
    
    func getTimeAcknowledgement(_ seconds: Int) -> String {
        let secondsOnAPTest = 6480
        if seconds < secondsOnAPTest / 4 {
            return "Ok, you definitely skipped like all of the questions, right? If you're looking for shorter practice, tap \"Go To Chapters\" in the unit select menu!"
        }
        if seconds < secondsOnAPTest / 2 {
            return "You might be going too fast. If this were an AP test, you'd still have more than half your time left!"
        }
        if seconds < Int(Double(secondsOnAPTest) / 1.5) {
            return "You're at a great pace. If this were an AP test, you'd have plenty of time to spare"
        }
        if seconds < secondsOnAPTest {
            return "You're at an ideal pace, spending a good amount of time per question with reasonable time to spare. Keep it up!"
        }
        return "You may be spending too much time per question. If this were the AP exam you would've run out of time!"
    }
}

#Preview {
    TestSummaryView(viewPath: .constant(NavigationPath()), testStats: Stats(answersCorrect: 1, answersIncorrect: 0), wrongBreakdownArray: [WrongAnswerBreakdown(question: Question(), answer: 0, id: 0)])
        .environmentObject(GlobalTimer())
}
