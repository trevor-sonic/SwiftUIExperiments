//
//  DBAccess.swift
//  Tests iOS
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 29/07/2023.
//

import XCTest

final class DBAccess: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testReadObjects() throws {
        let objects = ItemCRUD().findObjects(isMasterObject: true)
        
        XCTAssertNotNil(objects)
    }
    
    func testReadCarProperties(){
        let path = "rootItem.gallery"
        
        ItemCRUD().findBy(path: path)
        
        
        XCTAssertTrue(true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
