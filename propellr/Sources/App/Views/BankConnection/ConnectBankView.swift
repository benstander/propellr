import SwiftUI

struct ConnectBankView: View {
    @StateObject private var viewModel: BankConnectionViewModel
    @State private var showingError = false
    
    init() {
        _viewModel = StateObject(wrappedValue: BankConnectionViewModel(apiKey: APIConfig.BASIQ_API_KEY))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                // Show available banks
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.institutions) { institution in
                            HStack {
                                AsyncImage(url: institution.logo) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                                
                                VStack(alignment: .leading) {
                                    Text(institution.name)
                                        .font(.headline)
                                    Text(institution.country)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            // Load banks when view appears
            await viewModel.loadInstitutions()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.error ?? "An unknown error occurred")
        }
        .onChange(of: viewModel.error) { error in
            showingError = error != nil
        }
        .navigationTitle("Connect Bank")
    }
} 