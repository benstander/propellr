import SwiftUI

struct ConnectBankView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @State private var error: String?
    @State private var authURL: String?
    
    private let basiqService = BasiqService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text(error)
                            .multilineTextAlignment(.center)
                    }
                } else if let authURL = authURL {
                    Link(destination: URL(string: authURL)!) {
                        Text("Connect Your Bank")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    Button {
                        Task {
                            await connectBank()
                        }
                    } label: {
                        Text("Start Bank Connection")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Connect Bank")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func connectBank() async {
        isLoading = true
        error = nil
        
        do {
            // In a real app, you would get these values from your user management system
            let userId = try await basiqService.createUser(
                email: "user@example.com",
                mobile: "+61400000000"
            )
            
            let authURL = try await basiqService.createAuthLink(
                userId: userId,
                mobile: "+61400000000"
            )
            
            await MainActor.run {
                self.authURL = authURL
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
                isLoading = false
            }
        }
    }
} 