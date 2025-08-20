//
//  QuestionsView.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 6/9/25 for MistakeMaster.
//

// jotting this down for later but INSANE UI IDEA:
// when pressed down 3d rotate towards mouse

import SwiftUI

enum AlertContext: Hashable {
    case settings
    case misconception
    case exit
    case questionSelect
    case submitChallenge
    case challengeExplanation
    case liteVersionAlert
}

enum QuizMode: Hashable {
    case unitDiagnostic
    case chapterDiagnostic
    case misconceptionIntentional
    case mathIntentional
}

struct QBackground: View {
    let col1: Color
    let col2: Color
    var body: some View {
        Rectangle()
            .fill(col1)
            .frame(width: UIScreen.main.bounds.width * 1.1, height: UIScreen.main.bounds.height * 1.1)
            .ignoresSafeArea()
        Rectangle()
            .fill(col2)
            .frame(width: 260, height: UIScreen.main.bounds.height * 1.1)
            .ignoresSafeArea()
        Rectangle()
            .fill(col1)
            .mask(ParticleView())
    }
}

struct CustomToolbar: View {
    @Binding var showAlert: Bool
    @Binding var alert: AlertContext
    var time: Double
    var eventTime: Double
    
    var body: some View {
        HStack {
            Button {
                if (!showAlert) && eventTime == -1.0 {
                    showAlert = true
                    alert = AlertContext.exit
                }
            }
            label: {
                Text("Back")
                    .labelMod(100, 50, time - AppGlobals.waveOffset, textPadding: 12)
            }
            .buttonStyle(DefaultButtonStyle())
            .offset(x: -70) // fix later to work for all phones!
            Button {
                if (!showAlert) && eventTime == -1.0 {
                    alert = .settings
                    showAlert = true
                }
            }
            label: {
                Text("Options")
                    .labelMod(100, 50, time - AppGlobals.waveOffset, textPadding: 12)
            }
            .buttonStyle(DefaultButtonStyle())
            .offset(x: 70)
        }
    }
}

struct PopUpWindow: View {
    @EnvironmentObject var store: Store
    
    @Binding var alert: AlertContext
    @Binding var showAlert: Bool
    @Binding var viewPath: NavigationPath
    var time: Double
    var miscHeader: String = ""
    var miscExpl: String = ""
    var answerArray: [Int] = []
    let columns = Array(repeating: GridItem(.flexible()), count: 9)
    @Binding var answerSelection: Int
    var questionsLeft: Int = 0
    var endRoundFunc: () -> Void
    var recordStatsFunc: (Bool) -> Void
    var isOnChallenge: Bool = false
    
