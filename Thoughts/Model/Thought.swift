//
//  Thoughts.swift
//  Thoughts
//
//  Created by Dan Lindsay on 2017-11-28.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation
import CloudKit

struct Thought {
    
    static let recordType = "Thought"
    let title: String
    
    func thoughtRecord() -> CKRecord {
        let record = CKRecord(recordType: Thought.recordType)
        record.setValue(title, forKey: "title")
        
        return record
    }
}
