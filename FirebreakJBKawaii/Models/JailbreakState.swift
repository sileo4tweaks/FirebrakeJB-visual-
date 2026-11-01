//
//  JailbreakState.swift
//  FirebreakJBKawaii
//
//  State machine for the fake jailbreak flow.
//

import Foundation

enum JailbreakPhase: String, CaseIterable, Identifiable {
    case deviceDetected     = "DEVICE DETECTED"
    case exploitVerified    = "EXPLOIT VERIFIED"
    case kernelPatched      = "KERNEL PATCHED"
    case sandboxEscaped     = "SANDBOX ESCAPED"
    case bootstrapInjected  = "BOOTSTRAP INJECTED"
    case sileoInstalled     = "SILEO INSTALLED"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .deviceDetected:    return "♥"
        case .exploitVerified:   return "✨"
        case .kernelPatched:     return "♥"
        case .sandboxEscaped:    return "✨"
        case .bootstrapInjected: return "♥"
        case .sileoInstalled:    return "✨"
        }
    }

    var logLine: String {
        switch self {
        case .deviceDetected:    return "device detected via USB ♥"
        case .exploitVerified:   return "checkm8 exploit verified ~"
        case .kernelPatched:     return "kernel patched @ 0xfffffff00780"
        case .sandboxEscaped:    return "sandbox escaped ~ ✨"
        case .bootstrapInjected: return "bootstrap injected ♥"
        case .sileoInstalled:    return "Sileo installed ♥"
        }
    }
}

enum JailbreakStatus: String {
    case ready       = "✓ SUPPORTED"
    case running     = "EXPLOITING ~"
    case done        = "✓ JAILBROKEN"
}

@MainActor
final class JailbreakViewModel: ObservableObject {
    @Published var status: JailbreakStatus = .ready
    @Published var progress: Double = 0
    @Published var completedSteps: Set<JailbreakPhase> = []
    @Published var activeStep: JailbreakPhase? = nil
    @Published var logLines: [String] = [
        "awaiting input ♥...",
        "slide to begin ~"
    ]
    @Published var sliderDrag: CGFloat = 0
    @Published var isDragging = false

    let totalSteps = JailbreakPhase.allCases.count
    private var timer: Timer?
    private var stepIndex = 0

    var progressPercent: Int { Int(progress * 100) }

    func startJailbreak() {
        guard status != .running, status != .done else { return }
        status = .running
        progress = 0
        completedSteps = []
        activeStep = nil
        logLines = []
        stepIndex = 0
        appendLog("♥", "checkm8 triggered via USB")
        appendLog("♥", "pongoOS loaded @ 0x8badf00d")
        scheduleNextStep()
    }

    func reset() {
        status = .ready
        progress = 0
        completedSteps = []
        activeStep = nil
        logLines = [
            "awaiting input ♥...",
            "slide to begin ~"
        ]
        sliderDrag = 0
    }

    private func scheduleNextStep() {
        guard stepIndex < totalSteps else {
            finish()
            return
        }
        let step = JailbreakPhase.allCases[stepIndex]
        activeStep = step
        appendLog(step.emoji, step.logLine + " ...")

        timer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                self.completedSteps.insert(step)
                self.activeStep = nil
                self.stepIndex += 1
                self.progress = Double(self.stepIndex) / Double(self.totalSteps)
                self.scheduleNextStep()
            }
        }
    }

    private func finish() {
        status = .done
        progress = 1.0
        activeStep = nil
        appendLog("✨", "done in 47.3s · respring ~ ♥")
    }

    private func appendLog(_ icon: String, _ text: String) {
        logLines.append("\(icon) \(text)")
    }
}
