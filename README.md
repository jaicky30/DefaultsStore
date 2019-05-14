# Defaults Store for saving user defaults along with custom objects and encrypting it.

A simple api for storing userdefaults with custom objects using core data and encryption.

Usage Rules:

1. All custom classes, structs, enums must be marked as Codable (See Example 1 below).
2. While fetching stored objects, arrays, dictionaries, we need to specify the type of object we want to fetch. (See Example 2 below)

Example 1:

struct Car: Codable {
    var brand: String
    var type: CarType
}

enum CarType: Int, Codable {
    case sedan
    case hatchback
    case cooper
    case suv
}

class Person: Codable {
    var name: String?
    var surname: String?
    var numberOfCars: Int = 0
    var cars: [Car] = []
}

Example 2:

A) Fetching Primitive types is same like UserDefaults:
DefaultsStore.shared.int(for: "key")
DefaultsStore.shared.bool(for: "key")
DefaultsStore.shared.float(for: "key")
DefaultsStore.shared.double(for: "key")

B) Fetching Dictionary of Person objects:
DefaultsStore.shared.dictionary([String: Person].self, for: "key")

C) Fetching Array of Cars objects:
DefaultsStore.shared.array([Car].self, for: "key")

D) Fetching Person object:
DefaultsStore.shared.object(Person.self, for: "key")
