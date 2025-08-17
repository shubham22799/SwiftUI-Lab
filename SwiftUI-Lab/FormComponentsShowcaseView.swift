//
//  FormComponentsShowcaseView.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Form Components Showcase View
struct FormComponentsShowcaseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedComponent: FormComponentType = .textField
    @State private var textFieldValue: String = ""
    @State private var singleSelection: String = "Option 1"
    @State private var multiSelection: Set<String> = ["Option 1"]
    @State private var menuSelection: String = "Menu Item 1"
    @State private var fieldStyle: FieldStyle = .floating
    @State private var animationDuration: Double = 0.5
    @State private var isEnabled: Bool = true
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .purple
    
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
                
                Text("Form Components")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { isEnabled.toggle() }) {
                    Image(systemName: isEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.regularMaterial)
            
            // Top Half - Preview Area (takes maximum space)
            VStack(spacing: 16) {
                // Component Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    FormComponentFactory.createComponent(
                        type: selectedComponent,
                        textFieldValue: $textFieldValue,
                        singleSelection: $singleSelection,
                        multiSelection: $multiSelection,
                        menuSelection: $menuSelection,
                        fieldStyle: fieldStyle,
                        animationDuration: animationDuration,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        isEnabled: isEnabled
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Component Type Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Component Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(FormComponentType.allCases, id: \.self) { type in
                            FormComponentTypeCard(
                                type: type,
                                isSelected: selectedComponent == type,
                                action: { selectedComponent = type }
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
                        // Animation Type Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Field Style")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Picker("Field Style", selection: $fieldStyle) {
                                ForEach(FieldStyle.allCases, id: \.self) { style in
                                    Text(style.displayName).tag(style)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Animation Duration Control
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Duration: \(String(format: "%.1f", animationDuration))s")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            CustomSlider(
                                value: $animationDuration,
                                range: 0.1...2.0,
                                step: 0.1,
                                tint: .blue
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right Column - Colors and Info
                    VStack(spacing: 12) {
                        // Color Picker
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
                        
                        // Info Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Component Info")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Type: \(selectedComponent.displayName)")
                                Text("Field Style: \(fieldStyle.displayName)")
                                Text("Duration: \(String(format: "%.1f", animationDuration))s")
                                Text("Status: \(isEnabled ? "Enabled" : "Disabled")")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
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

// MARK: - Form Component Types
enum FormComponentType: String, CaseIterable, Identifiable {
    case textField = "Text Field"
    case singleSelect = "Single Select"
    case multiSelect = "Multi Select"
    case menu = "Menu"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .textField: return "textformat"
        case .singleSelect: return "checkmark.circle"
        case .multiSelect: return "checkmark.circle.fill"
        case .menu: return "list.bullet"
        }
    }
}

// MARK: - Field Styles
enum FieldStyle: String, CaseIterable, Identifiable {
    case floating = "Floating"
    case outlined = "Outlined"
    case filled = "Filled"
    case minimal = "Minimal"
    case gradient = "Gradient"
    case glassmorphism = "Glass"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
}

// MARK: - Form Component Type Card
struct FormComponentTypeCard: View {
    let type: FormComponentType
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
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Form Component Factory
struct FormComponentFactory {
    static func createComponent(
        type: FormComponentType,
        textFieldValue: Binding<String>,
        singleSelection: Binding<String>,
        multiSelection: Binding<Set<String>>,
        menuSelection: Binding<String>,
        fieldStyle: FieldStyle,
        animationDuration: Double,
        primaryColor: Color,
        secondaryColor: Color,
        isEnabled: Bool
    ) -> some View {
        Group {
            switch type {
            case .textField:
                AnimatedTextField(
                    value: textFieldValue,
                    fieldStyle: fieldStyle,
                    animationDuration: animationDuration,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            case .singleSelect:
                AnimatedSingleSelect(
                    selection: singleSelection,
                    fieldStyle: fieldStyle,
                    animationDuration: animationDuration,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            case .multiSelect:
                AnimatedMultiSelect(
                    selection: multiSelection,
                    fieldStyle: fieldStyle,
                    animationDuration: animationDuration,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            case .menu:
                AnimatedMenu(
                    selection: menuSelection,
                    fieldStyle: fieldStyle,
                    animationDuration: animationDuration,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            }
        }
    }
}

// MARK: - Animated Text Field
struct AnimatedTextField: View {
    @Binding var value: String
    let fieldStyle: FieldStyle
    let animationDuration: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    @State private var isFocused: Bool = false
    @State private var animationOffset: CGFloat = 0
    @State private var animationScale: CGFloat = 1.0
    @State private var animationOpacity: Double = 1.0
    @State private var animationRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Animated Text Field")
                .font(.headline)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                // Label based on field style
                if fieldStyle == .floating {
                    Text("Floating Label")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .offset(x: animationOffset)
                        .scaleEffect(animationScale)
                        .opacity(animationOpacity)
                        .rotationEffect(.degrees(animationRotation))
                }
                
                // Text Field with different styles
                Group {
                    switch fieldStyle {
                    case .floating:
                        FloatingTextField(
                            value: $value,
                            isFocused: $isFocused,
                            primaryColor: primaryColor,
                            isEnabled: isEnabled
                        )
                    case .outlined:
                        OutlinedTextField(
                            value: $value,
                            isFocused: $isFocused,
                            primaryColor: primaryColor,
                            isEnabled: isEnabled
                        )
                    case .filled:
                        FilledTextField(
                            value: $value,
                            isFocused: $isFocused,
                            primaryColor: primaryColor,
                            isEnabled: isEnabled
                        )
                    case .minimal:
                        MinimalTextField(
                            value: $value,
                            isFocused: $isFocused,
                            primaryColor: primaryColor,
                            isEnabled: isEnabled
                        )
                    case .gradient:
                        GradientTextField(
                            value: $value,
                            isFocused: $isFocused,
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                            isEnabled: isEnabled
                        )
                    case .glassmorphism:
                        GlassmorphismTextField(
                            value: $value,
                            isFocused: $isFocused,
                            primaryColor: primaryColor,
                            isEnabled: isEnabled
                        )
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        applyAnimation()
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .onAppear {
            applyAnimation()
        }
        .onChange(of: fieldStyle) { _, _ in
            applyAnimation()
        }
    }
    
    private func applyAnimation() {
        switch fieldStyle {
        case .floating:
            animationOffset = 20
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOffset = 0
                }
            }
        case .outlined:
            animationOpacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOpacity = 1.0
                }
            }
        case .filled:
            animationScale = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .minimal:
            animationScale = 1.2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .gradient:
            animationRotation = 360
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationRotation = 0
                }
            }
        case .glassmorphism:
            animationOpacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOpacity = 1.0
                }
            }
        }
    }
}

// MARK: - Floating Text Field
struct FloatingTextField: View {
    @Binding var value: String
    @Binding var isFocused: Bool
    let primaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .leading) {
                Text("Enter text here...")
                    .foregroundStyle(.secondary)
                    .font(.body)
                    .scaleEffect(isFocused || !value.isEmpty ? 0.8 : 1.0)
                    .offset(y: isFocused || !value.isEmpty ? -25 : 0)
                    .foregroundStyle(isFocused ? primaryColor : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                    .animation(.easeInOut(duration: 0.2), value: value.isEmpty)
                
                TextField("", text: $value)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .foregroundStyle(.primary)
                    .disabled(!isEnabled)
                    .onTapGesture {
                        isFocused = true
                    }
            }
            
            Rectangle()
                .fill(isFocused ? primaryColor : Color(.systemGray4))
                .frame(height: 2)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Outlined Text Field
struct OutlinedTextField: View {
    @Binding var value: String
    @Binding var isFocused: Bool
    let primaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Outlined Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter text here...", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .foregroundStyle(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? primaryColor : Color(.systemGray4), lineWidth: isFocused ? 2 : 1)
                        .background(Color(.systemBackground))
                )
                .disabled(!isEnabled)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

// MARK: - Filled Text Field
struct FilledTextField: View {
    @Binding var value: String
    @Binding var isFocused: Bool
    let primaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filled Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter text here...", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .foregroundStyle(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFocused ? primaryColor : Color.clear, lineWidth: 2)
                        )
                )
                .disabled(!isEnabled)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

// MARK: - Minimal Text Field
struct MinimalTextField: View {
    @Binding var value: String
    @Binding var isFocused: Bool
    let primaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Minimal Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter text here...", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .foregroundStyle(.primary)
                .padding(.vertical, 12)
                .background(
                    Rectangle()
                        .fill(Color.clear)
                        .overlay(
                            Rectangle()
                                .fill(isFocused ? primaryColor : Color(.systemGray4))
                                .frame(height: 1)
                                .offset(y: 20)
                        )
                )
                .disabled(!isEnabled)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

// MARK: - Gradient Text Field
struct GradientTextField: View {
    @Binding var value: String
    @Binding var isFocused: Bool
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Gradient Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter text here...", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .foregroundStyle(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(
                                        colors: isFocused ? [primaryColor, secondaryColor] : [Color(.systemGray4), Color(.systemGray4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: isFocused ? 3 : 1
                                )
                        )
                        .shadow(color: isFocused ? primaryColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                )
                .disabled(!isEnabled)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

// MARK: - Glassmorphism Text Field
struct GlassmorphismTextField: View {
    @Binding var value: String
    @Binding var isFocused: Bool
    let primaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Glassmorphism Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter text here...", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .foregroundStyle(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isFocused ? primaryColor.opacity(0.5) : Color.clear, lineWidth: 2)
                        )
                )
                .disabled(!isEnabled)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

// MARK: - Animated Single Select
struct AnimatedSingleSelect: View {
    @Binding var selection: String
    let fieldStyle: FieldStyle
    let animationDuration: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    @State private var isExpanded: Bool = false
    @State private var animationOffset: CGFloat = 0
    @State private var animationScale: CGFloat = 1.0
    @State private var animationOpacity: Double = 1.0
    
    private let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Single Selection Field")
                .font(.headline)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select an option")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button(action: { 
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        isExpanded.toggle()
                        applyAnimation()
                    }
                }) {
                    HStack {
                        Text(selection)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(primaryColor, lineWidth: 2)
                            )
                    )
                }
                .disabled(!isEnabled)
                
                if isExpanded {
                    VStack(spacing: 4) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selection = option
                                withAnimation(.easeInOut(duration: animationDuration)) {
                                    isExpanded = false
                                }
                            }) {
                                HStack {
                                    Text(option)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if selection == option {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(primaryColor)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(selection == option ? primaryColor.opacity(0.1) : .clear)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .onAppear {
            applyAnimation()
        }
        .onChange(of: fieldStyle) { _, _ in
            applyAnimation()
        }
    }
    
    private func applyAnimation() {
        switch fieldStyle {
        case .floating:
            animationOffset = 20
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOffset = 0
                }
            }
        case .outlined:
            animationOpacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOpacity = 1.0
                }
            }
        case .filled:
            animationScale = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .minimal:
            animationScale = 1.2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .gradient:
            break
        case .glassmorphism:
            break
        }
    }
}

