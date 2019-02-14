//
//  PostArticleControllerTests.swift
//  TwitchTestTests
//
//  Created by t19960804 on 2/12/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import XCTest
@testable import TwitchTest
class PostArticleControllerTests: XCTestCase {
    var postArticleController: PostArticleController?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        postArticleController = PostArticleController()
        _ = postArticleController?.view
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
    func testCheckHeart(){
        postArticleController?.pressHeart(number: 4)
        XCTAssertEqual(postArticleController?.numberOfHeart(), 4)
    }
    func testWhatKindOfError(){

        postArticleController?.titleTextField.text = "123"
        postArticleController?.reviewTextView.text = "123"
        
        var error: String?
        do{
            try postArticleController?.whatKindOfError()
        }catch UploadError.NotFillYet{
            error = "NotFillYet"
        }catch UploadError.NoImage{
            error = "NoImage"
        }catch UploadError.NoEvaluate{
            error = "NoEvaluate"
        }catch{
            print("test")
        }
        XCTAssertEqual(error, "NoImage")
        
    }

}
