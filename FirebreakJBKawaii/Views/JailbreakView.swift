//
//  JailbreakView.swift
//  FirebreakJBKawaii
//
//  Main screen — interactive kawaii jailbreak installer.
//  Three states: ready → running → done.
//  Slider triggers the (fake) jailbreak sequence.
//

import SwiftUI

struct JailbreakView: View {
    @StateObject private var vm = JailbreakViewModel()

    var body: some View {
        ZStack {
            // Sunset backdrop
            Theme.sunsetBackdrop.ignoresSafeArea()

            // Floating decorative hearts
            floatingHearts

            ScrollView {
                VStack(spacing: 16) {
                    header
                    deviceCard
                    optionsCard
                    pipelineCard
                    progressCard
                    consoleCard
                    Spacer(minLength: 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }

            // Slider pinned to bottom
            VStack {
                Spacer()
                sliderBlock
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("FIREBREAK")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.pinkLavender)
                Text("♥")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.pink)
                Spacer()
                Text(vm.status == .done ? "✓ DONE ✨" : "v3.0.1 ♥")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(vm.status == .done ? Theme.mint : Theme.lavender)
            }
            Text(statusTagline)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.lavender)
                .textCase(.uppercase)
        }
        .padding(.bottom, 12)
        .overlay(
            Rectangle()
                .fill(Theme.candyPink)
                .frame(height: 2)
                .opacity(0.6),
            alignment: .bottom
        )
    }

    private var statusTagline: String {
        switch vm.status {
        case .ready:   return "✨ SEMI-UNTETHERED · CHECKM8 ♥"
        case .running: return "♥ EXPLOITING · DO NOT DISCONNECT"
        case .done:    return "♥ JAILBROKEN · SILEO ACTIVE ✨"
        }
    }

    // MARK: - Device card

    private var deviceCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            row("Device", "iPhone 13")
            row("Chip", "A15 Bionic ♥", accent: true)
            row("iOS", "26.6.1 RC")
            row("ECID", "0x8BADF00D")
            if vm.status == .running {
                row("Stage", "KERNEL PATCH")
            }
            if vm.status == .done {
                row("Uptime", "00:01:23")
            }

            HStack {
                Text("STATUS")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.lavender)
                    .textCase(.uppercase)
                Spacer()
                Text(vm.status.rawValue)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(statusColor)
            }
            .padding(.top, 8)
            .overlay(
                Rectangle()
                    .fill(Theme.candyPink.opacity(0.5))
                    .frame(height: 1)
                    .padding(.top, -4),
                alignment: .top
            )
        }
        .kawaiiCard()
    }

    private func row(_ key: String, _ value: String, accent: Bool = false) -> some View {
        HStack {
            Text(key.uppercased())
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.lavender)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(accent ? Theme.pink : Theme.text)
        }
    }

    private var statusColor: Color {
        switch vm.status {
        case .ready:   return Theme.pink
        case .running: return Theme.lavender
        case .done:    return Theme.mint
        }
    }

    // MARK: - Options card

    private var optionsCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(vm.status == .ready ? "✨ OPTIONS ♥" : "✨ OPTIONS [\(vm.status == .done ? "APPLIED ♥" : "LOCKED ♥")]")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Theme.lavender)
                .textCase(.uppercase)

            optionRow("ROOTLESS", isOn: true, applied: vm.status == .done)
            optionRow("TWEAK INJECTION", isOn: true, applied: vm.status == .done)
            optionRow("INSTALL SILEO", isOn: true, applied: vm.status == .done)
            optionRow("VERBOSE LOG", isOn: false, applied: false)
        }
        .kawaiiCard()
    }

    private func optionRow(_ name: String, isOn: Bool, applied: Bool) -> some View {
        HStack {
            Text(name + (applied ? " ♥" : ""))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(vm.status == .ready ? Theme.text : Theme.text.opacity(0.5))
            Spacer()
            toggle(isOn: isOn)
        }
        .opacity(vm.status == .ready ? 1 : 0.6)
    }

    private func toggle(isOn: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isOn ? Theme.pink : Color(hex: 0xFFE4B5))
                .frame(width: 36, height: 18)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(isOn ? Theme.pink : Theme.candyPink, lineWidth: 2)
                )
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .shadow(color: .black.opacity(0.15), radius: 1, y: 1)
                .offset(x: isOn ? 9 : -9)
        }
    }

    // MARK: - Pipeline checklist

    private var pipelineCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("♥ PIPELINE ✨")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Theme.lavender)
                .textCase(.uppercase)

            ForEach(JailbreakPhase.allCases) { step in
                stepRow(step)
            }
        }
        .kawaiiCard()
    }

    private func stepRow(_ step: JailbreakPhase) -> some View {
        let isDone = vm.completedSteps.contains(step)
        let isActive = vm.activeStep == step

        return HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isDone ? Theme.pink : (isActive ? Theme.lavender : Color.white))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .strokeBorder(isDone ? Theme.pink : (isActive ? Theme.lavender : Theme.candyPink), lineWidth: 2)
                    )
                if isDone {
                    Text(step.emoji)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                } else if isActive {
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }

            Text(step.rawValue)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(isDone ? Theme.text : (isActive ? Theme.lavender : Theme.text.opacity(0.5)))

            Spacer()
        }
        .padding(.vertical, 3)
    }

    // MARK: - Progress bar

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("PROGRESS ♥")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.lavender)
                    .textCase(.uppercase)
                Spacer()
                Text("\(vm.progressPercent)%\(vm.status == .done ? " ✓" : "")")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.pink)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .strokeBorder(Theme.candyPink, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Theme.pinkLavenderHorizontal)
                        .frame(width: geo.size.width * vm.progress)
                        .shadow(color: Theme.pink.opacity(0.4), radius: 4)
                }
            }
            .frame(height: 14)
        }
        .kawaiiCard()
    }

    // MARK: - Console

    private var consoleCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(Array(vm.logLines.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(consoleColor(for: line))
                    }
                    if vm.status == .running {
                        HStack(spacing: 0) {
                            Text("✨ patching kernel")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.white)
                            Text("~")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(Theme.pink)
                                .blink()
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(10)
        .frame(height: 110)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: 0x4A3B5C))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Theme.pink, lineWidth: 2)
                )
        )
    }

    private func consoleColor(for line: String) -> Color {
        if line.hasPrefix("♥") { return Theme.candyPink }
        if line.hasPrefix("✨") { return Theme.peach }
        return Color(hex: 0xFFF0E8)
    }

    // MARK: - Slider

    private var sliderBlock: some View {
        GeometryReader { geo in
            let knobSize: CGFloat = 48
            let trackWidth = geo.size.width
            let maxDrag = trackWidth - knobSize - 12

            ZStack {
                // Track
                RoundedRectangle(cornerRadius: 30)
                    .fill(sliderTrackColor)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(sliderBorderColor, lineWidth: 3)
                    )
                    .shadow(color: Theme.pink.opacity(0.3), radius: 6, y: 3)

                // Text
                Text(sliderText)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(sliderTextColor)
                    .letterSpacing(2)
                    .textCase(.uppercase)

                // Knob
                HStack {
                    if vm.status == .done {
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 24)
                        .fill(sliderKnobGradient)
                        .frame(width: knobSize, height: knobSize)
                        .overlay(
                            Text(sliderKnobIcon)
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Theme.pink.opacity(0.5), radius: 4, y: 2)
                        .offset(x: vm.status == .ready ? vm.sliderDrag : (vm.status == .done ? 0 : maxDrag / 2))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard vm.status == .ready else { return }
                                    vm.sliderDrag = max(0, min(value.translation.width, maxDrag))
                                }
                                .onEnded { value in
                                    guard vm.status == .ready else { return }
                                    if vm.sliderDrag > maxDrag * 0.85 {
                                        vm.sliderDrag = maxDrag
                                        vm.startJailbreak()
                                    } else {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            vm.sliderDrag = 0
                                        }
                                    }
                                }
                        )
                    if vm.status != .done {
                        Spacer()
                    }
                }
                .padding(.horizontal, 6)
            }
        }
        .frame(height: 60)
    }

    private var sliderText: String {
        switch vm.status {
        case .ready:   return "SLIDE TO JAILBREAK ~ ♥"
        case .running: return "JAILBREAKING ~ ♥"
        case .done:    return "♥ RE-JAILBREAK ♥"
        }
    }
    private var sliderTextColor: Color {
        switch vm.status {
        case .ready:   return Theme.pink
        case .running: return Theme.lavender
        case .done:    return Theme.mint
        }
    }
    private var sliderTrackColor: Color {
        switch vm.status {
        case .ready:   return Color.white
        case .running: return Theme.peach.opacity(0.5)
        case .done:    return Color(hex: 0xFFF5F8)
        }
    }
    private var sliderBorderColor: Color {
        switch vm.status {
        case .ready:   return Theme.pink
        case .running: return Theme.lavender
        case .done:    return Theme.mint
        }
    }
    private var sliderKnobGradient: LinearGradient {
        switch vm.status {
        case .ready:   return Theme.pinkLavender
        case .running: return Theme.pinkLavender
        case .done:    return Theme.pinkMint
        }
    }
    private var sliderKnobIcon: String {
        switch vm.status {
        case .ready:   return "♥"
        case .running: return "✨"
        case .done:    return "↺"
        }
    }

    // MARK: - Floating hearts background

    private var floatingHearts: some View {
        ZStack {
            ForEach(floatingHeartData, id: \.id) { item in
                Text(item.symbol)
                    .font(.system(size: item.size, weight: .bold))
                    .foregroundColor(item.color)
                    .opacity(item.opacity)
                    .position(x: item.x, y: item.y)
            }
        }
        .allowsHitTesting(false)
    }

    private struct FloatingItem: Identifiable {
        let id = UUID()
        let symbol: String
        let size: CGFloat
        let color: Color
        let opacity: Double
        let x: CGFloat
        let y: CGFloat
    }

    private var floatingHeartData: [FloatingItem] {
        [
            .init(symbol: "♥", size: 36, color: Theme.pink, opacity: 0.5, x: 50, y: 100),
            .init(symbol: "✨", size: 28, color: Theme.peach, opacity: 0.6, x: UIScreen.main.bounds.width - 50, y: 150),
            .init(symbol: "♥", size: 22, color: Theme.lavender, opacity: 0.4, x: 30, y: 400),
            .init(symbol: "✨", size: 18, color: Theme.candyPink, opacity: 0.5, x: UIScreen.main.bounds.width - 40, y: 500),
            .init(symbol: "♥", size: 32, color: Theme.lavender, opacity: 0.4, x: 60, y: 700),
            .init(symbol: "♥", size: 24, color: Theme.pink, opacity: 0.5, x: UIScreen.main.bounds.width - 60, y: 800),
        ]
    }
}

// MARK: - Pink-lavender horizontal gradient extension

extension LinearGradient {
    static let pinkLavenderHorizontal = LinearGradient(
        colors: [Theme.pink, Theme.lavender],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Blink modifier

struct Blink: ViewModifier {
    @State private var visible = true
    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0.3)
            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: visible)
            .onAppear { visible.toggle() }
    }
}

extension View {
    func blink() -> some View { modifier(Blink()) }
}

#Preview {
    JailbreakView()
}
