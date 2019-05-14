//
//  MockCustomObjects.swift
//  DefaultsStoreTests
//
//  Created by Jaiprakash Dadwani on 11/05/19.
//  Copyright © 2019 jai. All rights reserved.
//

import Foundation
import DefaultsStore

class MockCustomObjects {
    
    func getMockPerson() -> Person {
        let person = Person()
        person.setupMockdata()
        return person
    }
    
    func getMockCarStruct() -> Car {
        let car = Car(brand: "MG", type: "SUV")
        return car
    }
    
    func getMockPersonsArray() -> [Person] {
        let john = Person()
        john.setupMockdata()
        
        let martini = Person()
        martini.name = "Martini"
        martini.surname = "Snow"
        return [martini, john]
    }
    
    func getMockPersonsDictionary() -> [String: Person] {
        let john = Person()
        john.setupMockdata()
        
        let martini = Person()
        martini.name = "Martini"
        martini.surname = "Snow"
        return [john.name!: john, martini.name!: martini]
    }
}

class Person: Codable {
    var name: String?
    var surname: String?
    var numberOfCars: Int?
    var cars: [Car]?
    
    func setupMockdata() {
        name = "John"
        surname = "Martin"
        numberOfCars = 2
        cars = [Car(brand: "Audi", type: "Sedan"), Car(brand: "BMW", type: "SUV")]
    }
}

struct Car: Codable {
    var brand: String
    var type: String
}
