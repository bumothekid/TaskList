//
//  HomeController.swift
//  TaskList
//
//  Created by David Riegel on 23.06.22.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
    }
    
    func configureViewComponents() {
        view.backgroundColor = .systemBackground
        title = "Task List"
        
        navigationItem.largeTitleDisplayMode = .never
    }
}
