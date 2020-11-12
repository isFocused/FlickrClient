//
//  CurentDateManager.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol CurentDateProtocol {
    func createStringDate() -> String
}

class CurentDateManager: CurentDateProtocol {
    
    func createStringDate() -> String {
        let calendar = Calendar.current
        
        guard let yesterday = calendar.date(byAdding: .day, value: -2, to: Date()) else { return "" }
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
        
        return createString(from: dateComponents)
    }
    
    private func createString(from dateComponents: DateComponents) -> String {
        guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else {
            return ""
        }
        
        if month < 10 && day < 10 {
            return "\(year)-0\(month)-0\(day)"
        } else if month < 10 {
            return "\(year)-0\(month)-\(day)"
        } else if day < 10 {
            return "\(year)-\(month)-0\(day)"
        } else {
            return "\(year)-\(month)-\(day)"
        }
    }
}
