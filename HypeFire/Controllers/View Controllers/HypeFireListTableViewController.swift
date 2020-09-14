//
//  HypeFireListTableViewController.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class HypeFireListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    //MARK: - Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - Methods
    func setupViews() {
        let cancelBarButton = UIBarButtonItem()
        self.tableView.backgroundColor = .spaceGray
        cancelBarButton.title = "Cancel"
        self.navigationItem.backBarButtonItem = cancelBarButton
        refresher.attributedTitle = NSAttributedString(string: "Pull to see new Hypes!")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.view.addSubview(refresher)
    }
    
    @objc func loadData() {
        HypeController.shared.fetchAllHypes { (result) in
            switch result {
            case .success(let fetchedHypes):
                HypeController.shared.hypes = fetchedHypes
                self.updateViews()
            case .failure(let hypeError):
                print(hypeError.errorDescription)
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    func presentHypeAlert(hype: Hype?) {
        let alertController = UIAlertController(title: "Get Hype!", message: "What is Hype may never die!", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "What is Hype today"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            if let hype = hype {
                textField.text = hype.body
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            
            if let hype = hype {
                hype.body = text
                HypeController.shared.updateHype(hype: hype) { (result) in
                    switch result {
                    case .success(_):
                        self.updateViews()
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                }
            } else {
                HypeController.shared.createHype(body: text) { (result) in
                    switch result {
                    case .success(let hype):
                        HypeController.shared.hypes.insert(hype, at: 0)
                        self.updateViews()
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addHypeAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath) as? HypeFireTableViewCell else { return UITableViewCell() }
        
        let hype = HypeController.shared.hypes[indexPath.row]
        
        if hype.authorID == UserController.shared.currentUser?.uuid {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        
        cell.hype = hype
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let hypeToDelete = HypeController.shared.hypes[indexPath.row]
        if hypeToDelete.authorID == UserController.shared.currentUser?.uuid {
            if editingStyle == .delete {
                guard let index = HypeController.shared.hypes.firstIndex(of: hypeToDelete) else { return }
                HypeController.shared.deleteHype(hype: hypeToDelete) { (result) in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            HypeController.shared.hypes.remove(at: index)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHypeDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destination = segue.destination as? HypeDetailViewController else { return }
            let hypeToSend = HypeController.shared.hypes[indexPath.row]
            destination.hype = hypeToSend
        }
    }
}
