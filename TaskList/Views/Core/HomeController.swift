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
        first.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if first { return }
        
        Task {
            let index = segmentControl.selectedSegmentIndex
        
            switch index {
                case 0:
                await setupTaskViews(filter: .pending)
                case 1:
                await setupTaskViews(filter: .completed)
                case 2:
                await setupTaskViews(filter: .overdue)
                default: break
            }
        }
    }
    
    enum taskFilter: String {
        case pending
        case completed
        case overdue
    }
    
    var first = true
    
    // MARK: -- Views
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Pending", "Completed", "Overdue"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentControl
    }()
    
    lazy var taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.text = "Your pending tasks are empty."
        label.isHidden = true
        return label
    }()
    
    lazy var createTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondaryColor
        button.addTarget(self, action: #selector(pushCreateTaskController), for: .touchUpInside)
        button.layer.cornerRadius = 35
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 18, weight: .bold))), for: .normal)
        return button
    }()
    
    // MARK: -- Objective C Functions
    
    @objc
    func segmentChanged() {
        Task {
            let index = segmentControl.selectedSegmentIndex
        
            switch index {
                case 0:
                await setupTaskViews(filter: .pending)
                case 1:
                await setupTaskViews(filter: .completed)
                case 2:
                await setupTaskViews(filter: .overdue)
                default: break
            }
        }
    }
    
    @objc
    func showTaskDetails(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        guard let stackView = button.superview?.superview as? UIStackView else {
            return
        }
        
        
        let index = stackView.arrangedSubviews.firstIndex(of: button.superview!)
        var tasks = UserDefaults.standard.array(forKey: "tasks") as? [Dictionary<String, Any>]
        
        if tasks == nil {
            tasks = [Dictionary<String, Any>]()
        }
        
        if tasks![index!]["done"] as! Bool != true {
            let vc = TaskDetailsController()
        
            vc.task = tasks![index!]
            vc.index = index!
            
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CompletedTaskDetailsController()
            
            vc.task = tasks![index!]
            vc.index = index!
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func pushCreateTaskController() {
        let vc = CreateTaskController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: -- Functions
    
    func checkIfTaskIsOverdue(date: Date) -> Bool {
        let dateInterval = date.timeIntervalSince1970
        
        if Date().timeIntervalSince1970 > dateInterval {
            return true
        }
        
        return false
    }
    
    func setupTaskViews(filter: taskFilter) async {
        if !taskStackView.arrangedSubviews.isEmpty {
            for view in taskStackView.arrangedSubviews {
                view.removeFromSuperview()
            }
        }
        
        var tasks = UserDefaults.standard.array(forKey: "tasks") as? [Dictionary<String, Any>]
        
        if tasks == nil {
            tasks = [Dictionary<String, Any>]()
        }
        
        var filteredTasks = [Dictionary<String, Any>]()
        var color = UIColor.secondaryColor
        
        switch filter {
            case .pending:
            
            emptyLabel.text = "Your pending tasks are empty."
            for task in tasks! {
                if task["done"] as! Bool == false && !checkIfTaskIsOverdue(date: task["due"] as! Date) {
                    filteredTasks.append(task)
                }
            }
            
            case .completed:
            
            color = UIColor.systemGreen
            emptyLabel.text = "Your completed tasks are empty."
            for task in tasks! {
                if task["done"] as! Bool == true {
                    filteredTasks.append(task)
                }
            }
            
            case .overdue:
            
            color = UIColor.systemRed
            emptyLabel.text = "Your overdue tasks are empty."
            for task in tasks! {
                if task["done"] as! Bool == false && checkIfTaskIsOverdue(date: task["due"] as! Date) {
                    filteredTasks.append(task)
                }
            }
        }
        
        for task in filteredTasks {
            let taskView: UIView = {
                let view = UIView()
                view.backgroundColor = color
                view.layer.cornerRadius = 10
                return view
            }()

            let titleLabel: FadingLabel = {
                let label = FadingLabel()
                label.text = (task["title"] as! String)
                label.font = .systemFont(ofSize: 16, weight: .bold)
                label.textAlignment = .natural
                label.textColor = .label
                label.numberOfLines = 1
                return label
            }()

            let descriptionLabel: FadingLabel = {
                let label = FadingLabel()
                label.text = (task["description"] as! String)
                label.font = .systemFont(ofSize: 14, weight: .regular)
                label.textAlignment = .natural
                label.textColor = .label
                label.numberOfLines = 1
                return label
            }()
            
            let taskButton: UIButton = {
                let button = UIButton()
                button.addTarget(self, action: #selector(showTaskDetails), for: .touchUpInside)
                return button
            }()
            
            taskStackView.addArrangedSubview(taskView)

            taskView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: -20, height: 80)

            taskView.addSubview(titleLabel)
            titleLabel.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, right: taskView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: -10)

            taskView.addSubview(descriptionLabel)
            descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, paddingTop: 10)
            
            taskView.addSubview(taskButton)
            taskButton.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, bottom: taskView.bottomAnchor, right: taskView.rightAnchor)
        }
        
        if taskStackView.subviews.isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
    }
    
    func configureViewComponents() {
        view.backgroundColor = .backgroundColor
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = segmentControl
        
        view.addSubview(taskStackView)
        taskStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: -20)
        
        view.addSubview(emptyLabel)
        emptyLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: -20)
        
        Task {
            await setupTaskViews(filter: .pending)
        }
        
        view.addSubview(createTaskButton)
        createTaskButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: -20, paddingRight: -20, width: 70, height: 70)
    }
}
