import SwiftUI

enum SouzaiColor {
    static let background   = Color(hex: 0x080506)
    static let bannerEdge   = Color(hex: 0x120203)
    static let bannerCore   = Color(hex: 0x4A060A)
    static let surface      = Color(hex: 0x0D0909)
    static let surfaceAlt   = Color(hex: 0x100D0E)
    static let chip         = Color(hex: 0x26090C)
    static let chipMuted    = Color(hex: 0x1C1C1E)
    static let border       = Color(hex: 0x241315)
    static let borderDeep   = Color(hex: 0x2E0D10)
    static let borderDashed = Color(hex: 0x43262A)
    static let red          = Color(hex: 0xE0161C)
    static let redDeep      = Color(hex: 0x7D0A10)
    static let redText      = Color(hex: 0xD6151B)
    static let textPrimary  = Color(hex: 0xFDF8F8)
    static let textSecondary = Color(hex: 0x8B7F80)
    static let textTertiary = Color(hex: 0x6E6768)
    static let track        = Color(hex: 0x3B3B40)
    static let success      = Color(hex: 0x35D16A)
    static let warnBackground = Color(hex: 0x1B1A08)
    static let warnBorder   = Color(hex: 0x5B5210)
    static let warnText     = Color(hex: 0xCBC5A2)
    static let warnIcon     = Color(hex: 0xE8C22A)
    static let badge        = Color(hex: 0xFFB4B6)
    static let radius: CGFloat = 12
}

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: 1)
    }
}

// MARK: - Fondo de pantalla

extension View {
    /// Fondo negro del diseño, sin gris del sistema.
    func souzaiScreen() -> some View {
        background(SouzaiColor.background)
            .scrollContentBackground(.hidden)
            .toolbarBackground(SouzaiColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Banner

struct SouzaiBanner: View {
    var badge: String = "PROJETO 3105"

    var body: some View {
        ZStack(alignment: .topLeading) {
            Group {
                if let image = UIImage(named: "ExternalBanner") {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    SouzaiBannerArt()
                }
            }

            VStack(alignment: .leading, spacing: -2) {
                Text("SOUZAIOSOFICIAL")
                    .font(.system(size: 19, weight: .black))
                    .fontWidth(.condensed)
                    .kerning(-0.4)
                    .foregroundStyle(.white)
                Text("EXTERNAL")
                    .font(.system(size: 33, weight: .black))
                    .fontWidth(.condensed)
                    .kerning(-0.6)
                    .foregroundStyle(SouzaiColor.red)
            }
            .shadow(color: SouzaiColor.red.opacity(0.55), radius: 10)
            .transformEffect(CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0))
            .padding(.leading, 14)
            .padding(.top, 14)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Souzaiosofficial External")

            HStack {
                Spacer()
                Text(badge)
                    .font(.system(size: 9, weight: .heavy))
                    .kerning(1)
                    .foregroundStyle(SouzaiColor.badge)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color(hex: 0x24070A), in: Capsule())
                    .overlay(Capsule().strokeBorder(Color(hex: 0x5A1015), lineWidth: 1))
            }
            .padding(8)
        }
        .frame(height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(SouzaiColor.borderDeep, lineWidth: 1)
        }
    }
}

private struct SouzaiBannerArt: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                LinearGradient(colors: [SouzaiColor.bannerEdge, SouzaiColor.bannerCore, Color(hex: 0x060102)],
                               startPoint: .leading, endPoint: .trailing)
                RadialGradient(colors: [SouzaiColor.redDeep.opacity(0.85), .clear],
                               center: UnitPoint(x: 0.8, y: 0.5), startRadius: 2, endRadius: w * 0.55)
                slash(x: 0.05, w: w, h: h, opacity: 0.45)
                slash(x: 0.3, w: w, h: h, opacity: 0.3)
                slash(x: 0.62, w: w, h: h, opacity: 0.4)
                Path { path in
                    path.move(to: CGPoint(x: w * 0.57, y: h * 0.12))
                    path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.36))
                    path.addLine(to: CGPoint(x: w * 0.62, y: h * 0.46))
                    path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.74))
                }
                .stroke(SouzaiColor.red.opacity(0.7), lineWidth: 1.4)
            }
        }
        .accessibilityHidden(true)
    }

    private func slash(x: CGFloat, w: CGFloat, h: CGFloat, opacity: Double) -> some View {
        Path { path in
            let base = w * x
            path.move(to: CGPoint(x: base, y: h))
            path.addLine(to: CGPoint(x: base + w * 0.13, y: 0))
            path.addLine(to: CGPoint(x: base + w * 0.2, y: h))
            path.closeSubpath()
        }
        .fill(SouzaiColor.redDeep.opacity(opacity))
    }
}

// MARK: - Piezas de lista

struct SouzaiSectionLabel: View {
    let systemImage: String
    let title: String

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: systemImage).font(.system(size: 11, weight: .bold))
            Text(title).font(.system(size: 10.5, weight: .heavy)).kerning(1.6)
        }
        .foregroundStyle(SouzaiColor.redText)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 14)
        .padding(.bottom, 8)
        .accessibilityElement(children: .combine)
    }
}

struct SouzaiCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(SouzaiColor.surface, in: RoundedRectangle(cornerRadius: SouzaiColor.radius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: SouzaiColor.radius, style: .continuous)
                    .strokeBorder(SouzaiColor.border, lineWidth: 1)
            }
    }
}

struct SouzaiSwitch: View {
    let isOn: Bool
    let label: String
    let action: () -> Void

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) { action() }
        } label: {
            Capsule(style: .continuous)
                .fill(isOn ? SouzaiColor.red : SouzaiColor.track)
                .frame(width: 46, height: 26)
                .overlay {
                    Circle()
                        .fill(.white)
                        .frame(width: 20, height: 20)
                        .padding(3)
                        .frame(maxWidth: .infinity, alignment: isOn ? .trailing : .leading)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isOn ? "ativado" : "desativado")
    }
}

struct SouzaiStatusPill: View {
    let activeOption: String?
    var idleText: String = "PRONTO — ESCOLHA UMA OPÇÃO"

    private var isActive: Bool { activeOption != nil }

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(isActive ? SouzaiColor.success : SouzaiColor.textTertiary)
                .frame(width: 6, height: 6)
                .shadow(color: isActive ? SouzaiColor.success.opacity(0.8) : .clear, radius: 4)
            Text(activeOption.map { "ATIVO — \($0)" } ?? idleText)
                .font(.system(size: 10, weight: .bold))
                .kerning(1.2)
                .foregroundStyle(isActive ? Color(hex: 0x7EE2A0) : Color(hex: 0x9A9091))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(SouzaiColor.surfaceAlt, in: Capsule())
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

struct SouzaiWarningCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(SouzaiColor.warnIcon)
                .accessibilityHidden(true)
            Text(text)
                .font(.system(size: 11.5))
                .lineSpacing(3)
                .foregroundStyle(SouzaiColor.warnText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(SouzaiColor.warnBackground, in: RoundedRectangle(cornerRadius: SouzaiColor.radius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SouzaiColor.radius, style: .continuous)
                .strokeBorder(SouzaiColor.warnBorder, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}
