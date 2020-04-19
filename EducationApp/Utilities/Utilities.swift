//
//  Constants.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

class Constants {
    static let primaryColor = UIColor(red: 19/255, green: 57/255, blue: 89/255, alpha: 1.0)
    static let secondaryColor = UIColor(red: 159/255, green: 225/255, blue: 93/255, alpha: 1.0)
    static let noEducationLevel = "None of the above"

    static func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
class DataParser {
    static func fetchEducationDataFromFile() -> EducationData? {
        guard let url = Bundle.main.url(forResource: "EducationLevel", withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(EducationModel.self, from: data)
            return response.educationData
        } catch {
            return nil
        }
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

