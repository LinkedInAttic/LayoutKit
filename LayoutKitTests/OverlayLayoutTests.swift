// Copyright 2017 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class OverlayLayoutTests: XCTestCase {

    // MARK: - constants

    private enum MaxLayout {

        static let background = 5
        static let overlay = 5

    }

    private enum Measurement {

        static let hugeWidth: CGFloat = 5000.0
        static let hugeHeight: CGFloat = 5000.0
        static let primaryWidth: CGFloat = 600.0
        static let primaryHeight: CGFloat = 300.0
        static let backgroundWidth: CGFloat = 60.0
        static let backgroundHeight: CGFloat = 40.0
        static let overlayWidth: CGFloat = 40.0
        static let overlayHeight: CGFloat = 80.0

    }

    private enum TestAlignment {

        static let all: [Alignment] = [
            .center,
            .centerLeading,
            .centerTrailing,
            .fill,
            .fillLeading,
            .fillTrailing,
            .topLeading,
            .topTrailing,
            .topCenter,
            .topFill,
            .bottomLeading,
            .bottomTrailing,
            .bottomCenter,
            .bottomFill,
            .aspectFit
        ]

    }

    // MARK: - tests

    /**
     Tests a simple primary-only layout
     */
    func testSimplePrimaryLayout() {
        let primaryLayout = SizeLayout<View>(width: 2, height: 2)
        let overlay = OverlayLayout(primaryLayouts: [primaryLayout])
        let arrangement = overlay.arrangement()

        let expectedFrame = CGRect(x: 0, y: 0, width: 2.0, height: 2.0)
        AssertEqualDensity(arrangement.frame, [
            1.0: expectedFrame,
            2.0: expectedFrame,
            3.0: expectedFrame
            ])
    }

    /**
     Tests an overlay layout with just two simple primary layouts.
     */
    func testTwoSimplePrimaryLayouts() {
        let primaryLayout0 = SizeLayout<View>(width: 100, height: 30)
        let primaryLayout1 = SizeLayout<View>(width: 40, height: 200)
        let overlay = OverlayLayout(primaryLayouts: [primaryLayout0, primaryLayout1])
        let arrangement = overlay.arrangement()

        let expectedFrame = CGRect(x: 0, y: 0, width: 100.0, height: 200.0)
        AssertEqualDensity(arrangement.frame, [
            1.0: expectedFrame,
            2.0: expectedFrame,
            3.0: expectedFrame
            ])
    }

    /**
     Tests an overlay layout with two primary layouts where one is bigger than the other in terms of both width and height.
     */
    func testSmallerBiggerPrimaryLayouts() {
        let primaryLayout0 = SizeLayout<View>(width: 40, height: 30)
        let primaryLayout1 = SizeLayout<View>(width: 100, height: 200)
        let overlay = OverlayLayout(primaryLayouts: [primaryLayout0, primaryLayout1])
        let arrangement = overlay.arrangement()

        let expectedFrame = CGRect(x: 0, y: 0, width: 100.0, height: 200.0)
        AssertEqualDensity(arrangement.frame, [
            1.0: expectedFrame,
            2.0: expectedFrame,
            3.0: expectedFrame
            ])
    }

    /**
     Tests an overlay layout with just three simple primary layouts.
     */
    func testThreeSimplePrimaryLayouts() {
        let primaryLayout0 = SizeLayout<View>(width: 100, height: 30)
        let primaryLayout1 = SizeLayout<View>(width: 40, height: 200)
        let primaryLayout2 = SizeLayout<View>(width: 120, height: 150)
        let overlay = OverlayLayout(primaryLayouts: [primaryLayout0, primaryLayout1, primaryLayout2])
        let arrangement = overlay.arrangement()

        let expectedFrame = CGRect(x: 0, y: 0, width: 120.0, height: 200.0)
        AssertEqualDensity(arrangement.frame, [
            1.0: expectedFrame,
            2.0: expectedFrame,
            3.0: expectedFrame
            ])
    }

    /**
     Tests flexible size of primary layout. Primary layout is measured with size 2x2.
     Sublayouts should have same measurements.
     */
    func testOverlaySublayoutsSize() {
        let primaryLayout = SizeLayout<View>(minWidth: 1)
        let sublayout = SizeLayout<View>(minWidth: 2, alignment: .fillLeading)

        let overlay = OverlayLayout(primaryLayouts: [primaryLayout], overlayLayouts: [sublayout])
        let arrangement = overlay.arrangement(width: 2.0, height: 2.0)

        let expectedFrame = CGRect(x: 0, y: 0, width: 2.0, height: 2.0)
        arrangement.sublayouts.forEach {
            AssertEqualDensity($0.frame, [
                1.0: expectedFrame,
                2.0: expectedFrame,
                3.0: expectedFrame
                ])
        }
    }

    /**
     Tests flexible size of primary layouts. Primary layouts are measured with size 20x20.
     Sublayouts should have same measurements.
     */
    func testOverlaySublayoutsSizeWithTwoPrimaryLayouts() {
        let primaryLayout0 = SizeLayout<View>(minWidth: 5)
        let primaryLayout1 = SizeLayout<View>(minWidth: 30)
        let sublayout = SizeLayout<View>(minWidth: 20, alignment: .fillLeading)

        let overlay = OverlayLayout(primaryLayouts: [primaryLayout0, primaryLayout1], overlayLayouts: [sublayout])
        let arrangement = overlay.arrangement(width: 20.0, height: 20.0)

        let expectedFrame = CGRect(x: 0, y: 0, width: 20.0, height: 20.0)
        arrangement.sublayouts.forEach {
            AssertEqualDensity($0.frame, [
                1.0: expectedFrame,
                2.0: expectedFrame,
                3.0: expectedFrame
                ])
        }
    }

    /**
     Tests primary layout smaller than overlay.
     Sublayouts should have same measurements.
     */
    func testPrimaryLayoutSmallerThanOverlay() {
        let primaryLayout = SizeLayout<View>(minWidth: 2, minHeight: 2)
        let sublayout = SizeLayout<View>(minWidth: 10, minHeight: 10)

        let overlay = OverlayLayout(primaryLayouts: [primaryLayout], overlayLayouts: [sublayout])
        let arrangement = overlay.arrangement(width: 2.0, height: 2.0)

        let expectedFrame = CGRect(x: 0, y: 0, width: 2.0, height: 2.0)
        arrangement.sublayouts.forEach {
            AssertEqualDensity($0.frame, [
                1.0: expectedFrame,
                2.0: expectedFrame,
                3.0: expectedFrame
                ])
        }
    }

    /**
     Tests primary layouts smaller than overlay while available size is between primary layouts and overlay layouts.
     */
    func testPrimaryLayoutsSmallerThanOverlayAndAvailableSizeInBetween() {
        let primaryLayout0 = SizeLayout<View>(width: 2, height: 2)
        let primaryLayout1 = SizeLayout<View>(width: 3, height: 4)
        let overlayLayout0 = SizeLayout<View>(width: 10, height: 10)

        let overlay = OverlayLayout(primaryLayouts: [primaryLayout0, primaryLayout1], overlayLayouts: [overlayLayout0])
        let arrangement = overlay.arrangement(width: 5.0, height: 6.0)

        // center alignment
        let expectedSmallPrimaryFrame = CGRect(x: 1.5, y: 2.0, width: 2.0, height: 2.0)
        let expectedBigPrimaryFrame = CGRect(x: 1.0, y: 1.0, width: 3.0, height: 4.0)
        let expectedOverlayFrame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 6.0)
        AssertEqualDensity(arrangement.sublayouts[0].frame, [
            1.0: expectedSmallPrimaryFrame,
            2.0: expectedSmallPrimaryFrame,
            3.0: expectedSmallPrimaryFrame
            ])
        AssertEqualDensity(arrangement.sublayouts[1].frame, [
            1.0: expectedBigPrimaryFrame,
            2.0: expectedBigPrimaryFrame,
            3.0: expectedBigPrimaryFrame
            ])
        AssertEqualDensity(arrangement.sublayouts[2].frame, [
            1.0: expectedOverlayFrame,
            2.0: expectedOverlayFrame,
            3.0: expectedOverlayFrame
            ])
    }

    /**
     Tests primary layouts smaller than overlay while available size is smaller than primary layouts.
     */
    func testPrimaryLayoutsSmallerThanOverlayAndAvailableSizeIsEvenSmaller() {
        let primaryLayout0 = SizeLayout<View>(width: 2, height: 2)
        let primaryLayout1 = SizeLayout<View>(width: 7, height: 8)
        let overlayLayout0 = SizeLayout<View>(width: 10, height: 10)

        let overlay = OverlayLayout(primaryLayouts: [primaryLayout0, primaryLayout1], overlayLayouts: [overlayLayout0])
        let arrangement = overlay.arrangement(width: 5.0, height: 6.0)

        // center alignment
        let expectedSmallPrimaryFrame = CGRect(x: 1.5, y: 2.0, width: 2.0, height: 2.0)
        let expectedBigPrimaryFrame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 6.0)
        let expectedOverlayFrame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 6.0)
        AssertEqualDensity(arrangement.sublayouts[0].frame, [
            1.0: expectedSmallPrimaryFrame,
            2.0: expectedSmallPrimaryFrame,
            3.0: expectedSmallPrimaryFrame
            ])
        AssertEqualDensity(arrangement.sublayouts[1].frame, [
            1.0: expectedBigPrimaryFrame,
            2.0: expectedBigPrimaryFrame,
            3.0: expectedBigPrimaryFrame
            ])
        AssertEqualDensity(arrangement.sublayouts[2].frame, [
            1.0: expectedOverlayFrame,
            2.0: expectedOverlayFrame,
            3.0: expectedOverlayFrame
            ])
    }

    /**
     Tests a simple layout with variable sized background and overlay layouts. The primary layout is
     always 2x2, and the background and overlay layouts are variably sized based on the amount of them.
     */
    func testSimpleLayoutWithVariableSublayouts() {
        (0...MaxLayout.background).forEach { backgroundCount in
            (0...MaxLayout.overlay).forEach { overlayCount in
                let size = CGFloat(overlayCount + backgroundCount)
                let sublayout = SizeLayout<View>(width: size, height: size)
                let primaryLayout = SizeLayout<View>(width: 2, height: 2)
                let overlay = OverlayLayout(
                    primaryLayouts: [primaryLayout],
                    backgroundLayouts: [Layout](repeating: sublayout, count: backgroundCount),
                    overlayLayouts: [Layout](repeating: sublayout, count: overlayCount))
                let arrangement = overlay.arrangement()

                // Makes sure the view is always 2x2
                let expectedFrame = CGRect(x: 0, y: 0, width: 2.0, height: 2.0)
                AssertEqualDensity(arrangement.frame, [
                    1.0: expectedFrame,
                    2.0: expectedFrame,
                    3.0: expectedFrame
                    ])
            }
        }
    }

    /**
     This test goes through all alignments for the backgrounds, all alignments for the overlays, and
     all alignments for the primary layout, and creates a complex layout with lots of sublayouts. Then,
     it confirms the main alignment's frames are correct, using the alignment's calculation for the
     given size in the max rectangle.
     */
    func testComplexLayoutWithAlignment() {
        let maxSize = CGSize(width: Measurement.hugeWidth, height: Measurement.hugeHeight)
        let maxRect = CGRect(origin: .zero, size: maxSize)
        let layoutSize = CGSize(width: Measurement.primaryWidth, height: Measurement.primaryHeight)
        (0..<TestAlignment.all.count).forEach { primaryAlignmentIndex in
            (0..<TestAlignment.all.count).forEach { backgroundCount in
                (0..<TestAlignment.all.count).forEach { overlayCount in
                    /*
                     Create a complex layout and simulate laying it out in a giant frame so we can
                     test the alignment of the complex layout itself, as well as all of the sublayouts'
                     alignment values.
                     */
                    let primaryAlignment = TestAlignment.all[primaryAlignmentIndex]
                    let layout = self.createComplexLayout(
                        backgroundCount: backgroundCount,
                        overlayCount: overlayCount,
                        primaryAlignment: primaryAlignment)
                    let arrangement = layout.arrangement(
                        origin: .zero,
                        width: maxSize.width,
                        height: maxSize.height)
                    let expectedRect = primaryAlignment.position(size: layoutSize, in: maxRect)
                    AssertEqualDensity(arrangement.frame, [1.0: expectedRect, 2.0: expectedRect, 3.0: expectedRect])
                }
            }
        }
    }

    /**
     This test goes through all alignments for the backgrounds and all alignments for the overlays
     and creates a complex layout with lots of sublayouts. Then, it confirms the main alignment's frames
     are correct, using the alignment's calculation for the given size in the max rectangle, as well
     as every sublayout's frames.
     */
    func testComplexLayoutSublayouts() {
        let layoutSize = CGSize(width: Measurement.primaryWidth, height: Measurement.primaryHeight)
        let expectedRect = CGRect(origin: .zero, size: layoutSize)
        (0..<TestAlignment.all.count).forEach { backgroundCount in
            (0..<TestAlignment.all.count).forEach { overlayCount in
                /*
                 Create a complex layout and simulate laying it out in a giant frame so we can
                 test the alignment of all of the sublayouts.
                 */
                let layout = self.createComplexLayout(
                    backgroundCount: backgroundCount,
                    overlayCount: overlayCount,
                    primaryAlignment: .center)
                let arrangement = layout.arrangement()
                assertAlignment(for: arrangement, equalTo: expectedRect, backgroundCount: backgroundCount)
            }
        }
    }

    /**
     Makes sure that huge overlays and underlays don't overflow their bounds - they are constrained
     to the size of the primary layout.
     */
    func testHugeOverlaysAndUnderlays() {
        TestAlignment.all.forEach { primaryAlignment in
            TestAlignment.all.forEach { hugeAlignment in
                let huge = SizeLayout(
                    width: Measurement.hugeWidth,
                    height: Measurement.hugeHeight,
                    alignment: hugeAlignment)
                let primary = SizeLayout(
                    width: Measurement.primaryWidth,
                    height: Measurement.primaryHeight,
                    alignment: primaryAlignment)
                let overlay = OverlayLayout(primaryLayouts: [primary], backgroundLayouts: [huge], overlayLayouts: [huge])
                let expectedFrame = CGRect(
                    origin: .zero,
                    size: CGSize(width: Measurement.primaryWidth, height: Measurement.primaryHeight))
                let arrangement = overlay.arrangement()
                AssertEqualDensity(arrangement.frame, [1.0: expectedFrame, 2.0: expectedFrame, 3.0: expectedFrame])
            }
        }
    }

    /**
     Tests the overlay layout when the size it is being laid into is unlimited. Confirms that all the
     alignments are correct, using a complex layout with lots of sublayouts. Lays it out into the top
     left so we can know the correct size.
     */
    func testUnlimitedSize() {
        let layoutSize = CGSize(width: Measurement.primaryWidth, height: Measurement.primaryHeight)
        let expectedRect = CGRect(origin: .zero, size: layoutSize)
        (0..<TestAlignment.all.count).forEach { backgroundCount in
            (0..<TestAlignment.all.count).forEach { overlayCount in
                /*
                 Create a complex layout and simulate laying it out in the largest frame possible so we can
                 test the alignment of all of the sublayouts.
                 */
                let layout = self.createComplexLayout(
                    backgroundCount: backgroundCount,
                    overlayCount: overlayCount,
                    primaryAlignment: .topLeading)
                let arrangement = layout.arrangement(
                    origin: .zero,
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude)
                assertAlignment(for: arrangement, equalTo: expectedRect, backgroundCount: backgroundCount)
            }
        }
    }

    /**
     Tests that make views creates the correct number of views when there's different amounts of
     background and overlay layouts passed.
     */
    func testViewCreationAndConfiguration() {
        (0...MaxLayout.background).forEach { backgroundCount in
            (0...MaxLayout.overlay).forEach { overlayCount in
                var configCount = 0
                let layout = SizeLayout<View>(width: 1, height: 1, config: { _ in
                    configCount += 1
                })
                let overlay = OverlayLayout(
                    primaryLayouts: [layout],
                    backgroundLayouts: [Layout](repeating: layout, count: backgroundCount),
                    overlayLayouts: [Layout](repeating: layout, count: overlayCount),
                    config: { _ in
                        configCount += 1
                })
                let overlayView = overlay.arrangement().makeViews()
                XCTAssertNotNil(overlayView)

                // overlay config + primary config + backgroundCount + overlayCount
                XCTAssertEqual(configCount, 2 + backgroundCount + overlayCount)
            }
        }
    }

    /**
     Makes sure that the views are ordered correctly - first background, then primary, then overlay.
     */
    func testViewOrdering() {
        // Note: the empty configs here are used to ensure that views get created for these layouts
        let background = SizeLayout(
            width: Measurement.backgroundWidth,
            height: Measurement.backgroundHeight,
            alignment: .topLeading,
            config: { _ in })
        let overlay = SizeLayout(
            width: Measurement.overlayWidth,
            height: Measurement.overlayHeight,
            alignment: .topLeading,
            config: { _ in })
        let primary = SizeLayout(
            width: Measurement.primaryWidth,
            height: Measurement.primaryHeight,
            alignment: .topLeading,
            config: { _ in })
        let layout = OverlayLayout(
            primaryLayouts: [primary],
            backgroundLayouts: [background, background, background],
            overlayLayouts: [overlay, overlay])

        let backgroundFrame = CGRect(x: 0, y: 0, width: Measurement.backgroundWidth, height: Measurement.backgroundHeight)
        let primaryFrame = CGRect(x: 0, y: 0, width: Measurement.primaryWidth, height: Measurement.primaryHeight)
        let overlayFrame = CGRect(x: 0, y: 0, width: Measurement.overlayWidth, height: Measurement.overlayHeight)

        // Asserts that all the frames match up correctly with the expected
        let testFrames = { (frames: [CGRect]) in
            XCTAssertEqual(frames.count, 6, "Wrong number of frames")
            frames.prefix(upTo: 3).forEach { frame in
                AssertEqualDensity(frame, [1.0: backgroundFrame, 2.0: backgroundFrame, 3.0: backgroundFrame])
            }
            AssertEqualDensity(frames[3], [1.0: primaryFrame, 2.0: primaryFrame, 3.0: primaryFrame])
            frames.suffix(from: 4).forEach { frame in
                AssertEqualDensity(frame, [1.0: overlayFrame, 2.0: overlayFrame, 3.0: overlayFrame])
            }
        }

        // Make sure (using the layout properties) that we have the correct lists of layouts
        XCTAssertEqual(layout.background.count, 3, "Background layouts incorrect")
        XCTAssertEqual(layout.overlay.count, 2, "Overlay layouts incorrect")

        // Make sure (using the arrangement's sublayouts' frames) that we have the correct order
        let arrangement = layout.arrangement()
        testFrames(arrangement.sublayouts.map({ $0.frame }))


        // Make sure (using the view frames themselves) that we have the correct order in `makeViews`.
        let mainView = arrangement.makeViews()
        AssertEqualDensity(mainView.frame, [1.0: primaryFrame, 2.0: primaryFrame, 3.0: primaryFrame])
        testFrames(mainView.subviews.map({ $0.frame }))
    }

    // MARK: - helpers

    /**
     Asserts that the alignments have the correct frames based on the given params.
     */
    private func assertAlignment(for arrangement: LayoutArrangement,
                                 equalTo expectedRect: CGRect,
                                 backgroundCount: Int) {
        // Make sure the frame is right for the main arrangement (should be the full size)
        AssertEqualDensity(arrangement.frame, [1.0: expectedRect, 2.0: expectedRect, 3.0: expectedRect])

        // Now check the children's alignments, using the expected frame from the alignment object
        arrangement.sublayouts.enumerated().forEach { (index, subLayout) in
            if index <= backgroundCount {
                // We have a background layout
                let backgroundSize = CGSize(width: Measurement.backgroundWidth, height: Measurement.backgroundHeight)
                let frame = TestAlignment.all[index].position(size: backgroundSize, in: expectedRect)
                AssertEqualDensity(subLayout.frame, [1.0: frame, 2.0: frame, 3.0: frame])
            } else if index == backgroundCount + 1 {
                // We have the primary layout - should be laid out just like the overlay itself
                AssertEqualDensity(subLayout.frame, [1.0: expectedRect, 2.0: expectedRect, 3.0: expectedRect])
            } else if index > backgroundCount + 1 {
                // We have an overlay layout
                let overlaySize = CGSize(width: Measurement.overlayWidth, height: Measurement.overlayHeight)
                let frame = TestAlignment.all[index - backgroundCount - 2].position(
                    size: overlaySize,
                    in: expectedRect)
                AssertEqualDensity(subLayout.frame, [1.0: frame, 2.0: frame, 3.0: frame])
            }
        }
    }

    /**
     Given the passed-in parameters, creates a complex overlay layout.
     */
    private func createComplexLayout(backgroundCount: Int,
                                     overlayCount: Int,
                                     primaryAlignment: Alignment) -> Layout {
        let backgroundLayouts = (0...backgroundCount).map { index in
            return SizeLayout(
                width: Measurement.backgroundWidth,
                height: Measurement.backgroundHeight,
                alignment: TestAlignment.all[index])
        }
        let overlayLayouts = (0...overlayCount).map { index in
            return SizeLayout(
                width: Measurement.overlayWidth,
                height: Measurement.overlayHeight,
                alignment: TestAlignment.all[index])
        }
        let baseLayout = SizeLayout(
            width: Measurement.primaryWidth,
            height: Measurement.primaryHeight)
        return OverlayLayout(
            primaryLayouts: [baseLayout],
            backgroundLayouts: backgroundLayouts,
            overlayLayouts: overlayLayouts,
            alignment: primaryAlignment)
    }
}
