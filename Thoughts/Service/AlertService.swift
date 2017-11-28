//
//  AlertService.swift
//  Thoughts
//
//  Created by Dan Lindsay on 2017-11-28.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    static func composeThought(in vc: UIViewController, completion: @escaping (Thought) -> Void) {
        let alert = UIAlertController(title: "New Thought", message: "What's on your mind friend?", preferredStyle: .alert)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            let thought = Thought(title: title)
            completion(thought)
        }
        
        alert.addAction(post)
        vc.present(alert, animated: true, completion: nil)
    }
}
