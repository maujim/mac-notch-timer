import AppKit
import MacNotchTimerSupport

final class TimerView: NSView {
    private let textField = NSTextField(labelWithString: "05:00")
    private let stealthBarLayer = CALayer()
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
        updateLayerFrames()
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
        layer?.backgroundColor = NSColor.clear.cgColor
        stealthBarLayer.backgroundColor = NSColor.black.withAlphaComponent(0.35).cgColor
        stealthBarLayer.cornerRadius = NotchTimerGeometry.stealthCornerRadius
        stealthBarLayer.masksToBounds = true
        layer?.addSublayer(stealthBarLayer)

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
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer?.backgroundColor = isExpanded ? NSColor.black.cgColor : NSColor.clear.cgColor
        layer?.cornerRadius = isExpanded ? 8 : 0
        layer?.masksToBounds = isExpanded
        stealthBarLayer.isHidden = isExpanded
        textField.isHidden = !isExpanded
        updateLayerFrames()
        CATransaction.commit()
    }

    private func updateLayerFrames() {
        stealthBarLayer.frame = CGRect(
            x: bounds.minX,
            y: bounds.maxY - NotchTimerGeometry.stealthHeight,
            width: bounds.width,
            height: NotchTimerGeometry.stealthHeight
        )
    }
}
