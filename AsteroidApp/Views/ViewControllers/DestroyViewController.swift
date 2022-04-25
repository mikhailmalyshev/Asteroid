//
//  DestroyViewController.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 19.04.2022.
//

import UIKit

// MARK: -  DestroyViewController - корзина астероидов
final class DestroyViewController: UIViewController {
    
    private enum Strings {
        static let mainFontRegular = "Helvetica"
        static let mainFontBold = "Helvetica-Bold"
        static let textForDestroyButton = """
            Отправить бригаду \nим. Брюса Уиллиса
            """
    }
    private var asteroids: [NearEarthObject] = []
    private let sectionInserts = UIEdgeInsets(top: 25, left: 16, bottom: 25, right: 16)
    
    // CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .white
        collection.register(AsteroidCollectionViewCell.self, forCellWithReuseIdentifier: AsteroidCollectionViewCell.reuseId)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // кнопка "Бригада Брюса Уиллиса"
    private lazy var destroyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 121, height: 30))
        
        guard let font = UIFont(name: Strings.mainFontRegular, size: 20) else { return button }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let text = Strings.textForDestroyButton
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(red: 0,
                                         green: 0.478,
                                         blue: 1,
                                         alpha: 1)
        button.layer.cornerRadius = 13
        
        button.titleLabel?.numberOfLines = 0
        button.isHidden = true
        button.alpha = 0
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        asteroids = StorageManager.shared.fetchAsteroids()
        collectionView.reloadData()
    }
    
    // установка views
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        view.addSubview(collectionView)
        view.addSubview(destroyButton)
    }
    
    // установка layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            destroyButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -20),
            destroyButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 20),
            destroyButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func buttonPressed(sender: UIButton) {
        asteroids = []
        
        StorageManager.shared.deleteAllAsteroids()
        
        UIView.transition(with: self.collectionView,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: { self.collectionView.reloadData() })
        sender.isHidden = true
    }
}

// MARK: -  Методы CollectionView
extension DestroyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asteroids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsteroidCollectionViewCell.reuseId, for: indexPath) as! AsteroidCollectionViewCell
 
        cell.configureWithAsteroid(asteroid: asteroids[indexPath.row], convertDistanceMode: 0)
        cell.destroyButton.isHidden = true
        // кнопка появляется в конце таблицы
        if indexPath.row == asteroids.count - 1 {
            UIView.animate(withDuration: 0.5) {
                self.destroyButton.alpha = 1.0
                self.destroyButton.isHidden = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 340, height: 308)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.bottom
    }
}
