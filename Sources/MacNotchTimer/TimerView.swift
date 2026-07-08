import AppKit
import MacNotchTimerSupport

final class TimerView: NSView {
    private let textField = NSTextField(labelWithString: "05:00")
    private var remainingSeconds: Int
    private var timer: Timer?

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
}
