//
//  CloudKitService.swift
//  Thoughts
//
//  Created by Dan Lindsay on 2017-11-28.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitService {
    
    private init() {}
    static let shared = CloudKitService()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "no ck save error")
            print(record ?? "no ck record saved")
        }
    }
    
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "no cloud kit record error")
            guard let records = records else { return }
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    func subscribe() {
        let subscription = CKQuerySubscription(recordType: Thought.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        privateDatabase.save(subscription) { (sub, error) in
            print(error ?? "No Cloud Kit subscription error")
            print(sub ?? "unable to subscribe")
        }
    }
    
    func fetchRecord(with recordId: CKRecordID) {
        privateDatabase.fetch(withRecordID: recordId) { (record, error) in
            print(error ?? "No Cloud Kit fetch error")
            guard let record = record else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchedRecord"), object: record)
            }
            
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        switch notification.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification, let recordId = queryNotification.recordID else { return }
            fetchRecord(with: recordId)
        default:
            return
        }
    }
}
