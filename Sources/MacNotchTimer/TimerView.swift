import AppKit
import MacNotchTimerSupport

final class TimerView: NSView {
    private let textField = NSTextField(labelWithString: "05:00")
    private let compactTrackLayer = CALayer()
    private let compactBarLayer = CALayer()
    private var remainingSeconds: Int
    private let totalSeconds: Int
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
        totalSeconds = duration
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
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        super.layout()
        
        let barHeight = NotchTimerGeometry.compactHeight
        let textFieldHeight: CGFloat = 24
        let remainingHeight: CGFloat = isExpanded ? (bounds.height - barHeight) : bounds.height
        let textFieldY = bounds.minY + (remainingHeight - textFieldHeight) / 2
        textField.frame = CGRect(
            x: bounds.minX,
            y: textFieldY,
            width: bounds.width,
            height: textFieldHeight
        )
        
        updateLayerFrames()
        CATransaction.commit()
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
        
        compactTrackLayer.backgroundColor = NSColor.systemGray.withAlphaComponent(0.4).cgColor
        compactTrackLayer.cornerRadius = NotchTimerGeometry.compactCornerRadius
        compactTrackLayer.masksToBounds = true
        layer?.addSublayer(compactTrackLayer)
        
        compactBarLayer.backgroundColor = NSColor.systemGreen.cgColor
        compactBarLayer.cornerRadius = NotchTimerGeometry.compactCornerRadius
        compactBarLayer.masksToBounds = true
        layer?.addSublayer(compactBarLayer)
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
        updateLayerFrames()
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
        layer?.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer?.masksToBounds = isExpanded
        compactTrackLayer.isHidden = false
        compactBarLayer.isHidden = false
        textField.isHidden = !isExpanded
        updateLayerFrames()
        CATransaction.commit()
    }

    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let barHeight = NotchTimerGeometry.compactHeight
        let progress = totalSeconds > 0 ? max(0.0, min(1.0, Double(remainingSeconds) / Double(totalSeconds))) : 0.0
        
        let horizontalPadding: CGFloat = 2.0
        let maxBarWidth = bounds.width - (horizontalPadding * 2.0)
        let barY = bounds.maxY - barHeight
        
        compactTrackLayer.frame = CGRect(
            x: bounds.minX + horizontalPadding,
            y: barY,
            width: maxBarWidth,
            height: barHeight
        )
        
        let barWidth = maxBarWidth * CGFloat(progress)
        let barX = bounds.minX + horizontalPadding + (maxBarWidth - barWidth) / 2.0
        compactBarLayer.frame = CGRect(
            x: barX,
            y: barY,
            width: barWidth,
            height: barHeight
        )
        CATransaction.commit()
    }
}
