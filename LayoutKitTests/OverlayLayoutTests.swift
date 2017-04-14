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

        static let primaryHeight: CGFloat = 300.0
        static let primaryWidth: CGFloat = 600.0
        static let backgroundWidth: CGFloat = 60.0
        static let backgroundHeight: CGFloat = 40.0
        static let overlayWidth: CGFloat = 40.0
        static let overlayHeight: CGFloat = 80.0

    }

    private enum Constant {

        static let alignments: [Alignment] = [
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
        let overlay = OverlayLayout(primary: primaryLayout)
        let arrangement = overlay.arrangement()

        let expectedFrame = CGRect(x: 0, y: 0, width: 2.0, height: 2.0)
        AssertEqualDensity(arrangement.frame, [
            1.0: expectedFrame,
            2.0: expectedFrame,
            3.0: expectedFrame
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
                    primary: primaryLayout,
                    background: [Layout](repeating: sublayout, count: backgroundCount),
                    overlay: [Layout](repeating: sublayout, count: overlayCount))
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
        let maxSize = CGSize(width: 5000, height: 5000)
        let maxRect = CGRect(origin: .zero, size: maxSize)
        let layoutSize = CGSize(width: Measurement.primaryWidth, height: Measurement.primaryHeight)
        (0..<Constant.alignments.count).forEach { primaryAlignmentIndex in
            (0..<Constant.alignments.count).forEach { backgroundCount in
                (0..<Constant.alignments.count).forEach { overlayCount in
                    /**
                     Create a complex layout and simulate laying it out in a giant frame so we can
                     test the alignment of the complex layout itself, as well as all of the sublayouts'
                     alignment values.
                     */
                    let primaryAlignment = Constant.alignments[primaryAlignmentIndex]
                    let layout = self.createComplexLayout(
                        backgroundCount: backgroundCount,
                        overlayCount: overlayCount,
                        primaryAlignment: primaryAlignment)
                    let measurement = layout.measurement(within: maxSize)
                    let arrangement = layout.arrangement(within: maxRect, measurement: measurement)
                    let expectedRect = primaryAlignment.position(size: layoutSize, in: maxRect)

                    // Make sure the frame is right for the main arrangement (should be the full size)
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
        (0..<Constant.alignments.count).forEach { backgroundCount in
            (0..<Constant.alignments.count).forEach { overlayCount in
                /**
                 Create a complex layout and simulate laying it out in a giant frame so we can
                 test the alignment of all of the sublayouts.
                 */
                let layout = self.createComplexLayout(
                    backgroundCount: backgroundCount,
                    overlayCount: overlayCount,
                    primaryAlignment: .center)
                let arrangement = layout.arrangement()

                // Make sure the frame is right for the main arrangement (should be the full size)
                AssertEqualDensity(arrangement.frame, [1.0: expectedRect, 2.0: expectedRect, 3.0: expectedRect])


                // Now check the children's alignments, using the expected frame from the alignment object
                arrangement.sublayouts.enumerated().forEach { (index, subLayout) in
                    if index <= backgroundCount {
                        // We have a background layout
                        let backgroundSize = CGSize(width: Measurement.backgroundWidth, height: Measurement.backgroundHeight)
                        let frame = Constant.alignments[index].position(size: backgroundSize, in: expectedRect)
                        AssertEqualDensity(subLayout.frame, [1.0: frame, 2.0: frame, 3.0: frame])
                    } else if index == backgroundCount + 1 {
                        // We have the primary layout - should be laid out just like the overlay itself
                        AssertEqualDensity(subLayout.frame, [1.0: expectedRect, 2.0: expectedRect, 3.0: expectedRect])
                    } else if index > backgroundCount + 1 {
                        // We have an overlay layout
                        let overlaySize = CGSize(width: Measurement.overlayWidth, height: Measurement.overlayHeight)
                        let frame = Constant.alignments[index - backgroundCount - 2].position(
                            size: overlaySize,
                            in: expectedRect)
                        AssertEqualDensity(subLayout.frame, [1.0: frame, 2.0: frame, 3.0: frame])
                    }
                }
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
                    primary: layout,
                    background: [Layout](repeating: layout, count: backgroundCount),
                    overlay: [Layout](repeating: layout, count: overlayCount),
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

    // MARK: - helpers

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
                alignment: Constant.alignments[index])
        }
        let overlayLayouts = (0...overlayCount).map { index in
            return SizeLayout(
                width: Measurement.overlayWidth,
                height: Measurement.overlayHeight,
                alignment: Constant.alignments[index])
        }
        let baseLayout = SizeLayout(
            width: Measurement.primaryWidth,
            height: Measurement.primaryHeight)
        return OverlayLayout(
            primary: baseLayout,
            background: backgroundLayouts,
            overlay: overlayLayouts,
            alignment: primaryAlignment)
    }
}
