//
//  NewPostViewController.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    var viewModel: NewPostViewModel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var headlineTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var headlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButtonToBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.newPostDelegate = self
        headlineTextView.delegate = viewModel
        bodyTextView.delegate = viewModel
        
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        headlineTextView.becomeFirstResponder()
    }
    
    func setUpView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        cancelButton.layer.cornerRadius = 16.5
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.grey2.cgColor
        cancelButton.setTitleColor(.pinkish, for: .normal)
        cancelButton.titleLabel?.font = .nunitoBold
        
        postButton.layer.cornerRadius = 16.5
        postButton.layer.borderWidth = 1
        postButton.layer.borderColor = UIColor.grey2.cgColor
        postButton.setTitleColor(.grey3, for: .normal)
        postButton.titleLabel?.font = .nunitoBold
        
        headlineTextView.delegate = viewModel
        headlineTextView.layer.borderWidth = 1
        headlineTextView.layer.borderColor = UIColor.greyBorder.cgColor
        headlineTextView.textColor = .pinkishGrey
        headlineTextView.font = .textStyle
        bodyTextView.textColor = .pinkishGrey
        bodyTextView.font = .textStyle
        
        let headlineInset = UIEdgeInsetsMake(15, 15, 15, 50)
        let bodyInset = UIEdgeInsetsMake(8.7, 15, 15, 29)
        headlineTextView.textContainerInset = headlineInset
        bodyTextView.textContainerInset = bodyInset
        
        locationLabel.textColor = .black2
        locationLabel.font = .h3
        optionalLabel.textColor = .black2
        optionalLabel.font = .small
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.changeLocationTapped))
        locationLabel.isUserInteractionEnabled = true
        locationLabel.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.changeLocationTapped))
        optionalLabel.isUserInteractionEnabled = true
        optionalLabel.addGestureRecognizer(tap1)
    }
    
    func buildActionSheet() -> UIAlertController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = viewModel
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        postButtonToBottomConstraint.constant = keyboardFrame.height + 10
    }
    
    func headlineIsEmpty() -> Bool {
        return headlineTextView.text == "Headline" || headlineTextView.text == "" ? true : false
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        let actionSheet = buildActionSheet()
        actionSheet.view.tintColor = UIColor.pinkish
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        headlineTextView.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTapped(_ sender: Any) {
        guard !headlineIsEmpty() else { return }
        
        if let presenter = presentingViewController as? HomeViewController {
            let checkImageName = "btnCheck"
            if let image = UIImage(named: checkImageName) {
                let imageView = UIImageView(image: image)
                let frame = CGRect(x: 124.8, y: 220.3, width: 124.4, height: 101.3)
                imageView.frame = frame
                imageView.center = presenter.mainImageView.center
                presenter.view.addSubview(imageView)
                presenter.mainImageView.image = nil
            }
        }
        headlineTextView.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeLocationTapped(_ sender: Any) {
        let vc = ChooseLocationViewController(nibName: ChooseLocationViewController.identifier, bundle: nil)
        vc.viewModel = LocationSelectorViewModel()
        self.present(vc, animated: true, completion: nil)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension NewPostViewController: NewPostProtocol {

    func animateTextViewHeightTo(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.headlineHeightConstraint.constant = height
        }
    }
    
    func pickedImage(_ image: UIImage) {
        if bodyTextView.text == "Body" {
            bodyTextView.text = ""
        }
        bodyTextView.textColor = .bodyBlack
        let bodyFont = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0) ]
        let bodyAttributedString = NSAttributedString(string: bodyTextView.text, attributes: bodyFont)
        let attributedString = NSMutableAttributedString(attributedString: bodyAttributedString)
        let bufferAttributedString = NSAttributedString(string: "\n", attributes: bodyFont)
        attributedString.append(bufferAttributedString)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        
        let oldWidth = textAttachment.image!.size.width;
        let scaleFactor = oldWidth / (bodyTextView.frame.size.width - 10);
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.append(attrStringWithImage)
        bodyTextView.attributedText = attributedString
    }
}