// MARK: - Animated Multi Select
struct AnimatedMultiSelect: View {
    @Binding var selection: Set<String>
    let fieldStyle: FieldStyle
    let animationDuration: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    @State private var isExpanded: Bool = false
    @State private var animationOffset: CGFloat = 0
    @State private var animationScale: CGFloat = 1.0
    @State private var animationOpacity: Double = 1.0
    
    private let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Multi Selection Field")
                .font(.headline)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select multiple options")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button(action: { 
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        isExpanded.toggle()
                        applyAnimation()
                    }
                }) {
                    HStack {
                        Text("\(selection.count) selected")
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(primaryColor, lineWidth: 2)
                            )
                    )
                }
                .disabled(!isEnabled)
                
                if isExpanded {
                    VStack(spacing: 4) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                if selection.contains(option) {
                                    selection.remove(option)
                                } else {
                                    selection.insert(option)
                                }
                            }) {
                                HStack {
                                    Text(option)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if selection.contains(option) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(primaryColor)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(selection.contains(option) ? primaryColor.opacity(0.1) : .clear)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .onAppear {
            applyAnimation()
        }
        .onChange(of: fieldStyle) { _, _ in
            applyAnimation()
        }
    }
    
    private func applyAnimation() {
        switch fieldStyle {
        case .floating:
            animationOffset = 20
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOffset = 0
                }
            }
        case .outlined:
            animationOpacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOpacity = 1.0
                }
            }
        case .filled:
            animationScale = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .minimal:
            animationScale = 1.2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .gradient:
            break
        case .glassmorphism:
            break
        }
    }
}

