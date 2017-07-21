//
//  MainAppViewController.swift
//  SceneKitDemo
//
//  Created by Eric Internicola on 7/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MainAppViewController: UIViewController {

    @IBOutlet var shapeTextField: UITextField!
    var shapeVC: ShapeViewController?

    let shapePickerView = UIPickerView()
    let shapes = Shape.values

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }

}

// MARK: - Navigation

extension MainAppViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShapeViewController {
            shapeVC = destinationVC
        }
    }
}

// MARK: - UITextFieldDelegate

extension MainAppViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        preselectRow()
    }

}

// MARK: - UIPickerViewDelegate

extension MainAppViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row < shapes.count else {
            return nil
        }
        return shapes[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        donePicker()
    }

}

// MARK: - UIPickerViewDataSource

extension MainAppViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shapes.count
    }

}

// MARK: - Implementation

extension MainAppViewController {

    @objc
    func donePicker() {
        let row = shapePickerView.selectedRow(inComponent: 0)
        let shape = shapes[row]
        defer {
            shapeTextField.resignFirstResponder()
        }
        shapeTextField.text = shapes[row].name

        if shapeVC?.shape != shape {
            shapeVC?.shape = shape
        }
    }

    /// Pre-selects the row
    func preselectRow() {
        guard let shape = shapeTextField.text else {
            return
        }
        let index = row(for: shape)
        guard index != -1 else {
            return
        }

        shapePickerView.selectRow(index, inComponent: 0, animated: false)
    }

    /// Gets you the row for the provided shape name
    ///
    /// - Parameter shapeNamed: The name of the shape you want the corresponding row for.
    /// - Returns: The index of the shape name (if found) or -1.
    func row(for shapeNamed: String) -> Int {
        for index in 0..<shapes.count {
            guard shapes[index].name == shapeNamed else {
                continue
            }

            return index
        }

        return -1
    }

    func configureVC() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        shapePickerView.delegate = self
        shapePickerView.dataSource = self
        shapeTextField.inputView = shapePickerView
        shapeTextField.inputAccessoryView = toolBar
        shapeTextField.delegate = self
    }

}
