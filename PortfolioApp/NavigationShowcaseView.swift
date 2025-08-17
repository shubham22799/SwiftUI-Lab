//
//  NavigationShowcaseView.swift
//  PortfolioApp
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Navigation Showcase View
struct NavigationShowcaseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedNavigation: NavigationType = .tabBar
    @State private var selectedTab: Int = 0
    @State private var isSideMenuOpen: Bool = false
    @State private var isModalPresented: Bool = false
    @State private var currentPage: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .purple
    @State private var isEnabled: Bool = true
    
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
                
                Text("Navigation & Layout")
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
                // Navigation Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    NavigationFactory.createNavigation(
                        type: selectedNavigation,
                        selectedTab: $selectedTab,
                        isSideMenuOpen: $isSideMenuOpen,
                        isModalPresented: $isModalPresented,
                        currentPage: $currentPage,
                        scrollOffset: $scrollOffset,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        isEnabled: isEnabled
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Navigation Type Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Navigation Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(NavigationType.allCases, id: \.self) { type in
                            NavigationTypeCard(
                                type: type,
                                isSelected: selectedNavigation == type,
                                action: { selectedNavigation = type }
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
                        // Enabled/Disabled Toggle
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Navigation State")
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
                        
                        // Interactive Controls
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Interactive Controls")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Button("Open Menu") {
                                    isSideMenuOpen.toggle()
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.blue.opacity(0.2))
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                
                                Button("Show Modal") {
                                    isModalPresented.toggle()
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.green.opacity(0.2))
                                .foregroundStyle(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
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
                colors: [.indigo.opacity(0.1), .blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Navigation Type Card
struct NavigationTypeCard: View {
    let type: NavigationType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : type.color)
                
                Text(type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? type.color : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Navigation Factory
struct NavigationFactory {
    static func createNavigation(
        type: NavigationType,
        selectedTab: Binding<Int>,
        isSideMenuOpen: Binding<Bool>,
        isModalPresented: Binding<Bool>,
        currentPage: Binding<Int>,
        scrollOffset: Binding<CGFloat>,
        primaryColor: Color,
        secondaryColor: Color,
        isEnabled: Bool
    ) -> AnyView {
        switch type {
        case .tabBar:
            return AnyView(
                CustomTabBar(
                    selectedTab: selectedTab,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .sideMenu:
            return AnyView(
                CustomSideMenu(
                    isOpen: isSideMenuOpen,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .modal:
            return AnyView(
                CustomModal(
                    isPresented: isModalPresented,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .pageIndicator:
            return AnyView(
                CustomPageIndicator(
                    currentPage: currentPage,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .stickyHeader:
            return AnyView(
                CustomStickyHeader(
                    scrollOffset: scrollOffset,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        case .parallax:
            return AnyView(
                CustomParallax(
                    scrollOffset: scrollOffset,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    isEnabled: isEnabled
                )
            )
        }
    }
}

// MARK: - Navigation Type Enum
enum NavigationType: String, CaseIterable, Identifiable {
    case tabBar = "Tab Bar"
    case sideMenu = "Side Menu"
    case modal = "Modal"
    case pageIndicator = "Page Indicator"
    case stickyHeader = "Sticky Header"
    case parallax = "Parallax"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .tabBar: return "Tab Bar"
        case .sideMenu: return "Side Menu"
        case .modal: return "Modal"
        case .pageIndicator: return "Page Indicator"
        case .stickyHeader: return "Sticky Header"
        case .parallax: return "Parallax"
        }
    }
    
    var icon: String {
        switch self {
        case .tabBar: return "rectangle.bottomthird.inset.filled"
        case .sideMenu: return "sidebar.left"
        case .modal: return "rectangle.inset.filled.top.and.bottom"
        case .pageIndicator: return "circle.grid.3x3.fill"
        case .stickyHeader: return "rectangle.inset.filled.top"
        case .parallax: return "arrow.up.and.down.and.arrow.left.and.right"
        }
    }
    
    var color: Color {
        switch self {
        case .tabBar: return .blue
        case .sideMenu: return .green
        case .modal: return .orange
        case .pageIndicator: return .red
        case .stickyHeader: return .purple
        case .parallax: return .teal
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    private let tabs = ["Home", "Search", "Favorites", "Profile"]
    private let icons = ["house.fill", "magnifyingglass", "heart.fill", "person.fill"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Content Area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .frame(height: 200)
                
                VStack(spacing: 16) {
                    Text("Tab Content")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Current tab: \(tabs[selectedTab])")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: icons[selectedTab])
                        .font(.system(size: 40))
                        .foregroundStyle(primaryColor)
                }
            }
            
            // Tab Bar
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        if isEnabled {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = index
                            }
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: icons[index])
                                .font(.system(size: 20))
                                .foregroundStyle(selectedTab == index ? primaryColor : .secondary)
                            
                            Text(tabs[index])
                                .font(.caption2)
                                .foregroundStyle(selectedTab == index ? primaryColor : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!isEnabled)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .opacity(isEnabled ? 1.0 : 0.5)
        }
    }
}

// MARK: - Custom Side Menu
struct CustomSideMenu: View {
    @Binding var isOpen: Bool
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    private let menuItems = ["Dashboard", "Profile", "Settings", "Help", "About"]
    private let menuIcons = ["chart.bar.fill", "person.fill", "gearshape.fill", "questionmark.circle.fill", "info.circle.fill"]
    
    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 16) {
                Text("Main Content")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Button(action: {
                    if isEnabled {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isOpen.toggle()
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "sidebar.left")
                        Text("Toggle Menu")
                    }
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(primaryColor)
                    )
                }
                .disabled(!isEnabled)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .offset(x: isOpen ? 100 : 0)
            .opacity(isEnabled ? 1.0 : 0.5)
            
            // Side Menu
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Menu")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("Navigation options")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(primaryColor)
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        ForEach(0..<menuItems.count, id: \.self) { index in
                            Button(action: {}) {
                                HStack(spacing: 12) {
                                    Image(systemName: menuIcons[index])
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                        .frame(width: 20)
                                    
                                    Text(menuItems[index])
                                        .font(.body)
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.clear)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if index < menuItems.count - 1 {
                                Divider()
                                    .background(.white.opacity(0.3))
                            }
                        }
                    }
                    .background(secondaryColor)
                    
                    Spacer()
                }
                .frame(width: 200)
                .background(secondaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .offset(x: isOpen ? 0 : -200)
        }
    }
}

// MARK: - Custom Modal
struct CustomModal: View {
    @Binding var isPresented: Bool
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        ZStack {
            // Background Content
            VStack(spacing: 16) {
                Text("Background Content")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Button(action: {
                    if isEnabled {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isPresented.toggle()
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "rectangle.inset.filled.top.and.bottom")
                        Text("Present Modal")
                    }
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(primaryColor)
                    )
                }
                .disabled(!isEnabled)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(isEnabled ? 1.0 : 0.5)
            
            // Modal Overlay
            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                
                // Modal Content
                VStack(spacing: 20) {
                    HStack {
                        Text("Modal Title")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Text("This is a custom modal presentation with smooth animations and custom styling.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }) {
                        Text("Close Modal")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(primaryColor)
                            )
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                )
                .shadow(radius: 20)
                .padding(.horizontal, 32)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

// MARK: - Custom Page Indicator
struct CustomPageIndicator: View {
    @Binding var currentPage: Int
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    private let totalPages = 5
    
    var body: some View {
        VStack(spacing: 20) {
            // Content Area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .frame(height: 150)
                
                VStack(spacing: 16) {
                    Text("Page \(currentPage + 1)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Swipe or use the indicator below to navigate")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Page Indicator
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? primaryColor : Color(.systemGray4))
                        .frame(width: 12, height: 12)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        .onTapGesture {
                            if isEnabled {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentPage = index
                                }
                            }
                        }
                }
            }
            .opacity(isEnabled ? 1.0 : 0.5)
        }
    }
}

// MARK: - Custom Sticky Header
struct CustomStickyHeader: View {
    @Binding var scrollOffset: CGFloat
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Sticky Header
            VStack(spacing: 12) {
                HStack {
                    Text("Sticky Header")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                
                Text("This header stays visible while scrolling")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Scrollable Content
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<10, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(height: 60)
                            .overlay(
                                Text("Content Item \(index + 1)")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                            )
                    }
                }
                .padding()
            }
            .frame(height: 200)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Custom Parallax
struct CustomParallax: View {
    @Binding var scrollOffset: CGFloat
    let primaryColor: Color
    let secondaryColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Parallax Header
            ZStack {
                // Background Image (simulated)
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                    .offset(y: scrollOffset * 0.5)
                
                // Content
                VStack(spacing: 8) {
                    Text("Parallax Header")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("Scroll to see the parallax effect")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .offset(y: scrollOffset * 0.3)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Scrollable Content
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<8, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(height: 50)
                            .overlay(
                                Text("Scroll Item \(index + 1)")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                            )
                    }
                }
                .padding()
            }
            .frame(height: 180)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
        }
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    NavigationShowcaseView()
}
