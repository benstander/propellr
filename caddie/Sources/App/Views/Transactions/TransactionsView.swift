import SwiftUI

struct TransactionsView: View {
    // Sample Data
    struct CategoryCard: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
    }
    
    struct Transaction: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let date: String
        let amount: Double
        let isIncome: Bool
    }
    
    let categories: [CategoryCard] = [
        CategoryCard(icon: "shopping", title: "Shopping"),
        CategoryCard(icon: "essentials", title: "Essentials"),
        CategoryCard(icon: "entertainment", title: "Entertainment"),
        CategoryCard(icon: "income", title: "Income")
    ]
    
    let transactions: [(String, [Transaction])] = [
        ("This Month", [
            Transaction(icon: "entertainment", title: "The Vicar Hotel", date: "Tue 8th April", amount: 20, isIncome: false),
            Transaction(icon: "income", title: "Soccajoeys Castle Hill", date: "Mon 2nd April", amount: 240, isIncome: true)
        ]),
        ("March", [
            Transaction(icon: "entertainment", title: "The Vicar Hotel", date: "Tue 8th April", amount: 20, isIncome: false),
            Transaction(icon: "income", title: "Soccajoeys Castle Hill", date: "Mon 2nd April", amount: 240, isIncome: true),
            Transaction(icon: "entertainment", title: "The Vicar Hotel", date: "Tue 8th April", amount: 20, isIncome: false),
            Transaction(icon: "income", title: "Soccajoeys Castle Hill", date: "Mon 2nd April", amount: 240, isIncome: true)
        ]),
        ("February", [
            Transaction(icon: "entertainment", title: "The Vicar Hotel", date: "Tue 8th April", amount: 20, isIncome: false),
            Transaction(icon: "income", title: "Soccajoeys Castle Hill", date: "Mon 2nd April", amount: 240, isIncome: true)
        ])
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Fixed Header and Categories
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack {
                        Text("Transactions")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories) { category in
                                CategoryCardView(category: category)
                            }
                        }
                    }
                    .padding(.bottom, 6)
                }
                .padding()
                .background(Color.white)
                
                // Scrollable Transactions List
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(transactions, id: \.0) { month, monthTransactions in
                            VStack(alignment: .leading, spacing: 24) {
                                Text(month)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                                VStack(spacing: 24) {
                                    ForEach(monthTransactions) { transaction in
                                        TransactionRowView(transaction: transaction)
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

struct CategoryCardView: View {
    let category: TransactionsView.CategoryCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(category.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.primary)
            Text(category.title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 100, height: 80, alignment: .leading)
        .background(Color(white: 0.95))
        .cornerRadius(10)
    }
}

struct TransactionRowView: View {
    let transaction: TransactionsView.Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            Image(transaction.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.primary)
                .frame(width: 38, height: 38)
                .background(Color(white: 0.95))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.body)
                Text(transaction.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(transaction.isIncome ? "+$\(transaction.amount, specifier: "%.2f")" : "-$\(transaction.amount, specifier: "%.2f")")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
} 