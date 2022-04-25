//
//  Date + Extension.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 24.04.2022.
//

import Foundation

// MARK: - Date + Extension
extension Date {
    
    // Метод добавления недели к дате
    func addWeekToDate() -> Date {
        let currentDate = self
        var dateComponent = DateComponents()
        dateComponent.day = 7
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return Date() }
        return futureDate
    }
    
    // Метод форматирования даты в Стринг для вставки в URL
    func formatDateToString() -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
