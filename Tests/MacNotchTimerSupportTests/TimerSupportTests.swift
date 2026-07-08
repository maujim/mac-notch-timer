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

    @Test func presentationHeightsMatchStealthHoverTargetAndExpandedTimerStates() {
        #expect(NotchTimerGeometry.stealthHeight == 6)
        #expect(NotchTimerGeometry.stealthHoverTargetHeight == 12)
        #expect(NotchTimerGeometry.stealthHoverTargetHeight == NotchTimerGeometry.stealthHeight * 2)
        #expect(NotchTimerGeometry.Presentation.stealth.height == NotchTimerGeometry.stealthHoverTargetHeight)
        #expect(NotchTimerGeometry.Presentation.expanded.height == 36)
        #expect(NotchTimerGeometry.stealthHeight < NotchTimerGeometry.Presentation.stealth.height)
        #expect(NotchTimerGeometry.Presentation.stealth.height < NotchTimerGeometry.Presentation.expanded.height)
    }

    @Test func stealthAndExpandedFramesShareTopEdgeWhileExpandingDownward() {
        let topY: CGFloat = 894
        let width: CGFloat = 210
        let centerX: CGFloat = 756

        let stealthFrame = NotchTimerGeometry.frame(
            centeredAtX: centerX,
            topY: topY,
            width: width,
            presentation: .stealth
        )
        let expandedFrame = NotchTimerGeometry.frame(
            centeredAtX: centerX,
            topY: topY,
            width: width,
            presentation: .expanded
        )

        #expect(stealthFrame == CGRect(x: 651, y: 882, width: 210, height: 12))
        #expect(expandedFrame == CGRect(x: 651, y: 858, width: 210, height: 36))
        #expect(stealthFrame.maxY == topY)
        #expect(expandedFrame.maxY == topY)
        #expect(stealthFrame.maxY == expandedFrame.maxY)
        #expect(stealthFrame.minY == topY - NotchTimerGeometry.stealthHoverTargetHeight)
        #expect(expandedFrame.minY == topY - NotchTimerGeometry.expandedHeight)
    }

    @Test func frameInVisibleFrameCentersNotchWidthFlushWithMenuBarBottom() {
        let visibleFrame = CGRect(x: 0, y: 0, width: 1512, height: 900)

        let frame = NotchTimerGeometry.frame(
            in: visibleFrame,
            notchWidth: 260,
            presentation: .expanded
        )

        #expect(frame == CGRect(x: 626, y: 864, width: 260, height: 36))
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
