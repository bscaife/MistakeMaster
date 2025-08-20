//
//  ContentView.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 5/28/25 for MistakeMaster.
//

import SwiftUI
import Foundation
import UIKit
import CoreLocation
import Combine
import AVFoundation
import StoreKit


enum Route: Hashable {
    case unitSelect
    case questions(questionsDiagnostic: [Question], questionAreas: [String: [Question]],
                   misconceptionDict: [String: Misconception], chapterCoords: [Int], mode: QuizMode)
    case challenge(questions: [Question], chapter: Int)
    case summary(roundStats: Stats, coords: [Int], mode: QuizMode)
    case challengeSummary(stats: Stats, breakdownArray: [WrongAnswerBreakdown])
    case settings
    case about
}

struct MainMenuGradientBackground: View {
    let col1: Color
    let col2: Color
    var body: some View {
        Rectangle()
            .foregroundStyle(col1)
            .frame(width: UIScreen.main.bounds.width * 1.1, height: UIScreen.main.bounds.height * 1.1)
            .ignoresSafeArea()
        Rectangle()
            .fill(col2)
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width * 1.1, height: UIScreen.main.bounds.height * 1.1)
            .mask (
                MainMenuParticleView()
            )
            .blur(radius: 50)
    }
}

@MainActor
final class Store: ObservableObject {
    static let shared = Store()
    private let productIDs = ["com.MistakeMaster.FullUnlock"]
    @Published var products: [Product] = []
    @Published var isFullVersion = false

    init() {
        Task {
            await listenForTransactions()
            await refreshEntitlements()
            try? await loadProducts()
        }
    }

    func loadProducts() async throws {
        products = try await Product.products(for: productIDs)
    }

    func buy(_ product: Product) async {
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result,
               case .verified(let txn) = verification {
                await txn.finish()
                await refreshEntitlements()
            }
        } catch { print("purchase error:", error) }
    }

    func refreshEntitlements() async {
        var pro = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let t) = result, productIDs.contains(t.productID) {
                pro = true
            }
        }
        isFullVersion = pro
    }

    func listenForTransactions() async {
        for await update in Transaction.updates {
            if case .verified(let t) = update {
                await t.finish()
                await refreshEntitlements()
            }
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }
}


struct ButtonModifier: ViewModifier {
    let x: CGFloat
    let y: CGFloat
    let t: Double
    let isElim: Bool
    let isWrong: Bool
    let textPadding: CGFloat
    let amp: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("futura", size: 30))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .frame(width: x - textPadding * 2, height: y - textPadding * 2)
            .foregroundStyle(AppGlobals.textColor)
            .minimumScaleFactor(0.3)
            .padding(textPadding)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isWrong ? AppGlobals.buttonOutlineColorWrong :
                                    (isElim ? AppGlobals.buttonOutlineColorElim : AppGlobals.buttonOutlineColor), lineWidth: 2)
                        .fill(isWrong ? AppGlobals.buttonColRed2 :
                            (isElim ? AppGlobals.buttonColElim2 : AppGlobals.buttonCol2))
                        .offset(y: 15)
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isWrong ? AppGlobals.buttonOutlineColorWrong :
                                    (isElim ? AppGlobals.buttonOutlineColorElim : AppGlobals.buttonOutlineColor), lineWidth: 2)
                        .fill(isWrong ? AppGlobals.buttonColRed1 :
                            (isElim ? AppGlobals.buttonColElim1: AppGlobals.buttonCol1))
                }
            )
            .compositingGroup()
            .hoverMod(t, amp)
//            .hoverMod(t, isElim ? 0 : 1)
            .scaleEffect(isElim ? 0.95 : 1)
            .animation(nil, value: isWrong)
    }
}

struct SmallButtonModifier: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color)
            )
    }
}

