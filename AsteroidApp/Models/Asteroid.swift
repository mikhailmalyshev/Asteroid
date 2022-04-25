//
//  Asteroid.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 20.04.2022.
//

import Foundation

// MARK: - Asteroid - главная модель

struct Asteroid: Codable {
    let links: AsteroidLinks?
    let nearEarthObjects: [String: [NearEarthObject]]

    enum CodingKeys: String, CodingKey {
        case links
        case nearEarthObjects = "near_earth_objects"
    }
}

// MARK: AsteroidLinks

struct AsteroidLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: NearEarthObject

struct NearEarthObject: Codable {
    let links: NearEarthObjectLinks
    let id: String
    let neoReferenceID: String
    let name: String
    let estimatedDiameter: EstimatedDiameter
    var isPotentiallyHazardousAsteroid: Bool
    let closeApproachData: [CloseApproachDatum]

    enum CodingKeys: String, CodingKey {
        case links, id
        case neoReferenceID = "neo_reference_id"
        case name
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case closeApproachData = "close_approach_data"
    }
}

// MARK: CloseApproachDatum

struct CloseApproachDatum: Codable {
    let closeApproachDate: String
    let closeApproachDateFull: String
    let relativeVelocity: RelativeVelocity
    let missDistance: MissDistance
    let orbitingBody: String

    enum CodingKeys: String, CodingKey {
        case closeApproachDate = "close_approach_date"
        case closeApproachDateFull = "close_approach_date_full"
        case relativeVelocity = "relative_velocity"
        case missDistance = "miss_distance"
        case orbitingBody = "orbiting_body"
    }
}



// MARK: MissDistance

struct MissDistance: Codable {
    let lunar: String
    let kilometers: String
}

// MARK: RelativeVelocity

struct RelativeVelocity: Codable {
    let kilometersPerHour: String

    enum CodingKeys: String, CodingKey {
        case kilometersPerHour = "kilometers_per_hour"
    }
}

// MARK: EstimatedDiameter

struct EstimatedDiameter: Codable {
    let kilometers: Feet
    let meters: Feet
    let feet: Feet
}

// MARK: Feet

struct Feet: Codable {
    let estimatedDiameterMin: Double
    let estimatedDiameterMax: Double

    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}

// MARK: NearEarthObjectLinks

struct NearEarthObjectLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}
