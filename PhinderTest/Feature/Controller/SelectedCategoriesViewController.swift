//
//  SelectedCategoriesViewController.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

class SelectedCategoriesViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: SelectedCategoriesViewModel
    lazy var imagePicker: ImagePicker = {
        return ImagePicker(presentationController: self, delegate: self)
    }()
    
    // MARK: - View cycle methods
    required init(_ model: SelectedCategoriesViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constant.ScreenTitle.selectedCategories
        self.view.backgroundColor = .white
        
        // Methods calling
        registerNotification()
        setupViewModel()
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove registered notification on view disappear.
        NotificationCenter.default.removeObserver(self,
                                    name: UIResponder.keyboardWillChangeFrameNotification,
                                    object: nil)
    }
    
    // MARK: - Private Methods
    // Method to register for the notification.
    private func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                selector: #selector(onKeyboardFrameWillChangeNotificationReceived(_:)),
                                name: UIResponder.keyboardWillChangeFrameNotification,
                                object: nil)
    }
    
    private func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        tableView.register(UserImageTableViewCell.self)
        tableView.register(UserTextTableViewCell.self)
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Reload tableview in main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showDatePickerController() {
        let storybord = UIStoryboard(name: Constant.Storyboard.main, bundle: nil)
        guard let controller = storybord.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController else { return }
        controller.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        controller.delegate = self
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    // Keyboard handeling notification
    @objc private func onKeyboardFrameWillChangeNotificationReceived(_ notification: Notification)
        {
            guard
                let userInfo = notification.userInfo,
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
            }

            let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
            let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
            let intersection = safeAreaFrame.intersection(keyboardFrameInView)

            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            let animationDuration: TimeInterval = (keyboardAnimationDuration as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)

            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: animationCurve,
                           animations: {
                self.additionalSafeAreaInsets.bottom = intersection.height
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
}

// MARK: - UITableView Delegate & DataSource
extension SelectedCategoriesViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitleForHeader(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.getHeightForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if let textlabel = header.textLabel {
            textlabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRowAt(indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryType = viewModel.getCategory(for: indexPath)
        switch categoryType {
        case .camera:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserImageTableViewCell
            cell.configureData(viewModel.getUserImage(for: indexPath))
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserImageTableViewCell
            cell.configureData(viewModel.getUserImage(for: indexPath))
            return cell
        case .fullName:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserTextTableViewCell
            cell.configureData(value: viewModel.getUserTextValue(for: indexPath), for: categoryType)
            cell.delegate = self
            return cell
        case .telephone:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserTextTableViewCell
            cell.configureData(value: viewModel.getUserTextValue(for: indexPath), for: categoryType)
            cell.delegate = self
            return cell
        case .dob:
            let identifier = Constant.CellIdentifier.defaultCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else { return UITableViewCell() }
            let dob = viewModel.getUserDOB()
            cell.textLabel?.text = dob == "" ? Constant.PlaceholderText.selectDOB : dob
            cell.textLabel?.textColor = dob == "" ? .lightGray : .black
            return cell
        case .gender:
            let identifier = Constant.CellIdentifier.defaultCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else { return UITableViewCell() }
            cell.textLabel?.text = viewModel.getGenderOption(for: indexPath.row)
            cell.accessoryType = viewModel.getAccessoryType(for: indexPath)
            return cell
        case .favColor:
            let identifier = Constant.CellIdentifier.defaultCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else { return UITableViewCell() }
            cell.textLabel?.text = viewModel.getColorOption(for: indexPath.row)
            cell.accessoryType = viewModel.getAccessoryType(for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let categoryType = viewModel.getCategory(for: indexPath)
        switch categoryType {
        case .camera:
            self.imagePicker.present(from: cell)
        case .photo: break
        case .fullName: break
        case .telephone: break
        case .dob:
            showDatePickerController()
        case .gender, .favColor:
            viewModel.setUserSelection(for: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SelectedCategoriesViewController: DatePickerDelegate {
    func didSelectDate(date: String) {
        viewModel.setUserDOB(date)
    }
}

extension SelectedCategoriesViewController: UserTextDelegate {
    func didEnterText(value: String, for categoryType: CategoryType) {
        viewModel.setUserTextInput(value, categoryType)
    }
}

extension SelectedCategoriesViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let userImage = image else { return }
        viewModel.setUserCameraGalleryImage(userImage)
    }
}
