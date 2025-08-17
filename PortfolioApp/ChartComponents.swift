//
//  ChartComponents.swift
//  PortfolioApp
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Bar Chart
struct BarChart: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let dataPoints: Int
    let isAnimating: Bool
    let animationSpeed: Double
    
    @State private var barHeights: [Double] = []
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: size * 0.05) {
            ForEach(0..<dataPoints, id: \.self) { index in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index % 2 == 0 ? primaryColor : secondaryColor)
                        .frame(
                            width: size * 0.1,
                            height: size * 0.3 * (barHeights[safe: index] ?? 0.5)
                        )
                        .scaleEffect(y: animationProgress, anchor: .bottom)
                    
                    Text("\(index + 1)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: size, height: size * 0.6)
        .onAppear {
            generateRandomData()
        }
        .onReceive(timer) { _ in
            if isAnimating {
                animationProgress = min(1.0, animationProgress + 0.02 * animationSpeed)
            }
        }
    }
    
    private func generateRandomData() {
        barHeights = (0..<dataPoints).map { _ in Double.random(in: 0.3...1.0) }
    }
}

// MARK: - Line Chart
struct LineChart: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let dataPoints: Int
    let isAnimating: Bool
    let animationSpeed: Double
    
    @State private var dataValues: [Double] = []
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Grid lines
            VStack(spacing: size * 0.1) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(.secondary.opacity(0.2))
                        .frame(height: 1)
                }
            }
            
            // Line path
            Path { path in
                let step = size * 0.8 / Double(dataPoints - 1)
                let maxHeight = size * 0.6
                
                for (index, value) in dataValues.enumerated() {
                    let x = size * 0.1 + Double(index) * step
                    let y = size * 0.8 - value * maxHeight
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(
                LinearGradient(colors: [primaryColor, secondaryColor], startPoint: .leading, endPoint: .trailing),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .scaleEffect(x: animationProgress, anchor: .leading)
            
            // Data points
            ForEach(0..<dataPoints, id: \.self) { index in
                Circle()
                    .fill(index % 2 == 0 ? primaryColor : secondaryColor)
                    .frame(width: 8, height: 8)
                    .position(
                        x: size * 0.1 + (size * 0.8 / Double(dataPoints - 1)) * Double(index),
                        y: size * 0.8 - (dataValues[safe: index] ?? 0.5) * size * 0.6
                    )
                    .scaleEffect(animationProgress)
            }
        }
        .frame(width: size, height: size * 0.8)
        .onAppear {
            generateRandomData()
        }
        .onReceive(timer) { _ in
            if isAnimating {
                animationProgress = min(1.0, animationProgress + 0.015 * animationSpeed)
            }
        }
    }
    
    private func generateRandomData() {
        dataValues = (0..<dataPoints).map { _ in Double.random(in: 0.2...0.8) }
    }
}

// MARK: - Pie Chart
struct PieChart: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let accentColor: Color
    let dataPoints: Int
    let isAnimating: Bool
    let animationSpeed: Double
    
    @State private var dataValues: [Double] = []
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ForEach(0..<min(dataPoints, 3), id: \.self) { index in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: [primaryColor, secondaryColor, accentColor][index],
                    size: size * 0.4
                )
                .scaleEffect(animationProgress)
                .rotationEffect(.degrees(animationProgress * 360))
            }
        }
        .frame(width: size, height: size * 0.8)
        .onAppear {
            generateRandomData()
        }
        .onReceive(timer) { _ in
            if isAnimating {
                animationProgress = min(1.0, animationProgress + 0.01 * animationSpeed)
            }
        }
    }
    
    private func generateRandomData() {
        dataValues = (0..<3).map { _ in Double.random(in: 0.2...0.4) }
        let total = dataValues.reduce(0, +)
        dataValues = dataValues.map { $0 / total }
    }
    
    private func startAngle(for index: Int) -> Double {
        let previousValues = dataValues.prefix(index).reduce(0, +)
        return previousValues * 360
    }
    
    private func endAngle(for index: Int) -> Double {
        let currentValue = dataValues[safe: index] ?? 0
        let previousValues = dataValues.prefix(index).reduce(0, +)
        return (previousValues + currentValue) * 360
    }
}

// MARK: - Pie Slice
struct PieSlice: View {
    let startAngle: Double
    let endAngle: Double
    let color: Color
    let size: Double
    
    var body: some View {
        Path { path in
            path.move(to: .zero)
            path.addArc(center: .zero, radius: size, startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), clockwise: false)
            path.closeSubpath()
        }
        .fill(color)
    }
}

