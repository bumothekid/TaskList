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
        
        if task == nil || index == nil {
            back()
        }
        
        configureViewComponents()
    }
    
    var task: Dictionary<String, Any>!
    var index: Int!
    
    // MARK: -- Views
    
    lazy var titleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = task["title"] as? String
        return label
    }()
    
    lazy var descriptionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .semibold)
        textView.textContainer.maximumNumberOfLines = 6
        textView.text = task["description"] as? String
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy var dueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = (task["due"] as? Date)!
        datePicker.isEnabled = false
        return datePicker
    }()
    
    lazy var dueToLabel: UILabel = {
        let label = UILabel()
        label.text = "Due to:"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    lazy var completeTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondaryColor
        button.addTarget(self, action: #selector(completeTask), for: .touchUpInside)
        button.layer.cornerRadius = 35
        button.tintColor = .systemGreen
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 18, weight: .bold))), for: .normal)
        return button
    }()

    lazy var editTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondaryColor
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.layer.cornerRadius = 35
        button.tintColor = .systemBlue
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 18, weight: .bold))), for: .normal)
        return button
    }()

    
    // MARK: -- Objective C Functions
    
    @objc
    func completeTask() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to complete this Task?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            var tasks = UserDefaults.standard.array(forKey: "tasks") as? [Dictionary<String, Any>]
            
            if tasks == nil {
                tasks = [Dictionary<String, Any>]()
            }
            
            var index: Int?
            
            for (idx, value) in tasks!.enumerated() {
                if value["createdAt"] as? Date == task["createdAt"]! as? Date {
                    index = idx
                }
            }
            
            guard index != nil else {
                return
            }
            
            tasks![index!]["done"] = true
            
            UserDefaults.standard.set(tasks, forKey: "tasks")
            
            back()
        }))
        
        present(alert, animated: true)
    }
    
    @objc
    func deleteTask() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Task?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] _ in
            var tasks = UserDefaults.standard.array(forKey: "tasks") as? [Dictionary<String, Any>]
            
            if tasks == nil {
                tasks = [Dictionary<String, Any>]()
            }
            
            var index: Int?
            
            for (idx, value) in tasks!.enumerated() {
                if value["createdAt"] as? Date == task["createdAt"] as? Date {
                    index = idx
                }
            }
            
            guard index != nil else {
                return
            }
            
            tasks!.remove(at: index!)
            
            UserDefaults.standard.set(tasks, forKey: "tasks")
            
            back()
        }))
        
        present(alert, animated: true)
    }
    
    @objc
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -- Functions
    
    func configureViewComponents() {
        view.backgroundColor = .backgroundColor
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16, weight: .bold))), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16, weight: .bold))), style: .plain, target: self, action: #selector(deleteTask))
        
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        view.addSubview(titleBackgroundView)
        titleBackgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: -20, height: 50)
        
        titleBackgroundView.addSubview(titleLabel)
        titleLabel.anchor(left: titleBackgroundView.leftAnchor, right: titleBackgroundView.rightAnchor, paddingLeft: 8, paddingRight: -8)
        titleLabel.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor).isActive = true
        
        view.addSubview(descriptionBackgroundView)
        descriptionBackgroundView.anchor(top: titleBackgroundView.bottomAnchor, left: titleBackgroundView.leftAnchor, right: titleBackgroundView.rightAnchor, paddingTop: 20, height: 150)

        descriptionBackgroundView.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: descriptionBackgroundView.topAnchor, left: descriptionBackgroundView.leftAnchor, bottom: descriptionBackgroundView.bottomAnchor, right: descriptionBackgroundView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: -8)
        
        view.addSubview(dueBackgroundView)
        dueBackgroundView.anchor(top: descriptionBackgroundView.bottomAnchor, left: descriptionBackgroundView.leftAnchor, right: descriptionBackgroundView.rightAnchor, paddingTop: 20, height: 50)
        
        dueBackgroundView.addSubview(dueDatePicker)
        dueDatePicker.anchor(top: dueBackgroundView.topAnchor, right: dueBackgroundView.rightAnchor, paddingTop: 8, paddingRight: -8)
        
        dueBackgroundView.addSubview(dueToLabel)
        dueToLabel.anchor(left: dueBackgroundView.leftAnchor, right: dueDatePicker.rightAnchor, paddingLeft: 8, paddingRight: -8)
        dueToLabel.centerYAnchor.constraint(equalTo: dueBackgroundView.centerYAnchor).isActive = true
        
        view.addSubview(completeTaskButton)
        completeTaskButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: -20, paddingRight: -20, width: 70, height: 70)
        
        view.addSubview(editTaskButton)
        editTaskButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: -20, width: 70, height: 70)
    }
}
