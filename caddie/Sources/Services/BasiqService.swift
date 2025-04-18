import Foundation

enum BasiqError: Error {
    case authenticationFailed
    case invalidResponse
    case networkError(Error)
    case apiError(String)
}

class BasiqService {
    private let apiKey: String
    private var accessToken: String?
    private let baseURL = "https://au-api.basiq.io"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Authentication
    
    private func authenticate() async throws {
        let url = URL(string: "\(baseURL)/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BasiqError.authenticationFailed
        }
        
        struct AuthResponse: Codable {
            let access_token: String
        }
        
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        self.accessToken = authResponse.access_token
    }
    
    // MARK: - User Management
    
    func createUser(email: String) async throws -> String {
        if accessToken == nil {
            try await authenticate()
        }
        
        let url = URL(string: "\(baseURL)/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData = ["email": email]
        request.httpBody = try JSONEncoder().encode(userData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw BasiqError.apiError("Failed to create user")
        }
        
        struct UserResponse: Codable {
            let id: String
        }
        
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return userResponse.id
    }
    
    // MARK: - Institution Management
    
    func getInstitutions() async throws -> [Institution] {
        if accessToken == nil {
            try await authenticate()
        }
        
        let url = URL(string: "\(baseURL)/institutions")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BasiqError.apiError("Failed to fetch institutions")
        }
        
        struct InstitutionsResponse: Codable {
            let data: [Institution]
        }
        
        let institutionsResponse = try JSONDecoder().decode(InstitutionsResponse.self, from: data)
        return institutionsResponse.data
    }
    
    // MARK: - Account Linking
    
    func createConnectionURL(userId: String, institutionId: String) async throws -> String {
        if accessToken == nil {
            try await authenticate()
        }
        
        let url = URL(string: "\(baseURL)/users/\(userId)/connections")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let connectionData = [
            "institution": ["id": institutionId],
            "mobile": true
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: connectionData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw BasiqError.apiError("Failed to create connection URL")
        }
        
        struct ConnectionResponse: Codable {
            let links: Links
            
            struct Links: Codable {
                let mobile: String
            }
        }
        
        let connectionResponse = try JSONDecoder().decode(ConnectionResponse.self, from: data)
        return connectionResponse.links.mobile
    }
    
    // MARK: - Account Data
    
    func getAccounts(userId: String) async throws -> [Account] {
        if accessToken == nil {
            try await authenticate()
        }
        
        let url = URL(string: "\(baseURL)/users/\(userId)/accounts")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BasiqError.apiError("Failed to fetch accounts")
        }
        
        struct AccountsResponse: Codable {
            let data: [Account]
        }
        
        let accountsResponse = try JSONDecoder().decode(AccountsResponse.self, from: data)
        return accountsResponse.data
    }
    
    func getTransactions(userId: String, accountId: String? = nil, fromDate: Date? = nil, toDate: Date? = nil) async throws -> [Transaction] {
        if accessToken == nil {
            try await authenticate()
        }
        
        var urlComponents = URLComponents(string: "\(baseURL)/users/\(userId)/transactions")!
        var queryItems: [URLQueryItem] = []
        
        if let accountId = accountId {
            queryItems.append(URLQueryItem(name: "account.id", value: accountId))
        }
        
        let dateFormatter = ISO8601DateFormatter()
        if let fromDate = fromDate {
            queryItems.append(URLQueryItem(name: "from", value: dateFormatter.string(from: fromDate)))
        }
        if let toDate = toDate {
            queryItems.append(URLQueryItem(name: "to", value: dateFormatter.string(from: toDate)))
        }
        
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BasiqError.apiError("Failed to fetch transactions")
        }
        
        struct TransactionsResponse: Codable {
            let data: [Transaction]
        }
        
        let transactionsResponse = try JSONDecoder().decode(TransactionsResponse.self, from: data)
        return transactionsResponse.data
    }
} 