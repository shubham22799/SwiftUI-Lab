//
//  SpinnerComponents.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Classic Spinner
struct ClassicSpinner: View {
    let size: Double
    let color: Color
    let strokeWidth: Double
    let speed: Double
    let isAnimating: Bool
    
    @State private var rotation: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                color,
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                if isAnimating {
                    rotation = 0
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    rotation = 0
                } else {
                    rotation = 0
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    rotation += 360 * 0.016 * speed / 1.0 // Smooth rotation based on speed
                }
            }
    }
}

// MARK: - Dots Spinner
struct DotsSpinner: View {
    let size: Double
    let color: Color
    let speed: Double
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: size * 0.2) {
            ForEach(0..<3, id: \.self) { index in
                DotView(
                    size: size * 0.25,
                    color: color,
                    speed: speed,
                    delay: Double(index) * 0.2,
                    isAnimating: isAnimating
                )
            }
        }
    }
}

struct DotView: View {
    let size: Double
    let color: Color
    let speed: Double
    let delay: Double
    let isAnimating: Bool
    
    @State private var scale: Double = 0.6
    @State private var opacity: Double = 0.4
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                if isAnimating {
                    scale = 0.6
                    opacity = 0.4
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    scale = 0.6
                    opacity = 0.4
                } else {
                    scale = 0.6
                    opacity = 0.4
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    let time = Date().timeIntervalSinceReferenceDate * speed + delay
                    scale = 0.6 + 0.4 * (1 + sin(time * .pi * 1.5)) / 2
                    opacity = 0.4 + 0.6 * (1 + sin(time * .pi * 1.5)) / 2
                }
            }
    }
}

// MARK: - Pulse Spinner
struct PulseSpinner: View {
    let size: Double
    let color: Color
    let speed: Double
    let isAnimating: Bool
    
    @State private var scale: Double = 1
    @State private var opacity: Double = 1
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                if isAnimating {
                    scale = 1.0
                    opacity = 1.0
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    scale = 1.0
                    opacity = 1.0
                } else {
                    scale = 1.0
                    opacity = 1.0
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    let time = Date().timeIntervalSinceReferenceDate * speed
                    scale = 1.0 + 0.3 * (1 + sin(time * .pi)) / 2
                    opacity = 1.0 - 0.4 * (1 + sin(time * .pi)) / 2
                }
            }
    }
}

// MARK: - Wave Spinner
struct WaveSpinner: View {
    let size: Double
    let color: Color
    let speed: Double
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: size * 0.1) {
            ForEach(0..<5, id: \.self) { index in
                WaveBar(
                    width: size * 0.15,
                    maxHeight: size * 0.8,
                    color: color,
                    speed: speed,
                    delay: Double(index) * 0.1,
                    isAnimating: isAnimating
                )
            }
        }
    }
}

struct WaveBar: View {
    let width: Double
    let maxHeight: Double
    let color: Color
    let speed: Double
    let delay: Double
    let isAnimating: Bool
    
    @State private var scaleY: Double = 0.3
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        RoundedRectangle(cornerRadius: width * 0.3)
            .fill(color)
            .frame(width: width, height: maxHeight)
            .scaleEffect(y: scaleY)
            .onAppear {
                if isAnimating {
                    scaleY = 0.3
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    scaleY = 0.3
                } else {
                    scaleY = 0.3
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    let time = Date().timeIntervalSinceReferenceDate * speed + delay
                    scaleY = 0.3 + 0.7 * (1 + sin(time * .pi * 1.67)) / 2
                }
            }
    }
}

// MARK: - Orbit Spinner
struct OrbitSpinner: View {
    let size: Double
    let color: Color
    let speed: Double
    let isAnimating: Bool
    
    @State private var rotation: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 2)
                .frame(width: size, height: size)
            
            Circle()
                .fill(color)
                .frame(width: size * 0.2, height: size * 0.2)
                .offset(x: size * 0.4)
                .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            if isAnimating {
                rotation = 0
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                rotation = 0
            } else {
                rotation = 0
            }
        }
        .onReceive(timer) { _ in
            if isAnimating {
                rotation += 360 * 0.016 * speed / 1.5 // Smooth rotation based on speed
            }
        }
    }
}

// MARK: - Gradient Spinner
struct GradientSpinner: View {
    let size: Double
    let color: Color
    let strokeWidth: Double
    let speed: Double
    let isAnimating: Bool
    
    @State private var rotation: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(
                AngularGradient(
                    colors: [color.opacity(0), color, color, color.opacity(0)],
                    center: .center
                ),
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                if isAnimating {
                    rotation = 0
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    rotation = 0
                } else {
                    rotation = 0
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    rotation += 360 * 0.016 * speed / 1.2 // Smooth rotation based on speed
                }
            }
    }
}

// MARK: - Bounce Spinner
struct BounceSpinner: View {
    let size: Double
    let color: Color
    let speed: Double
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: size * 0.15) {
            ForEach(0..<3, id: \.self) { index in
                BounceBall(
                    size: size * 0.25,
                    color: color,
                    speed: speed,
                    delay: Double(index) * 0.15,
                    bounceHeight: size * 0.4,
                    isAnimating: isAnimating
                )
            }
        }
    }
}

struct BounceBall: View {
    let size: Double
    let color: Color
    let speed: Double
    let delay: Double
    let bounceHeight: Double
    let isAnimating: Bool
    
    @State private var offsetY: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(y: offsetY)
            .onAppear {
                if isAnimating {
                    offsetY = 0
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    offsetY = 0
                } else {
                    offsetY = 0
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    let time = Date().timeIntervalSinceReferenceDate * speed + delay
                    offsetY = -bounceHeight * abs(sin(time * .pi * 1.67))
                }
            }
    }
}

// MARK: - Ripple Spinner
struct RippleSpinner: View {
    let size: Double
    let color: Color
    let speed: Double
    let isAnimating: Bool
    
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(color, lineWidth: 2)
                    .scaleEffect(isAnimating ? 1 + animationProgress + Double(index) * 0.3 : 1)
                    .opacity(isAnimating ? 1 - (animationProgress + Double(index) * 0.3) : 1)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if isAnimating {
                animationProgress = 0
            }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                animationProgress = 0
            } else {
                animationProgress = 0
            }
        }
        .onReceive(timer) { _ in
            if isAnimating {
                let time = Date().timeIntervalSinceReferenceDate * speed
                animationProgress = (time.truncatingRemainder(dividingBy: 1.5 / speed)) / (1.5 / speed)
            }
        }
    }
}

// MARK: - Spiral Spinner
struct SpiralSpinner: View {
    let size: Double
    let color: Color
    let strokeWidth: Double
    let speed: Double
    let isAnimating: Bool
    
    @State private var rotation: Double = 0
    @State private var trimEnd: Double = 1
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60 FPS
    
    var body: some View {
        Circle()
            .trim(from: 0, to: trimEnd)
            .stroke(
                color,
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                if isAnimating {
                    rotation = 0
                    trimEnd = 1
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    rotation = 0
                    trimEnd = 1
                } else {
                    trimEnd = 1
                    rotation = 0
                }
            }
            .onReceive(timer) { _ in
                if isAnimating {
                    let time = Date().timeIntervalSinceReferenceDate * speed
                    rotation += 360 * 0.016 * speed / 2.0 // Smooth rotation based on speed
                    trimEnd = 0.1 + 0.9 * (1 + sin(time * .pi * 2.0)) / 2
                }
            }
    }
}
