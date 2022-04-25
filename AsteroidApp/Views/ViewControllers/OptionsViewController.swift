//
//  OptionsViewController.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 19.04.2022.
//

import UIKit

//MARK: - OptionsViewController - экран с опциями
final class OptionsViewController: UIViewController {
    
    var delegate: SetModeDelegate?
    var selectedSegmentIndex = 0
    var filterIsOn = false
    
    private enum Strings {
        static let textForFirstLabel = "Ед.изм. расстояний"
        static let textForSecondLabel = "Показывать только опасные"
        static let segmentedControlFirstItem = "км."
        static let segmentedControlSecondItem = "л.орб."
        static let font = "SFProText-Regular"
        static let title = "Фильтр"
        static let titleForAcceptButton = "Применить"
    }
    
    private lazy var mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 88))
        
        view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 0.92)
        view.layer.cornerRadius = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // лэйбл первой ячейки
    private lazy var labelForFirstRow: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 163, height: 22)
        label.text = Strings.textForFirstLabel
        label.textColor = .black
        label.font = UIFont(name: Strings.font, size: 17)
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // сегментед контрол
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Strings.segmentedControlFirstItem, Strings.segmentedControlSecondItem])
        segmentedControl.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
        segmentedControl.selectedSegmentIndex = selectedSegmentIndex
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    // лэйбл второй ячейки
    private lazy var labelForSecondRow: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 227, height: 22)
        label.text = Strings.textForSecondLabel
        label.textColor = .black
        label.font = UIFont(name: Strings.font, size: 17)
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // свитч
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 30))
        
        switchView.isOn = filterIsOn
        
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    // полоска
    private lazy var dividerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 20))
        
        view.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12).cgColor
       
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // кастомный инициализатор
    init(selectedSegment: Int, filterIsOn: Bool) {
        self.selectedSegmentIndex = selectedSegment
        self.filterIsOn = filterIsOn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    // установка views
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        title = Strings.title
        
        let item = UIBarButtonItem(title: Strings.titleForAcceptButton, style: .plain, target: self, action: #selector(acceptButtonTapped))
        let font = UIFont(name: "SFProText-Semibold", size: 17)
        let attributes = [NSAttributedString.Key.font: font]
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        navigationItem.rightBarButtonItem = item
        
        view.addSubview(mainView)
        view.addSubview(labelForFirstRow)
        view.addSubview(labelForSecondRow)
        view.addSubview(segmentedControl)
        view.addSubview(switchView)
        view.addSubview(dividerView)
    }
    
    // установка layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainView.heightAnchor.constraint(equalToConstant: 88)
        ])
        NSLayoutConstraint.activate([
            labelForFirstRow.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 11),
            labelForFirstRow.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            labelForSecondRow.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -11),
            labelForSecondRow.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 7),
            segmentedControl.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -4)
        ])
        NSLayoutConstraint.activate([
            switchView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -7),
            switchView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -17)
        ])
        NSLayoutConstraint.activate([
            dividerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
    }
    
    // кнопка "Применить" нажата
    @objc private func acceptButtonTapped() {
        delegate?.setMode(distanceMode: segmentedControl.selectedSegmentIndex, filterIsDanger: switchView.isOn)
        navigationController?.popToRootViewController(animated: true)
    }
}
