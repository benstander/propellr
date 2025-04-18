import SwiftUI

struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let value: Double
    let percentageChange: Double
    let logoName: String
}

struct StocksView: View {
    let stocks: [Stock] = [
        Stock(symbol: "VOO", name: "Vanguard S&P 500", value: 1246, percentageChange: 0.08, logoName: "voo-logo"),
        Stock(symbol: "VAS", name: "Vanguard Australian Shares", value: 1034, percentageChange: 0.08, logoName: "vas-logo"),
        Stock(symbol: "TSLA", name: "Tesla", value: 903, percentageChange: -2.34, logoName: "tesla-logo")
    ]
    
    let totalValue: Double = 2268
    let totalPercentageChange: Double = 0.83
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Total Value Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Value")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("$\(totalValue, specifier: "%.0f")")
                            .font(.system(size: 34, weight: .medium))
                        
                        Text("+\(totalPercentageChange, specifier: "%.2f")%")
                            .font(.title3)
                            .foregroundColor(.green)
                    }
                }
                
                // Stocks List
                VStack(spacing: 24) {
                    ForEach(stocks) { stock in
                        HStack(spacing: 16) {
                            // Stock Logo
                            Image(stock.logoName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                            
                            // Stock Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stock.symbol)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            // Value and Change
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("$\(stock.value, specifier: "%.0f")")
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                Text("\(stock.percentageChange >= 0 ? "+" : "")\(stock.percentageChange, specifier: "%.2f")%")
                                    .font(.subheadline)
                                    .foregroundColor(stock.percentageChange >= 0 ? .green : .red)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Stocks")
    }
}

struct StocksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StocksView()
        }
    }
} 