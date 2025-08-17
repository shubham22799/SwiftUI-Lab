//
//  SpinnerShowcaseView.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Custom Slider with Tap-to-Position
struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let tint: Color
    
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 8)
                
                // Filled Track
                RoundedRectangle(cornerRadius: 4)
                    .fill(tint)
                    .frame(width: trackWidth(in: geometry), height: 8)
                
                // Thumb
                Circle()
                    .fill(tint)
                    .frame(width: 20, height: 20)
                    .shadow(radius: isDragging ? 4 : 2)
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .offset(x: thumbOffset(in: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDragging = true
                                updateValue(from: gesture.location.x, in: geometry)
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                updateValue(from: location.x, in: geometry)
            }
        }
        .frame(height: 20)
    }
    
    private func trackWidth(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percentage)
    }
    
    private func thumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percentage) - 10
    }
    
    private func updateValue(from xPosition: CGFloat, in geometry: GeometryProxy) {
        let percentage = xPosition / geometry.size.width
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
        let steppedValue = round(newValue / step) * step
        value = max(range.lowerBound, min(range.upperBound, steppedValue))
    }
}

struct SpinnerShowcaseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpinner = SpinnerType.classic
    @State private var animationSpeed: Double = 1.0
    @State private var spinnerSize: Double = 50.0
    @State private var spinnerColor: Color = .blue
    @State private var strokeWidth: Double = 4.0
    @State private var isAnimating = true
    
    let spinnerTypes = SpinnerType.allCases
    
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
                
                Text("Loading Spinners")
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
                // Spinner Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    SpinnerFactory.createSpinner(
                        type: selectedSpinner,
                        size: spinnerSize,
                        color: spinnerColor,
                        strokeWidth: strokeWidth,
                        speed: animationSpeed,
                        isAnimating: isAnimating
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Spinner Type Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Spinner Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                        ForEach(SpinnerType.allCases, id: \.self) { type in
                            SpinnerTypeCard(
                                type: type,
                                isSelected: selectedSpinner == type,
                                action: { selectedSpinner = type }
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
                        // Size Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Size: \(Int(spinnerSize))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $spinnerSize,
                                range: 20...100,
                                step: 5,
                                tint: .blue
                            )
                        }
                        
                        // Speed Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Speed: \(String(format: "%.1f", animationSpeed))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $animationSpeed,
                                range: 0.1...3.0,
                                step: 0.1,
                                tint: .green
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right Column - Colors
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Primary Color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            ColorPicker("", selection: $spinnerColor)
                                .labelsHidden()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Secondary Color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            ColorPicker("", selection: $spinnerColor)
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
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

struct SpinnerTypeCard: View {
    let type: SpinnerType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                SpinnerFactory.createSpinner(
                    type: type,
                    size: 30,
                    color: isSelected ? .white : .primary,
                    strokeWidth: 2,
                    speed: 1.0,
                    isAnimating: true
                )
                
                Text(type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
                                .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.blue : Color.clear)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                    )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .blue : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        SpinnerShowcaseView()
    }
}
