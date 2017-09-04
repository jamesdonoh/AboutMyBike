//
//  BikeViewController.swift
//  AboutMyBike
//
//  Created by James Donohue on 28/08/2017.
//  Copyright © 2017 James Donohue. All rights reserved.
//

import os.log
import UIKit

class BikeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties

    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var vinTextField: UITextField!
    @IBOutlet weak var engineNoTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var bike: Bike?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text fields' input through delegate callbacks
        makeTextField.delegate = self
        modelTextField.delegate = self
        vinTextField.delegate = self
        engineNoTextField.delegate = self
        
        if let bike = bike {
            makeTextField.text = bike.make
            modelTextField.text = bike.model
            vinTextField.text = bike.vin
            engineNoTextField.text = bike.engineNo
            photoImageView.image = bike.photo
        }

        // Enable the Save button only if the required text fields are not empty
        updateSaveButtonState()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    // This is the simplest way of avoiding invalid state being saved during editing
    // TODO: make this unnecessary by validating input as the user types
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    // This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let make = makeTextField.text ?? ""
        let model = modelTextField.text ?? ""
        let vin = vinTextField.text
        let engineNo = engineNoTextField.text
        let photo = photoImageView.image
        
        bike = Bike(make: make, model: model, vin: vin, engineNo: engineNo, photo: photo)
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        makeTextField.resignFirstResponder()
        modelTextField.resignFirstResponder()
        vinTextField.resignFirstResponder()
        engineNoTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: Private methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if either of the text fields are empty
        let makeText = makeTextField.text ?? ""
        let modelText = modelTextField.text ?? ""

        saveButton.isEnabled = !makeText.isEmpty && !modelText.isEmpty
    }
}

