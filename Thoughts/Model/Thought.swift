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
    
    init(title: String) {
        self.title = title
    }
    
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else { return nil }
        self.title = title
    }
    
    func thoughtRecord() -> CKRecord {
        let record = CKRecord(recordType: Thought.recordType)
        record.setValue(title, forKey: "title")
        
        return record
    }
}
