//
//  TwitchTestTests.swift
//  TwitchTestTests
//
//  Created by t19960804 on 2/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import XCTest

@testable import TwitchTest
class AllCommodityTests: XCTestCase {
    var allCommodityCollectionViewController: AllCommodityCollectionViewController!
    override func setUp() {
        //測試開始前執行這
        allCommodityCollectionViewController = AllCommodityCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //主動去觸發初始化
        _ = allCommodityCollectionViewController.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testUserDefault(){
        UserDefaults().setIsLogIn(value: true)
        XCTAssertTrue(UserDefaults().isLogIn())
        
        UserDefaults().setIsLogIn(value: false)
        XCTAssertFalse(UserDefaults().isLogIn())
    }
    

}
