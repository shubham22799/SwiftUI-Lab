//
//  SpinnerTypes.swift
//  PortfolioApp
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

enum SpinnerType: CaseIterable {
    case classic
    case dots
    case pulse
    case wave
    case orbit
    case gradient
    case bounce
    case ripple
    case spiral
    
    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .dots: return "Dots"
        case .pulse: return "Pulse"
        case .wave: return "Wave"
        case .orbit: return "Orbit"
        case .gradient: return "Gradient"
        case .bounce: return "Bounce"
        case .ripple: return "Ripple"
        case .spiral: return "Spiral"
        }
    }
}

struct SpinnerFactory {
    static func createSpinner(
        type: SpinnerType,
        size: Double,
        color: Color,
        strokeWidth: Double,
        speed: Double,
        isAnimating: Bool
    ) -> some View {
        Group {
            switch type {
            case .classic:
                ClassicSpinner(
                    size: size,
                    color: color,
                    strokeWidth: strokeWidth,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .dots:
                DotsSpinner(
                    size: size,
                    color: color,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .pulse:
                PulseSpinner(
                    size: size,
                    color: color,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .wave:
                WaveSpinner(
                    size: size,
                    color: color,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .orbit:
                OrbitSpinner(
                    size: size,
                    color: color,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .gradient:
                GradientSpinner(
                    size: size,
                    color: color,
                    strokeWidth: strokeWidth,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .bounce:
                BounceSpinner(
                    size: size,
                    color: color,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .ripple:
                RippleSpinner(
                    size: size,
                    color: color,
                    speed: speed,
                    isAnimating: isAnimating
                )
            case .spiral:
                SpiralSpinner(
                    size: size,
                    color: color,
                    strokeWidth: strokeWidth,
                    speed: speed,
                    isAnimating: isAnimating
                )
            }
        }
    }
}
