//
//  Message Controller.swift
//  CKBulletinBoard
//
//  Created by Kaden Hendrickson on 6/3/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    //Singleton
    static let shared = MessageController()
    
    //SourceOfTruth
    var messages: [Message] = []
    
    //Standard Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD Functions
    
        //Create
    func createMessage(text: String, timestamp: Date) {
        let message = Message(text: text, timestamp: timestamp)
        self.saveMessage(message: message) { (_) in
            //Bad Error Handling - fix later
        }
    }
        //Remove
    func removeMessage(message: Message, completion: @escaping (Bool) -> ()) {
        //remove locally
        guard let index = MessageController.shared.messages.firstIndex(of: message) else {return}
        MessageController.shared.messages.remove(at: index)
        //remove
        privateDB.delete(withRecordID: message.ckRecordID) { (_, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                completion(false)
                return
            } else {
                print("Message Deleted! YEEET!")
                completion(true)
            }
        }
    }
    
    //Save Data
    func saveMessage(message: Message, completion: @escaping (Bool) -> ()) {
        let messageRecord = CKRecord(message: message)
        privateDB.save(messageRecord) { (record, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                completion(false)
                return
            }
            guard let record = record, let message = Message(ckRecord: record) else {completion(false); return}
            self.messages.append(message)
            print("Message Posted!")
            completion(true)
        }
        
    }
    //Load Data
    func fetchMessages(completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.recordKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                completion(false)
                return
            }
            
            guard let records = records else {completion(false); return}
            let messages = records.compactMap({Message(ckRecord: $0)})
            self.messages = messages
            completion(true)
            
        }
    }
    
    
    func subscribeToNotifications(completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        
        let subscription = CKQuerySubscription(recordType: Constants.recordKey, predicate: predicate, options: .firesOnRecordCreation)
    }
}
