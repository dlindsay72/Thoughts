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
}
