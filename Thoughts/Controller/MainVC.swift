//
//  MainVC.swift
//  Thoughts
//
//  Created by Dan Lindsay on 2017-11-28.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import CloudKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var thoughts = [Thought]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        CloudKitService.shared.subscribe()
        getThoughts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetch(_:)), name: NSNotification.Name("internalNotification.fetchRecord"), object: nil)
    }

    @IBAction func comboseBtnWasPressed(_ sender: Any) {
        AlertService.composeThought(in: self) { (thought) in
            CloudKitService.shared.save(record: thought.thoughtRecord())
            self.insert(thought: thought)
        }
    }
    
    @objc func handleFetch(_ sender: Notification) {
        guard let record = sender.object as? CKRecord, let thought = Thought(record: record) else { return }
        insert(thought: thought)
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func insert(thought: Thought) {
        thoughts.insert(thought, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func getThoughts() {
        ThoughtsService.getThoughts { (thoughts) in
            self.thoughts = thoughts
            self.tableView.reloadData()
        }
    }
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let thought = thoughts[indexPath.row]
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 1, green: 0.5943232126, blue: 0.04868936191, alpha: 1)
        cell.textLabel?.text = thought.title
        cell.backgroundColor = #colorLiteral(red: 0.3579174876, green: 0.7784708738, blue: 0.997761786, alpha: 0.57)
        cell.textLabel?.textColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        cell.textLabel?.highlightedTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Snell Roundhand", size: 30)
        cell.selectedBackgroundView? = bgColorView
        return cell
    }
    
    
    
}