struct HoverModifier: ViewModifier {
    let t: Double
    let amp: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: AppGlobals.buttonWobble ? (amp * sin(t)) : 0))
            .offset(x: AppGlobals.buttonWobble ? (amp * 3 * cos(t)) : 0, y: AppGlobals.buttonWobble ? (amp * 3 * cos(t * 1.1)) : 0)
    }
}

struct alertOverlay: ViewModifier {
    let showAlert: Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: showAlert ? 5 : 0)
            .brightness(showAlert ? -0.5 : 0)
            .contrast(showAlert ? 0.5 : 1)
            .saturation(showAlert ? 0.7 : 1)
    }
}

extension View{
    func labelMod(_ x: CGFloat, _ y: CGFloat, _ t: Double, isElim: Bool = false, isWrong: Bool = false, textPadding: CGFloat = 20.0, amp: CGFloat = 1.0) -> some View {
        self.modifier(ButtonModifier(x: x, y: y, t: t, isElim: isElim, isWrong: isWrong, textPadding: textPadding, amp: amp))
    }
    
    func hoverMod(_ t: Double, _ amp: CGFloat) -> some View {
        self.modifier(HoverModifier(t: t, amp: amp))
    }
    
    func smallButtonMod(_ color: Color) -> some View {
        self.modifier(SmallButtonModifier(color: color))
    }
    
    func alertOverlayMod(_ showAlert: Bool) -> some View {
        self.modifier(alertOverlay(showAlert: showAlert))
    }
}

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.91 : 1)
            .rotationEffect(Angle(degrees: configuration.isPressed ? 1 : 0))
            .animation(AppGlobals.animSpeed == "None" ? nil : .interpolatingSpring(mass: 1, stiffness: 1300, damping: 12, initialVelocity: 50), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                if newValue {
                    SoundManager.playMP3("select1")
                }
                if oldValue {
                    SoundManager.playMP3("select2")
                }
            }
    }
}

struct InactiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

class GlobalTimer: ObservableObject {
    @Published var time: Double = 0.0
        
    let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    private var cancellable: AnyCancellable?

    init() {
        cancellable = timer.sink { [weak self] _ in
            self?.time += 1.0 / 60.0
        }
    }
}

struct SoundManager {
    static var players: [AVAudioPlayer] = []
    
    static func playMP3(_ name: String, isLoop: Bool = false) {
        if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.numberOfLoops = isLoop ? -1 : 0
                player.volume = globalVolume
                player.play()
                players.append(player)
            } catch {
                print("Can't find the sound!")
            }
        }
    }
    
    static var globalVolume: Float = AppGlobals.isMuted ? 0.0 : 1.0 {
        didSet {
            for player in players {
                player.volume = globalVolume
            }
        }
    }

    static func stopAll() {
        for player in players {
            player.stop()
        }
        players.removeAll()
    }
    
    static func toggleMuted() {
        AppGlobals.isMuted.toggle()
        globalVolume = AppGlobals.isMuted ? 0.0 : 1.0
        UserDefaults.standard.set(AppGlobals.isMuted, forKey: "isMuted")
    }
}


struct ContentView: View {
    @EnvironmentObject var store: Store
    
    @State var viewPath = NavigationPath()
    @State var time = 0.0
    @State var isFirstAppearance = true
    @State var startBgMusic = true
    
    @StateObject var globalTimer = GlobalTimer()
    
    @State var info = InfoList()
    
    @State var isBuying = false
    
