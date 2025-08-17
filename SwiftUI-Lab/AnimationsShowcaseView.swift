//
//  AnimationsShowcaseView.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Animations Showcase View
struct AnimationsShowcaseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedAnimation: AnimationType = .spring
    @State private var animationDuration: Double = 1.0
    @State private var animationDelay: Double = 0.0
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .purple
    @State private var isAnimating: Bool = true
    @State private var animationIntensity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                Text("Animations & Transitions")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { isAnimating.toggle() }) {
                    Image(systemName: isAnimating ? "pause.fill" : "play.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.regularMaterial)
            
            // Top Half - Preview Area (takes maximum space)
            VStack(spacing: 16) {
                // Animation Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    AnimationFactory.createAnimation(
                        type: selectedAnimation,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        duration: animationDuration,
                        delay: animationDelay,
                        intensity: animationIntensity,
                        isAnimating: isAnimating
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Animation Type Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Animation Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(AnimationType.allCases, id: \.self) { type in
                            AnimationTypeCard(
                                type: type,
                                isSelected: selectedAnimation == type,
                                action: { selectedAnimation = type }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Bottom Half - Options Area (takes minimal space needed)
            VStack(spacing: 12) {
                Text("Customization Options")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 16) {
                    // Left Column - Animation Controls
                    VStack(spacing: 12) {
                        // Duration Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Duration: \(String(format: "%.1f", animationDuration))s")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $animationDuration,
                                range: 0.1...3.0,
                                step: 0.1,
                                tint: .blue
                            )
                        }
                        
                        // Delay Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Delay: \(String(format: "%.1f", animationDelay))s")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $animationDelay,
                                range: 0.0...2.0,
                                step: 0.1,
                                tint: .green
                            )
                        }
                        
                        // Intensity Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Intensity: \(String(format: "%.1f", animationIntensity))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $animationIntensity,
                                range: 0.1...3.0,
                                step: 0.1,
                                tint: .orange
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right Column - Colors and Animation State
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Primary Color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            ColorPicker("", selection: $primaryColor)
                                .labelsHidden()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Secondary Color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            ColorPicker("", selection: $secondaryColor)
                                .labelsHidden()
                        }
                        
                        // Animation State Toggle
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Animation State")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text(isAnimating ? "Animating" : "Static")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Button(action: { isAnimating.toggle() }) {
                                    Text(isAnimating ? "Stop" : "Start")
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(isAnimating ? .red.opacity(0.2) : .green.opacity(0.2))
                                        .foregroundStyle(isAnimating ? .red : .green)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .background(.ultraThinMaterial)
        }
        .navigationBarHidden(true)
        .background(
            LinearGradient(
                colors: [.purple.opacity(0.1), .pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Animation Type Card
struct AnimationTypeCard: View {
    let type: AnimationType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .blue : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Animation Types
enum AnimationType: CaseIterable {
    case spring, bounce, shake, pulse, rotate, scale, slide, morph, wave, elastic
    
    var displayName: String {
        switch self {
        case .spring: return "Spring"
        case .bounce: return "Bounce"
        case .shake: return "Shake"
        case .pulse: return "Pulse"
        case .rotate: return "Rotate"
        case .scale: return "Scale"
        case .slide: return "Slide"
        case .morph: return "Morph"
        case .wave: return "Wave"
        case .elastic: return "Elastic"
        }
    }
    
    var icon: String {
        switch self {
        case .spring: return "arrow.up.and.down"
        case .bounce: return "arrow.up.circle"
        case .shake: return "arrow.left.and.right"
        case .pulse: return "heart.fill"
        case .rotate: return "arrow.clockwise"
        case .scale: return "arrow.up.left.and.arrow.down.right"
        case .slide: return "arrow.left.and.right.circle"
        case .morph: return "sparkles"
        case .wave: return "waveform"
        case .elastic: return "arrow.up.and.down.circle"
        }
    }
}

// MARK: - Animation Factory
struct AnimationFactory {
    static func createAnimation(
        type: AnimationType,
        primaryColor: Color,
        secondaryColor: Color,
        duration: Double,
        delay: Double,
        intensity: Double,
        isAnimating: Bool
    ) -> some View {
        Group {
            switch type {
            case .spring:
                SpringAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .bounce:
                BounceAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .shake:
                ShakeAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .pulse:
                PulseAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .rotate:
                RotateAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .scale:
                ScaleAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .slide:
                SlideAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .morph:
                MorphAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .wave:
                WaveAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            case .elastic:
                ElasticAnimation(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    duration: duration,
                    delay: delay,
                    intensity: intensity,
                    isAnimating: isAnimating
                )
            }
        }
    }
}

// MARK: - Individual Animation Views
struct SpringAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60, height: 60)
            .offset(y: offset)
            .scaleEffect(scale)
            .animation(
                isAnimating ?
                Animation.spring(
                    response: duration,
                    dampingFraction: 0.6 / intensity,
                    blendDuration: 0
                )
                .delay(delay)
                .repeatForever(autoreverses: true) :
                .default,
                value: offset
            )
            .onAppear {
                if isAnimating {
                    offset = -30 * intensity
                    scale = 1.2
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    offset = -30 * intensity
                    scale = 1.2
                } else {
                    offset = 0
                    scale = 1.0
                }
            }
    }
}

struct BounceAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var offset: CGFloat = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 80, height: 40)
            .offset(y: offset)
            .rotationEffect(.degrees(rotation))
            .animation(
                isAnimating ?
                Animation.easeInOut(duration: duration)
                    .delay(delay)
                    .repeatForever(autoreverses: true) :
                .default,
                value: offset
            )
            .onAppear {
                if isAnimating {
                    offset = -40 * intensity
                    rotation = 15 * intensity
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    offset = -40 * intensity
                    rotation = 15 * intensity
                } else {
                    offset = 0
                    rotation = 0
                }
            }
    }
}

