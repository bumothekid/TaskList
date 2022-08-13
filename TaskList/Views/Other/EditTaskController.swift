//
//  EditTaskController.swift
//  TaskList
//
//  Created by David Riegel on 12.08.22.
//

import UIKit

class EditTaskController: UIViewController {

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
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        textField.attributedPlaceholder = NSAttributedString(string: "Title...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.delegate = self
        textField.text = task["title"] as? String
        return textField
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
        textView.text = task["description"] as? String == "Description..." ? "Description..." : task["description"] as? String
        textView.textColor = task["description"] as? String == "Description..." ? UIColor.lightGray : UIColor.label
        textView.isEditable = true
        textView.delegate = self
        textView.textContainer.maximumNumberOfLines = 6
        textView.returnKeyType = .continue
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
        datePicker.minimumDate = (task["due"] as? Date)
        datePicker.isEnabled = true
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
        button.addTarget(self, action: #selector(completeTaskEditing), for: .touchUpInside)
        button.layer.cornerRadius = 35
        button.tintColor = .systemGreen
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 18, weight: .bold))), for: .normal)
        return button
    }()

    
    // MARK: -- Objective C Functions
    
    @objc
    func completeTaskEditing() {
        if titleTextField.text!.isEmpty || titleTextField.text == "" {
            let alert = UIAlertController(title: "Please enter a title", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
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
        
        tasks![index!]["title"] = titleTextField.text!
        tasks![index!]["description"] = descriptionTextView.text!
        tasks![index!]["due"] = dueDatePicker.date
        
        UserDefaults.standard.set(tasks, forKey: "tasks")
        
        let alert = UIAlertController(title: "Succesfully edited task!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.back()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -- Functions
    
    func checkMaxLength(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, maxLength: Int) -> Bool {
        guard let stringRange = Range(range, in: textField.text ?? "") else {
            return false
        }
        
        let updateText = textField.text!.replacingCharacters(in: stringRange, with: string)
        
        return updateText.count < maxLength
    }
    
    func configureViewComponents() {
        view.backgroundColor = .backgroundColor
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16, weight: .bold))), style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        view.addSubview(titleBackgroundView)
        titleBackgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: -20, height: 50)
        
        titleBackgroundView.addSubview(titleTextField)
        titleTextField.anchor(left: titleBackgroundView.leftAnchor, right: titleBackgroundView.rightAnchor, paddingLeft: 8, paddingRight: -8)
        titleTextField.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor).isActive = true
        
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
    }
}

extension EditTaskController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == titleTextField {
            return checkMaxLength(textField: textField, shouldChangeCharactersIn: range, replacementString: string, maxLength: 40)
        }
        
        return false
    }
}

extension EditTaskController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let numLines = (textView.contentSize.height / textView.font!.lineHeight)
            
            if numLines >= 6 {
                view.hideKeyboard()
                return false
            }
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count

        if textView == descriptionTextView {
            return numberOfChars <= 100
        }

        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = .label
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text.isEmpty {
                textView.text = "Description..."
                textView.textColor = .lightGray
            }
        }
    }
}
