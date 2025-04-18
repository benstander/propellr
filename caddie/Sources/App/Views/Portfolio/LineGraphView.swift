import SwiftUI

struct DataPoint: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct LineGraphView: View {
    let dataPoints: [DataPoint]
    let minY: Double
    let maxY: Double
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                // Graph container
                ZStack {
                    // X-axis only
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height - 32))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - 32))
                    }
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    
                    // Graph line
                    Path { path in
                        for (index, point) in dataPoints.enumerated() {
                            let xPosition = (CGFloat(index) / CGFloat(dataPoints.count - 1)) * geometry.size.width
                            let yPosition = (1 - CGFloat((point.value - minY) / (maxY - minY))) * (geometry.size.height - 32)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: xPosition, y: yPosition))
                            } else {
                                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                            }
                        }
                    }
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                }
                
                // Month labels
                HStack(spacing: 0) {
                    ForEach(dataPoints) { point in
                        Text(monthFormatter.string(from: point.date))
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 20)
            }
        }
    }
} 