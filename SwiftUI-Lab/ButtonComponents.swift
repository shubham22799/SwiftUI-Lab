//
//  ButtonComponents.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Gradient Button
struct GradientButton: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let cornerRadius: Double
    let text: String
    let isAnimating: Bool
    
    @State private var isPressed = false
    @State private var gradientRotation: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(text)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size * 0.4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(gradientRotation))
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .shadow(color: primaryColor.opacity(0.3), radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 2 : 4)
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if isAnimating {
                gradientRotation += 0.5
            }
        }
    }
}

// MARK: - Neumorphic Button
struct NeumorphicButton: View {
    let size: Double
    let primaryColor: Color
    let cornerRadius: Double
    let text: String
    let isAnimating: Bool
    
    @State private var isPressed = false
    @State private var shadowOffset: Double = 4
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(text)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundStyle(primaryColor)
                .frame(width: size, height: size * 0.4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.regularMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(primaryColor.opacity(0.2), lineWidth: 1)
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .shadow(color: .black.opacity(0.2), radius: shadowOffset, x: shadowOffset, y: shadowOffset)
                .shadow(color: .white.opacity(0.7), radius: shadowOffset, x: -shadowOffset, y: -shadowOffset)
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if isAnimating {
                shadowOffset = 4 + 2 * sin(Date().timeIntervalSinceReferenceDate * 2)
            }
        }
    }
}

// MARK: - Glassmorphic Button
struct GlassmorphicButton: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let cornerRadius: Double
    let text: String
    let isAnimating: Bool
    
    @State private var isPressed = false
    @State private var blurRadius: Double = 10
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(text)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size * 0.4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [primaryColor.opacity(0.8), secondaryColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .background(.ultraThinMaterial)
                        .blur(radius: blurRadius)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if isAnimating {
                blurRadius = 8 + 4 * sin(Date().timeIntervalSinceReferenceDate * 1.5)
            }
        }
    }
}

// MARK: - Animated Button
struct AnimatedButton: View {
    let size: Double
    let primaryColor: Color
    let cornerRadius: Double
    let text: String
    let isAnimating: Bool
    
    @State private var isPressed = false
    @State private var pulseScale: Double = 1.0
    @State private var rotationAngle: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            ZStack {
                // Pulse ring
                Circle()
                    .stroke(primaryColor.opacity(0.3), lineWidth: 2)
                    .scaleEffect(pulseScale)
                    .opacity(2 - pulseScale)
                
                // Main button
                Text(text)
                    .font(.system(size: size * 0.15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: size * 0.8, height: size * 0.4)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(primaryColor)
                    )
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .rotationEffect(.degrees(rotationAngle))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if isAnimating {
                pulseScale = 1.0 + 0.5 * sin(Date().timeIntervalSinceReferenceDate * 3)
                rotationAngle += 0.5
            }
        }
    }
}

// MARK: - Floating Button
struct FloatingButton: View {
    let size: Double
    let primaryColor: Color
    let cornerRadius: Double
    let text: String
    let isAnimating: Bool
    
    @State private var isPressed = false
    @State private var floatOffset: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(text)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size * 0.4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(primaryColor)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .offset(y: floatOffset)
                .shadow(color: primaryColor.opacity(0.4), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if isAnimating {
                floatOffset = 5 * sin(Date().timeIntervalSinceReferenceDate * 2)
            }
        }
    }
}

// MARK: - Morphing Button
struct MorphingButton: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let cornerRadius: Double
    let text: String
    let isAnimating: Bool
    
    @State private var isPressed = false
    @State private var morphProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(text)
                .font(.system(size: size * 0.15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size * 0.4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                startPoint: UnitPoint(x: morphProgress, y: 0),
                                endPoint: UnitPoint(x: 1 - morphProgress, y: 1)
                            )
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .clipShape(
                    RoundedRectangle(cornerRadius: cornerRadius + 10 * sin(morphProgress * .pi))
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if isAnimating {
                morphProgress = (Date().timeIntervalSinceReferenceDate * 0.5).truncatingRemainder(dividingBy: 1.0)
            }
        }
    }
}
