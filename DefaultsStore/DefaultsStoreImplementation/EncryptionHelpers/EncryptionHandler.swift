//
//  KeyHandler.swift
//  JPUserDefaults
//
//  Created by Jaiprakash Dadwani on 09/05/19.
//  Copyright © 2019 jai. All rights reserved.
//

import Foundation

class EncryptionHandler {
    
    //Keys Hardcoded for now. Can be stored/fetched in keychain.
    private var encryptionPass = "jWnZr4u7x!A%D*G-KaPdSgVkXp2s5v8y".data(using: .utf8)!
    private var iv = "G+KbPeSgVkYp3s6v".data(using: .utf8)!
    
    private var encryptor: RNCryptor.EncryptorV3 {
        let encryptor = RNCryptor.EncryptorV3(encryptionKey: encryptionPass, hmacKey: encryptionPass, iv: iv)
        return encryptor
    }
    
    private var decryptor: RNCryptor.DecryptorV3 {
        let decryptor = RNCryptor.DecryptorV3(encryptionKey: encryptionPass, hmacKey: encryptionPass)
        return decryptor
    }
    
    public func encryptData(data: Data) -> Data {
        return encryptor.encrypt(data: data)
    }
    
    public func decryptedData(data: Data) -> Data? {
        do {
            return try decryptor.decrypt(data: data)
        } catch let error {
            Log("Error decrypting data. \(error)")
        }
        return nil
    }
    
}
