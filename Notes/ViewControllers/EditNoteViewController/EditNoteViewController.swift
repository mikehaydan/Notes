//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Mike Haydan on 24/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, EditNoteView {

    // MARK: - Properties
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    var presenter: EditNotePresenter!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.preparePresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
    
    // MARK: - IBActions
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        view.endEditing(true)
        presenter.saveNoteWith(text: textView.text)
    }
    
    // MARK: - Private
    
    // MARK: - Observers
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func prepareKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardChangeFrame(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        if notification.name == .UIKeyboardWillHide {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    // MARK: - Public
    
}

// MARK: - UITextViewDelegate

extension EditNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        saveBarButtonItem.isEnabled = presenter.saveEnabledFor(text: textView.text)
    }
}

// MARK: - EditNoteView

extension EditNoteViewController {
    
    func showLoader() {
        view.isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader() {
        view.isUserInteractionEnabled = true
        activityIndicatorView.stopAnimating()
    }
    
    func set(text: String) {
        textView.text = text
    }
    
    func popView() {
        navigationController?.popViewController(animated: true)
    }
}
