import SwiftUI
import Charts

struct MonthlyTotal: Identifiable {
    let id = UUID()
    let month: Date
    let totalCost: Int
}

struct ApiCharge: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Int
    let apiKey: String
}

struct ChartView: View {
    var apiResponse: ApiResponse
    var apiCharge: [ApiCharge] = []
    var currentMonthCharges: [ApiCharge] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        return apiCharge.filter { charge in
            let month = calendar.component(.month, from: charge.date)
            let year = calendar.component(.year, from: charge.date)
            return month == currentMonth && year == currentYear
        }
    }
    
    @State private var chartSelection: Date?
    @State private var apiKeyColors: [String: Color] = [:]
    
    
    init(apiResponse: ApiResponse) {
        self.apiResponse = apiResponse
        self.apiCharge = apiResponse.apiKeys.flatMap { apiKey in
            apiKey.charges.compactMap { charge -> ApiCharge? in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let date = dateFormatter.date(from: charge.date) else { return nil }
                return ApiCharge(date: date, amount: charge.amount, apiKey: apiKey.apiKey)
            }
        }
        _apiKeyColors = State(initialValue: ChartView.generateApiKeyColors(apiCharge: self.apiCharge))
    }

    private var currentAndPreviousMonthTotal: (current: Int, previous: Int, increase: Double, percentage: Double) {
        let calendar = Calendar.current
        let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
        
        let currentMonthTotal = totalCostForMonth(month: currentMonth)
        let previousMonthTotal = totalCostForMonth(month: previousMonth)
        
        let increase = Double(currentMonthTotal - previousMonthTotal)
        let percentage = previousMonthTotal > 0 ? (increase / Double(previousMonthTotal)) * 100 : 0.0
        
        return (currentMonthTotal, previousMonthTotal, increase, percentage)
    }
    
    private func totalCostForMonth(month: Date) -> Int {
        let calendar = Calendar.current
        return apiCharge.filter { charge in
            calendar.isDate(charge.date, equalTo: month, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
    }
    
    
    static func generateApiKeyColors(apiCharge: [ApiCharge]) -> [String: Color] {
        var colorsMap: [String: Color] = [:]
        let distinctApiKeys = Set(apiCharge.map { $0.apiKey })
        
        let colors: [Color] = [Color(.LightBlue200), Color(.LightBlue400),Color(.LightBlue600), Color(.LightBlue800),]
        
        for (index, apiKey) in distinctApiKeys.enumerated() {
            let color = colors[index % colors.count]
            colorsMap[apiKey] = color
        }
        return colorsMap
    }
    
    var totalCostsForLastThreeMonths: [MonthlyTotal] {
        let calendar = Calendar.current
        let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        
        return (-2...0).map { offset -> MonthlyTotal in
            let month = calendar.date(byAdding: .month, value: offset, to: currentMonth)!
            let totalCost = apiCharge.filter { charge in
                let chargeMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: charge.date))!
                return chargeMonth == month
            }.reduce(0) { $0 + $1.amount }
            
            return MonthlyTotal(month: month, totalCost: totalCost)
        }
    }
    
    private var currentMonthDateRange: String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let startOfMonth = calendar.date(from: components)!
        let comps2 = DateComponents(month: 1, day: -1)
        let endOfMonth = calendar.date(byAdding: comps2, to: startOfMonth)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. M. d"
        let startDateString = dateFormatter.string(from: startOfMonth)
        let endDateString = dateFormatter.string(from: endOfMonth)
        
        return "\(startDateString) ~ \(endDateString)"
    }
    
    private var currentYearAndMonth : (String,String) {
        let currentDate = Date()
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter1.dateFormat = "M"
        dateFormatter2.dateFormat = "yyyy"
        return (dateFormatter1.string(from: currentDate),dateFormatter2.string(from:currentDate))
    }
    
    var body: some View {
        List {
            Section(header: ListHeader1) {
                VStack(alignment: .leading, spacing: 5){
                    Text("\(currentYearAndMonth.0)월 청구요금")
                        .bold()
                    let currentPrice = currentAndPreviousMonthTotal
                    Text("\(currentPrice.current)원")
                        .font(.title)
                        .bold()
                    Text(currentMonthDateRange)
                        .font(.system(size: 16, weight: .regular, design: .default))
                }
                VStack(alignment: .leading){
                    Text("\(currentYearAndMonth.1)년 \(currentYearAndMonth.0)월 요금")
                        .font(.headline)
                    Spacer().frame(height: 30)
                    barChart
                    legend
                }
            }
            Section(header: ListHeader2) {
                VStack(alignment: .leading, spacing: 5){
                    Text("이전 달 대비 증가액")
                        .font(.headline)
                        .bold()
                    HStack{
                        let result = currentAndPreviousMonthTotal
                        Text("\(result.increase, specifier: "%.0f")원")
                            .font(.title)
                            .bold()
                            .foregroundColor(result.increase >= 0 ? .red : .blue)
                        Text("(\(result.percentage, specifier: "%.2f")%)")
                            .bold()
                            .foregroundColor(result.increase >= 0 ? .red : .blue)
                        
                    }
                    Spacer().frame(height: 30)
                    lineChart
                }
            }
        }.scrollIndicators(.hidden)
    }
    
    
}

