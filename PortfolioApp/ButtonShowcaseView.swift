//
//  ButtonShowcaseView.swift
//  PortfolioApp
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Button Showcase View
struct ButtonShowcaseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedButton: ButtonType = .gradient
    @State private var size: Double = 120
    @State private var cornerRadius: Double = 12
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .purple
    @State private var isEnabled: Bool = true
    @State private var isAnimating: Bool = true
    @State private var buttonText: String = "Tap Me!"
    
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
                
                Text("Interactive Buttons")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { isEnabled.toggle() }) {
                    Image(systemName: isEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(isEnabled ? .green : .red)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.regularMaterial)
            
            // Top Half - Preview Area (takes maximum space)
            VStack(spacing: 16) {
                // Button Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    ButtonFactory.createButton(
                        type: selectedButton,
                        size: size,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        isEnabled: isEnabled
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Button Type Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Button Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(ButtonType.allCases, id: \.self) { type in
                            ButtonTypeCard(
                                type: type,
                                isSelected: selectedButton == type,
                                action: { selectedButton = type }
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
                            Text("Size: \(Int(size))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $size,
                                range: 100...300,
                                step: 10,
                                tint: .blue
                            )
                        }
                        
                        // Enabled/Disabled Toggle
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Button State")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text(isEnabled ? "Enabled" : "Disabled")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Button(action: { isEnabled.toggle() }) {
                                    Text(isEnabled ? "Disable" : "Enable")
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(isEnabled ? .red.opacity(0.2) : .green.opacity(0.2))
                                        .foregroundStyle(isEnabled ? .red : .green)
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
                colors: [.green.opacity(0.1), .blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Button Types
enum ButtonType: CaseIterable {
    case gradient, neumorphic, glassmorphism, animated, floating, morphing
    
    var displayName: String {
        switch self {
        case .gradient: return "Gradient"
        case .neumorphic: return "Neumorphic"
        case .glassmorphism: return "Glass"
        case .animated: return "Animated"
        case .floating: return "Floating"
        case .morphing: return "Morphing"
        }
    }
}

// MARK: - Button Factory
struct ButtonFactory {
    static func createButton(
        type: ButtonType,
        size: Double,
        primaryColor: Color,
        secondaryColor: Color,
        isEnabled: Bool
    ) -> some View {
        Group {
            switch type {
            case .gradient:
                GradientButton(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, cornerRadius: 12, text: "Tap Me!", isAnimating: true)
            case .neumorphic:
                NeumorphicButton(size: size, primaryColor: primaryColor, cornerRadius: 12, text: "Tap Me!", isAnimating: true)
            case .glassmorphism:
                GlassmorphicButton(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, cornerRadius: 12, text: "Tap Me!", isAnimating: true)
            case .animated:
                AnimatedButton(size: size, primaryColor: primaryColor, cornerRadius: 12, text: "Tap Me!", isAnimating: true)
            case .floating:
                FloatingButton(size: size, primaryColor: primaryColor, cornerRadius: 12, text: "Tap Me!", isAnimating: true)
            case .morphing:
                MorphingButton(size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, cornerRadius: 12, text: "Tap Me!", isAnimating: true)
            }
        }
    }
}

// MARK: - Button Type Card
struct ButtonTypeCard: View {
    let type: ButtonType
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
                    .fill(isSelected ? .blue : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


