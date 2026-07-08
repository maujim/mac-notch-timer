import CoreGraphics

public enum NotchTimerGeometry {
    public static let fallbackNotchWidth: CGFloat = 210

    public static func notchWidth(leftArea: CGRect?, rightArea: CGRect?) -> CGFloat {
        guard let leftArea, let rightArea else {
            return fallbackNotchWidth
        }

        return notchWidth(leftAreaMaxX: leftArea.maxX, rightAreaMinX: rightArea.minX)
    }

    public static func notchWidth(leftAreaMaxX: CGFloat, rightAreaMinX: CGFloat) -> CGFloat {
        max(rightAreaMinX - leftAreaMaxX, fallbackNotchWidth)
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
