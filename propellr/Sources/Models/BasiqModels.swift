import Foundation

struct Institution: Codable, Identifiable {
    let id: String
    let name: String
    let shortName: String
    let institutionType: String
    let country: String
    let logo: URL?
}

struct Account: Codable, Identifiable {
    let id: String
    let accountNo: String
    let name: String
    let currency: String
    let balance: Double
    let availableFunds: Double?
    let type: AccountType
    let status: String
    
    enum AccountType: String, Codable {
        case savings
        case credit
        case transaction
        case loan
        case investment
        case mortgage
        case other
    }
}

struct Transaction: Codable, Identifiable {
    let id: String
    let status: String
    let description: String
    let amount: Double
    let account: AccountRef
    let postDate: Date
    let transactionDate: Date
    let direction: TransactionDirection
    let balance: Double?
    let category: String?
    
    struct AccountRef: Codable {
        let id: String
        let accountNo: String
    }
    
    enum TransactionDirection: String, Codable {
        case credit
        case debit
    }
}

// MARK: - Connection Status
enum ConnectionStatus: String, Codable {
    case pending
    case active
    case suspended
    case expired
}

// MARK: - Connection
struct Connection: Codable, Identifiable {
    let id: String
    let status: ConnectionStatus
    let institution: Institution
    let lastUsed: Date?
} 