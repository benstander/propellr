import SwiftUI


struct SavingsGoal: Identifiable {
    let id = UUID()
    let title: String
    let currentAmount: Double
    let targetAmount: Double
}

struct PortfolioView: View {
    @State private var selectedType: PortfolioType = .all
    
    // Sample Data (replace with actual data models later)
    struct PortfolioCard: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let type: PortfolioType
    }

    struct PortfolioItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let amount: Double
        let type: PortfolioType
        let percentageChange: Double
    }
    
    // Sample savings goals
    let savingsGoals: [SavingsGoal] = [
        SavingsGoal(title: "All Savings", currentAmount: 12456, targetAmount: 12456),
        SavingsGoal(title: "Euro Summer", currentAmount: 5672, targetAmount: 8000),
        SavingsGoal(title: "Car", currentAmount: 4598, targetAmount: 12000),
        SavingsGoal(title: "House Deposit", currentAmount: 6345, targetAmount: 100000)
    ]
    
    // Sample graph data
    let graphData: [DataPoint] = {
        let calendar = Calendar.current
        let today = Date()
        let values = [
            17000,  // 6 months ago
            17500,  // 5 months ago
            18000,  // 4 months ago
            17700,  // 3 months ago
            18500,  // 2 months ago
            19000   // 1 month ago
        ]
        
        return values.enumerated().map { index, value in
            let date = calendar.date(byAdding: .month, value: -5 + index, to: today)!
            return DataPoint(value: Double(value), date: date)
        }
    }()
    
    enum PortfolioType {
        case all
        case stocks
        case savings
        case crypto
        case realAssets
        case debts
        case superannuation
        case other
    }

    let cards: [PortfolioCard] = [
        PortfolioCard(icon: "portfolio", title: "All", type: .all),
        PortfolioCard(icon: "stocks", title: "Stocks", type: .stocks),
        PortfolioCard(icon: "savings", title: "Savings", type: .savings),
        PortfolioCard(icon: "crypto", title: "Crypto", type: .crypto),
        PortfolioCard(icon: "real-assets", title: "Real Assets", type: .realAssets),
        PortfolioCard(icon: "debts", title: "Debts", type: .debts),
        PortfolioCard(icon: "superannuation", title: "Super", type: .superannuation),
        PortfolioCard(icon: "other", title: "Other", type: .other)
    ]

    let portfolioItems: [PortfolioItem] = [
        // Stocks
        PortfolioItem(icon: "voo-logo", title: "VOO", amount: 1246, type: .stocks, percentageChange: 0.08),
        PortfolioItem(icon: "vas-logo", title: "VAS", amount: 1034, type: .stocks, percentageChange: 0.08),
        PortfolioItem(icon: "tesla-logo", title: "Tesla", amount: 903, type: .stocks, percentageChange: -2.34),
        // Savings
        PortfolioItem(icon: "savings", title: "Savings", amount: 12456, type: .savings, percentageChange: 0.02),
        // Crypto
        PortfolioItem(icon: "crypto", title: "Crypto", amount: 903, type: .crypto, percentageChange: -1.5),
        // Real Assets
        PortfolioItem(icon: "real-assets", title: "Real Assets", amount: 12300, type: .realAssets, percentageChange: 0.5),
        // Debts
        PortfolioItem(icon: "debts", title: "Credit Card", amount: 324, type: .debts, percentageChange: 0.0),
        PortfolioItem(icon: "debts", title: "Personal Loan", amount: 5600, type: .debts, percentageChange: 0.0),
        // Superannuation
        PortfolioItem(icon: "superannuation", title: "Australian Super", amount: 3456, type: .superannuation, percentageChange: 0.12),
        // Other
        PortfolioItem(icon: "other", title: "Cash", amount: 134, type: .other, percentageChange: 0.0)
    ]

    var filteredItems: [PortfolioItem] {
        if selectedType == .all {
            return portfolioItems
        }
        return portfolioItems.filter { $0.type == selectedType }
    }
    
    var categorizedItems: [PortfolioType: [PortfolioItem]] {
        Dictionary(grouping: portfolioItems) { $0.type }
    }
    
    var totalValue: Double {
        filteredItems.reduce(0) { $0 + $1.amount }
    }
    
    var totalPercentageChange: Double {
        let totalChange = filteredItems.reduce(0.0) { $0 + $1.percentageChange }
        return filteredItems.isEmpty ? 0 : totalChange / Double(filteredItems.count)
    }
    
    func categoryTotal(for type: PortfolioType) -> Double {
        portfolioItems.filter { $0.type == type }.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Fixed Header and Categories
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack {
                        Text("Portfolio")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        NavigationLink {
                            ConnectBankView()
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(cards) { card in
                                Button(action: { selectedType = card.type }) {
                                    PortfolioCardView(card: card, isSelected: selectedType == card.type)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 6)
                }
                .padding()
                .background(Color.white)

                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Category Total Value
                        VStack(alignment: .leading, spacing: 12) {
                            Text(selectedType == .all ? "Net Worth" : "Total Value")
                                .font(.system(size: 22, weight: .medium))
                            HStack(alignment: .firstTextBaseline, spacing: 12) {
                                Text("$\(totalValue, specifier: "%.0f")")
                                    .font(.system(size: 20, weight: .medium))
                                
                                if totalPercentageChange != 0 {
                                    Text("\(totalPercentageChange >= 0 ? "+" : "")\(totalPercentageChange, specifier: "%.2f")%")
                                        .font(.title3)
                                        .foregroundColor(totalPercentageChange >= 0 ? .green : .red)
                                }
                            }
                        }
                        
                        // Graph for All category
                        if selectedType == .all {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last 6 Months")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                LineGraphView(
                                    dataPoints: graphData,
                                    minY: graphData.map(\.value).min() ?? 0,
                                    maxY: graphData.map(\.value).max() ?? 0
                                )
                                .frame(height: 250)
                                .padding(.horizontal, 8)
                            }
                            .padding(.vertical, 8)
                        }

                        Divider()

                        // List Items
                        if selectedType == .all {
                            // Show categorized list
                            VStack(spacing: 20) {
                                ForEach(cards.filter { $0.type != .all }, id: \.id) { category in
                                    if let items = categorizedItems[category.type], !items.isEmpty {
                                        HStack(spacing: 16) {
                                            Image(category.icon)
                                                .resizable()
                                                .renderingMode(.template)
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.primary)
                                                .frame(width: 38, height: 38)
                                                .background(Color(white: 0.95))
                                                .clipShape(Circle())

                                            Text(category.title)
                                                .font(.body)

                                            Spacer()

                                            Text("$\(categoryTotal(for: category.type), specifier: "%.0f")")
                                                .font(.body)
                                                .fontWeight(.medium)
                                        }
                                    }
                                }
                            }
                        } else if selectedType == .savings {
                            // Show savings goals grid
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(savingsGoals) { goal in
                                    SavingsGoalCard(goal: goal)
                                }
                                
                                // Add savings goal button
                                Button(action: {}) {
                                    VStack(spacing: 16) {
                                        Text("Add savings goal")
                                            .font(.system(size: 16))
                                            .fontWeight(.medium)
                                        Image(systemName: "plus.circle")
                                            .font(.title)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 120)
                                    .background(Color(white: 0.97))
                                    .cornerRadius(16)
                                }
                                .foregroundColor(.primary)
                            }
                        } else {
                            // Show individual items for selected category
                            VStack(spacing: 20) {
                                ForEach(filteredItems) { item in
                                    HStack(spacing: 16) {
                                        Image(item.icon)
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.primary)
                                            .frame(width: 38, height: 38)
                                            .background(Color(white: 0.95))
                                            .clipShape(Circle())

                                        Text(item.title)
                                            .font(.body)

                                        Spacer()

                                        // Value and percentage on same line
                                        HStack(spacing: 8) {
                                            Text("$\(item.amount, specifier: "%.0f")")
                                                .font(.body)
                                                .fontWeight(.medium)
                                            
                                            if item.percentageChange != 0 {
                                                Text("\(item.percentageChange >= 0 ? "+" : "")\(item.percentageChange, specifier: "%.2f")%")
                                                    .font(.subheadline)
                                                    .foregroundColor(item.percentageChange >= 0 ? .green : .red)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    EmptyView()
                }
            }
        }
    }
}

// Reusable Card View
struct PortfolioCardView: View {
    let card: PortfolioView.PortfolioCard
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(card.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.primary)
            Text(card.title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 100, height: 80, alignment: .leading)
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: isSelected ? 2 : 0)
        )
    }
}

struct SavingsGoalCard: View {
    let goal: SavingsGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(goal.title)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .padding(.top, 12)
                .padding(.bottom, 16)
            
            if goal.title != "All Savings" {
                // Amount and target on the same line
                HStack {
                    Text("$\(goal.currentAmount, specifier: "%.0f")")
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                    
                    Text("/ $\(goal.targetAmount, specifier: "%.0f")")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 16)
                
                // Progress bar
                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: (geometry.size.width) * CGFloat(goal.currentAmount / goal.targetAmount), height: 4)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                }
                .frame(height: 4)
                .background(Color(white: 0.9))
                .padding(.bottom, 12)
            } else {
                HStack {
                    Text("$\(goal.currentAmount, specifier: "%.0f")")
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                    
                    Spacer()
                }
                .padding(.bottom, 32)  // Increased to align with other cards' bottom content
            }
        }
        .padding(.horizontal)
        .frame(height: 130)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(white: 0.97))
        .cornerRadius(10)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
} 