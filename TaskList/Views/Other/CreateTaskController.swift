//
//  CreateTaskController.swift
//  TaskList
//
//  Created by David Riegel on 25.06.22.
//

import UIKit

class CreateTaskController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewComponents()
    }
    
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
        textView.text = "Description..."
        textView.textColor = .lightGray
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
        // Set minimumDate to now in 10 minutes
        datePicker.minimumDate = Date().addingTimeInterval(600)
        return datePicker
    }()
    
    lazy var dueToLabel: UILabel = {
        let label = UILabel()
        label.text = "Due to:"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var confirmBtnView: UIView = {
        let view = UIView()
        view.alpha = 1
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let button = UIButton()
        button.alpha = 1
        button.layer.cornerRadius = 10
        button.setTitle("Confirm Task", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(confirmTaskBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: -- Objc Functions
    
    @objc func confirmTaskBtn() {
        confirmTask()
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    func confirmTask() {
        if titleTextField.text!.isEmpty || titleTextField.text == "" {
            let alert = UIAlertController(title: "Please enter a title", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if descriptionTextView.text!.isEmpty || descriptionTextView
            .text == "" {
            let alert = UIAlertController(title: "Please enter a description", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if defaults.array(forKey: "tasks") == nil {
            var array = [Dictionary<String, Any>]()
            let dict: Dictionary = ["title": titleTextField.text!, "description": descriptionTextView.text!, "due": dueDatePicker.date, "done": false] as [String : Any]
            
            array.append(dict)
            
            defaults.set(array, forKey: "tasks")
        }
        else {
            let dict: Dictionary = ["title": titleTextField.text!, "description": descriptionTextView.text!, "due": dueDatePicker.date, "done": false] as [String : Any]
            
            var array = defaults.array(forKey: "tasks")!
            
            array.append(dict)
            
            defaults.set(array, forKey: "tasks")
        }
        
        let alert = UIAlertController(title: "Succesfully created task!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.back()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func configureViewComponents() {
        view.backgroundColor = .backgroundColor
        title = "Create Task"
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16, weight: .bold))), style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
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
        
        view.addSubview(confirmBtnView)
        confirmBtnView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 200, paddingLeft: 20, paddingBottom: -100, paddingRight: -20, width: 0, height: 50)
        
        confirmBtnView.addSubview(confirmBtn)
        confirmBtn.anchor(top: nil, left: confirmBtnView.leftAnchor, bottom: nil, right: confirmBtnView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: -8, width: 0, height: 0)
        confirmBtn.centerYAnchor.constraint(equalTo: confirmBtnView.centerYAnchor).isActive = true
    }
}

extension CreateTaskController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == titleTextField {
            return checkMaxLength(textField: textField, shouldChangeCharactersIn: range, replacementString: string, maxLength: 40)
        }
        
        return false
    }
}

extension CreateTaskController: UITextViewDelegate {
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
                textView.textColor = UIColor.white
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text.isEmpty {
                textView.text = "Description..."
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
