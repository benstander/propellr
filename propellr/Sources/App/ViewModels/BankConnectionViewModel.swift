import SwiftUI
import Foundation

// Import local modules
import App

@MainActor
class BankConnectionViewModel: ObservableObject {
    private let basiqService: BasiqService
    
    @Published var institutions: [Institution] = []
    @Published var accounts: [Account] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var connectionURL: String?
    
    private var userId: String?
    
    init(apiKey: String) {
        self.basiqService = BasiqService(apiKey: apiKey)
    }
    
    func loadInstitutions() async {
        isLoading = true
        error = nil
        
        do {
            institutions = try await basiqService.getInstitutions()
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func connectBank(email: String, institutionId: String) async {
        isLoading = true
        error = nil
        
        do {
            // Create or get user
            if userId == nil {
                userId = try await basiqService.createUser(email: email)
            }
            
            // Get connection URL
            connectionURL = try await basiqService.createConnectionURL(
                userId: userId!,
                institutionId: institutionId
            )
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func refreshAccounts() async {
        guard let userId = userId else {
            error = "No user found"
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            accounts = try await basiqService.getAccounts(userId: userId)
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func getTransactions(fromDate: Date? = nil, toDate: Date? = nil) async -> [Transaction] {
        guard let userId = userId else {
            error = "No user found"
            return []
        }
        
        do {
            return try await basiqService.getTransactions(
                userId: userId,
                fromDate: fromDate,
                toDate: toDate
            )
        } catch {
            self.error = error.localizedDescription
            return []
        }
    }
} 