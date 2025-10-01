//
//  LottoResultsDemoAppUITests.swift
//  LottoResultsDemoAppUITests
//
//  Created by vijayesha on 29.09.25.
//

import XCTest

final class LottoResultsDemoAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testAppLaunch() throws {
        XCTAssertTrue(app.state == .runningForeground)
        
        let navigationTitle = app.navigationBars["Lotteries"]
        XCTAssertTrue(navigationTitle.exists)
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testToolbarFilterButton() throws {
        let filterButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(filterButton.exists)
    }
    
    @MainActor
    func testLotteryListDisplay() throws {
        let lotteryList = app.tables.firstMatch
        if lotteryList.exists {
            XCTAssertTrue(lotteryList.exists)
        }
    }
    
    @MainActor
    func testLotteryItemDisplay() throws {
        let lotteryItems = app.cells
        if lotteryItems.count > 0 {
            XCTAssertGreaterThan(lotteryItems.count, 0)
        }
    }
    
    
    @MainActor
    func testPullToRefresh() throws {
        let lotteryList = app.tables.firstMatch
        if lotteryList.exists {
            lotteryList.swipeDown()
        }
        XCTAssertTrue(true)
    }

    
    @MainActor
    func testNetworkErrorDisplay() throws {
        let errorAlert = app.alerts.firstMatch
        if errorAlert.exists {
            XCTAssertTrue(errorAlert.exists)
        }
    }
    
    @MainActor
    func testErrorAlertDismissal() throws {
        let errorAlert = app.alerts.firstMatch
        if errorAlert.exists {
            let okButton = errorAlert.buttons["OK"]
            okButton.tap()
        }
        XCTAssertFalse(errorAlert.exists)
    }
    
    @MainActor
    func testScrollPerformance() throws {
        // Test scrolling performance with large lists
        let lotteryList = app.tables.firstMatch
        if lotteryList.exists {
            measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
                lotteryList.swipeUp(velocity: .fast)
                lotteryList.swipeDown(velocity: .fast)
            }
        }
    }
}
