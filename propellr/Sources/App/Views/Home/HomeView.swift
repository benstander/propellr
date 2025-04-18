import SwiftUI

struct HomeView: View {
    let userName = "Ben"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Group 1: Welcome & Current Balance
                        VStack(alignment: .leading, spacing: 18) {
                            // Welcome Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Hey, \(userName)")
                                    .font(.title)
                                    .fontWeight(.medium)
                                
                                Text("Welcome Back!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 20)
                            
                            // Current Balance
                            VStack(alignment: .leading, spacing: 28) {
                                Text("Current Balance")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("$236")
                                    .font(.system(size: 26, weight: .medium))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                        }
                        
                        // Group 2: Cash Flow Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cash Flow")
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding(.bottom, 8)
                            
                            // Income
                            VStack(alignment: .leading, spacing: 28) {
                                Text("Income this month")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("$2,345")
                                    .font(.system(size: 26, weight: .medium))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                            
                            // Spending
                            VStack(alignment: .leading, spacing: 28) {
                                Text("Spending this month")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("$654")
                                    .font(.system(size: 26, weight: .medium))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                            
                            // Projected Spending
                            VStack(alignment: .leading, spacing: 28) {
                                Text("Projected spending")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("$1,546")
                                    .font(.system(size: 26, weight: .medium))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                
                // Search Bar
                HStack {
                    Image(systemName: "sparkles")
                    Text("Ask me something ...")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(white: 0.1), lineWidth: 1)
                )
                .padding()
            }
        }
    }
}

struct NavigationButton: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .black : .gray)
        }
    }
} 