// MARK: - Animated Menu
struct AnimatedMenu: View {
    @Binding var selection: String
    let fieldStyle: FieldStyle
    let animationDuration: Double
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    @State private var isExpanded: Bool = false
    @State private var animationOffset: CGFloat = 0
    @State private var animationScale: CGFloat = 1.0
    @State private var animationOpacity: Double = 1.0
    
    private let menuItems = ["Menu Item 1", "Menu Item 2", "Menu Item 3", "Menu Item 4"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Animated Menu")
                .font(.headline)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select from menu")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Menu {
                    ForEach(menuItems, id: \.self) { item in
                        Button(action: {
                            selection = item
                            applyAnimation()
                        }) {
                            HStack {
                                Text(item)
                                if selection == item {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selection)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        LinearGradient(
                                            colors: [primaryColor, secondaryColor],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                    )
                }
                .disabled(!isEnabled)
                .onTapGesture {
                    applyAnimation()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .onAppear {
            applyAnimation()
        }
        .onChange(of: fieldStyle) { _, _ in
            applyAnimation()
        }
    }
    
    private func applyAnimation() {
        switch fieldStyle {
        case .floating:
            animationOffset = 20
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOffset = 0
                }
            }
        case .outlined:
            animationOpacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationOpacity = 1.0
                }
            }
        case .filled:
            animationScale = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .minimal:
            animationScale = 1.2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationScale = 1.0
                }
            }
        case .gradient:
            break
        case .glassmorphism:
            break
        }
    }
}

#Preview {
    FormComponentsShowcaseView()
}
