//
//  ListAsteroidViewController.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 19.04.2022.
//

import UIKit

// протокол для передачи информации между экранами
protocol SetModeDelegate {
    func setMode(distanceMode: Int, filterIsDanger: Bool)
}

// MARK: - ListAsteroidViewController - список астероидов, полученных от NASA
final class ListAsteroidViewController: UIViewController {
    
    var distanceMode = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    var filterIsDanger = false {
        didSet {
            filteredAsteroids = asteroids.filter{ $0.isPotentiallyHazardousAsteroid }
            collectionView.reloadData()
        }
    }
    private enum Strings {
        static let backButtonTitle = "Назад"
        static let imageForOptionsButton = "line.3.horizontal.decrease"
    }
    private var asteroids: [NearEarthObject] = []
    private var filteredAsteroids: [NearEarthObject] = []
    private let sectionInserts = UIEdgeInsets(top: 25, left: 16, bottom: 25, right: 16)
    private var date = Date()
    
    // активити индикатор внизу таблице при подгрузке
    private lazy var activityIndicatorInBottom: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        activityIndicator.isHidden = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // активити индикатор внизу таблице при подгрузке
    private lazy var activityIndicatorInCenter: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
        
        activityIndicatorInCenter.startAnimating()
        NetworkManager.shared.fetchArrayOfAsteroids(from: date) { asteroids in
            DispatchQueue.main.async {
                self.activityIndicatorInCenter.stopAnimating()
                self.activityIndicatorInCenter.isHidden = true
                self.asteroids = asteroids
                self.collectionView.reloadData()
            }
        }
    }
    
    // Установка views
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorInBottom)
        view.addSubview(activityIndicatorInCenter)
        guard let imageForButtonEdit = UIImage(systemName: Strings.imageForOptionsButton) else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageForButtonEdit,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(optionButtonTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Strings.backButtonTitle, style: .plain, target: nil, action: nil)
    }
    
    // Установка layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicatorInBottom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorInBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            activityIndicatorInCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorInCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Кнопка для перехода на экран настроек
    @objc private func optionButtonTapped() {
        let optionsVC = OptionsViewController(selectedSegment: distanceMode,
                                              filterIsOn: filterIsDanger)
        optionsVC.delegate = self
        navigationController?.pushViewController(optionsVC, animated: true)
    }
    
    // Кнопка для добавления астероида в корзину
    @objc private func buttonTapped(sender: UIButton) {
        if filterIsDanger {
            StorageManager.shared.saveAsteroids(with: filteredAsteroids[sender.tag])
        } else {
        StorageManager.shared.saveAsteroids(with: asteroids[sender.tag])
        }
        sender.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            sender.alpha = 1.0
        }
    }
}

// MARK: -  Методы CollectionView
extension ListAsteroidViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterIsDanger ? filteredAsteroids.count : asteroids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsteroidCollectionViewCell.reuseId, for: indexPath) as! AsteroidCollectionViewCell
        var newAsteroids: [NearEarthObject] = []
        newAsteroids = filterIsDanger ? filteredAsteroids : asteroids
        cell.destroyButton.tag = indexPath.row
        cell.configureWithAsteroid(asteroid: newAsteroids[indexPath.row], convertDistanceMode: distanceMode)
        cell.destroyButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asteroid = filterIsDanger ? filteredAsteroids[indexPath.row] : asteroids[indexPath.row]
        let detailVC = DetailAsteroidViewController()
        detailVC.title = asteroid.name
        detailVC.asteroid = asteroid
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let currentAsteroids = filterIsDanger ? filteredAsteroids : asteroids
        
        if indexPath.row == currentAsteroids.count - 1 {
            date = date.addWeekToDate()
            activityIndicatorInBottom.isHidden = false
            activityIndicatorInBottom.startAnimating()
            NetworkManager.shared.fetchArrayOfAsteroids(from: date) { asteroids in
                DispatchQueue.main.async {
                    self.activityIndicatorInBottom.stopAnimating()
                    self.activityIndicatorInBottom.isHidden = true
                    if self.filterIsDanger {
                        self.filteredAsteroids += asteroids.filter{ $0.isPotentiallyHazardousAsteroid }
                    } else {
                        self.asteroids += asteroids
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ListAsteroidViewController: SetModeDelegate {
    func setMode(distanceMode: Int, filterIsDanger: Bool) {
        self.distanceMode = distanceMode
        self.filterIsDanger = filterIsDanger
    }
}
