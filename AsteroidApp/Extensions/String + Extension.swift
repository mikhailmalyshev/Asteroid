//
//  ExtensionDate.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 22.04.2022.
//

import Foundation

// MARK: - String + Extension
extension String {
    
    // ковертация даты для лэйбла
    func convertShortDateForLabel() -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else { return "" }
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
    
    // конвертация полной даты для лэйбла
    func convertFullDateForLabel() -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
        guard let date = dateFormatter.date(from: date) else { return "Ошибка" }
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
    
    // конвертация расстояния, если convert = 0 - в км, если convert = 1 - в лунных орбитах
    func formatDistance(convert: Int) -> String {
        let distance = self
        guard let doubleDistance = Double(distance) else { return "Ошибка"}
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        guard let string = formatter.string(for: doubleDistance.rounded()) else { return "Ошибка" }
        switch convert {
        case 0: return string + " км"
        case 1: return string + " лунных орбит"
        default: return "Ошибка"
        }
    }
    
    // форматирование имени астероида для ячейки
    func formatNameForCell() -> String {
        let name = self
        let splitStringArray = name.split(separator: "(", maxSplits: 1).map(String.init)
        guard var resultName = splitStringArray.last else { return "Ошибка" }
        resultName.removeLast()
        return resultName
    }
    
    // форматирование скорости
    func formatSpeed() -> String {
        let speed = self
        guard let doubleDistance = Double(speed) else { return "Ошибка"}
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        guard let string = formatter.string(for: doubleDistance.rounded()) else { return "Ошибка" }
        return string + " км/ч"
    }
}
