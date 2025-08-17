//
//  ComponentLibrary.swift
//  PortfolioApp
//
//  Created by Shubham on 17/08/25.
//

import SwiftUI

// MARK: - Component Library Architecture
struct ComponentLibrary {
    
    // MARK: - Component Categories
    enum ComponentCategory: String, CaseIterable, Identifiable {
        case spinners = "Loading Spinners"
        case buttons = "Interactive Buttons"
        case controls = "Custom Controls"
        case dataVisualization = "Data Visualization"
        case animations = "Animations & Transitions"
        case navigation = "Navigation & Layout"
        case formComponents = "Form Components"
        case mediaContent = "Media & Content"
        case gestures = "Gestures & Interactions"
        case networking = "Networking & Data"
        case authentication = "Authentication & Security"
        case advancedCharts = "Advanced Charts"
        case gaming = "Gaming & Entertainment"
        case smartHome = "Smart Home & IoT"
        case platformFeatures = "Platform Features"
        case designSystems = "Design Systems"
        case developerTools = "Developer Tools"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .spinners: return "arrow.trianglehead.2.clockwise"
            case .buttons: return "button.horizontal"
            case .controls: return "slider.horizontal.3"
            case .dataVisualization: return "chart.bar.fill"
            case .animations: return "sparkles"
            case .navigation: return "rectangle.inset.filled.top.and.bottom"
            case .formComponents: return "textformat"
            case .mediaContent: return "photo.fill"
            case .gestures: return "hand.tap.fill"
            case .networking: return "network"
            case .authentication: return "lock.shield.fill"
            case .advancedCharts: return "chart.xyaxis.line"
            case .gaming: return "gamecontroller.fill"
            case .smartHome: return "house.fill"
            case .platformFeatures: return "iphone"
            case .designSystems: return "paintbrush.fill"
            case .developerTools: return "wrench.and.screwdriver.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .spinners: return .blue
            case .buttons: return .green
            case .controls: return .orange
            case .dataVisualization: return .red
            case .animations: return .purple
            case .navigation: return .indigo
            case .formComponents: return .teal
            case .mediaContent: return .pink
            case .gestures: return .yellow
            case .networking: return .cyan
            case .authentication: return .mint
            case .advancedCharts: return .brown
            case .gaming: return .orange
            case .smartHome: return .green
            case .platformFeatures: return .blue
            case .designSystems: return .purple
            case .developerTools: return .gray
            }
        }
        
        var description: String {
            switch self {
            case .spinners: return "Animated loading indicators"
            case .buttons: return "Interactive button styles"
            case .controls: return "Custom input controls"
            case .dataVisualization: return "Charts and graphs"
            case .animations: return "Custom animation effects"
            case .navigation: return "Tab bars, side menus, modals"
            case .formComponents: return "Text fields, selections, filters"
            case .mediaContent: return "Images, videos, audio"
            case .gestures: return "Touch interactions & feedback"
            case .networking: return "API integration & data"
            case .authentication: return "Login & security flows"
            case .advancedCharts: return "Interactive data visualization"
            case .gaming: return "Mini-games & entertainment"
            case .smartHome: return "IoT device interfaces"
            case .platformFeatures: return "iOS-specific features"
            case .designSystems: return "Color & typography tools"
            case .developerTools: return "Debug & development tools"
            }
        }
    }
    
    // MARK: - Component Protocols
    protocol ShowcaseComponent {
        var title: String { get }
        var description: String { get }
        var category: ComponentCategory { get }
        func createView() -> AnyView
    }
    
    protocol CustomizableComponent: ShowcaseComponent {
        associatedtype ConfigurationType
        var configuration: ConfigurationType { get set }
        func updateConfiguration(_ config: ConfigurationType)
    }
    
    // MARK: - Predefined Component Sets
    static let featuredComponents: [ComponentCategory] = [
        .spinners,
        .buttons,
        .controls,
        .dataVisualization
    ]
    
    static let advancedComponents: [ComponentCategory] = [
        .animations,
        .navigation
    ]
    
    // MARK: - Component Factory
    static func createShowcaseView(for category: ComponentCategory) -> AnyView {
        switch category {
        case .spinners:
            return AnyView(SpinnerShowcaseView())
        case .buttons:
            return AnyView(ButtonShowcaseView())
        case .controls:
            return AnyView(ControlsShowcaseView())
        case .dataVisualization:
            return AnyView(DataVisualizationView())
        case .animations:
            return AnyView(AnimationsShowcaseView())
        case .navigation:
            return AnyView(NavigationShowcaseView())
        case .formComponents:
            return AnyView(FormComponentsShowcaseView())
        case .mediaContent:
            return AnyView(ComingSoonView(category: category))
        case .gestures:
            return AnyView(ComingSoonView(category: category))
        case .networking:
            return AnyView(ComingSoonView(category: category))
        case .authentication:
            return AnyView(ComingSoonView(category: category))
        case .advancedCharts:
            return AnyView(ComingSoonView(category: category))
        case .gaming:
            return AnyView(ComingSoonView(category: category))
        case .smartHome:
            return AnyView(ComingSoonView(category: category))
        case .platformFeatures:
            return AnyView(ComingSoonView(category: category))
        case .designSystems:
            return AnyView(ComingSoonView(category: category))
        case .developerTools:
            return AnyView(ComingSoonView(category: category))
        }
    }
}

// MARK: - Coming Soon View
struct ComingSoonView: View {
    let category: ComponentLibrary.ComponentCategory
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: category.icon)
                .font(.system(size: 80))
                .foregroundStyle(category.color.gradient)
                .breathing(scale: 1.1, duration: 2.0)
            
            VStack(spacing: 16) {
                Text("Coming Soon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(category.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(category.color)
                
                Text("This component showcase is under development and will be available in the next update.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Interactive animations")
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Real-time customization")
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Multiple style variants")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Spacer()
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .background(
            LinearGradient(
                colors: [category.color.opacity(0.1), category.color.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Design System Constants
struct DesignSystem {
    
    // MARK: - Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.purple
        static let accent = Color.pink
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        
        static let cardBackground = Color(.systemBackground)
        static let surfaceBackground = Color(.secondarySystemBackground)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let headline = Font.headline.weight(.medium)
        static let body = Font.body
        static let caption = Font.caption
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 20
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(radius: 4, x: 0, y: 2)
        static let medium = Shadow(radius: 8, x: 0, y: 4)
        static let large = Shadow(radius: 16, x: 0, y: 8)
    }
}

struct Shadow {
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions for Design System
extension View {
    func designSystemCard(color: Color = DesignSystem.Colors.primary) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(.regularMaterial)
                    .shadow(color: color.opacity(0.2), radius: DesignSystem.Shadows.medium.radius, x: DesignSystem.Shadows.medium.x, y: DesignSystem.Shadows.medium.y)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
    
    func primaryButton() -> some View {
        self
            .font(DesignSystem.Typography.headline)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(DesignSystem.Colors.primary.gradient)
            .cornerRadius(DesignSystem.CornerRadius.medium)
    }
}
