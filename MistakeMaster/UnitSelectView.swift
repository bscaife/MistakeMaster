//
//  UnitSelectView.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 6/12/25 for MistakeMaster.
//

import SwiftUI
import Foundation

struct unitSelectLabelModifier: ViewModifier {
    let w: CGFloat
    let h: CGFloat
    let subtext: String
    let col1: Color
    let col2: Color
    let col3: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("futura", size: 25))
            .foregroundStyle(col3)
            .minimumScaleFactor(0.5)
            .padding(10)
            .frame(width: w, height: h, alignment: .topLeading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(col1)
                        .stroke(col2, lineWidth: 8)
                    Text(subtext)
                        .font(.custom("futura", size: 45))
                        .foregroundStyle(col2)
                        .frame(width: w, height: h, alignment: .bottomTrailing)
                        .offset(y: 9)
                        .bold()
//                    Text(String(format: "%d:%02d", time / 60, time % 60))
//                        .font(.custom("futura", size: 45))
//                        .foregroundStyle(AppGlobals.buttonCol2)
//                        .offset(x: -95, y: 40)
                }
            )
    }
}

struct SelectedIndicator: View {
    let col1: Color
    let time: Double
    let w: CGFloat
    let h: CGFloat
    let spaceFac: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(col1, lineWidth: 8)
            .frame(width: max((w + (w + h) * spaceFac) + sin(time * 4) * 3, 0), height: max((h + (w + h) * spaceFac) + sin(time * 4 + 1.5) * 3, 0))
            .padding(0)
        //            .scaleEffect(1.1 + sin(time * 0.5) * 0.05)
    }
}

struct Separator: View {
    var col1: Color
    var width: CGFloat = 335
    var height: CGFloat = 4
    var body: some View {
        RoundedRectangle(cornerRadius: height)
            .frame(width: width, height: height)
            .foregroundStyle(col1)
    }
}

extension View {
    func unitSelectLabelMod(width: CGFloat, height: CGFloat, subtext: String = "0%", time: Int = 0, col1: Color, col2: Color, col3: Color, includePercentage: Bool = true) -> some View {
        self.modifier(unitSelectLabelModifier(w: width, h: height, subtext: subtext, col1: col1, col2: col2, col3: col3))
    }
}

struct myAwesomeSuperCoolWheel: View {
    var elements: [String]
    let subtextArray: [String]
    
    @Binding var selection: Int
    let scrollWidth: CGFloat = 400.0 // sticking to this ig
    let scrollHeight: CGFloat
    
    let labelSpacing: CGFloat = 22.0
    let labelWidth: CGFloat = 340.0
    let labelHeight: CGFloat = 120.0
    let time: Double
    
    let col1: Color
    let col2: Color
    let col3: Color
    let col4: Color
    let col5: Color
    
    let centerTapFunc: () -> Void
    