    var body: some View {
        NavigationStack(path: $viewPath){
            ZStack {
                MainMenuGradientBackground(col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2)
                VStack {
                    HStack {
                        Rectangle()
                            .frame(width: 100, height: 120)
                            .foregroundStyle(AppGlobals.textColor)
                            .mask {
                                Image("Logotransparentbg")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                            }
                            .padding(-5)
                        VStack(spacing: -20) {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 10, height: 43)
//                                .frame(width: 10, height: store.isFullVersion ? 43 : 52)
                            Text("Mistake")
                                .bold()
                                .font(.custom("futura", size: 40))
                            Text("Master")
                                .bold()
                                .font(.custom("futura", size: 46))
                            Text("AP Physics 1")
                                .bold()
                                .font(.custom("futura", size: 24))
                                .padding(.vertical, 8)
//                            if !store.isFullVersion {
//                                Text("lite")
//                                    .bold()
//                                    .font(.custom("futura", size: 18))
//                                    .rotationEffect(Angle(degrees: -5))
//                                    .offset(x: 0, y: 8)
//                            }
                        }
                    }
                        .labelMod(350, 200, globalTimer.time)
                    Button {
                        withAnimation(nil) {
                            viewPath.append(Route.unitSelect)
                        }
                    }
                    label: {
                        Text("Start")
                            .bold()
                            .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    Button {
                        withAnimation(nil) {
                            viewPath.append(Route.settings)
                        }
                    }
                    label: {
                        Text("Settings")
                            .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    Button {
                        withAnimation(nil) {
                            viewPath.append(Route.about)
                        }
                    }
                    label: {
                        Text("About")
                            .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    
                    if store.isFullVersion {
                        Text("Full version unlocked! :D")
                            .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                    }
                    else {
                        let product = store.products.first
                        
                        Button {
                            guard let p = product, !isBuying else { return }
                            isBuying = true
                            Task {
                                await store.buy(p)
                                isBuying = false
                            }
                        } label: {
                            if let p = product {
                                Text("Unlock Full Version (\(p.displayPrice))")
                                .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                            } else {
                                Text("Loading…")
                                    .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                            }
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .disabled(product == nil || isBuying)
                    }
                    Button {
                        Task { await store.restore() }
                    } label: {
                        Text("Restore Purchases")
                            .labelMod(350, 80, globalTimer.time + AppGlobals.waveOffset)
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
            }
            .navigationDestination(for: Route.self) {route in
                switch route {
                case .unitSelect:
                    UnitSelectView(viewPath: $viewPath, info: $info)
                        .environmentObject(globalTimer)
                case .questions(let qDiag, let qAreas, let misc, let coords, let mode):
                    QuestionsView(viewPath: $viewPath, qDiagSet: qDiag, qAreaSet: qAreas, miscSet: misc, info: $info, chapterCoords: coords, quizMode: mode)
                        .environmentObject(globalTimer)
                case .summary(let stats, let coords, let mode):
                    Summary(viewPath: $viewPath, roundStats: stats, coords: coords, info: $info, quizMode: mode)
                        .environmentObject(globalTimer)
                case .challenge(let qSet, let chapter):
                    ChallengeView(viewPath: $viewPath, qSet: qSet, info: $info, chapter: chapter)
                        .environmentObject(globalTimer)
                case .challengeSummary(let stats, let bList):
                    TestSummaryView(viewPath: $viewPath, testStats: stats, wrongBreakdownArray: bList)
                        .environmentObject(globalTimer)
                case .settings:
                    SettingsView(viewPath: $viewPath, info: $info)
                        .environmentObject(globalTimer)
                case .about:
                    AboutView(viewPath: $viewPath)
                        .environmentObject(globalTimer)
                }
            }
        }
        .task {
            await store.refreshEntitlements()
            if store.products.isEmpty { try? await store.loadProducts() }
        }
        .onAppear {
            // load progress on launch
            if startBgMusic {
                SoundManager.stopAll()
                SoundManager.playMP3("MistakeMaster bg", isLoop: true)
                startBgMusic = false
            }
            if isFirstAppearance {
                info = InfoList.load() ?? info
                isFirstAppearance = false
            }
            switch AppGlobals.theme {
                case "classic":
                    AppGlobals.setThemeClassic()
                case "light":
                    AppGlobals.setThemeLight()
                case "dark":
                    AppGlobals.setThemeDark()
                case "space":
                    AppGlobals.setThemeSpace()
                default:
                    print("unknown theme")
            }
        }
        .statusBar(hidden: true)
    }
}


#Preview {
    ContentView()
        .environmentObject(Store.shared)
}
