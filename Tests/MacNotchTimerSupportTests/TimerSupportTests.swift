import CoreGraphics
import Testing

@testable import MacNotchTimerSupport

struct NotchTimerGeometryTests {
    @Test func notchWidthFallsBackWhenAuxiliaryAreasAreUnavailable() {
        #expect(NotchTimerGeometry.notchWidth(leftArea: nil, rightArea: nil) == 210)
    }

    @Test func notchWidthFallsBackWhenCalculatedGapIsTooSmall() {
        let leftArea = CGRect(x: 0, y: 0, width: 850, height: 40)
        let rightArea = CGRect(x: 960, y: 0, width: 850, height: 40)

        #expect(NotchTimerGeometry.notchWidth(leftArea: leftArea, rightArea: rightArea) == 210)
    }

    @Test func notchWidthUsesGapBetweenAuxiliaryAreasWhenLargerThanFallback() {
        let leftArea = CGRect(x: 0, y: 0, width: 780, height: 40)
        let rightArea = CGRect(x: 1040, y: 0, width: 780, height: 40)

        #expect(NotchTimerGeometry.notchWidth(leftArea: leftArea, rightArea: rightArea) == 260)
    }
}

struct CountdownFormatterTests {
    @Test func formatsFiveMinuteCountdownStart() {
        #expect(CountdownFormatter.minutesAndSeconds(from: 300) == "05:00")
    }

    @Test func formatsSingleDigitMinutesAndSecondsWithLeadingZeroes() {
        #expect(CountdownFormatter.minutesAndSeconds(from: 9) == "00:09")
        #expect(CountdownFormatter.minutesAndSeconds(from: 61) == "01:01")
    }

    @Test func clampsNegativeSecondsToZero() {
        #expect(CountdownFormatter.minutesAndSeconds(from: -1) == "00:00")
    }
}
