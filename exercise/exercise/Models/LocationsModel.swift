//
//  LocationsModel.swift
//  exercise
//
//  Created by Nikhil Doppalapudi on 2/10/21.
//

import Foundation

struct LocationsModel: Codable {
    let type: String
    let features: [Feature]
    let bbox: [Double]
}

struct Feature: Codable {
    let properties: Properties
    let geometry: Geometry
    let id: String
}

struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Double]
}

enum GeometryType: String, Codable {
    case point = "Point"
}

struct Properties: Codable {
    let place: String
    let url, detail: String
    let title: String
}
