import SwiftUI

struct SouzaiProfileView: View {
    let onOpenSettings: () -> Void
    @State private var key = SouzaiProfileView.makeKey()
    @State private var expiresAt = Date().addingTimeInterval(6 * 3600)

    private let youtube = URL(string: "https://www.youtube.com/@souzaiosoficial")

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SouzaiBanner()
                Text("Minha conta")
                    .font(.system(size: 22, weight: .heavy))
                    .kerning(-0.5)
                    .foregroundStyle(SouzaiColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 18)
                    .padding(.bottom, 12)

                VStack(spacing: 0) {
                    row("key", "KEY DO USUARIO") {
                        Text(key)
                            .font(.system(size: 12.5, weight: .bold, design: .monospaced))
                            .foregroundStyle(SouzaiColor.textPrimary)
                    }
                    Divider().overlay(SouzaiColor.border)
                    row("clock", "TEMPO RESTANTE") {
                        TimelineView(.periodic(from: .now, by: 30)) { _ in
                            Text(remaining)
                                .font(.system(size: 12.5, weight: .bold))
                                .foregroundStyle(SouzaiColor.textPrimary)
                        }
                    }
                    Divider().overlay(SouzaiColor.border)
                    row("person", "USUARIO") {
                        Text("ATIVO")
                            .font(.system(size: 12.5, weight: .bold))
                            .foregroundStyle(SouzaiColor.success)
                    }
                }
                .background(SouzaiColor.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color(hex: 0x2A1618), lineWidth: 1)
                }

                HStack(spacing: 8) {
                    Capsule().fill(SouzaiColor.red).frame(width: 3, height: 14)
                    Text("INFORMAÇÕES DESENVOLVEDOR")
                        .font(.system(size: 10.5, weight: .heavy))
                        .kerning(1.2)
                        .foregroundStyle(Color(hex: 0xF0EAEA))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 10)

                if let youtube {
                    Link(destination: youtube) {
                        link("play.rectangle.fill", "CANAL DO YOUTUBE")
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 10)
                }
                Button { } label: { link("arrow.up.right", "TODA MINHA COMUNIDADE") }
                    .buttonStyle(.plain)
                    .padding(.bottom, 10)
                Button { } label: { link("cart", "MINHA LOJA OFICIAL") }
                    .buttonStyle(.plain)
                    .padding(.bottom, 10)
                Button(action: onOpenSettings) { link("gearshape", "AJUSTES DO 3105") }
                    .buttonStyle(.plain)
            }
            .padding(.horizontal, SouzaiColor.insetH)
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .souzaiScreen()
    }

    private var remaining: String {
        let seconds = max(0, expiresAt.timeIntervalSinceNow)
        guard seconds > 0 else { return "expirado" }
        return String(format: "%dh %02dm", Int(seconds) / 3600, (Int(seconds) % 3600) / 60)
    }

    private func row<Content: View>(_ icon: String, _ label: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 12) {
            AppRowIcon(systemName: icon)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 9.5, weight: .heavy))
                    .kerning(1.4)
                    .foregroundStyle(SouzaiColor.textSecondary)
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
    }

    private func link(_ icon: String, _ title: String) -> some View {
        HStack(spacing: 12) {
            AppRowIcon(systemName: icon)
            Text(title)
                .font(.system(size: 12.5, weight: .heavy))
                .kerning(0.4)
                .foregroundStyle(SouzaiColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(SouzaiColor.textTertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 13)
        .background(SouzaiColor.surface, in: RoundedRectangle(cornerRadius: SouzaiColor.radius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SouzaiColor.radius, style: .continuous)
                .strokeBorder(SouzaiColor.border, lineWidth: 1)
        }
    }

    private static func makeKey() -> String {
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return "120A" + String((0..<8).map { _ in alphabet.randomElement()! })
    }
}
