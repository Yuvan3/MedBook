//
//  CountryInfo.swift
//  MedBook
//
//  Created by Yuvan Shankar on 09/08/23.
//

import Foundation

struct CountryInfo: Codable {
    let status: String?
    let statusCode: Int?
    let version, access: String?
    let data: [String: Country]?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version, access, data
    }
}

struct Country: Codable {
    let country: String?
    let region: Region?
}

enum Region: String, Codable {
    case africa = "Africa"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case centralAmerica = "Central America"
}
