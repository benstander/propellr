import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            
            PortfolioView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                }
                .tag(1)
            
            TransactionsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
                .tag(2)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.black)
    }
} 