    var body: some View {
        ZStack {
            LazyVStack(spacing: labelSpacing) {
                ForEach(elements.indices, id: \.self) {i in
                    Text(elements[i])
                        .unitSelectLabelMod(width: labelWidth, height: labelHeight, subtext: subtextArray[i], col1: col4, col2: col5, col3: col3)
                        .overlay {
                            Group {
                                if i == selection {
                                    SelectedIndicator(col1: AppGlobals.textColor, time: time, w: labelWidth, h: labelHeight, spaceFac: 0.03)
                                }
                            }
                            .animation(nil, value: selection)
                        }
                        .rotation3DEffect(Angle(degrees: pow(Double((-selection + i)), 2) * 11 * ((i < selection) ? 1 : -1)), axis: (x: 1, y: 0, z: 0))
                        .blur(radius: CGFloat(abs(-selection + i) * 3))
                        .scaleEffect(1 - pow(CGFloat(-selection + i), 2) * 0.04)
                        .offset(y: pow(Double((-selection + i)), 2) * 8 * ((i < selection) ? 1 : -1))
                    //                                .scaleEffect(1 + CGFloat(-selection - i)) accidental but REALLY COOL
                }
            }
            .offset(y: (CGFloat(-selection) + CGFloat(elements.count) / 2.0 - 0.5) * (labelHeight + labelSpacing))
            LazyVStack(spacing: 0) {
                Button {
                    selection = (selection > 0) ? selection - 1 : 0
                } label: {
                    Rectangle()
                        .frame(width: scrollWidth, height: scrollHeight / 3, alignment: .bottom)
                        .foregroundStyle(.clear)
                }
                Button {
                    centerTapFunc()
                } label: {
                    Rectangle()
                        .frame(width: scrollWidth, height: scrollHeight / 3, alignment: .bottom)
                        .foregroundStyle(.clear)
                }
                Button {
                    selection = selection < elements.count - 1 ? selection + 1 : elements.count - 1
                } label: {
                    Rectangle()
                        .frame(width: scrollWidth, height: scrollHeight / 3, alignment: .bottom)
                        .foregroundStyle(.clear)
                }
            }
        }
        .frame(width: scrollWidth, height: scrollHeight)
        .clipped()
        .animation(.timingCurve(0.2, 0, -0.3, 1, duration: 1 * AppGlobals.getAnimSpeed()), value: selection)
        .background(col2)
        .overlay {
            Rectangle()
                .frame(maxWidth: scrollWidth, maxHeight: scrollHeight)
                .foregroundStyle(LinearGradient(colors: [col1, .clear, .clear, .clear, .clear, col1], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                .allowsHitTesting(false)
            
        }
    }
}

struct UnitSelectBackground: View {
    let col1: Color
    let col2: Color
    var body: some View {
        Rectangle()
            .foregroundStyle(col1)
            .frame(width: UIScreen.main.bounds.width * 1.1, height: UIScreen.main.bounds.height * 1.1)
            .ignoresSafeArea()
        VStack {
            Rectangle()
                .frame(height: 175)
                .foregroundStyle(LinearGradient(colors: [col2, col1], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
            Spacer()
            Rectangle()
                .frame(height: 250)
                .foregroundStyle(LinearGradient(colors: [col1, col2], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
        }
    }
}

struct UnitSelectView: View {
    @Binding var viewPath: NavigationPath
    
    @State var unitSelection: Int = 1
    @State var chapterSelection: Int = 1
    @State var miscSelection: Int = 1
    
    // !!!!! change this to switch between the lite and full version!
    
    
    @State var showAlert = false
    
    @Binding var info: InfoList
    
    var filename = ""
    var subdir = ""
    @EnvironmentObject var globalTimer: GlobalTimer
    @State var layer: Int = 0
    
    var nullFunc: () -> Void = {}
    
    // I don't plan on using a similar thing for any other section and for this reason as well as time constraints I'm hardcoding all tutorial stuff instead of OOPing it
    @State var onTutorial = false
    @State var tutorialSlide = 0
    @State var extraVarForSizeScaling = 0
    let tutorialBGPositions = [CGPoint(x: 0, y: -55), CGPoint(x: 130, y: -18), CGPoint(x: -125, y: 195), CGPoint(x: 60, y: 195), CGPoint(x: 100, y: 340), CGPoint(x: -78, y: 310), CGPoint(x: -78, y: 360), CGPoint(x: 0, y: -55), CGPoint(x: 130, y: -18), CGPoint(x: 100, y: 340), CGPoint(x: -78, y: 310), CGPoint(x: 0, y: -55), CGPoint(x: 130, y: -18), CGPoint(x: 100, y: 340), CGPoint(x: 0, y: -55)]
    let tutorialBGScales = [0.85, 0.25, 0.35, 0.65, 0.43, 0.40, 0.40, 0.85, 0.25, 0.43, 0.40, 0.85, 0.25, 0.43, 4]
    let tutorialPositions = [CGPoint(x: 0, y: -250), CGPoint(x: -61, y: -20), CGPoint(x: 61, y: 195), CGPoint(x: 57, y: 60), CGPoint(x: 95, y: 200), CGPoint(x: -75, y: 200), CGPoint(x: -75, y: 255), CGPoint(x: 0, y: -250), CGPoint(x: -61, y: -20), CGPoint(x: 95, y: 200), CGPoint(x: -75, y: 200), CGPoint(x: 0, y: -250), CGPoint(x: -61, y: -20), CGPoint(x: 95, y: 200), CGPoint(x: 0, y: -250)]
    let tutorialScales = [CGSize(width: 350, height: 100), CGSize(width: 240, height: 80), CGSize(width: 240, height: 80), CGSize(width: 260, height: 85), CGSize(width: 180, height: 115), CGSize(width: 200, height: 110), CGSize(width: 200, height: 110), CGSize(width: 350, height: 100), CGSize(width: 240, height: 80), CGSize(width: 180, height: 115), CGSize(width: 200, height: 110), CGSize(width: 350, height: 100), CGSize(width: 240, height: 80), CGSize(width: 180, height: 115), CGSize(width: 350, height: 100)]
    
    let tutorialText = ["This is the unit selector. To scroll between units, tap the top and bottom sides.", "The average of your highest scores for each chapter dispays here.", "The total time you've spent on all content related to this unit is displayed here.", "Your most common misconceptions are listed here in this scrollable menu.", "To look through the sections of each unit, click \"go to Sections.\"", "...or you can practice the whole unit with an adaptive study set.", "An AP-style, 60-Question test is also available for each unit.", "After tapping \"Go to Sections,\" each section in the unit is now displayed.", "...alongside each unit\'s highest score.", "Tap \"Go!\" to begin adaptive practice with questions from the selected section.", "You can practice problems associated with a particular misconception in the section here.", "The selector now displays misconceptions from the unit.", "as well as a count of how many times you\'ve run into each misconception.", "and then the \"Go!\" button begins practice with non-adaptive questions addressing that misconception.", "That's all! Now go on and master your mistakes!"]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ZStack {
                UnitSelectBackground(col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2)
                VStack {
                    Group {
                        HStack {
                            Button {
                                dismiss()
                            }
                            label: {
                                Text("Back")
                                    .labelMod(100, 50, globalTimer.time - AppGlobals.waveOffset, textPadding: 12)
                            }
                            .buttonStyle(DefaultButtonStyle())
                            .offset(x: -52)
                            Button {
                                onTutorial = true
                                layer = 0
                            }
                            label: {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(AppGlobals.textColor)
                                    .hoverMod(globalTimer.time - AppGlobals.waveOffset * 0.8, 1)
                                
                            }
                            .offset(x: 52, y: 10)
                            .buttonStyle(DefaultButtonStyle())
                            Button {
                                showAlert = true
                            }
                            label: {
                                Text("Options")
                                    .labelMod(100, 50, globalTimer.time - AppGlobals.waveOffset * 0.7, textPadding: 12)
                            }
                            .offset(x: 52)
                            .buttonStyle(DefaultButtonStyle())
                        }
                        Text("Select a \(layer == 0 ? "Unit" : (layer == 1 ? "Section" : "Misconception"))")
                            .labelMod(350, 80, globalTimer.time, amp: 0.5)
//                            .frame(width: 325, height: 80)
//                            .font(.custom("futura", size: 80))
//                            .bold()
//                            .minimumScaleFactor(0.3)
                    }
                    .offset(y: -20)
                    Separator(col1: AppGlobals.buttonCol2)
                    ZStack {
                        ZStack {
                            if layer < 2 {
                                myAwesomeSuperCoolWheel(elements: info.getUnitArray().map {$0.adjustedName}, subtextArray: info.getCompletionArrayOfUnits(), selection: $unitSelection, scrollHeight: 360.0, time: globalTimer.time, col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2, col3: AppGlobals.textColor, col4: AppGlobals.buttonCol1, col5: AppGlobals.buttonCol2, centerTapFunc:                             handleGoButton)
                            }
                            myAwesomeSuperCoolWheel(elements: info.getChArray()[unitSelection].map { $0.adjustedName }, subtextArray: info.getChArray()[unitSelection].map {"\(Int($0.highestScore * 100 + 0.5))%"}, selection: $chapterSelection, scrollHeight: 360.0, time: globalTimer.time, col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2, col3: AppGlobals.textColor, col4: AppGlobals.buttonCol1, col5: AppGlobals.buttonCol2, centerTapFunc: handleGoButton)
                                .offset(x: UIScreen.main.bounds.width)
                            if layer > 0 && unitSelection != 0 {
                                myAwesomeSuperCoolWheel(elements: info.getChArray()[unitSelection][chapterSelection].getMisconceptionArray().map {"\"" + $0.misconception + "\"" }, subtextArray: info.getChArray()[unitSelection][chapterSelection].getMisconceptionArray().map {String($0.freq) + "x"}, selection: $miscSelection, scrollHeight: 360.0, time: globalTimer.time, col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2, col3: AppGlobals.textColor, col4: AppGlobals.buttonCol1, col5: AppGlobals.buttonCol2, centerTapFunc: handleGoButton)
                                    .offset(x: UIScreen.main.bounds.width * 2)
                            }
                        }
                        .offset(x: -UIScreen.main.bounds.width * CGFloat(layer))
                        .animation(.timingCurve(0.2, 0, -0.3, 1, duration: 0.7 * AppGlobals.getAnimSpeed()), value: layer)
                        Button {
                            if layer > 0 {
                                layer -= 1
                            }
                        }
                        label: {
                            ZStack {
                                Image(systemName: "triangleshape.fill")
                                    .resizable()
                                    .foregroundStyle(AppGlobals.textColor)
                                    .rotationEffect(Angle(degrees: -90))
                                Image(systemName: "triangleshape.fill")
                                    .resizable()
                                    .foregroundStyle(AppGlobals.buttonCol2)
                                    .rotationEffect(Angle(degrees: -90))
                                    .scaleEffect(0.6)
                                    .offset(x: 1)
                            }
                        }
                        .hoverMod(globalTimer.time, 0.5)
                        .frame(width: 50, height: 30)
                        .buttonStyle(DefaultButtonStyle())
                        .offset(x: -185)
                        .scaleEffect(layer > 0 ? 1 : 0)
                        .animation(.timingCurve(0.2, 0, -0.3, 1, duration: 0.7 * AppGlobals.getAnimSpeed()), value: layer)
                    }
                    Separator(col1: AppGlobals.buttonCol2)
                    HStack {
                        VStack {
                            Text("Total Time:")
                                .font(.custom("futura", size: 18))
                                .foregroundStyle(AppGlobals.textColor)
                                .minimumScaleFactor(0.5)
                                .frame(width: 100, height: 55)
                                .padding(-30)
                            Text("\(layer == 0 ? info.getUnitArray()[unitSelection].getTimeFormatted() : (layer == 1 ? info.getChArray()[unitSelection][chapterSelection].getTimeFormatted() : "--:-- --"))")
                                .font(.custom("futura", size: 40))
                                .foregroundStyle(AppGlobals.textColor)
                                .minimumScaleFactor(0.5)
                                .frame(width: 100, height: 55)
                        }
                        RoundedRectangle(cornerRadius: 15)
                            .fill(AppGlobals.buttonCol1)
                            .stroke(AppGlobals.buttonCol2, lineWidth: 8)
                            .frame(width: 240, height: 120)
                            .overlay {
                                VStack(spacing: -10) {
                                    Text("Your Misconceptions:")
                                        .font(.custom("futura", size: 20))
                                        .foregroundStyle(AppGlobals.textColor)
                                        .frame(height: 40)
                                        .underline()
                                    ScrollView(showsIndicators: false) {
                                        LazyVStack(spacing: 3) {
                                            ForEach(info.getMostCommonMisconceptions(unit: unitSelection, chapter: layer > 0 ? chapterSelection : -1), id: \.self) {i in
                                                HStack(spacing: 8) {
                                                    Circle()
                                                        .foregroundStyle(AppGlobals.textColor)
                                                        .frame(maxWidth: 7, maxHeight: 80, alignment: .topLeading)
                                                        .offset(y: 11)
                                                    Text("\"\(i)\"")
                                                        .font(.custom("futura", size: 18))
                                                        .foregroundStyle(AppGlobals.textColor)
                                                        .frame(maxWidth: 200, maxHeight: 80, alignment: .topLeading)
                                                        .minimumScaleFactor(0.5)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .padding(1)
                                                }
                                                .frame(maxWidth: 215, maxHeight: 80, alignment: .topLeading)
                                            }
                                        }
                                        .padding(5)
                                    }
                                    .frame(height: 86)
                                    Spacer()
                                }
                            }
                    }
                    Separator(col1: AppGlobals.buttonCol2)
                    
                    // to whoever has to work with this in the future, im sorry on behalf of some of the code. I couldn't get the dumbass default opacity effect to disappear without using a double ternary operator.
                    
                    HStack(spacing: 5) {
                        VStack {
                            Button {
                                if (AppGlobals.isFullVersion || unitSelection <= 2) {
                                    if !(unitSelection == 0) {
                                        switch layer {
                                        case 0:
                                            QuestionLoader.goToUnitDiagnostic(i: info, unit: unitSelection, chapter: chapterSelection, viewPath: $viewPath)
                                        case 1:
                                            layer = 2
                                        default:
                                            break
                                        }
                                    }
                                }
                            } label: {
                                // see comment at the top of the HStack addressing this abomination
                                (Text(unitSelection == 0 ? "(Not available)" : (layer == 0 ? "Diagnostic Quiz" :
                                        (layer == 1 ? "Your Misconceptions" :
                                            "- - - -"))) +
                                 Text((layer == 0 && unitSelection != 0) ? " (\(Int(info.getUnitArray()[unitSelection].getHighestScoreDiagnostic() * 100))%)" : "").bold())
                                    .animation(nil, value: layer)
                                    .labelMod(195, 50, globalTimer.time + AppGlobals.waveOffset * 1.5, isElim: !AppGlobals.isFullVersion && unitSelection > 2, textPadding: 12, amp: 0.5)
                            }
                            .buttonStyle(DefaultButtonStyle())
                            Button {
                                if (AppGlobals.isFullVersion || unitSelection <= 2) {
                                    switch layer {
                                    case 0:
                                        if !(unitSelection == 0) {
                                            QuestionLoader.goToTest(i: info, unit: unitSelection, chapter: chapterSelection, viewPath: $viewPath)
                                        }
                                    case 1:
                                        layer = 0
                                    default:
                                        layer = 1
                                    }
                                }
                            } label: {
                                // see comment at top of HStack addressing this abomination too
                                (Text((unitSelection == 0 && layer == 0) ? "(Not available)" : (layer == 0 ? "Challenge Test" :
                                        (layer == 1 ? "Return to Units" :
                                            "Return to Sections"))) +
                                 Text((layer == 0 && unitSelection != 0) ? " (\(Int(info.getUnitArray()[unitSelection].getHighestScoreTest() * 100))%)" : "").bold())
                                    .animation(nil, value: layer)
                                    .labelMod(195, 50, globalTimer.time + AppGlobals.waveOffset * 2.5, isElim: !AppGlobals.isFullVersion && unitSelection > 2, textPadding: 12, amp: 0.5)
                            }
                            .buttonStyle(DefaultButtonStyle())
                        }
                        Button {
                            handleGoButton()
                        } label: {
                            Text(layer == 0 ? "Go to Sections" : "Go!")
                                .animation(nil, value: layer)
                                .bold(layer != 0)
                                .labelMod(150, 110, globalTimer.time + AppGlobals.waveOffset * 1.8, isElim: !AppGlobals.isFullVersion && unitSelection > 2, amp: 0.5)
                        }
                        .buttonStyle(DefaultButtonStyle())
//  MORE OLD BUTTON CODE
//                        if layer == 0 {
//                            Button {
//                                layer = 1
//                            } label: {
//                                Text("Go to sections")
//                                    .labelMod(140, 110, globalTimer.time + AppGlobals.waveOffset)
//                            }
//                            .buttonStyle(DefaultButtonStyle())
//                            VStack {
//                                Button {
//                                    goToUnitDiagnostic()
//                                } label: {
//                                    Text("Diagnostic (\(Int(info.getUnitArray()[unitSelection].getHighestScoreDiagnostic() * 100))%)")
//                                        .labelMod(185, 50, globalTimer.time + AppGlobals.waveOffset * 2, textPadding: 12)
//                                }
//                                .buttonStyle(DefaultButtonStyle())
//                                Button {
//                                    goToTest()
//                                } label: {
//                                    Text("Challenge (\(Int(info.getUnitArray()[unitSelection].getHighestScoreTest() * 100))%)")
//                                        .labelMod(185, 50, globalTimer.time + AppGlobals.waveOffset * 3, textPadding: 12)
//                                }
//                                .buttonStyle(DefaultButtonStyle())
//                            }
//                        }
//                        else if layer == 1 {
//                            Button {
//                                goToChapterQuestions()
//                            } label: {
//                                Text("Go!")
//                                    .labelMod(140, 110, globalTimer.time + AppGlobals.waveOffset)
//                                    .bold()
//                            }
//                            .buttonStyle(DefaultButtonStyle())
//                            VStack {
//                                Button {
//                                    layer = 0
//                                } label: {
//                                    Text("Return to Units")
//                                        .labelMod(185, 50, globalTimer.time + AppGlobals.waveOffset * 2, textPadding: 12)
//                                }
//                                .buttonStyle(DefaultButtonStyle())
//                                Button {
//                                    layer = 2
//                                } label: {
//                                    Text("Misconceptions")
//                                        .labelMod(185, 50, globalTimer.time + AppGlobals.waveOffset * 3, textPadding: 12)
//                                }
//                                .buttonStyle(DefaultButtonStyle())
//                            }
//                        }
//                        else {
//                            Button {
//                                goToMisconceptionIntentional()
//                            } label: {
//                                Text("Go!")
//                                    .labelMod(140, 110, globalTimer.time + AppGlobals.waveOffset)
//                                    .bold()
//                            }
//                            .buttonStyle(DefaultButtonStyle())
//                            VStack {
//                                Button {
//                                    layer = 1
//                                } label: {
//                                    Text("Return to Chapters")
//                                        .labelMod(185, 50, globalTimer.time + AppGlobals.waveOffset * 2, textPadding: 12)
//                                }
//                                .buttonStyle(DefaultButtonStyle())
//                                Button {
//                                    
//                                } label: {
//                                    Text("Misconceptions")
//                                        .labelMod(185, 50, globalTimer.time + AppGlobals.waveOffset * 3, textPadding: 12)
//                                }
//                                .buttonStyle(DefaultButtonStyle())
//                            }
//                        }
                    }
                }
            }
            .alertOverlayMod(showAlert)
            
            // tutorial overlays
            
            // overlay background
            
            Rectangle()
                .opacity(onTutorial ? 0.75 : 0)
                .foregroundStyle(.black)
                .overlay(
                    Circle()
                        .scaleEffect(tutorialBGScales[tutorialSlide])
                        .offset(x: tutorialBGPositions[tutorialSlide].x, y: tutorialBGPositions[tutorialSlide].y)
//                        .scaleEffect(0.40)
//                        .offset(x: 78, y: 360)
                        .blendMode(.destinationOut)
                )
                .compositingGroup()
                .blur(radius: 4)
                .animation(.timingCurve(0.3, 0.2, 0.1, 1, duration: 0.5 * AppGlobals.getAnimSpeed()), value: tutorialSlide)
                .animation(.easeInOut(duration: 0.5 * AppGlobals.getAnimSpeed()), value: onTutorial)
                .allowsHitTesting(false)
            
            // overlay text
            
            ZStack {
                Rectangle()
                    .stroke(AppGlobals.textColor, lineWidth: 10)
                    .fill(AppGlobals.buttonCol1)
                    .frame(width: tutorialScales[extraVarForSizeScaling].width + 10, height: tutorialScales[extraVarForSizeScaling].height + 10)
                    .shadow(color: AppGlobals.textColor, radius: 15, x: 0, y: 5)
                    .padding(-7)
                Text(tutorialText[tutorialSlide])
                    .font(.custom("futura", size: 30))
                    .foregroundStyle(AppGlobals.textColor)
                    .frame(width: tutorialScales[extraVarForSizeScaling].width, height: tutorialScales[extraVarForSizeScaling].height)
                    .minimumScaleFactor(0.5)
            }
            .hoverMod(globalTimer.time, 1)
            .offset(x: tutorialPositions[tutorialSlide].x, y: tutorialPositions[tutorialSlide].y)
            .opacity(onTutorial ? 1 : 0)
            
            // button
            
            Button {
                if tutorialSlide >= tutorialBGPositions.count - 1 {
                    onTutorial = false
                    tutorialSlide = 0
                }
                else {
                    tutorialSlide += 1
                    if tutorialSlide == 7 || tutorialSlide == 11 {
                        layer += 1
                    }
                    else if tutorialSlide == 14 {
                        layer = AppGlobals.isFullVersion ? 1 : 0
                    }
                }
                extraVarForSizeScaling = tutorialSlide
            } label: {
                Rectangle()
                    .fill(.clear)
                    .ignoresSafeArea()
            }
            .allowsHitTesting(onTutorial)
            
            PopUpWindow(alert: .constant(AlertContext.settings), showAlert: $showAlert, viewPath: $viewPath, time: globalTimer.time, miscHeader: "", miscExpl: "", answerSelection: .constant(0), endRoundFunc: nullFunc, recordStatsFunc: nullRecordStatsFunc)

        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .statusBar(hidden: true)
        .animation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.7 * AppGlobals.getAnimSpeed()), value: showAlert)
        .onAppear {
            if AppGlobals.firstLoading {
                onTutorial = true
                AppGlobals.firstLoading = false
                UserDefaults.standard.set(AppGlobals.firstLoading, forKey: "firstLoading")
            }
            InfoList.save(info)
            setNextChapter()
        }
        .onChange(of: unitSelection) {
            setNextChapter()
        }
    }
    
    func setNextChapter() {
        chapterSelection = 0
        for i in info.getChArray()[unitSelection].indices {
            if info.getChArray()[unitSelection][i].getHighestScore() == 0.0 {
                chapterSelection = i
                break
            }
        }
    }
    
    func handleGoButton() {
        if (AppGlobals.isFullVersion || unitSelection <= 2) {
            switch layer {
            case 0:
                layer = 1
            case 1:
                if unitSelection != 0 {
                    QuestionLoader.goToChapterQuestions(i: info, unit: unitSelection, chapter: chapterSelection, viewPath: $viewPath)
                }
                else {
                    QuestionLoader.goToMathMisconception(i: info, unit: unitSelection, chapter: chapterSelection, viewPath: $viewPath)
                }
            default:
                QuestionLoader.goToMisconceptionIntentional(i: info, unit: unitSelection, chapter: chapterSelection, misc: miscSelection, viewPath: $viewPath)
            }
        }
    }
    
    // holy
    func nullRecordStatsFunc(_ a: Bool) {
        
    }
}

struct QuestionLoader {
    
    static func goToChapterQuestions(i: InfoList, unit: Int, chapter: Int, viewPath: Binding<NavigationPath>) {
        let tempPath = AppGlobals.basePath +
        "/\(i.getUnitArray()[unit].name)" +
        "/\(i.getChArray()[unit][chapter].name)"
        
        let diagFile: String = loadFolderContents(tempPath + "/DP", onlyFolders: false)[0]
        let questionsDiagnostic = unpackQuestions(fileName: diagFile, subdirectory: tempPath + "/DP")
        
        let areasFiles: [String] = loadFolderContents(tempPath + "/IP", onlyFolders: false).dropLast()
        let questionAreas = makeAreasDict(fileNameList: areasFiles, path: tempPath + "/IP")
        
        viewPath.wrappedValue.append(Route.questions(questionsDiagnostic: questionsDiagnostic, questionAreas: questionAreas, misconceptionDict: makeMisconceptionsDict(path: tempPath + "/IP"), chapterCoords: [unit, chapter], mode: QuizMode.chapterDiagnostic))
    }
    
    // theres gotta be a less laggy way to do this REVISE LATER OR SOMETHING
    static func goToUnitDiagnostic(i: InfoList, unit: Int, chapter: Int, viewPath: Binding<NavigationPath>) {
        let tempPath = AppGlobals.basePath + "/\(i.getUnitArray()[unit].name)"
        
        var questionsList: [Question] = []
        var areasDict: [String: [Question]] = [:]
        let files: [String] = loadFolderContents(tempPath, onlyFolders: false)
        let chapterFolders = loadFolderContents(tempPath)
        
        for f in files {
            if f.contains("Diagnostic") {
                questionsList.append(contentsOf: unpackQuestions(fileName: f, subdirectory: tempPath))
            }
        }
        for f in chapterFolders {
            let currentPath = tempPath + "/\(f)" + "/IP"
            let areasFiles: [String] = loadFolderContents(currentPath, onlyFolders: false).dropLast()
            let areas = makeAreasDict(fileNameList: areasFiles, path: currentPath)
            areasDict.merge(areas) { (_, new) in new }
        }
        let miscDict = makeMisconceptionsDict(path: tempPath)
        
        viewPath.wrappedValue.append(Route.questions(questionsDiagnostic: questionsList, questionAreas: areasDict, misconceptionDict: miscDict, chapterCoords: [unit, 0], mode: QuizMode.unitDiagnostic))
    }
    
    // substitutes
    static func goToTest(i: InfoList, unit: Int, chapter: Int, viewPath: Binding<NavigationPath>) {
        let tempPath = AppGlobals.basePath + "/\(i.getUnitArray()[unit].name)"
        
        let files: [String] = loadFolderContents(tempPath, onlyFolders: false)
        let file: String = files.first { $0.contains("Challenge") }! // fix force unwrap later
        
        let questions = unpackQuestions(fileName: file, subdirectory: tempPath, loadDiagnosticType: false)
        
        viewPath.wrappedValue.append(Route.challenge(questions: questions, chapter: unit))
    }
    
    static func goToMisconceptionIntentional(i: InfoList, unit: Int, chapter: Int, misc: Int, viewPath: Binding<NavigationPath>) {
        let tempPath = AppGlobals.basePath +
        "/\(i.getUnitArray()[unit].name)" +
        "/\(i.getChArray()[unit][chapter].name)" + "/IP"
        let questionFiles = unpackQuestions(fileName: i.getChArray()[unit][chapter].getMisconceptionArray()[misc].code, subdirectory: tempPath, loadDiagnosticType: false)
        viewPath.wrappedValue.append(Route.questions(questionsDiagnostic: questionFiles, questionAreas: [:], misconceptionDict: [:], chapterCoords: [unit, chapter, misc], mode: QuizMode.misconceptionIntentional))
        
    }
    
    static func goToMathMisconception(i: InfoList, unit: Int, chapter: Int, viewPath: Binding<NavigationPath>) {
        let tempPath = AppGlobals.basePath +
        "/\(i.getUnitArray()[unit].name)"
        let questionFiles = unpackQuestions(fileName: i.getChArray()[unit][chapter].getName(), subdirectory: tempPath, loadDiagnosticType: false)
        viewPath.wrappedValue.append(Route.questions(questionsDiagnostic: questionFiles, questionAreas: [:], misconceptionDict: [:], chapterCoords: [unit, chapter], mode: QuizMode.mathIntentional))
    }
}

#Preview {
    UnitSelectView(viewPath: .constant(NavigationPath()), info: .constant(InfoList()))
        .environmentObject(GlobalTimer())
}

// OLD CODE IN MAIN STRUCT:

//@Binding var viewPath: NavigationPath
//
//@State var items: [[String]] = Array(repeating: [], count: 4)
//@State var time = 0.0
//@State var layer: Int = 0
//@State var path: String = "Subjects"
//@State var selection: Int = 0
//let labelHeight: CGFloat = 120.0
//let labelSpacing: CGFloat = 15.0
//var filename = ""
//var subdir = ""
//@State var questionsDiagnostic: [Question] = []
//@State var questionAreas: [String: [Question]] = [:]
//let timer = Timer.publish(every: (1 / 60.0), on: .main, in: .common).autoconnect()
//
//let scrollWidth: CGFloat = 400.0
//let scrollHeight: CGFloat = 400.0
//
//@Environment(\.dismiss) var dismiss

//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(AppGlobals.BGColor1)
//                .ignoresSafeArea()
//            VStack {
//                HStack {
//                    Button {
//                        dismiss()
//                    }
//                    label: {
//                        Text("Back")
//                            .labelMod(100, 50, time - AppGlobals.waveOffset)
//                    }
//                    .buttonStyle(DefaultButtonStyle())
//                    Button {
//                        AppGlobals.togglePath()
//                    }
//                    label: {
//                        Text(AppGlobals.isPathDiagnostic ? "Diagnostic Path" : "Intentional Path")
//                            .labelMod(230, 50, time - AppGlobals.waveOffset)
//                    }
//                    .buttonStyle(DefaultButtonStyle())
//                }
//                Text("Select A Unit")
//                    .labelMod(325, 125, time)
//
//                RoundedRectangle(cornerRadius: 5)
//                    .foregroundStyle(AppGlobals.buttonCol2)
//                    .frame(width: 325, height: 5)
//                    .padding(16)
//
//                ScrollView {
//                    LazyVStack(spacing: 10) {
//                        Spacer()
//                        ForEach(0..<items[selection].count, id: \.self) {i in
//                            Button {
//                                handleSelection(i)
//                            }
//                            label: {
//                                Text(items[selection][i])
//                                    .unitSelectButtonMod()
//                            }
//                            .buttonStyle(DefaultButtonStyle())
//                        }
//                    }
//                }
//                .scrollIndicators(.hidden)
//            }
////            Rectangle()
////                .frame(maxWidth: 400, maxHeight: 800)
////                .foregroundStyle(LinearGradient(colors: [AppGlobals.BGColor1, .clear], startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 0, y: 0.1)))
//        .navigationBarBackButtonHidden(true)
//        .toolbar(.hidden)
//        }
//        .onAppear {
//            items = Array(repeating: [], count: 4)
//            path = "Subjects"
//            items[0] = loadFolderContents(path)
//            selection = 0
//        }
//        .onReceive(timer) {_ in
//            time += 1.0 / 60.0
//        }
//    }
//    
//    func handleSelection(_ index: Int) {
//        if layer < 2 {
//            path.append("/\(items[layer][index])")
//            layer += 1
//            items[layer] = loadFolderContents(path)
//        }
//        else {
//            path.append("/\(items[layer][index])")
//            
//            let diagFile: String = loadFolderContents(path + "/DP", onlyFolders: false)[0]
//            questionsDiagnostic = unpackQuestions(fileName: diagFile, subdirectory: path + "/DP")
//            
//            let areasFiles: [String] = loadFolderContents(path + "/IP", onlyFolders: false).dropLast()
//            questionAreas = makeAreasDict(fileNameList: areasFiles, path: path + "/IP")
//            
//            viewPath.append(Route.questions(questionsDiagnostic: questionsDiagnostic, questionAreas: questionAreas, misconceptionDict: makeMisconceptionsDict(path: path + "/IP")))
//        }
//    }
//}