    var body: some View {
        ZStack {
            Button {
                showAlert = false
            } label: {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(.clear)
            }
            .opacity(showAlert ? 1 : 0)
            
            VStack {
                switch alert {
                case .settings:
                    Text("---- Options ----")
                        .scaleEffect(2)
                        .padding(10)
                        .offset(y: -10)
                    HStack {
                        Text("Theme:")
                        Button {
                            AppGlobals.setThemeClassic()
                        }
                        label: {
                            Text("Classic")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            AppGlobals.setThemeLight()
                        }
                        label: {
                            Text("Light")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .padding(-5)
                    HStack {
                        Spacer()
                        Button {
                            SoundManager.toggleMuted()
                            UserDefaults.standard.set(AppGlobals.animSpeed, forKey: "animSpeed")
                        } label: {
                            Image(systemName: AppGlobals.isMuted ? "speaker.slash.fill" : "speaker.wave.3.fill")
                                .resizable()
                                .foregroundStyle(AppGlobals.textColor)
                            
                        }
                        .frame(width: 40, height: 30)
                        .buttonStyle(DefaultButtonStyle())
                        Spacer()
                        Button {
                            AppGlobals.setThemeSpace()
                        }
                        label: {
                            Text("Space")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            AppGlobals.setThemeDark()
                        }
                        label: {
                            Text("Dark")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .offset(x: -15)  // fix practices like these in future updates, quick fix for now
                    HStack {
                        Text("Anim. speed:")
                        Button {
                            if AppGlobals.animSpeed == "Normal" {
                                AppGlobals.animSpeed = "Fast"
                            }
                            else if AppGlobals.animSpeed == "Fast" {
                                AppGlobals.animSpeed = "None"
                            }
                            else {
                                AppGlobals.animSpeed = "Normal"
                            }
                            UserDefaults.standard.set(AppGlobals.animSpeed, forKey: "animSpeed")
                        }
                        label: {
                            Text(AppGlobals.animSpeed)
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    HStack {
                        Button {
                            AppGlobals.animSpeed = "Normal"
                            AppGlobals.setThemeClassic()
                        }
                        label: {
                            Text("Reset to defaults")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            showAlert = false
                        }
                        label: {
                            Text("OK")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                case .misconception:
                    Text(miscHeader)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 300, height: 4)
                        .padding(-10)
                    Text(miscExpl)
                        .padding(-4)
                    Button {
                        showAlert = false
                    }
                    label: {
                        Text("OK")
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .fill(AppGlobals.buttonCol2)
                            )
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .padding(10)
                case .exit:
                    Text("Are you sure you want to end practice?")
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 300, height: 4)
                        .padding(-10)
                    Text(isOnChallenge ? "No worries, your current answer selections will be saved if you return to the menu" : "All stats are recorded but your score won't save unless you complete the whole module!")
                        .padding(-4)
                    HStack {
                        Button {
                            showAlert = false
                            recordStatsFunc(false)
                            viewPath.removeLast(1)
                        }
                        label: {
                            Text("Take me back")
                                .padding(5)
                                .frame(width: 205)
                                .background(
                                    RoundedRectangle(cornerRadius: 11)
                                        .fill(AppGlobals.buttonCol2)
                                )
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            showAlert = false
                        }
                        label: {
                            Text("Stay")
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 11)
                                        .fill(AppGlobals.buttonCol2)
                                )
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .padding(10)
                case .questionSelect:
                    Text("-------- Questions: --------")
                        .font(.custom("futura", size: 30))
                    LazyVGrid(columns: columns) {
                        ForEach(0..<60) {i in
                            Button {
                                answerSelection = i + 1
                                showAlert = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 * AppGlobals.getAnimSpeed()) {
                                    alert = AlertContext.settings
                                }
                            }
                            label: {
                                Text("\(i + 1)")
                                    .font(.custom("futura", size: 15))
                                    .foregroundStyle(AppGlobals.textColor)
                                    .frame(width: 25, height: 25)
                                    .background (
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(answerArray[i] == -1 ? AppGlobals.buttonColElim1 : AppGlobals.buttonCol2)
                                    )
                                    .hoverMod(!AppGlobals.buttonWobble ? 0 : (time * 4 + Double(i) * 0.6), answerArray[i] == -1 ? 0.4 : 0)
                                    .padding(-2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                case .submitChallenge:
                    Text("Are you sure you want to submit?")
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 300, height: 4)
                        .padding(-10)
                    Text(questionsLeft == 0 ? "You can still go back and double check your answers" : (questionsLeft == 1 ? "You still have an unanswered question!" : "You still have \(questionsLeft) unanswered Questions!"))
                        .padding(-4)
                    HStack {
                        Button {
                            showAlert = false
                            endRoundFunc()
                        }
                        label: {
                            Text("Yes")
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 11)
                                        .fill(AppGlobals.buttonCol2)
                                )
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            showAlert = false
                        }
                        label: {
                            Text("No")
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 11)
                                        .fill(AppGlobals.buttonCol2)
                                )
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .padding(10)
                case .challengeExplanation:
                    Text("For the unit challenge, swipe horizontally to go through 60 AP-Style questions")
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 300, height: 4)
                        .padding(-10)
                    Text("Review your answers by pressing the number button. At the very end, there is a button to submit your answers and look over your results")
                    Button {
                        showAlert = false
                    }
                    label: {
                        Text("OK")
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .fill(AppGlobals.buttonCol2)
                            )
                    }
                    .buttonStyle(DefaultButtonStyle())
                case .liteVersionAlert:
                    Text("To practice with this unit, you must purchase the full version of MistakeMaster!")
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppGlobals.buttonCol2)
                        .frame(width: 300, height: 4)
                        .padding(-10)
                    Text("You're currently using the free version. You can purchase the full version in the main menu.")
                    Button {
                        showAlert = false
                    }
                    label: {
                        Text("OK")
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .fill(AppGlobals.buttonCol2)
                            )
                    }
                }
                
            }
            .labelMod(350, 350, time)
            .animation(nil, value: alert)
            .shadow(color: .black, radius: 8, x: -3, y: 3)
            .scaleEffect(x: showAlert ? 1 : 0.8, y: showAlert ? 1 : 1.5)
            .blur(radius: showAlert ? 0 : 5)
            .rotation3DEffect(Angle(degrees: showAlert ? 0 : -17), axis: (x: 1, y: 0, z: 0))
            .offset(y: showAlert ? 0 : 800)
        }
    }
}

struct QuestionMarkPattern: View {
    let squareSize: CGFloat = UIScreen.main.bounds.width / 8
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...20, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0...7, id: \.self) { j in
                        Image(systemName: (i + j) % 2 == 0 ? "questionmark.square.fill" : "questionmark")
                            .resizable()
                            .frame(width: squareSize, height: squareSize)
                            .scaleEffect(x: (i + j) % 2 == 0 ? 1 : 0.3, y: (i + j) % 2 == 0 ? 1 : 0.5)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

struct ExplanationBackground: View {
    var time: CGFloat
    let col1: Color
    let loopingFac = 0.5
    
    var body: some View {
        Rectangle()
            .fill(AppGlobals.buttonCol2)
            .ignoresSafeArea()
        ZStack {
            QuestionMarkPattern()
                .ignoresSafeArea()
                .opacity(0.1)
                .blendMode(.colorDodge)
                .offset(x: (time * 40).truncatingRemainder(dividingBy: UIScreen.main.bounds.width * loopingFac))
            QuestionMarkPattern()
                .ignoresSafeArea()
                .opacity(0.1)
                .blendMode(.colorDodge)
                .offset(x: -UIScreen.main.bounds.width + (time * 40).truncatingRemainder(dividingBy: UIScreen.main.bounds.width * loopingFac))
            QuestionMarkPattern()
                .ignoresSafeArea()
                .opacity(0.1)
                .blendMode(.colorDodge)
                .offset(x: UIScreen.main.bounds.width + (time * 40).truncatingRemainder(dividingBy: UIScreen.main.bounds.width * loopingFac))
        }
        .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0.7, z: -0.25))
        .scaleEffect(1.25)
        .offset(y: -200)
        
        Rectangle()
            .foregroundStyle(LinearGradient(colors: [col1, .clear, .clear, .clear, .clear, col1], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
            .opacity(0.5)
    }
}

struct QuestionsView: View {
    @Binding var viewPath: NavigationPath
    
    @State var eventTime = -1.0
    @State var diagQI = 0
    @State var areaQI = 0
    @State var ansi = -1
    @State var wrongSpringTrigger = false
    @State var explanationSlideTrigger = false
    @State var flipWrongAnimation = false
    @State var displayingMisconception = false
    
    @State var answersElimed = Array(repeating: false, count: 4)
    @State var buttonPressed = Array(repeating: false, count: 4)
    @State var showAlert = false
    @State var alert = AlertContext.settings
    @State var isEndingRound = false
    @State var progress: CGFloat = 0
    
    @State var qDiagSet: [Question]
    @State var qAreaSet: [String: [Question]]
    @State var miscSet: [String: Misconception]
    
    @State var question: Question = Question()
    
    @State var errorCode: String = ""
    @State var onMisconceptionBranch = false
    @State var misconceptionCorrectCount = 0
    
    // defining these as separate variables to handle key errors
    @State var misconceptionHeader: String = ""
    @State var misconceptionExplanation: String = ""
    
    var isChallengeMode: Bool = false
    var nullFunc: () -> Void = {}
    
    @Binding var info: InfoList
    var chapterCoords: [Int]
    
    @State var roundStats: Stats = Stats()
    
    var quizMode: QuizMode
    
    @State var randomOrder: [Int] = [0, 1, 2, 3]
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var globalTimer: GlobalTimer
    @State var timeRef: Double = 0.0
    
    var body: some View {
        ZStack {
            ZStack {
                // draws background rectangles and particles with a slight overshoot to prevent glowing white edges when pausing
                QBackground(col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2)
                    .blur(radius: 3)
                VStack {
                    CustomToolbar(showAlert: $showAlert, alert: $alert, time: globalTimer.time, eventTime: eventTime)
                        .offset(y: 95)
                    .padding(-5) // janky implementation FIX LATER
                    Spacer(minLength: 150)
                    Text(question.question) // holy hell please for the love of god FIX LATER!!!
                        .labelMod(350, 250, globalTimer.time)
                    ForEach(0..<4) {i in
                        HStack {
                            // answer buttons
                            Button {
                                if !showAlert {
                                    handleAnswerMain(i)
                                }
                            } label: {
                                Text(question.answers[i])
                                    .labelMod(300, 90, globalTimer.time + (Double(i) * AppGlobals.waveOffset), isElim: answersElimed[i], isWrong: isWrongAnswer(i))
                            }
                            .buttonStyle(DefaultButtonStyle())
                            .animation(.timingCurve(0.05, 0.95, 0.05, 0.95, duration: 0.5 * AppGlobals.getAnimSpeed()), value: answersElimed[i])
                            .offset(x: wrongSpringTrigger && isWrongAnswer(i) && !(AppGlobals.animSpeed == "None") ? 40 : 0)
                            .animation(.interpolatingSpring(mass: 1, stiffness: 1200, damping: 12, initialVelocity: 20), value: wrongSpringTrigger)
                            
                            // answer eliminator buttons
                            Button {
                                if !showAlert {
                                    answersElimed[i].toggle()
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(AppGlobals.isLighterTheme() ? AppGlobals.buttonCol2 : AppGlobals.buttonCol1)
                                    .hoverMod(globalTimer.time + (Double(i) * AppGlobals.waveOffset), 1)
                                    .padding(5)
                            }
                            .buttonStyle(DefaultButtonStyle())
                            .scaleEffect(eventTime >= 0 ? 0 : 1)
                            .animation(.timingCurve(0.05, 0.95, 0.05, 0.95, duration: 0.4 * AppGlobals.getAnimSpeed()), value: eventTime)
                        }
                    }
                    Spacer()
                    ZStack {
                        ProgressBar(progressFac: CGFloat(misconceptionCorrectCount) / 2.0, col1: AppGlobals.buttonCol1, col2: AppGlobals.buttonCol2, col3: AppGlobals.isLighterTheme() ? AppGlobals.textColor : AppGlobals.buttonCol2, col4: AppGlobals.isLighterTheme() ? AppGlobals.buttonCol2 : AppGlobals.buttonOutlineColor, lineOverlay: false, outlineWidth: onMisconceptionBranch ? 6 : 7)
                            .animation(.timingCurve(0.1, 0.0, 0.1, 1.0, duration: 1.5 * AppGlobals.getAnimSpeed()), value: misconceptionCorrectCount)
                            .offset(y: onMisconceptionBranch ? -10 : 0)
                        ProgressBar(progressFac: progress, col1: AppGlobals.buttonCol1, col2: AppGlobals.buttonCol2, col3: AppGlobals.isLighterTheme() ? AppGlobals.textColor : AppGlobals.buttonCol2, col4: AppGlobals.isLighterTheme() ? AppGlobals.buttonCol2 : AppGlobals.buttonOutlineColor, outlineWidth: onMisconceptionBranch ? 6 : 7)
                            .animation(.timingCurve(0.1, 0.0, 0.1, 1.0, duration: 1.5 * AppGlobals.getAnimSpeed()), value: progress)
                            .offset(y: onMisconceptionBranch ? 5 : 0)
                    }
                    .offset(y: UIScreen.main.bounds.height * -0.109)
                    .animation(.timingCurve(0.4, 0.0, 0.5, 1.0, duration: 1 * AppGlobals.getAnimSpeed()), value: onMisconceptionBranch)
                }
                
//                // counter overlay for Area branch
//                Text("\(misconceptionCorrectCount)/2")
//                    .offset(y: UIScreen.main.bounds.height * 0.46)
//                    .font(.custom("futura", size: 20))
//                    .foregroundStyle(AppGlobals.textColor)
//                    .opacity(onMisconceptionBranch ? 1 : 0)
            }
            .alertOverlayMod(showAlert)
            .animation(flipWrongAnimation ? .easeOut(duration: 0.0) : .easeOut(duration: 1.0 * AppGlobals.getAnimSpeed()), value: explanationSlideTrigger)
            
            // explanation overlay
            
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
                .opacity(explanationSlideTrigger ? 1 : 0)
                .animation(flipWrongAnimation ? .easeOut(duration: 0.0) : .easeOut(duration: 1.0 * AppGlobals.getAnimSpeed()), value: explanationSlideTrigger)
            
            ZStack {
                ExplanationBackground(time: globalTimer.time, col1: AppGlobals.textColor)
                RoundedRectangle(cornerRadius: 170)
                    .frame(width: 550, height: 600)
                    .foregroundStyle(AppGlobals.buttonCol2)
                    .blur(radius: explanationSlideTrigger ? 100 : 0)
                    .scaleEffect(explanationSlideTrigger ? 1 : 0)
            }
            .mask (
                Circle()
                    .frame(width: explanationSlideTrigger ? UIScreen.main.bounds.width * 2.5 : 0, height: explanationSlideTrigger ? UIScreen.main.bounds.height * 2.5 : 0)
            )
            .background (
                Circle()
                    .foregroundStyle(AppGlobals.textColor)
                    .frame(width: explanationSlideTrigger ? UIScreen.main.bounds.width * 2.5 + 40 : 0, height: explanationSlideTrigger ? UIScreen.main.bounds.height * 2.5 + 40 : 0)
            )
            .animation(flipWrongAnimation ? .timingCurve(0.6, 0.0, 1.0, 0.4, duration: 0) : .timingCurve(0.2, 0.7, 0.2, 1.0, duration: 1 * AppGlobals.getAnimSpeed()), value: explanationSlideTrigger)
            .allowsHitTesting(false)
            
            VStack {
                if !displayingMisconception {
                    (Text("The correct answer was: ") + Text("\(question.answers[question.correctAnswer])").bold())
                        .foregroundStyle(AppGlobals.textColor)
                        .font(.custom("futura", size: 38))
                        .padding(-5)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: 340, maxHeight: 200, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                    Separator(col1: AppGlobals.textColor, width: 350)
                    Text(question.explanation)
                        .foregroundStyle(AppGlobals.textColor)
                        .font(.custom("futura", size: 22))
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: 340, maxHeight: 150, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                else {
                    (Text("You might be assuming that ") + Text(misconceptionHeader).bold())
                        .foregroundStyle(AppGlobals.textColor)
                        .font(.custom("futura", size: 38))
                        .padding(-5)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: 340, maxHeight: 200, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                    Separator(col1: AppGlobals.textColor, width: 350)
                    Text("Under this misconception, a student " + misconceptionExplanation)
                        .foregroundStyle(AppGlobals.textColor)
                        .font(.custom("futura", size: 22))
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: 340, maxHeight: 150, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text("(tap anywhere to continue)")
                    .foregroundStyle(AppGlobals.textColor)
                    .font(.custom("futura", size: 18))
                    .kerning(3)
            }
            .background (
                Rectangle()
                    .stroke(AppGlobals.textColor, lineWidth: 10)
                    .fill(AppGlobals.buttonCol2)
                    .frame(width: 360)
                    .padding(-15)
                    .shadow(color: AppGlobals.textColor, radius: 10, x: 0, y: 5)
            )
            .scaleEffect(x: 1, y: displayingMisconception ? -1 : 1)
            .animation(nil, value: displayingMisconception)
            .rotation3DEffect(Angle(degrees: displayingMisconception ? -180.0 : 0), axis: (x: 1, y: 0, z: 0))
            .scaleEffect(explanationSlideTrigger ? 1 : 0)
            .blur(radius: explanationSlideTrigger ? 0 : 5)
            .animation(flipWrongAnimation ? .timingCurve(0.7, 0.2, 1.0, 0.3, duration: 0.0) : .timingCurve(0.0, 0.8, 0.2, 1.0, duration: 1.25 * AppGlobals.getAnimSpeed()), value: explanationSlideTrigger)
            .animation(AppGlobals.animSpeed == "None" ? nil : .interpolatingSpring(mass : 1, stiffness: 200, damping: 15, initialVelocity: 3), value: displayingMisconception)
            
            // explanation button overlay
            Button {
                if explanationSlideTrigger {
                    if !onIntentionalPath() && !onMisconceptionBranch && !displayingMisconception {
                        SoundManager.playMP3("whoosh")
                        displayingMisconception = true
//                        alert = .misconception
//                        showAlert = true
                    }
                    else {
                        displayingMisconception = false
                        explanationSlideTrigger = false
                        flipWrongAnimation = true
                        checkForRoundEnd()
                        resetQuestion()
                    }
                }
            } label: {
                Rectangle()
                    .opacity(0.0001)
                    .ignoresSafeArea()
            }
            .allowsHitTesting(true)
            .buttonStyle(InactiveButtonStyle())
            .opacity(explanationSlideTrigger ? 1 : 0)
//                .animation(.easeOut(duration: AppGlobals.isFastAnim ? 0.15 : 0.3), value: explanationSlideTrigger)
            
            // alert
            PopUpWindow(alert: $alert, showAlert: $showAlert, viewPath: $viewPath, time: globalTimer.time, miscHeader: misconceptionHeader, miscExpl: misconceptionExplanation, answerSelection: .constant(0), endRoundFunc: nullFunc, recordStatsFunc: recordStats
            )
        }
        .onAppear {
            timeRef = globalTimer.time
            qDiagSet.shuffle()
            for key in qAreaSet.keys {
                qAreaSet[key]?.shuffle()
            }
            question = updateQuestion(qDiagSet, diagQI)
        }
        .animation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.7 * AppGlobals.getAnimSpeed()), value: showAlert)
        .onReceive(globalTimer.timer) {_ in
            if !isEndingRound {
                eventTime = eventTime >= 0 ? eventTime + 1.0 / AppGlobals.fps : -1
            }
            if eventTime >= 0 {
                wrongSpringTrigger = false
            }
            if eventTime >= 1.15 {
                if ansi != question.correctAnswer {
                    if !explanationSlideTrigger {
                        SoundManager.playMP3("whoosh")
                    }
                    explanationSlideTrigger = true
                    flipWrongAnimation = false
                }
                else {
                    checkForRoundEnd()
                    resetQuestion()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .statusBar(hidden: true)
    }
    
    func handleAnswerMain(_ i: Int) {
        if eventTime == -1.0 && !answersElimed[i] {
            eventTime = 0
            ansi = i
            answersElimed = Array(repeating: true, count: 4)
            answersElimed[question.correctAnswer] = false
            answersElimed[ansi] = false
            wrongSpringTrigger = true
            if onMisconceptionBranch {
                if isRightAnswer(i) {
                    misconceptionCorrectCount += 1
                }
                else {
                    misconceptionCorrectCount = 0
                    info.tallyMisconception(code: errorCode, unitIndex: chapterCoords[0], chapterIndex: chapterCoords[1])
                }
            }
            else {
                if isRightAnswer(i) {
                    updateProgressMeter()
                }
                else {
                    // remove unnecessary stuff for intentional path +path updating properly pls
                    if !onIntentionalPath()  {
                        errorCode = question.codes[i]
                        updateHeaders(key: errorCode)
                        // if they land on the same misconception twice in a run, this ensures it stays fresh
                        qAreaSet[errorCode]?.shuffle()
                    }
                    
                    // tallies misconceptions
                    if quizMode == QuizMode.chapterDiagnostic && !onIntentionalPath() {
                        info.tallyMisconception(code: errorCode, unitIndex: chapterCoords[0], chapterIndex: chapterCoords[1])
                    }
                    else if quizMode == QuizMode.unitDiagnostic && !onIntentionalPath() {
                        // fix later
                        for i in info.getChArray()[chapterCoords[0]].indices {
                            info.tallyMisconception(code: errorCode, unitIndex: chapterCoords[0], chapterIndex: i)
                        }
                    }
                }
            }
            
            // tally answer for stats and plays sound
            if isRightAnswer(i) {
                roundStats.tallyCorrectAnswer()
                SoundManager.playMP3("right")
            }
            else {
                roundStats.tallyIncorrectAnswer()
                SoundManager.playMP3("wrong2")
            }
        }
    }
    
    func isRightAnswer(_ i: Int) -> Bool {
        return (ansi == question.correctAnswer && ansi == i)
    }
    
    func isWrongAnswer(_ i: Int) -> Bool {
        return (ansi != question.correctAnswer && ansi == i)
    }
    
    func resetQuestion() {
        shuffleOrder()
        if isEndingRound {
            return
        }
        if !onIntentionalPath() {
            if isWrongAnswer(ansi) {
                if !onMisconceptionBranch {
                    onMisconceptionBranch = true
                    areaQI = -1
                }
            }
            else {
                if misconceptionCorrectCount == 2 {
                    updateProgressMeter()
                    onMisconceptionBranch = false
                    misconceptionCorrectCount = 0
                }
            }
        }
        else {
            updateProgressMeter()
        }
        areaQI += onMisconceptionBranch ? 1 : 0
        diagQI += onMisconceptionBranch ? 0 : 1
        
        // if user runs out of area questions, just loop it (only reshuffle if they land on it off of another diagnostic question)
        if onMisconceptionBranch && areaQI == qAreaSet[errorCode]?.count {
            areaQI = 0
        }
        
        eventTime = -1.0
        answersElimed = Array(repeating: false, count: 4)
        ansi = -1
        question = onMisconceptionBranch ? updateQuestion(qAreaSet[errorCode]!, areaQI) : updateQuestion(qDiagSet, diagQI)
    }
    
    
    func checkForRoundEnd() {
        if (onIntentionalPath() && diagQI == qDiagSet.count - 1) ||
            (!onIntentionalPath() && diagQI == qDiagSet.count - 1 &&
             ((onMisconceptionBranch && isRightAnswer(ansi) && misconceptionCorrectCount == 2) ||
             (!onMisconceptionBranch && isRightAnswer(ansi)))) {
            endRound()
        }
    }
    
    func endRound() {
        isEndingRound = true
        eventTime = 0
        recordStats(includingHighscore: true)
        viewPath.append(Route.summary(roundStats: roundStats, coords: chapterCoords, mode: quizMode))
    }
    
    func shuffleOrder() {
        randomOrder.shuffle()
    }
    
    func recordStats(includingHighscore: Bool = false) {
        let u = quizMode == QuizMode.misconceptionIntentional ? 0 : chapterCoords[0]
        let c = quizMode == QuizMode.misconceptionIntentional ? 0 : chapterCoords[1]
        roundStats.setSecondsElapsed(Int(globalTimer.time - timeRef))

        switch quizMode {
        case .chapterDiagnostic, .mathIntentional:
            if includingHighscore {
                info.chapterInfoArray[u][c].updateHighestScore(roundStats.getScoreFac())
            }
            info.chapterInfoArray[u][c].addTotalTime(roundStats.getSecondsElapsed())
            info.unitInfoArray[u].addTotalTime(roundStats.getSecondsElapsed())
        case .unitDiagnostic:
            if includingHighscore {
                info.unitInfoArray[u].updateHighestScoreDiagnostic(roundStats.getScoreFac())
            }
            info.unitInfoArray[u].addTotalTime(roundStats.getSecondsElapsed())
        case .misconceptionIntentional:
            break
        }
    }
    
    func updateHeaders(key: String) {
        
        if errorCode != "" {
            misconceptionHeader = miscSet[key]!.misconception.lowercased()
            misconceptionExplanation = miscSet[key]!.explanation.lowercased()
        }
        else {
            misconceptionHeader = "No error code attached to this answer"
        }
    }
    
    func updateQuestion(_ array: [Question], _ index: Int) -> Question {
        return array[index]
    }
    
    func updateProgressMeter() {
        progress = CGFloat((diagQI + 1)) / CGFloat(qDiagSet.count)
    }
    
    func onIntentionalPath() -> Bool {
        return quizMode == .mathIntentional || quizMode == .misconceptionIntentional || AppGlobals.overrideDiagnostic
    }
    
}

#Preview {
    QuestionsView(viewPath: .constant(NavigationPath()),
                  qDiagSet: unpackQuestions(
                        fileName: "Topic_1.1_Diagnostic",
                        subdirectory: "Subjects/AP Physics/Unit 1 Kinematics/1.1 1D Scalars and Vectors/DP"),
                  qAreaSet: makeAreasDict(fileNameList: loadFolderContents("Subjects/AP Physics/Unit 1 Kinematics/1.1 1D Scalars and Vectors/IP", onlyFolders: false).dropLast(), path: "Subjects/AP Physics/Unit 1 Kinematics/1.1 1D Scalars and Vectors/IP"),
                  miscSet: makeMisconceptionsDict(path: "Subjects/AP Physics/Unit 1 Kinematics/1.1 1D Scalars and Vectors/IP"),
                  info: .constant(InfoList()), chapterCoords: [1, 0],
                  quizMode: QuizMode.chapterDiagnostic)
    .environmentObject(GlobalTimer())
}
