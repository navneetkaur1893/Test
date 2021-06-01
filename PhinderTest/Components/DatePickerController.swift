//
//  DatePickerController.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit
import Foundation

protocol DatePickerDelegate: AnyObject {
    func didSelectDate(date: String)
}

class DatePickerViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: DatePickerDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - View cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        datePicker.maximumDate = Date()
    }
    
    // MARK: - IBAction
    @IBAction func doneButtonPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.DateFormat.ddMMyyyy
        let dateString = formatter.string(from: datePicker.date)
        delegate?.didSelectDate(date: dateString)
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
