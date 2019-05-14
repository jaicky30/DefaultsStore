//
//  DefaultsStore.swift
//  DefaultsStore
//
//  Created by Jaiprakash Dadwani on 10/05/19.
//  Copyright © 2019 jai. All rights reserved.
//

import Foundation

open class DefaultsStore {
    
    open static let shared = DefaultsStore()
    open var autoSync = true
    private lazy var defaultsManager = StoreManager()
    private lazy var encryptionHandler = EncryptionHandler()
    
    private init() {}
    
    //MARK: - Setter function
    open func set<Storable: Encodable>(_ object: Storable, for key: String) {
        self.storeObject(object: object, for: key)
    }
    
    open func set(_ bool: Bool, for key: String) {
        self.storePrimitive(value: bool, for: key)
    }
    
    open func set(_ int: Int, for key: String) {
        self.storePrimitive(value: int, for: key)
    }
    
    open func set(_ float: Float, for key: String) {
        self.storePrimitive(value: float, for: key)
    }

    open func set(_ double: Double, for key: String) {
        self.storePrimitive(value: double, for: key)
    }
    
    open func set<Storable: Encodable>(_ object: [Storable], for key: String)  {
        self.storeObject(object: object, for: key)
    }
    
    open func set<Storable: Encodable>(_ object: [String: Storable], for key: String)  {
        self.storeObject(object: object, for: key)
    }
    
    //MARK: - Getter function
    open func object<Storable: Decodable>(_ type: Storable.Type, for key: String) -> Storable? {
        return self.getObject(type, for: key)
    }
    
    open func bool(for key: String) -> Bool {
        return getPrimitive(for: key) as? Bool ?? false
    }
    
    open func int(for key: String) -> Int? {
        return getPrimitive(for: key) as? Int
    }
    
    open func float(for key: String) -> Float? {
        return getPrimitive(for: key) as? Float
    }

    open func double(for key: String) -> Double? {
        return getPrimitive(for: key) as? Double
    }
    
    open func array<Storable: Decodable>(_ type: [Storable].Type, for key: String) -> [Storable]? {
        return self.getObject(type, for: key)
    }
    
    open func dictionary<Storable: Decodable>(_ type: [String: Storable].Type, for key: String) -> [String: Storable]? {
        return getObject(type, for: key)
    }
    
    // MARK: - Saving and deleting functions
    open func synchronize() {
        defaultsManager.saveContext()
    }
    
    open func deleteAllDefaults() {
        defaultsManager.deleteAll()
    }
    
    // MARK: - Private functions
    private func storePrimitive(value: Any, for key: String) {
        guard !key.isEmpty else { return }
        let storedData = getStoredData(for: key)
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        let encryptedData = encryptionHandler.encryptData(data: data)
        storedData.value = encryptedData as NSData?
        if autoSync { defaultsManager.saveContext() }
    }
    
    private func storeObject<E: Encodable>(object: E, for key: String) {
        guard !key.isEmpty else { return }
        let storedData = getStoredData(for: key)
        
        do {
            let data = try PropertyListEncoder().encode(object)
            let archdata = NSKeyedArchiver.archivedData(withRootObject: data)
            let encryptedData = encryptionHandler.encryptData(data: archdata)
            storedData.value = encryptedData as NSData?
            if autoSync { defaultsManager.saveContext() }
        } catch {
            Log("***Error encoding data. Data should contain all the properties of Codable type. \(error.localizedDescription)")
        }
    }
    
    private func getPrimitive(for key: String) -> Any? {
        guard !key.isEmpty else { return false }
        let encryptedKey = getEncryptedKey(key: key)
        let storedData = defaultsManager.getStoredDataForKey(key: encryptedKey)
        if let data = storedData?.value as? Data, let unencryptedData = encryptionHandler.decryptedData(data: data) {
            let value = NSKeyedUnarchiver.unarchiveObject(with: unencryptedData)
            return value
        }
        return nil
    }
    
    private func getStoredData(for key: String) -> StoredData {
        let encryptedKey = getEncryptedKey(key: key)
        var storedData = defaultsManager.getStoredDataForKey(key: encryptedKey)
        if storedData == nil {
            storedData = defaultsManager.getStoredDataInstance()
            storedData!.key = encryptedKey
        }
        return storedData!
    }
    
    private func getObject<D: Decodable>(_ type: D.Type, for key: String) -> D? {
        guard !key.isEmpty else { return nil }
        let encryptedKey = getEncryptedKey(key: key)
        let storedData = defaultsManager.getStoredDataForKey(key: encryptedKey)
        if let data = storedData?.value as? Data, let unencryptedData = encryptionHandler.decryptedData(data: data) {
            let unArchdata = NSKeyedUnarchiver.unarchiveObject(with: unencryptedData)
            if let unarData = unArchdata as? Data {
                do {
                    let value = try PropertyListDecoder().decode(type.self, from: unarData)
                    return value
                } catch {
                    Log("***Error - Data type mismatch. \(error.localizedDescription)")
                }
            }
        }
        return nil
    }
    
    private func getEncryptedKey(key: String) -> NSData {
        let arcdata = NSKeyedArchiver.archivedData(withRootObject: key)
        return encryptionHandler.encryptData(data: arcdata) as NSData
    }
}