// MARK: - Area Chart
struct AreaChart: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let dataPoints: Int
    let isAnimating: Bool
    let animationSpeed: Double
    
    @State private var dataValues: [Double] = []
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Grid lines
            VStack(spacing: size * 0.1) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(.secondary.opacity(0.2))
                        .frame(height: 1)
                }
            }
            
            // Area path
            Path { path in
                let step = size * 0.8 / Double(dataPoints - 1)
                let maxHeight = size * 0.6
                
                path.move(to: CGPoint(x: size * 0.1, y: size * 0.8))
                
                for (index, value) in dataValues.enumerated() {
                    let x = size * 0.1 + Double(index) * step
                    let y = size * 0.8 - value * maxHeight
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                path.addLine(to: CGPoint(x: size * 0.9, y: size * 0.8))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [primaryColor.opacity(0.6), secondaryColor.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .scaleEffect(y: animationProgress, anchor: .bottom)
        }
        .frame(width: size, height: size * 0.8)
        .onAppear {
            generateRandomData()
        }
        .onReceive(timer) { _ in
            if isAnimating {
                animationProgress = min(1.0, animationProgress + 0.02 * animationSpeed)
            }
        }
    }
    
    private func generateRandomData() {
        dataValues = (0..<dataPoints).map { _ in Double.random(in: 0.2...0.8) }
    }
}

// MARK: - Radar Chart
struct RadarChart: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let dataPoints: Int
    let isAnimating: Bool
    let animationSpeed: Double
    
    @State private var dataValues: [Double] = []
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Radar grid
            ForEach(0..<5, id: \.self) { ring in
                Circle()
                    .stroke(.secondary.opacity(0.2), lineWidth: 1)
                    .frame(width: size * 0.4 * Double(ring + 1) / 5, height: size * 0.4 * Double(ring + 1) / 5)
            }
            
            // Radar lines
            ForEach(0..<dataPoints, id: \.self) { index in
                let angle = Double(index) * 2 * .pi / Double(dataPoints)
                Rectangle()
                    .fill(.secondary.opacity(0.2))
                    .frame(width: 1, height: size * 0.2)
                    .rotationEffect(.radians(angle))
            }
            
            // Data polygon
            Path { path in
                for (index, value) in dataValues.enumerated() {
                    let angle = Double(index) * 2 * .pi / Double(dataPoints)
                    let radius = size * 0.15 * value * animationProgress
                    let x = cos(angle) * radius
                    let y = sin(angle) * radius
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
            }
            .fill(primaryColor.opacity(0.3))
            .stroke(primaryColor, lineWidth: 2)
        }
        .frame(width: size, height: size * 0.8)
        .onAppear {
            generateRandomData()
        }
        .onReceive(timer) { _ in
            if isAnimating {
                animationProgress = min(1.0, animationProgress + 0.015 * animationSpeed)
            }
        }
    }
    
    private func generateRandomData() {
        dataValues = (0..<dataPoints).map { _ in Double.random(in: 0.3...1.0) }
    }
}

// MARK: - Scatter Chart
struct ScatterChart: View {
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let dataPoints: Int
    let isAnimating: Bool
    let animationSpeed: Double
    
    @State private var scatterPoints: [CGPoint] = []
    @State private var animationProgress: Double = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Grid lines
            VStack(spacing: size * 0.1) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(.secondary.opacity(0.2))
                        .frame(height: 1)
                }
            }
            
            HStack(spacing: size * 0.1) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(.secondary.opacity(0.2))
                        .frame(width: 1, height: size * 0.6)
                }
            }
            
            // Scatter points
            ForEach(0..<dataPoints, id: \.self) { index in
                Circle()
                    .fill(index % 2 == 0 ? primaryColor : secondaryColor)
                    .frame(width: 8, height: 8)
                                            .position(
                            x: size * 0.1 + (scatterPoints[safe: index]?.x ?? 0) * size * 0.8,
                            y: size * 0.8 - (scatterPoints[safe: index]?.y ?? 0) * size * 0.6
                        )
                    .scaleEffect(animationProgress)
                    .opacity(animationProgress)
            }
        }
        .frame(width: size, height: size * 0.8)
        .onAppear {
            generateRandomData()
        }
        .onReceive(timer) { _ in
            if isAnimating {
                animationProgress = min(1.0, animationProgress + 0.02 * animationSpeed)
            }
        }
    }
    
    private func generateRandomData() {
        scatterPoints = (0..<dataPoints).map { _ in
            CGPoint(
                x: Double.random(in: 0.1...0.9),
                y: Double.random(in: 0.1...0.9)
            )
        }
    }
}

// MARK: - Array Extension for Safe Access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
