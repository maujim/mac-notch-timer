import CoreGraphics

public enum NotchTimerGeometry {
    public static let fallbackNotchWidth: CGFloat = 210
    public static let expandedHeight: CGFloat = 36
    public static let compactHeight: CGFloat = 6
    public static let compactHoverTargetHeight: CGFloat = compactHeight * 2
    public static let verticalInset: CGFloat = 0
    public static let compactCornerRadius: CGFloat = 4

    public enum Presentation {
        case compact
        case expanded

        public var height: CGFloat {
            switch self {
            case .compact:
                NotchTimerGeometry.compactHoverTargetHeight
            case .expanded:
                NotchTimerGeometry.expandedHeight
            }
        }
    }

    public static func notchWidth(leftArea: CGRect?, rightArea: CGRect?) -> CGFloat {
        guard let leftArea, let rightArea else {
            return fallbackNotchWidth
        }

        return notchWidth(leftAreaMaxX: leftArea.maxX, rightAreaMinX: rightArea.minX)
    }

    public static func notchWidth(leftAreaMaxX: CGFloat, rightAreaMinX: CGFloat) -> CGFloat {
        max(rightAreaMinX - leftAreaMaxX, fallbackNotchWidth)
    }

    public static func frame(centeredAtX centerX: CGFloat, topY: CGFloat, width: CGFloat, presentation: Presentation) -> CGRect {
        CGRect(
            x: (centerX - (width / 2)).rounded(),
            y: (topY - presentation.height).rounded(),
            width: width.rounded(),
            height: presentation.height
        )
    }

    public static func frame(in visibleFrame: CGRect, notchWidth: CGFloat, presentation: Presentation) -> CGRect {
        frame(
            centeredAtX: visibleFrame.midX,
            topY: visibleFrame.maxY - verticalInset,
            width: notchWidth,
            presentation: presentation
        )
    }
}

public enum CountdownFormatter {
    public static func minutesAndSeconds(from totalSeconds: Int) -> String {
        let clampedSeconds = max(totalSeconds, 0)
        let minutes = clampedSeconds / 60
        let seconds = clampedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
