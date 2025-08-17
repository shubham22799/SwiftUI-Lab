//
//  ControlsShowcaseView.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Controls Showcase View
struct ControlsShowcaseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedControl: ControlType = .toggle
    @State private var size: Double = 120
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .purple
    @State private var isEnabled: Bool = true
    @State private var toggleValue: Bool = false
    @State private var sliderValue: Double = 0.5
    @State private var stepperValue: Int = 5
    @State private var progressValue: Double = 0.7
    @State private var switchValue: Bool = false
    @State private var segmentedValue: Int = 0
    
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
                
                Text("Custom Controls")
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
                // Control Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    ControlFactory.createControl(
                        type: selectedControl,
                        toggleValue: $toggleValue,
                        sliderValue: $sliderValue,
                        stepperValue: $stepperValue,
                        progressValue: $progressValue,
                        switchValue: $switchValue,
                        segmentedValue: $segmentedValue,
                        size: size,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        isEnabled: isEnabled
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Control Type Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Control Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(ControlType.allCases, id: \.self) { type in
                            ControlTypeCard(
                                type: type,
                                isSelected: selectedControl == type,
                                action: { selectedControl = type }
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
                            Text("Control State")
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
                colors: [.orange.opacity(0.1), .yellow.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Control Type Card
struct ControlTypeCard: View {
    let type: ControlType
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
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .orange : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Control Type Enum
enum ControlType: CaseIterable {
    case toggle, slider, stepper, progress, `switch`, segmented
    
    var displayName: String {
        switch self {
        case .toggle: return "Toggle"
        case .slider: return "Slider"
        case .stepper: return "Stepper"
        case .progress: return "Progress"
        case .switch: return "Switch"
        case .segmented: return "Segmented"
        }
    }
    
    var icon: String {
        switch self {
        case .toggle: return "toggle.on"
        case .slider: return "slider.horizontal.3"
        case .stepper: return "plus.minus"
        case .progress: return "chart.bar.fill"
        case .switch: return "switch.2"
        case .segmented: return "rectangle.split.3x3"
        }
    }
}

// MARK: - Control Factory
struct ControlFactory {
    static func createControl(
        type: ControlType,
        toggleValue: Binding<Bool>,
        sliderValue: Binding<Double>,
        stepperValue: Binding<Int>,
        progressValue: Binding<Double>,
        switchValue: Binding<Bool>,
        segmentedValue: Binding<Int>,
        size: Double,
        primaryColor: Color,
        secondaryColor: Color,
        isEnabled: Bool
    ) -> some View {
        switch type {
        case .toggle:
            AnyView(
                CustomToggle(
                    isOn: toggleValue,
                    size: size,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .slider:
            AnyView(
                CustomSlider(
                    value: sliderValue,
                    range: 0...1,
                    step: 0.01,
                    tint: primaryColor
                )
                .frame(width: size, height: 30)
            )
        case .stepper:
            AnyView(
                CustomStepper(
                    value: stepperValue,
                    size: size,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .progress:
            AnyView(
                CustomProgressBar(
                    value: progressValue.wrappedValue,
                    size: size,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor
                )
            )
        case .switch:
            AnyView(
                CustomSwitch(
                    isOn: switchValue,
                    size: size,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .segmented:
            AnyView(
                CustomSegmentedControl(
                    selection: segmentedValue,
                    size: size,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor
                )
            )
        }
    }
}

// MARK: - Custom Toggle
struct CustomToggle: View {
    @Binding var isOn: Bool
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        Button(action: {
            if isEnabled {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn.toggle()
                }
            }
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: size / 2)
                    .fill(isOn ? primaryColor : secondaryColor.opacity(0.3))
                    .frame(width: size, height: size * 0.6)
                
                // Thumb
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.5, height: size * 0.5)
                    .shadow(radius: 2)
                    .offset(x: isOn ? size * 0.25 : -size * 0.25)
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Custom Stepper
struct CustomStepper: View {
    @Binding var value: Int
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Minus Button
            Button(action: {
                if isEnabled && value > 0 {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        value -= 1
                    }
                }
            }) {
                Image(systemName: "minus")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: size * 0.4, height: size * 0.4)
                    .background(
                        Circle()
                            .fill(primaryColor)
                    )
            }
            .disabled(!isEnabled || value <= 0)
            
            // Value Display
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(width: size * 0.6)
            
            // Plus Button
            Button(action: {
                if isEnabled {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        value += 1
                    }
                }
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: size * 0.4, height: size * 0.4)
                    .background(
                        Circle()
                            .fill(secondaryColor)
                    )
            }
            .disabled(!isEnabled)
        }
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Custom Progress Bar
struct CustomProgressBar: View {
    let value: Double
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: size * 0.1)
                    .fill(secondaryColor.opacity(0.3))
                    .frame(width: size, height: size * 0.2)
                
                // Progress
                RoundedRectangle(cornerRadius: size * 0.1)
                    .fill(
                        LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: size * value, height: size * 0.2)
                    .animation(.easeInOut(duration: 0.5), value: value)
            }
            
            Text("\(Int(value * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Custom Switch
struct CustomSwitch: View {
    @Binding var isOn: Bool
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        Button(action: {
            if isEnabled {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn.toggle()
                }
            }
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: size * 0.3)
                    .fill(isOn ? primaryColor : secondaryColor.opacity(0.3))
                    .frame(width: size, height: size * 0.6)
                
                // Thumb
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.45, height: size * 0.45)
                    .shadow(radius: 2)
                    .offset(x: isOn ? size * 0.275 : -size * 0.275)
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Custom Segmented Control
struct CustomSegmentedControl: View {
    @Binding var selection: Int
    let size: Double
    let primaryColor: Color
    let secondaryColor: Color
    
    private let segments = ["A", "B", "C"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<segments.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = index
                    }
                }) {
                    Text(segments[index])
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(selection == index ? .white : .primary)
                        .frame(width: size / 3, height: size * 0.4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selection == index ? primaryColor : secondaryColor.opacity(0.3))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.regularMaterial)
        )
    }
}

#Preview {
    ControlsShowcaseView()
}
