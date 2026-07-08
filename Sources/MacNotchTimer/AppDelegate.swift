import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var timerWindow: TimerWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = TimerWindow(screen: NSScreen.main ?? NSScreen.screens.first)
        timerWindow = window
        window.show()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
