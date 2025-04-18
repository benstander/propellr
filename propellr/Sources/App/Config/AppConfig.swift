import Foundation

enum AppConfig {
    // MARK: - API Keys
    
    /// The Basiq API key loaded from configuration
    static var basiqApiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["BASIQ_API_KEY"] as? String,
              !apiKey.isEmpty,
              apiKey != "your_api_key_here" else {
            fatalError("Basiq API Key not found. Please add it to Config.xcconfig")
        }
        return apiKey
    }
    
    /// The Basiq API version
    static var basiqApiVersion: String {
        Bundle.main.infoDictionary?["BASIQ_API_VERSION"] as? String ?? "2.0"
    }
    
    // MARK: - Keychain
    
    /// The keychain service name for storing sensitive data
    static let keychainService = "io.propellr"
    
    /// The keychain access group (for sharing between extensions)
    static let keychainAccessGroup = "group.io.propellr"
} 