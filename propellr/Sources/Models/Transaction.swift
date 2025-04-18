import Foundation

struct Transaction: Identifiable, Codable {
    let id: String
    let date: Date
    let amount: Double
    let vendor: String
    let category: TransactionCategory
    let type: TransactionType
}

enum TransactionCategory: String, Codable {
    case shopping
    case essentials
    case entertainment
    case income
    case other
}

enum TransactionType: String, Codable {
    case income
    case expense
} 