private extension ChartView {
    var ListHeader1: some View {
        HStack(alignment: .center) {
            Text("이번 달 요금 세부사항")
                .font(.title2)
                .bold()
                .foregroundStyle(Color(.label))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var ListHeader2: some View {
        HStack(alignment: .center) {
            Text("요금 분석")
                .font(.title2)
                .bold()
                .foregroundStyle(Color(.label))
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ChartView {
    
    var barChart: some View {
        
        return Chart {
            ForEach(currentMonthCharges) { charge in
                let apiKey = charge.apiKey
                let barColor = apiKeyColors[apiKey] ?? .blue
                BarMark(
                    x: .value("Day", charge.date, unit: .day),
                    y: .value("Amount", charge.amount)
                )
                .foregroundStyle(barColor) // API 키별 색상 적용
                .cornerRadius(12)
            }
            if let chartSelection {
                RuleMark(x: .value("selected", chartSelection, unit: .day))
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .offset(yStart: -10)
                    .zIndex(-1)
                    .annotation(
                        position: .top , spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled)
                    ) {
                        if let totalAmount = totalAmountOnDate(date: chartSelection) {
                            
                            Text("\(totalAmount)원").bold()
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                    }
            }
        }
        .frame(height: 300)
        .chartXVisibleDomain(length: Double(3600 * 24 * 31))
        .chartYAxis {
            AxisMarks {
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.month().year(), centered: true)
            }
        }
        .chartXSelection(value: $chartSelection)
        .padding()
    }
    
    private func totalAmountOnDate(date: Date) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedInputDate = dateFormatter.string(from: date)
        let dayAmount = apiCharge.filter { charge in
            let chargeDateFormatted = dateFormatter.string(from: charge.date)
            return chargeDateFormatted == formattedInputDate
        }.reduce(0) { $0 + $1.amount }
        return dayAmount
    }
    
    private var legend: some View {
        VStack(alignment: .leading) {
            ForEach(apiKeyColors.keys.sorted(), id: \.self) { apiKey in
                HStack {
                    Circle()
                        .fill(apiKeyColors[apiKey] ?? .black)
                        .frame(width: 10, height: 10)
                    Text(apiKey)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
        .padding(.top, 5)
    }
    
    private var lineChart: some View {
        Chart {
            ForEach(totalCostsForLastThreeMonths) { monthlyTotal in
                BarMark(
                    x: .value("Month", monthlyTotal.month, unit: .month),
                    y: .value("Total Cost", monthlyTotal.totalCost)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 5))
                .foregroundStyle(Color.blue)
                .annotation(position: .top, spacing: 10) {
                    Text("\(monthlyTotal.totalCost)원")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .frame(height: 300)
        .chartYAxis {
            AxisMarks(preset: .extended, position: .trailing) {
                AxisGridLine(centered: true)
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month, count: 1)) {
                AxisValueLabel(format: .dateTime.month(), centered: true)
            }
        }
        .padding(.horizontal)
    }
    
    
}

#Preview {
    ChartView(apiResponse: ApiResponse.generateDummyData())
}
