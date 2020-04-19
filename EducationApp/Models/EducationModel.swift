//
//  EducationModel.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

public struct EducationModel: Codable {
    let status: Int
    let educationData: EducationData?
}

struct EducationData: Codable {
    let title: String?
    let education: [Education]?
}

struct Education: Codable {
    let level: String?
    let subjects: [Subjects]?
}

struct Subjects: Codable {
    let item: String?
    let courses: [String]?
}
