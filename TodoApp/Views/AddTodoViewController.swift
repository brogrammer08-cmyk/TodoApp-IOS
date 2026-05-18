//
//  AddTodoViewController.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import UIKit
import Combine

class AddTodoViewController: UIViewController {
    
    // - Properties
    
    private let viewModel: AddTodoViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title *"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Description (optional)"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Due Date"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let reminderLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminder"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reminderSegmentedControl: UISegmentedControl = {
        let items = ["None", "At time", "5 min", "15 min", "1 hour", "1 day"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - Initialization
    
    init(viewModel: AddTodoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupBindings()
        setupKeyboardHandling()
    }
    
    // - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "New Todo"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(descriptionPlaceholderLabel)
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(dueDatePicker)
        contentView.addSubview(reminderLabel)
        contentView.addSubview(reminderSegmentedControl)
        contentView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            
            dueDateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            dueDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dueDatePicker.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 8),
            dueDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dueDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            reminderLabel.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 20),
            reminderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            reminderSegmentedControl.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 8),
            reminderSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reminderSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            errorLabel.topAnchor.constraint(equalTo: reminderSegmentedControl.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        descriptionTextView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveTapped)
        )
    }
    
    private func setupBindings() {
        // Two-way binding for title
        titleTextField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)
        
        // Bind due date picker
        dueDatePicker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
        
        // Bind reminder segmented control
        reminderSegmentedControl.addTarget(self, action: #selector(reminderChanged), for: .valueChanged)
        
        // Bind error message
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error
                self?.errorLabel.isHidden = (error == nil)
            }
            .store(in: &cancellables)
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // - Actions
    
    @objc private func titleChanged() {
        viewModel.title = titleTextField.text ?? ""
    }
    
    @objc private func dueDateChanged() {
        viewModel.dueDate = dueDatePicker.date
    }
    
    @objc private func reminderChanged() {
        let reminderType: ReminderType?
        switch reminderSegmentedControl.selectedSegmentIndex {
        case 1:
            reminderType = .atTime
        case 2:
            reminderType = .fiveMinutesBefore
        case 3:
            reminderType = .fifteenMinutesBefore
        case 4:
            reminderType = .oneHourBefore
        case 5:
            reminderType = .oneDayBefore
        default:
            reminderType = nil
        }
        viewModel.selectedReminderType = reminderType
    }
    
    @objc private func saveTapped() {
        viewModel.save()
    }
    
    @objc private func cancelTapped() {
        viewModel.cancel()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//- UITextViewDelegate

extension AddTodoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.todoDescription = textView.text
        descriptionPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionPlaceholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            descriptionPlaceholderLabel.isHidden = false
        }
    }
}
