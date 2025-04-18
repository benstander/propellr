import Foundation

enum Environment {
    case development
    case production
}

struct APIConfig {
    static let environment: Environment = .development
    
    // Basiq API Keys
    static let BASIQ_API_KEY: String = {
        #if DEBUG
        // Replace this string with your actual API key from Basiq dashboard
        // Example format: "YOUR_KEY_HERE"
        return "Nzk1Mzk4ZWUtMGRiZC00MzU1LWI1NjgtMjU0NjZjMjMyOWViOjkxMmM5MDQ3LTRkOTctNGY2YS05ZjhlLWQ2YzMxZDZlZWYyNA=="
        #else
        return "PRODUCTION_KEY_WILL_GO_HERE"    // Production key
        #endif
    }()
} 