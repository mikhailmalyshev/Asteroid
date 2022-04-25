//
//  AsteroidCollectionViewCell.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 19.04.2022.
//

import UIKit

//MARK: - AsteroidCollectionViewCell - ячейка астероида
final class AsteroidCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "AsteroidCollectionViewCellID"
    
    private enum Strings {
        static let mainFontRegular = "Helvetica"
        static let mainFontBold = "Helvetica-Bold"
        static let fontForButton = "SFProText-Semibold"
        static let titleForButton = "УНИЧТОЖИТЬ"
        static let smallAsteroidImage = "Малый астероид"
        static let averageAsteroidImage = "Побольше"
        static let bigAsteroidImage = "Огромный"
        static let dinosaurImage = "Vector"
    }
    
    // градиентный фон
    private lazy var backgroundAsteroidView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 145))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // имя астероида
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 94, height: 32))
        
        label.textColor = .black
        label.font = UIFont(name: Strings.mainFontBold, size: 24)
        label.text = "2021 FQ"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // информация об астероиде
    private lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 209, height: 88))
        
        label.text = """
        Диаметр:
        \nПодлетает
        \nна расстояние
        """
        label.textColor = .black
        label.font = UIFont(name: Strings.mainFontRegular, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Опасен / Не опасен
    private lazy var dangerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 141, height: 24))
        
        label.text = "Оценка: "
        label.textColor = .black
        label.font = UIFont(name: Strings.mainFontRegular, size: 16)
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // картинка динозавра
    private lazy var dinosaourImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        
        view.image = UIImage(named: Strings.dinosaurImage)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // картинка астероида
    private lazy var asteroidImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // кнопка для добавления астероида в список на уничтожение
    lazy var destroyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 121, height: 28))
        
        guard let font = UIFont(name: Strings.fontForButton, size: 13) else { return button }
        let attributesForNormal: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributeString = NSMutableAttributedString(
            string: Strings.titleForButton,
            attributes: attributesForNormal
        )
        
        button.setAttributedTitle(attributeString, for: .normal)
        
        button.backgroundColor = UIColor(red: 0,
                                         green: 0.478,
                                         blue: 1,
                                         alpha: 1)
        button.layer.cornerRadius = 13
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // конфигурация ячейки по переданному астероиду
    func configureWithAsteroid(asteroid: NearEarthObject, convertDistanceMode: Int) {
        nameLabel.text = asteroid.name.formatNameForCell()
        
        if asteroid.isPotentiallyHazardousAsteroid {
            dangerLabel.halfTextColorChange(fullText: "Оценка: опасен", changeText: "опасен", fontForChangedText: 16)
        } else {
            dangerLabel.text = "Оценка: не опасен"
        }

        let diameter = (asteroid.estimatedDiameter.meters.estimatedDiameterMax + asteroid.estimatedDiameter.meters.estimatedDiameterMin) / 2
        asteroidImageView.image = UIImage(named: resizeAsteriodImageFromDiameter(diameter))
        guard let dateClose = asteroid.closeApproachData.first?.closeApproachDate else { return }
        
        var distance = ""
        switch convertDistanceMode {
        case 0: guard let fetcedDistance = asteroid.closeApproachData.first?.missDistance.kilometers else { return }
            distance = fetcedDistance
        case 1: guard let fetcedDistance = asteroid.closeApproachData.first?.missDistance.lunar else { return }
            distance = fetcedDistance
        default: break
        }
        infoLabel.text = """
        Диаметр: \(String(format: "%.0f", diameter)) м
        \nПодлетает \(dateClose.convertShortDateForLabel())
        \nна расстояние \(distance.formatDistance(convert: convertDistanceMode))
        """
        setupGradientForBackgroundAsteroidView(isDangerous: asteroid.isPotentiallyHazardousAsteroid)
    }
    
    // установка views
    private func setupViews() {
        // тень для ячейки
        contentView.backgroundColor = .white
        layer.cornerRadius = 10.0
        layer.borderWidth = 5.0
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 5.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath

        contentView.addSubview(backgroundAsteroidView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dinosaourImageView)
        contentView.addSubview(asteroidImageView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(dangerLabel)
        contentView.addSubview(destroyButton)
    }
    
    // установка layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundAsteroidView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundAsteroidView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundAsteroidView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundAsteroidView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -163)
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: backgroundAsteroidView.leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: backgroundAsteroidView.bottomAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            dinosaourImageView.trailingAnchor.constraint(equalTo: backgroundAsteroidView.trailingAnchor, constant: -12),
            dinosaourImageView.bottomAnchor.constraint(equalTo: backgroundAsteroidView.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            asteroidImageView.leadingAnchor.constraint(equalTo: backgroundAsteroidView.leadingAnchor, constant: 27),
            asteroidImageView.bottomAnchor.constraint(equalTo: backgroundAsteroidView.bottomAnchor, constant: -65)
        ])
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 161)
        ])
        NSLayoutConstraint.activate([
            dangerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dangerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -19)
        ])
        NSLayoutConstraint.activate([
            destroyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            destroyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            destroyButton.widthAnchor.constraint(equalToConstant: 121)
        ])
    }
    
    // установка градиента в зависимости от опасности астероида
    private func setupGradientForBackgroundAsteroidView(isDangerous: Bool) {
        backgroundAsteroidView.layer.sublayers = nil
        let gradient = CAGradientLayer()
        if isDangerous {
            gradient.colors = [
                UIColor(red: 1, green: 0.694, blue: 0.6, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.031, blue: 0.267, alpha: 1).cgColor
            ]
        } else {
            gradient.colors = [
                UIColor(red: 0.811, green: 0.952, blue: 0.491, alpha: 1).cgColor,
                UIColor(red: 0.492, green: 0.908, blue: 0.549, alpha: 1).cgColor
            ]
        }
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.frame = backgroundAsteroidView.bounds
        gradient.position = backgroundAsteroidView.center
        backgroundAsteroidView.layer.insertSublayer(gradient, at: 0)
    }
}

extension AsteroidCollectionViewCell {
    // ранжирование астероида по диаметру, возвращает название нужной картинки
    private func resizeAsteriodImageFromDiameter(_ diameter: Double) -> String {
        switch diameter {
        case ..<300: return Strings.smallAsteroidImage
        case ..<800: return Strings.averageAsteroidImage
        default: return Strings.bigAsteroidImage
        }
    }
}
