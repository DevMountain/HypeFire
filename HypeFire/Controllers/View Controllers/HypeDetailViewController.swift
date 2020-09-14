//
//  HypeDetailViewController.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/12/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class HypeDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var hypeBodyTextView: UITextView!
    @IBOutlet weak var addHypePhotoButton: HypeFireButton!
    
    //MARK: - Properties
    var hype: Hype?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .spaceGray
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let text = hypeBodyTextView.text, !text.isEmpty else { return }
        if let hype = hype {
            hype.body = text
            HypeController.shared.updateHype(hype: hype) { (result) in
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        } else {
            HypeController.shared.createHype(body: text) { (result) in
                switch result {
                case .success(let hype):
                    HypeController.shared.hypes.insert(hype, at: 0)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    @IBAction func addHypePhotoButtonTapped(_ sender: Any) {
    }
    
    func setupViews() {
        if let hype = hype {
            self.hypeBodyTextView.text = hype.body
        } else {
            self.hypeBodyTextView.text = ""
        }
        hypeBodyTextView.addCornerRadius()
    }
}
