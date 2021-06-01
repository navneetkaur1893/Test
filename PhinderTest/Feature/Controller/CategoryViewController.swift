//
//  CategoryViewController.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

class CategoryViewController: BaseViewController {
    
    // MARK: - Properties
    let viewModel = CategoryViewModel()
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.ButtonTitle.done, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    // MARK: - View cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constant.ScreenTitle.selectCategories
        self.view.backgroundColor = .white
        addDoneButton()
        
        // Add tableview in the view
        setupTableView()
    }
    
    // MARK: - Private Methods
    func addDoneButton() {
        self.view.addSubview(doneButton)
        doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        updateDoneButton()
    }
    
    func updateDoneButton() {
        let isValid = viewModel.getSelectedCategoriesCount() > 0 ? true : false
        doneButton.isEnabled = isValid
        doneButton.backgroundColor = isValid ? .systemGreen : .gray
    }
    
    func setupTableView() {
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor).isActive = true
        
        // Reload tableview in main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action methods
    @objc func doneButtonPressed(_ sender: Any) {
        if viewModel.getSelectedCategoriesCount() > 0 {
            let model = viewModel.getSelectedCategoriesViewModel()
            let controller = SelectedCategoriesViewController(model)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryType = viewModel.getCategory(for: indexPath)
        let identifier = Constant.CellIdentifier.defaultCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else { return UITableViewCell() }
        cell.textLabel?.text = categoryType.rawValue
        cell.accessoryType = viewModel.getAccessoryType(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selected type
        viewModel.didSelectRowAt(indexPath)
        
        // Reload selected cell
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // Check for done button enable/disable property
        updateDoneButton()
    }
}
