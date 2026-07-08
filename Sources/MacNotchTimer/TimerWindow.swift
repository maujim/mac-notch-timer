import AppKit
import MacNotchTimerSupport

final class TimerWindow: NSPanel {
    private static let fallbackNotchWidth = NotchTimerGeometry.fallbackNotchWidth

    init(screen: NSScreen?) {
        let targetScreen = screen ?? NSScreen.main ?? NSScreen.screens.first
        let frame = Self.windowFrame(on: targetScreen)

        super.init(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        hidesOnDeactivate = false
        isReleasedWhenClosed = false

        let timerView = TimerView(duration: 300)
        timerView.onHoverChanged = { [weak self] isHovered in
            self?.setExpanded(isHovered)
        }
        contentView = timerView
    }

    func show() {
        orderFrontRegardless()
    }

    private func setExpanded(_ expanded: Bool) {
        let presentation: NotchTimerGeometry.Presentation = expanded ? .expanded : .stealth
        guard frame.height != presentation.height else { return }

        let newFrame = NotchTimerGeometry.frame(
            centeredAtX: frame.midX,
            topY: frame.maxY,
            width: frame.width,
            presentation: presentation
        )
        setFrame(newFrame, display: true, animate: true)
    }

    private static func windowFrame(on screen: NSScreen?) -> NSRect {
        guard let screen else {
            return NSRect(
                x: 0,
                y: 0,
                width: fallbackNotchWidth,
                height: NotchTimerGeometry.Presentation.stealth.height
            )
        }

        let screenFrame = screen.frame
        let visibleFrame = screen.visibleFrame
        let width = notchWidth(on: screen)

        return NotchTimerGeometry.frame(
            centeredAtX: screenFrame.midX,
            topY: visibleFrame.maxY - NotchTimerGeometry.verticalInset,
            width: width,
            presentation: .stealth
        )
    }

    private static func notchWidth(on screen: NSScreen) -> CGFloat {
        NotchTimerGeometry.notchWidth(
            leftArea: screen.auxiliaryTopLeftArea,
            rightArea: screen.auxiliaryTopRightArea
        )
    }
}
