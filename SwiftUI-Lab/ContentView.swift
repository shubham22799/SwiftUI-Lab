//
//  ContentView.swift
//  SwiftUI-Lab
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {

            VStack(spacing: 30) {
                // Header Section
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundStyle(.purple.gradient)
                    
                    Text("SwiftUI-Lab")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Interactive demonstrations of custom UI components with real-time customization")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Component Categories
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    
                    NavigationLink(destination: SpinnerShowcaseView()) {
                        ComponentCategoryCard(
                            icon: "arrow.trianglehead.2.clockwise",
                            title: "Loading Spinners",
                            description: "Animated loading indicators",
                            color: .blue,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: ButtonShowcaseView()) {
                        ComponentCategoryCard(
                            icon: "button.horizontal",
                            title: "Buttons",
                            description: "Interactive button styles",
                            color: .green,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: ControlsShowcaseView()) {
                        ComponentCategoryCard(
                            icon: "slider.horizontal.3",
                            title: "Controls",
                            description: "Custom input controls",
                            color: .orange,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: DataVisualizationView()) {
                        ComponentCategoryCard(
                            icon: "chart.bar.fill",
                            title: "Data Viz",
                            description: "Charts and graphs",
                            color: .red,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: AnimationsShowcaseView()) {
                        ComponentCategoryCard(
                            icon: "sparkles",
                            title: "Animations",
                            description: "Custom animation effects",
                            color: .purple,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: NavigationShowcaseView()) {
                        ComponentCategoryCard(
                            icon: "rectangle.inset.filled.top.and.bottom",
                            title: "Navigation",
                            description: "Tab bars, side menus, modals",
                            color: .indigo,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: FormComponentsShowcaseView()) {
                        ComponentCategoryCard(
                            icon: "textformat",
                            title: "Form Components",
                            description: "Text fields, selections, filters",
                            color: .teal,
                            isNavigable: true
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    ComponentCategoryCard(
                        icon: "photo.fill",
                        title: "Media & Content",
                        description: "Images, videos, audio",
                        color: .pink
                    )
                    
                    ComponentCategoryCard(
                        icon: "hand.tap.fill",
                        title: "Gestures",
                        description: "Touch interactions & feedback",
                        color: .yellow
                    )
                    
                    ComponentCategoryCard(
                        icon: "network",
                        title: "Networking",
                        description: "API integration & data",
                        color: .cyan
                    )
                    
                    ComponentCategoryCard(
                        icon: "lock.shield.fill",
                        title: "Authentication",
                        description: "Login & security flows",
                        color: .mint
                    )
                    
                    ComponentCategoryCard(
                        icon: "chart.xyaxis.line",
                        title: "Advanced Charts",
                        description: "Interactive data visualization",
                        color: .brown
                    )
                    
                    ComponentCategoryCard(
                        icon: "gamecontroller.fill",
                        title: "Gaming",
                        description: "Mini-games & entertainment",
                        color: .orange
                    )
                    
                    ComponentCategoryCard(
                        icon: "house.fill",
                        title: "Smart Home",
                        description: "IoT device interfaces",
                        color: .green
                    )
                    
                    ComponentCategoryCard(
                        icon: "iphone",
                        title: "Platform Features",
                        description: "iOS-specific features",
                        color: .blue
                    )
                    
                    ComponentCategoryCard(
                        icon: "paintbrush.fill",
                        title: "Design Systems",
                        description: "Color & typography tools",
                        color: .purple
                    )
                    
                    ComponentCategoryCard(
                        icon: "wrench.and.screwdriver.fill",
                        title: "Developer Tools",
                        description: "Debug & development tools",
                        color: .gray
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )

        }
    }
}

struct ComponentCategoryCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let isNavigable: Bool
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    init(icon: String, title: String, description: String, color: Color, isNavigable: Bool = false) {
        self.icon = icon
        self.title = title
        self.description = description
        self.color = color
        self.isNavigable = isNavigable
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color.gradient)
                .scaleEffect(isPressed ? 0.9 : (isHovered ? 1.1 : 1.0))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: color.opacity(isHovered ? 0.4 : 0.2), radius: isHovered ? 12 : 8, x: 0, y: isHovered ? 6 : 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(isHovered ? 0.6 : 0.3), lineWidth: isHovered ? 2 : 1)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .if(!isNavigable) { view in
            view.onTapGesture {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        isPressed = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
