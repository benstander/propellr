import Foundation

enum BasiqError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case apiError(String)
}

class BasiqService {
    private let baseURL = "https://au-api.basiq.io"
    private let apiKey: String
    private var accessToken: String?
    
    init(apiKey: String? = nil) {
        self.apiKey = apiKey ?? AppConfig.basiqApiKey
    }
    
    // MARK: - Authentication
    
    func authenticate() async throws {
        let url = URL(string: "\(baseURL)/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(AppConfig.basiqApiVersion, forHTTPHeaderField: "basiq-version")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BasiqError.networkError(NSError(domain: "", code: -1))
        }
        
        guard httpResponse.statusCode == 200 else {
            throw BasiqError.apiError("Authentication failed with status code: \(httpResponse.statusCode)")
        }
        
        struct TokenResponse: Codable {
            let access_token: String
            let expires_in: Int
            let token_type: String
        }
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        self.accessToken = tokenResponse.access_token
    }
    
    // MARK: - Users
    
    func createUser(email: String, mobile: String) async throws -> String {
        guard let accessToken = accessToken else {
            try await authenticate()
            return try await createUser(email: email, mobile: mobile)
        }
        
        let url = URL(string: "\(baseURL)/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2.0", forHTTPHeaderField: "basiq-version")
        
        let body = ["email": email, "mobile": mobile]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BasiqError.networkError(NSError(domain: "", code: -1))
        }
        
        guard httpResponse.statusCode == 201 else {
            throw BasiqError.apiError("User creation failed with status code: \(httpResponse.statusCode)")
        }
        
        struct UserResponse: Codable {
            let id: String
        }
        
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return userResponse.id
    }
    
    // MARK: - Bank Connections
    
    func createAuthLink(userId: String, mobile: String) async throws -> String {
        guard let accessToken = accessToken else {
            try await authenticate()
            return try await createAuthLink(userId: userId, mobile: mobile)
        }
        
        let url = URL(string: "\(baseURL)/users/\(userId)/auth_link")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2.0", forHTTPHeaderField: "basiq-version")
        
        let body = ["mobile": mobile]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BasiqError.networkError(NSError(domain: "", code: -1))
        }
        
        guard httpResponse.statusCode == 201 else {
            throw BasiqError.apiError("Auth link creation failed with status code: \(httpResponse.statusCode)")
        }
        
        struct AuthLinkResponse: Codable {
            let url: String
        }
        
        let authLinkResponse = try JSONDecoder().decode(AuthLinkResponse.self, from: data)
        return authLinkResponse.url
    }
} 