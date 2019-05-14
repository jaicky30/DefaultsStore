//
//  DefaultsStoreTests.swift
//  DefaultsStoreTests
//
//  Created by Jaiprakash Dadwani on 13/05/19.
//  Copyright © 2019 jai. All rights reserved.
//

import XCTest
@testable import DefaultsStore

class DefaultsStoreTests: XCTestCase {
    
    var defaultsStore: DefaultsStore!
    var mockProvider: MockCustomObjects!
    override func setUp() {
        super.setUp()
        defaultsStore = DefaultsStore.shared
        mockProvider = MockCustomObjects()
    }
    
    override func tearDown() {
        defaultsStore = nil
        mockProvider = nil
        super.tearDown()
    }
    
    func testStorePrimitives() {
        defaultsStore.set(true, for: "BoolTest")
        XCTAssertEqual(true, defaultsStore.bool(for: "BoolTest"), "The bool values shoould be equal")
        
        defaultsStore.set(false, for: "BoolTest")
        XCTAssertNotEqual(true, defaultsStore.bool(for: "BoolTest"), "The bool values shoould not be equal now")
        
        defaultsStore.set(134423, for: "IntTest")
        XCTAssertEqual(134423, defaultsStore.int(for: "IntTest"), "The Int values shoould be equal")
        
        XCTAssertNil(defaultsStore.int(for: "NotStoredTest"), "The value should be nil for unknown key")
        
        defaultsStore.set(13.32, for: "FloatTest")
        XCTAssertNotEqual(123132, defaultsStore.float(for: "FloatTest"), "The Float values shoould not be equal")
        
    }
    
    func testStoreObjects() {
        defaultsStore.set(mockProvider.getMockPerson(), for: "ObjectTest")
        XCTAssertEqual("John", defaultsStore.object(Person.self, for: "ObjectTest")?.name, "The Person name values shoould be equal")
        
        XCTAssertEqual(2, defaultsStore.object(Person.self, for: "ObjectTest")?.numberOfCars, "The Person's number of car values shoould be equal")
    }
    
    func testStoreStructs() {
        defaultsStore.set(mockProvider.getMockCarStruct(), for: "StructTest")
        XCTAssertEqual("MG", defaultsStore.object(Car.self, for: "StructTest")?.brand, "The Car's brand values shoould be equal")
        
        XCTAssertEqual("SUV", defaultsStore.object(Car.self, for: "StructTest")?.type, "The Car's type values shoould be equal")
    }
    
    func testStorePrimitiveArray() {
        defaultsStore.set([Float(32.3), Float(45)], for: "PrimArrayTest")
        XCTAssertEqual([Float(32.3), Float(45)], defaultsStore.array([Float].self, for: "PrimArrayTest"), "The float array values shoould be equal")
    }
    
    func testStoreObjectArray() {
        defaultsStore.set(mockProvider.getMockPersonsArray(), for: "PrimArrayTest")
        XCTAssertEqual("Martini", defaultsStore.array([Person].self, for: "PrimArrayTest")?.first?.name, "The values for name of first Person in array shoould be equal")
    }
    
    func testStorePrimitiveDictionary() {
        defaultsStore.set(["1": 23, "2": 26, "3": 29], for: "PrimArrayTest")
        XCTAssertEqual(26, defaultsStore.dictionary([String: Int].self, for: "PrimArrayTest")!["2"], "The float array values shoould be equal")
    }
    
    func testStoreObjectDict() {
        defaultsStore.set(mockProvider.getMockPersonsDictionary(), for: "PrimArrayTest")
        XCTAssertEqual("Martini", defaultsStore.dictionary([String: Person].self, for: "PrimArrayTest")?["Martini"]?.name, "The values for name of first Person in array shoould be equal")
    }
    
    func testDeleteAll() {
        defaultsStore.set(mockProvider.getMockPerson(), for: "ObjectTest")
        XCTAssertEqual("John", defaultsStore.object(Person.self, for: "ObjectTest")?.name, "The Person name values shoould be equal")
        
        defaultsStore.deleteAllDefaults()
        XCTAssertNil(defaultsStore.object(Person.self, for: "ObjectTest")?.name, "The Person object should be nil after deleting")
    }
    
    func testPerformanceExample() {
        self.measure {
            testStorePrimitives()
            testStoreObjects()
            testStoreStructs()
            testStorePrimitiveArray()
            testStorePrimitiveDictionary()
            testStoreObjectArray()
            testStoreObjectDict()
        }
    }
    
}
