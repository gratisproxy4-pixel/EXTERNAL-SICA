import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.appLanguage) private var language
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var patchDraftCoordinator: PatchDraftCoordinator
    @EnvironmentObject private var patchStore: PatchProjectStore
    @EnvironmentObject private var repositoryStore: PackageRepositoryStore
    @AppStorage(FeatureVisibility.developerModeStorageKey)
    private var developerModeEnabled = false
    @State private var tabNavigation = AppTabNavigationState()
    @State private var selectedTab: SouzaiTab = .principal
    @State private var showSettings = false
    @State private var showLogs = false

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                regularLayout
            } else {
                compactLayout
            }
        }
        .tint(SouzaiColor.red)
        .preferredColorScheme(.dark)
        .imageScale(.small)
        .onChange(of: patchDraftCoordinator.request?.id) { id in
            if id != nil { selectedTab = .visual }
        }
        .onChange(of: patchDraftCoordinator.importRequest?.id) { id in
            if id != nil { selectedTab = .visual }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .sheet(isPresented: $showLogs) { LogView() }
        .patchStorePresentation(patchStore)
        .repositoryStorePresentation(repositoryStore, patchStore: patchStore)
    }

    private var compactLayout: some View {
        ZStack {
            SouzaiColor.background.ignoresSafeArea()

            content(for: selectedTab)
                .safeAreaInset(edge: .top, spacing: 0) {
                    SouzaiBanner()
                        .padding(.horizontal, SouzaiColor.insetH)
                        .padding(.top, 6)
                        .padding(.bottom, 6)
                        .background(SouzaiColor.background)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    tabBar
                        .padding(.horizontal, SouzaiColor.insetH)
                        .padding(.bottom, 6)
                        .background(SouzaiColor.background)
                }
        }
    }

    private var regularLayout: some View {
        NavigationSplitView {
            List {
                ForEach(SouzaiTab.visible(developerMode: developerModeActive)) { item in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) { selectedTab = item }
                    } label: {
                        Label(item.title, systemImage: item.icon)
                            .fontWeight(selectedTab == item ? .semibold : .regular)
                            .foregroundStyle(SouzaiColor.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(
                        selectedTab == item ? SouzaiColor.red.opacity(0.14) : Color.clear
                    )
                    .listRowSeparatorTint(SouzaiColor.border)
                    .accessibilityAddTraits(selectedTab == item ? .isSelected : [])
                }
            }
            .scrollContentBackground(.hidden)
            .background(SouzaiColor.background)
            .navigationTitle("3105")
            .navigationSplitViewColumnWidth(min: 210, ideal: 240, max: 300)
        } detail: {
            content(for: selectedTab)
                .id(selectedTab)
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    private func content(for tab: SouzaiTab) -> some View {
        switch tab {
        case .principal:
            RepositoryHomeView(onOpenSettings: { showSettings = true }, onOpenLogs: { showLogs = true })
        case .visual:
            PatchProjectsView(onOpenSettings: { showSettings = true }, onOpenLogs: { showLogs = true })
        case .perfil:
            SouzaiProfileView(onOpenSettings: { showSettings = true })
        case .arquivos:
            AppDataBrowserView(
                tabSession: Binding(
                    get: { tabNavigation.filesTabs },
                    set: { tabNavigation.setFilesTabs($0) }
                ),
                onOpenSettings: { showSettings = true },
                onOpenLogs: { showLogs = true }
            )
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(SouzaiTab.visible(developerMode: developerModeActive)) { item in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selectedTab = item }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon).font(.system(size: 18, weight: .medium))
                        Text(item.title).font(.system(size: 10.5, weight: .semibold))
                    }
                    .foregroundStyle(selectedTab == item ? SouzaiColor.red : SouzaiColor.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedTab == item ? .isSelected : [])
            }
        }
        .background(SouzaiColor.surfaceAlt, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color(hex: 0x221618), lineWidth: 1)
        }
    }

    private var developerModeActive: Bool {
#if targetEnvironment(simulator)
        developerModeEnabled || ProcessInfo.processInfo.arguments.contains("--simulate-developer-mode")
#else
        developerModeEnabled
#endif
    }
}

enum SouzaiTab: Int, CaseIterable, Identifiable {
    case principal, visual, perfil, arquivos

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .principal: return "Principal"
        case .visual: return "Visual"
        case .perfil: return "Perfil"
        case .arquivos: return "Arquivos"
        }
    }

    var icon: String {
        switch self {
        case .principal: return "house.fill"
        case .visual: return "tray.full.fill"
        case .perfil: return "person.fill"
        case .arquivos: return "folder.fill"
        }
    }

    /// Tres pestañas como el diseño; Archivos solo con modo desarrollador.
    static func visible(developerMode: Bool) -> [SouzaiTab] {
        developerMode ? allCases : [.principal, .visual, .perfil]
    }
}
