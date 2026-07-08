import AppKit
import MacNotchTimerSupport

final class TimerView: NSView {
    private let textField = NSTextField(labelWithString: "05:00")
    private var remainingSeconds: Int
    private var timer: Timer?
    var onHoverChanged: ((Bool) -> Void)?
    private var trackingArea: NSTrackingArea?
    private var isExpanded = false {
        didSet {
            guard isExpanded != oldValue else { return }
            applyExpandedState()
        }
    }

    init(duration: Int) {
        remainingSeconds = duration
        super.init(frame: .zero)
        configureView()
        updateText()
        startTimer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func layout() {
        super.layout()
        textField.frame = bounds
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea {
            removeTrackingArea(trackingArea)
        }

        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
        self.trackingArea = trackingArea
    }

    override func mouseEntered(with event: NSEvent) {
        setExpanded(true)
    }

    override func mouseExited(with event: NSEvent) {
        setExpanded(false)
    }

    private func configureView() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor

        textField.alignment = .center
        textField.textColor = .white
        textField.font = .monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        textField.backgroundColor = .clear
        textField.isBordered = false
        textField.isEditable = false
        textField.isSelectable = false
        textField.drawsBackground = false
        addSubview(textField)
        applyExpandedState()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func tick(_ timer: Timer) {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            updateText()
        } else {
            timer.invalidate()
        }
    }

    private func updateText() {
        textField.stringValue = CountdownFormatter.minutesAndSeconds(from: remainingSeconds)
    }

    private func setExpanded(_ expanded: Bool) {
        isExpanded = expanded
        onHoverChanged?(expanded)
    }

    private func applyExpandedState() {
        let backgroundColor: NSColor = isExpanded ? .black : .black.withAlphaComponent(0.35)
        layer?.backgroundColor = backgroundColor.cgColor
        textField.isHidden = !isExpanded
    }
}
