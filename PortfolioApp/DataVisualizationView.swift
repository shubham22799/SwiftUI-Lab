//
//  DataVisualizationView.swift
//  PortfolioApp
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Data Visualization Showcase View
struct DataVisualizationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedChart: ChartType = .bar
    @State private var chartSize: Double = 200
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .green
    @State private var accentColor: Color = .orange
    @State private var isAnimating: Bool = true
    @State private var dataPoints: Double = 5
    @State private var animationSpeed: Double = 1.0
    
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
                
                Text("Data Visualization")
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
                // Chart Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    ChartFactory.createChart(
                        type: selectedChart,
                        size: 200,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        accentColor: .orange,
                        dataPoints: Int(dataPoints),
                        isAnimating: isAnimating,
                        animationSpeed: 1.0
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Chart Type Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Chart Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(ChartType.allCases, id: \.self) { type in
                            ChartTypeCard(
                                type: type,
                                isSelected: selectedChart == type,
                                action: { selectedChart = type }
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
                    // Left Column - Basic Controls
                    VStack(spacing: 12) {
                        // Data Points Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Data Points: \(Int(dataPoints))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $dataPoints,
                                range: 3...20,
                                step: 1,
                                tint: .blue
                            )
                        }
                        
                        // Animation Toggle
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
                    
                    // Right Column - Colors
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
                colors: [.red.opacity(0.1), .orange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Chart Types
enum ChartType: CaseIterable {
    case bar, line, pie, area, radar, scatter
    
    var displayName: String {
        switch self {
        case .bar: return "Bar"
        case .line: return "Line"
        case .pie: return "Pie"
        case .area: return "Area"
        case .radar: return "Radar"
        case .scatter: return "Scatter"
        }
    }
}

// MARK: - Chart Factory
struct ChartFactory {
    static func createChart(
        type: ChartType,
        size: Double,
        primaryColor: Color,
        secondaryColor: Color,
        accentColor: Color,
        dataPoints: Int,
        isAnimating: Bool,
        animationSpeed: Double
    ) -> some View {
        Group {
            switch type {
            case .bar:
                BarChart(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, dataPoints: dataPoints, isAnimating: isAnimating, animationSpeed: animationSpeed)
            case .line:
                LineChart(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, dataPoints: dataPoints, isAnimating: isAnimating, animationSpeed: animationSpeed)
            case .pie:
                PieChart(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, accentColor: accentColor, dataPoints: dataPoints, isAnimating: isAnimating, animationSpeed: animationSpeed)
            case .area:
                AreaChart(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, dataPoints: dataPoints, isAnimating: isAnimating, animationSpeed: animationSpeed)
            case .radar:
                RadarChart(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, dataPoints: dataPoints, isAnimating: isAnimating, animationSpeed: animationSpeed)
            case .scatter:
                ScatterChart(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, dataPoints: dataPoints, isAnimating: isAnimating, animationSpeed: animationSpeed)
            }
        }
    }
}

// MARK: - Chart Type Card
struct ChartTypeCard: View {
    let type: ChartType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .red : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
