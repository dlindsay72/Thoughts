//
//  ThoughtsService.swift
//  Thoughts
//
//  Created by Dan Lindsay on 2017-11-28.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation

class ThoughtsService {
    
    private init() {}
    
    static func getThoughts(completion: @escaping ([Thought]) -> Void) {
        CloudKitService.shared.query(recordType: Thought.recordType) { (records) in
            var thoughts = [Thought]()
            for record in records {
                guard let thought = Thought(record: record) else { continue }
                thoughts.append(thought)
            }
            completion(thoughts)
        }
    }
}
