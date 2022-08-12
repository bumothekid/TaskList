//
//  TaskDetailsController.swift
//  TaskList
//
//  Created by David Riegel on 12.08.22.
//

import UIKit

class TaskDetailsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewComponents()
    }
    
    // MARK: -- Views
    
    // MARK: -- Objective C Functions
    
    // MARK: -- Functions
    
    func configureViewComponents() {
        view.backgroundColor = .backgroundColor
        
        navigationItem.largeTitleDisplayMode = .never
    }
}
