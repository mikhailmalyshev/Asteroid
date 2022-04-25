//
//  flightsOfAsteroidViewController.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 22.04.2022.
//

import UIKit

//MARK: - FlightsOfAsteroidViewController - экран со списком подлетов астероида
final class FlightsOfAsteroidViewController: UIViewController {
    
    var asteroidUrl = ""
    
    private var flights: [CloseApproachDatum] = []
    
    // tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // активити индикатор
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        activityIndicator.isHidden = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.shared.fetchDataForAsteroid(from: asteroidUrl) { asteroid in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.flights = asteroid.closeApproachData
                self.tableView.reloadData()
            }
        }
        setupViews()
        setupLayout()
    }
    
    // установка views
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    // установка layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 50)
        ])
    }
}

// MARK: -  Методы TableView

extension FlightsOfAsteroidViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        
        let flight = flights[indexPath.row]
        cell.textLabel?.text = """
        Cкорость относительно Земли:
        \(flight.relativeVelocity.kilometersPerHour.formatSpeed())
        Время максимального сближения с Землей:
        \(flight.closeApproachDateFull.convertFullDateForLabel())
        Расстояние до Земли:
        \(flight.missDistance.kilometers.formatDistance(convert: 0))
        По орбите чего летит: \(flight.orbitingBody)
        """
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: "Малый астероид")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
