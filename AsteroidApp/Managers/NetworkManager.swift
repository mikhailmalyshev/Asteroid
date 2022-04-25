//
//  NetworkManager.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 20.04.2022.
//

import Foundation

// MARK: -  NetworkManager - класс для работы с сетью
class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let apiKey = "dbQmjc7dsbaopghlM1LeeiY9TSsQRLL1rJyhMcNG"
    
    private init() {}
    
    // загрузка массива астероидов из api
    func fetchArrayOfAsteroids(from date: Date, with complition: @escaping ([NearEarthObject]) -> Void) {
        
        let startDate = date.formatDateToString()
        let endDate = date.addWeekToDate().formatDateToString()
        
        let urlString = "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error); return }
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(Asteroid.self, from: data)
                var asteroids: [NearEarthObject] = []
                result.nearEarthObjects.forEach { (_, value) in
                    asteroids += value
                }
                complition(asteroids)
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }
    
    // загрузка информации по выбранному астероиду
    func fetchDataForAsteroid(from urlString: String, with complition: @escaping (NearEarthObject) -> Void) {

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error); return }
            guard let data = data else { return }

            do {
                let asteroid = try JSONDecoder().decode(NearEarthObject.self, from: data)
                complition(asteroid)
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }
}
