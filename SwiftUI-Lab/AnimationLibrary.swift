//
//  AnimationLibrary.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

struct AnimationLibrary {
    
    // MARK: - Easing Curves
    enum EasingCurve {
        case linear
        case easeIn
        case easeOut
        case easeInOut
        case spring
        case bouncy
        case smooth
        
        func animation(duration: Double) -> Animation {
            switch self {
            case .linear:
                return .linear(duration: duration)
            case .easeIn:
                return .easeIn(duration: duration)
            case .easeOut:
                return .easeOut(duration: duration)
            case .easeInOut:
                return .easeInOut(duration: duration)
            case .spring:
                return .spring(response: duration, dampingFraction: 0.8, blendDuration: 0)
            case .bouncy:
                return .spring(response: duration, dampingFraction: 0.6, blendDuration: 0)
            case .smooth:
                return .smooth(duration: duration)
            }
        }
        
        var displayName: String {
            switch self {
            case .linear: return "Linear"
            case .easeIn: return "Ease In"
            case .easeOut: return "Ease Out"
            case .easeInOut: return "Ease In-Out"
            case .spring: return "Spring"
            case .bouncy: return "Bouncy"
            case .smooth: return "Smooth"
            }
        }
    }
    
    // MARK: - Animation Presets
    static let fastRotation = Animation.linear(duration: 0.5).repeatForever(autoreverses: false)
    static let mediumRotation = Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
    static let slowRotation = Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
    
    static let quickPulse = Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
    static let mediumPulse = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
    static let slowPulse = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    
    static let bouncySpring = Animation.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)
    static let softSpring = Animation.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 0)
    
    // MARK: - Transition Effects
    static let slideTransition = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
    
    static let scaleTransition = AnyTransition.scale.combined(with: .opacity)
    
    static let cardFlipTransition = AnyTransition.asymmetric(
        insertion: .scale.combined(with: .opacity),
        removal: .scale.combined(with: .opacity)
    )
}

// MARK: - Custom Animation Modifiers
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    let duration: Double
    let amplitude: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.3), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: phase)
                    .clipped()
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = amplitude
                }
            }
    }
}

struct FloatingEffect: ViewModifier {
    @State private var isFloating = false
    let amplitude: CGFloat
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -amplitude : amplitude)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}

struct BreathingEffect: ViewModifier {
    @State private var isBreathing = false
    let scale: CGFloat
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isBreathing ? scale : 1.0)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isBreathing
            )
            .onAppear {
                isBreathing = true
            }
    }
}

// MARK: - Extension for easy access
extension View {
    func shimmer(duration: Double = 2.0, amplitude: CGFloat = 200) -> some View {
        self.modifier(ShimmerEffect(duration: duration, amplitude: amplitude))
    }
    
    func floating(amplitude: CGFloat = 10, duration: Double = 2.0) -> some View {
        self.modifier(FloatingEffect(amplitude: amplitude, duration: duration))
    }
    
    func breathing(scale: CGFloat = 1.1, duration: Double = 2.0) -> some View {
        self.modifier(BreathingEffect(scale: scale, duration: duration))
    }
    
    func glowEffect(color: Color = .blue, radius: CGFloat = 20) -> some View {
        self
            .background(
                self
                    .blur(radius: radius / 2)
                    .opacity(0.8)
            )
            .background(
                self
                    .blur(radius: radius)
                    .opacity(0.6)
            )
    }
}
