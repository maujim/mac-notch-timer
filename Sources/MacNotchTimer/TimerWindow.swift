import AppKit
import MacNotchTimerSupport

final class TimerWindow: NSPanel {
    private static let fallbackNotchWidth = NotchTimerGeometry.fallbackNotchWidth
    private static let timerHeight: CGFloat = 36
    private static let verticalInset: CGFloat = 6

    init(screen: NSScreen?) {
        let targetScreen = screen ?? NSScreen.main ?? NSScreen.screens.first
        let frame = Self.windowFrame(on: targetScreen)

        super.init(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        backgroundColor = .black
        isOpaque = true
        hasShadow = false
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        hidesOnDeactivate = false
        isReleasedWhenClosed = false
        contentView = TimerView(duration: 300)
    }

    func show() {
        orderFrontRegardless()
    }

    private static func windowFrame(on screen: NSScreen?) -> NSRect {
        guard let screen else {
            return NSRect(x: 0, y: 0, width: fallbackNotchWidth, height: timerHeight)
        }

        let screenFrame = screen.frame
        let visibleFrame = screen.visibleFrame
        let width = notchWidth(on: screen)
        let x = screenFrame.midX - (width / 2)
        let y = visibleFrame.maxY - timerHeight - verticalInset

        return NSRect(x: x.rounded(), y: y.rounded(), width: width.rounded(), height: timerHeight)
    }

    private static func notchWidth(on screen: NSScreen) -> CGFloat {
        NotchTimerGeometry.notchWidth(
            leftArea: screen.auxiliaryTopLeftArea,
            rightArea: screen.auxiliaryTopRightArea
        )
    }
}
