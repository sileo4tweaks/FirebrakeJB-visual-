//
//  Theme.swift
//  FirebreakJBKawaii
//
//  Peach-lavender sunset palette · candy kawaii aesthetic ♥
//

import SwiftUI

enum Theme {
    // MARK: - Backgrounds (light, pastel)
    static let bgDeep       = Color(hex: 0xFFF5F8)
    static let bgSurface    = Color(hex: 0xFFF0E8)
    static let bgElevated   = Color(hex: 0xF8F0FF)

    // MARK: - Accents
    static let pink         = Color(hex: 0xFF6B9D)    // primary
    static let pinkDim      = Color(hex: 0xFF6B9D).opacity(0.5)
    static let pinkFaint    = Color(hex: 0xFF6B9D).opacity(0.1)
    static let candyPink    = Color(hex: 0xFFB6C1)
    static let lavender     = Color(hex: 0xB19CD9)    // secondary
    static let lavenderDim  = Color(hex: 0xB19CD9).opacity(0.5)
    static let lavenderFaint = Color(hex: 0xB19CD9).opacity(0.1)
    static let mint         = Color(hex: 0x98D8C8)    // success
    static let mintDim      = Color(hex: 0x98D8C8).opacity(0.5)
    static let peach        = Color(hex: 0xFFE4B5)

    // Text
    static let text         = Color(hex: 0x4A3B5C)
    static let textDim      = Color(hex: 0x4A3B5C).opacity(0.5)
    static let textFaint    = Color(hex: 0x4A3B5C).opacity(0.3)

    // MARK: - Gradients
    static let pinkLavender = LinearGradient(
        colors: [pink, lavender],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let pinkLavenderVertical = LinearGradient(
        colors: [pink, lavender],
        startPoint: .top,
        endPoint: .bottom
    )

    static let pinkLavenderHorizontal = LinearGradient(
        colors: [pink, lavender],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let pinkMint = LinearGradient(
        colors: [pink, mint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let sunsetBackdrop = LinearGradient(
        stops: [
            .init(color: Color(hex: 0xFFD1DC), location: 0),
            .init(color: Color(hex: 0xFFE4B5), location: 0.5),
            .init(color: Color(hex: 0xDDA0DD), location: 1),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let screenBackdrop = LinearGradient(
        stops: [
            .init(color: Color(hex: 0xFFF5F8), location: 0),
            .init(color: Color(hex: 0xFFF0E8), location: 0.5),
            .init(color: Color(hex: 0xF8F0FF), location: 1),
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let pinkGlow = RadialGradient(
        colors: [pink.opacity(0.4), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 200
    )
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// MARK: - Card modifier

struct KawaiiCard: ViewModifier {
    var borderColor: Color = Theme.candyPink
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: 2)
                    )
                    .shadow(color: Theme.lavender.opacity(0.25), radius: 8, y: 4)
            )
    }
}

extension View {
    func kawaiiCard(border: Color = Theme.candyPink, corner: CGFloat = 24) -> some View {
        modifier(KawaiiCard(borderColor: border, cornerRadius: corner))
    }
}
