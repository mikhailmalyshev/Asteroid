//
//  DetailAsteroidViewController.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 19.04.2022.
//

import UIKit

// MARK: -  DetailAsteroidViewController - детальная информация по астероиду
final class DetailAsteroidViewController: UIViewController {
    
    var asteroid: NearEarthObject?
    
    private enum Strings {
        static let smallAsteroidImage = "Малый астероид"
        static let averageAsteroidImage = "Побольше"
        static let bigAsteroidImage = "Огромный"
        static let mainFontRegular = "Helvetica"
        static let mainFontBold = "Helvetica-Bold"
        static let fontForButton = "SFProText-Semibold"
    }
    
    private lazy var mainView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // lable с информацией по астероиду
    private lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 209, height: 88))
        
        label.text = """
        Диаметр:
        \nПодлетает
        \nна расстояние
        \nЕще информация
        \nЕще информация
        \nЕще информация
        """
        label.textColor = .black
        label.font = UIFont(name: Strings.mainFontRegular, size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Опасен / Не опасен
    private lazy var dangerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 141, height: 24))
        
        label.text = "Оценка:"
        label.textColor = .black
        label.font = UIFont(name: Strings.mainFontRegular, size: 18)
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // кнопка для добавления астероида в корзину
    private lazy var destroyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 121, height: 28))
        
        guard let font = UIFont(name: Strings.fontForButton, size: 18) else { return button }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributeString = NSMutableAttributedString(
            string: "Уничтожить",
            attributes: attributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(red: 0,
                                         green: 0.478,
                                         blue: 1,
                                         alpha: 1)
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // картинка астероида
    private lazy var asteroidImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // кнопка для показа списка всех подлетов
    private lazy var showFlightsButton: UIButton = {
        let button = UIButton()
        
        guard let font = UIFont(name: Strings.mainFontRegular, size: 18) else { return button }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: "Открыть список всех сближений",
            attributes: attributes
        )
        button.addTarget(self, action: #selector(showListOfFlightsButtonTapped), for: .touchUpInside)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
        
        guard let asteroid = asteroid else { return }
        configureViews(with: asteroid)
    }
    
    // установка views
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        
        view.addSubview(mainView)
        mainView.layer.masksToBounds = true
        
        view.addSubview(infoLabel)
        view.addSubview(dangerLabel)
        view.addSubview(destroyButton)
        view.addSubview(asteroidImageView)
        view.addSubview(showFlightsButton)
    }
    
    // установка layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            infoLabel.topAnchor.constraint(equalTo: asteroidImageView.bottomAnchor, constant: 100)
        ])
        NSLayoutConstraint.activate([
            dangerLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            dangerLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            destroyButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 40),
            destroyButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -40),
            destroyButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            asteroidImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 1),
            asteroidImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            showFlightsButton.topAnchor.constraint(equalTo: dangerLabel.bottomAnchor, constant: 10),
            showFlightsButton.leadingAnchor.constraint(equalTo: dangerLabel.leadingAnchor)
        ])
    }
    
    // конфигурация views по переданному астероиду
    private func configureViews(with asteroid: NearEarthObject) {
        
        if asteroid.isPotentiallyHazardousAsteroid {
            dangerLabel.halfTextColorChange(fullText: "Оценка: опасен", changeText: "опасен", fontForChangedText: 18)
        } else {
            dangerLabel.text = "Оценка: не опасен"
        }
        
        let diameter = (asteroid.estimatedDiameter.meters.estimatedDiameterMax + asteroid.estimatedDiameter.meters.estimatedDiameterMin) / 2
        asteroidImageView.image = UIImage(named: resizeAsteriodFromDiameter(diameter))
        guard let dateClose = asteroid.closeApproachData.first?.closeApproachDate else { return }
        
        guard let fetcedDistanceInKm = asteroid.closeApproachData.first?.missDistance.kilometers else { return }
        guard let fetcedDistanceInLunar = asteroid.closeApproachData.first?.missDistance.lunar else { return }
        
        infoLabel.text = """
        Диаметр: \(String(format: "%.0f", diameter)) м
        \nПодлетает \(dateClose.convertShortDateForLabel())
        \nна расстояние \(fetcedDistanceInKm.formatDistance(convert: 0))
        \nили \(fetcedDistanceInLunar.formatDistance(convert: 1))
        """
    }
    
    // ранжирование астеорида по диаметру
    private func resizeAsteriodFromDiameter(_ diameter: Double) -> String {
        switch diameter {
        case ..<300: return Strings.smallAsteroidImage
        case ..<800: return Strings.averageAsteroidImage
        default: return Strings.bigAsteroidImage
        }
    }
    
    // нажата кнопка показа списка астероидов
    @objc private func showListOfFlightsButtonTapped() {
        let flightsVC = FlightsOfAsteroidViewController()
        guard var asteroidUrl = asteroid?.links.linksSelf else { return }
        
        // добавление "s" к http
        asteroidUrl.insert("s", at: asteroidUrl.index(asteroidUrl.startIndex, offsetBy: 4))
        flightsVC.asteroidUrl = asteroidUrl
        present(flightsVC, animated: true)
    }
    
    // нажата кнопка добавления астероида в корзину
    @objc private func addButtonPressed() {
        guard let asteroid = asteroid else { return }
        StorageManager.shared.saveAsteroids(with: asteroid)
        destroyButton.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.destroyButton.alpha = 1.0
        }
    }
}
