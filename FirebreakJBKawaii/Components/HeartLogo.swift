//
//  HeartLogo.swift
//  FirebreakJBKawaii
//
//  Pink-lavender heart logo for the app.
//

import SwiftUI

struct HeartLogo: View {
    var size: CGFloat = 56

    var body: some View {
        ZStack {
            // Outer rounded square
            RoundedRectangle(cornerRadius: size * 0.275, style: .continuous)
                .fill(Theme.pinkLavender)
                .frame(width: size, height: size)
                .shadow(color: Theme.pink.opacity(0.4), radius: size * 0.15)

            // Inner border
            RoundedRectangle(cornerRadius: size * 0.225, style: .continuous)
                .strokeBorder(Color.white.opacity(0.6), lineWidth: 1.5)
                .frame(width: size * 0.9, height: size * 0.9)

            // Heart
            HeartShape()
                .fill(Color.white)
                .frame(width: size * 0.5, height: size * 0.5)
                .overlay(
                    HeartShape()
                        .fill(Theme.pink.opacity(0.5))
                        .frame(width: size * 0.15, height: size * 0.15)
                        .offset(x: -size * 0.08, y: -size * 0.04)
                )

            // Sheen
            Ellipse()
                .fill(Color.white.opacity(0.5))
                .frame(width: size * 0.4, height: size * 0.06)
                .offset(y: -size * 0.2)
        }
        .frame(width: size, height: size)
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = rect.midX

        path.move(to: CGPoint(x: cx, y: rect.maxY))
        path.addCubicCurve(
            to: CGPoint(x: rect.minX, y: rect.minY + h * 0.35),
            control1: CGPoint(x: cx - w * 0.4, y: rect.maxY - h * 0.1),
            control2: CGPoint(x: rect.minX, y: rect.midY + h * 0.1)
        )
        path.addCubicCurve(
            to: CGPoint(x: cx, y: rect.minY + h * 0.25),
            control1: CGPoint(x: rect.minX, y: rect.minY),
            control2: CGPoint(x: cx - w * 0.2, y: rect.minY)
        )
        path.addCubicCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + h * 0.35),
            control1: CGPoint(x: cx + w * 0.2, y: rect.minY),
            control2: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.addCubicCurve(
            to: CGPoint(x: cx, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.midY + h * 0.1),
            control2: CGPoint(x: cx + w * 0.4, y: rect.maxY - h * 0.1)
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Theme.bgDeep
        HeartLogo(size: 96)
    }
}