struct ShakeAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60, height: 60)
            .offset(x: offset)
            .animation(
                isAnimating ?
                Animation.easeInOut(duration: duration)
                    .delay(delay)
                    .repeatForever(autoreverses: true) :
                .default,
                value: offset
            )
            .onAppear {
                if isAnimating {
                    offset = 20 * intensity
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    offset = 20 * intensity
                } else {
                    offset = 0
                }
            }
    }
}

struct PulseAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60, height: 60)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(
                isAnimating ?
                Animation.easeInOut(duration: duration)
                    .delay(delay)
                    .repeatForever(autoreverses: true) :
                .default,
                value: scale
            )
            .onAppear {
                if isAnimating {
                    scale = 1.5 * intensity
                    opacity = 0.3
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    scale = 1.5 * intensity
                    opacity = 0.3
                } else {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

struct RotateAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 60 + CGFloat(index * 20), height: 60 + CGFloat(index * 20))
                    .rotationEffect(.degrees(rotation))
                    .animation(
                        isAnimating ?
                        Animation.linear(duration: duration)
                            .delay(delay + Double(index) * 0.1)
                            .repeatForever(autoreverses: false) :
                        .default,
                        value: rotation
                    )
            }
        }
        .onAppear {
            if isAnimating {
                rotation = 360 * intensity
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                rotation = 360 * intensity
            } else {
                rotation = 0
            }
        }
    }
}

struct ScaleAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 70, height: 50)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .animation(
                isAnimating ?
                Animation.easeInOut(duration: duration)
                    .delay(delay)
                    .repeatForever(autoreverses: true) :
                .default,
                value: scale
            )
            .onAppear {
                if isAnimating {
                    scale = 1.3 * intensity
                    rotation = 5 * intensity
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    scale = 1.3 * intensity
                    rotation = 5 * intensity
                } else {
                    scale = 1.0
                    rotation = 0
                }
            }
    }
}

struct SlideAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 20, height: 20)
                    .offset(x: offset)
                    .opacity(opacity)
                    .animation(
                        isAnimating ?
                        Animation.easeInOut(duration: duration)
                            .delay(delay + Double(index) * 0.1)
                            .repeatForever(autoreverses: true) :
                        .default,
                        value: offset
                    )
            }
        }
        .onAppear {
            if isAnimating {
                offset = 30 * intensity
                opacity = 0.5
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                offset = 30 * intensity
                opacity = 0.5
            } else {
                offset = 0
                opacity = 1.0
            }
        }
    }
}

struct MorphAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var morphProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .scaleEffect(x: 1 + morphProgress * 0.3, y: 1 - morphProgress * 0.3)
                .rotationEffect(.degrees(morphProgress * 45))
                .animation(
                    isAnimating ?
                    Animation.easeInOut(duration: duration)
                        .delay(delay)
                        .repeatForever(autoreverses: true) :
                    .default,
                    value: morphProgress
                )
        }
        .onAppear {
            if isAnimating {
                morphProgress = 1.0 * intensity
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                morphProgress = 1.0 * intensity
            } else {
                morphProgress = 0
            }
        }
    }
}

struct WaveAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 4, height: 20 + waveOffset)
                    .animation(
                        isAnimating ?
                        Animation.easeInOut(duration: duration)
                            .delay(delay + Double(index) * 0.1)
                            .repeatForever(autoreverses: true) :
                        .default,
                        value: waveOffset
                    )
            }
        }
        .onAppear {
            if isAnimating {
                waveOffset = 20 * intensity
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                waveOffset = 20 * intensity
            } else {
                waveOffset = 0
            }
        }
    }
}

struct ElasticAnimation: View {
    let primaryColor: Color
    let secondaryColor: Color
    let duration: Double
    let delay: Double
    let intensity: Double
    let isAnimating: Bool
    
    @State private var elasticScale: CGFloat = 1.0
    @State private var elasticRotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<2) { index in
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 60 + CGFloat(index * 20), height: 40 + CGFloat(index * 20))
                    .scaleEffect(elasticScale)
                    .rotationEffect(.degrees(elasticRotation))
                    .animation(
                        isAnimating ?
                        Animation.spring(
                            response: duration,
                            dampingFraction: 0.3 / intensity,
                            blendDuration: 0
                        )
                        .delay(delay + Double(index) * 0.1)
                        .repeatForever(autoreverses: true) :
                        .default,
                        value: elasticScale
                    )
            }
        }
        .onAppear {
            if isAnimating {
                elasticScale = 1.4 * intensity
                elasticRotation = 10 * intensity
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                elasticScale = 1.4 * intensity
                elasticRotation = 10 * intensity
            } else {
                elasticScale = 1.0
                elasticRotation = 0
            }
        }
    }
}
