import SwiftUI

struct AccountView: View {
    struct MenuItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
    }
    
    let profileItems: [MenuItem] = [
        MenuItem(icon: "account", title: "Personal info"),
        MenuItem(icon: "account-security", title: "Account security")
    ]
    
    let walletItems: [MenuItem] = [
        MenuItem(icon: "credit-cards", title: "Manage cards"),
        MenuItem(icon: "entertainment", title: "Manage subscriptions"),
        MenuItem(icon: "savings", title: "Open new savings account"),
        MenuItem(icon: "bank-account", title: "Connect bank account"),
        MenuItem(icon: "trading-app", title: "Connect trading app")
    ]
    
    let settingsItems: [MenuItem] = [
        MenuItem(icon: "currency", title: "Currency"),
        MenuItem(icon: "notifications", title: "Notifications")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Account")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    // Profile Section
                    VStack(alignment: .leading, spacing: 26) {
                        Text("Profile")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        VStack(spacing: 24) {
                            ForEach(profileItems) { item in
                                MenuItemView(item: item)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Wallet Section
                    VStack(alignment: .leading, spacing: 26) {
                        Text("Wallet")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        VStack(spacing: 24) {
                            ForEach(walletItems) { item in
                                MenuItemView(item: item)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Settings Section
                    VStack(alignment: .leading, spacing: 26) {
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        VStack(spacing: 24) {
                            ForEach(settingsItems) { item in
                                MenuItemView(item: item)
                            }
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    EmptyView()
                }
            }
        }
    }
}

struct MenuItemView: View {
    let item: AccountView.MenuItem
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(item.icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(item.title)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .foregroundColor(.primary)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
} 