//
//  ArticlesCollectionVIewTests.swift
//  TwitchTestTests
//
//  Created by t19960804 on 2/12/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import XCTest
@testable import TwitchTest
class ArticlesCollectionVIewTests: XCTestCase {

    var articlesCollectionView: ArticlesCollectionViewController?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        articlesCollectionView = ArticlesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        _ = articlesCollectionView?.view
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
    func testNavTitle(){
        articlesCollectionView?.category = "美妝"
        XCTAssertEqual(articlesCollectionView?.navigationItem.title, "美妝")
    }

}
