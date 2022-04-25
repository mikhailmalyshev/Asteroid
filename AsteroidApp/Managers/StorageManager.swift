//
//  StorageManager.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 22.04.2022.
//

import Foundation

// MARK: -  StorageManager - класс для хранения данных
class StorageManager {
    
    static let shared = StorageManager()
    
    private let key = "key"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // добавления астероида в базу
    func saveAsteroids(with newNearEarthObject: NearEarthObject) {
        var asteroids = fetchAsteroids()
        
        for asteroid in asteroids {
            if newNearEarthObject.id == asteroid.id {
                return
            }
        }
        asteroids.append(newNearEarthObject)
        
        guard let data = try? JSONEncoder().encode(asteroids) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    // получения списка астероидов, добавленных в базу
    func fetchAsteroids() -> [NearEarthObject] {
        guard let data = userDefaults.object(forKey: key) as? Data else { return [] }
        guard let asteroids = try? JSONDecoder().decode([NearEarthObject].self, from: data) else { return [] }
        return asteroids
    }
    
    // удаление всех астероидов из базы
    func deleteAllAsteroids() {
        var asteroids = fetchAsteroids()
        asteroids.removeAll()
        
        guard let data = try? JSONEncoder().encode(asteroids) else { return }
        userDefaults.set(data, forKey: key)
    }
}
