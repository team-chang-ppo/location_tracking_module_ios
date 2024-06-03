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
    let apiKey: Int
}

struct ApiHourlyUsage: Identifiable {
    let id = UUID()
    let hour: Int
    let count: Int
    let apiKey: Int
}

struct ChartView: View {
    @ObservedObject var viewModel: ChargeViewModel
    var apiKeyId: Int?
    
    @State private var chartSelection: Date?
    @State private var apiKeyColors: [Int: Color] = [:]
    
    init(viewModel: ChargeViewModel, apiKeyId: Int? = nil) {
        self.viewModel = viewModel
        self.apiKeyId = apiKeyId
        self.viewModel.fetchCharges(apiKeyId: apiKeyId)
    }
    
    var currentMonthCharges: [ApiCharge] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        return viewModel.apiCharges.filter { charge in
            let month = calendar.component(.month, from: charge.date)
            let year = calendar.component(.year, from: charge.date)
            return month == currentMonth && year == currentYear
        }
    }
    
    var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: Date())
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
        return viewModel.apiCharges.filter { charge in
            calendar.isDate(charge.date, equalTo: month, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
    }
    
    private func currentDayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    static func generateApiKeyColors(apiCharge: [ApiCharge]) -> [Int: Color] {
        var colorsMap: [Int: Color] = [:]
        let distinctApiKeys = Set(apiCharge.map { $0.apiKey })
        
        let colors: [Color] = [Color(.systemBlue), Color(.systemGreen), Color(.systemOrange), Color(.systemPurple)]
        
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
            let totalCost = viewModel.apiCharges.filter { charge in
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. M. d"
        let startDateString = dateFormatter.string(from: startOfMonth)
        let endDateString = dateFormatter.string(from: currentDate)
        
        return "\(startDateString) ~ \(endDateString)"
    }
    
    private var currentYearAndMonth: (String, String) {
        let currentDate = Date()
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter1.dateFormat = "M"
        dateFormatter2.dateFormat = "yyyy"
        return (dateFormatter1.string(from: currentDate), dateFormatter2.string(from: currentDate))
    }
    
    
    
    private var todayTotalCount: Int {
        return viewModel.apiHourlyUsage.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("데이터를 가져오는 중입니다...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let apiResponse = viewModel.apiResponse {
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
                            if currentMonthCharges.isEmpty {
                                Text("이번달은 사용한 기록이 없어요 !")
                                    .font(.title)
                                    .bold()
                                    .frame(height: 100)
                            } else {
                                barChart
                                legend
                            }
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
                                    .foregroundColor(result.increase >= 0 ? .blue : .red)
                                Text("(\(result.percentage, specifier: "%.2f")%)")
                                    .bold()
                                    .foregroundColor(result.increase >= 0 ? .blue : .red)
                            }
                            Spacer().frame(height: 30)
                            if totalCostsForLastThreeMonths.isEmpty {
                                Text("이번달은 사용한 기록이 없어요 !")
                                    .font(.title)
                                    .bold()
                                    .frame(height: 100)
                            } else {
                                lineChart
                            }
                        }
                    }
                    Section() {
                        VStack(alignment: .leading, spacing: 5){
                            Text("\(currentDateString) API 호출 횟수")
                                .font(.headline)
                                .bold()
                            Text("\(todayTotalCount)회")
                                .font(.title)
                                .bold()
                            Spacer().frame(height: 30)
                            if viewModel.apiHourlyUsage.isEmpty {
                                Text("이번달은 사용한 기록이 없어요 !")
                                    .font(.title)
                                    .bold()
                                    .frame(height: 100)
                            } else {
                                scatterChart
                            }
                        }
                    }
                }.scrollIndicators(.hidden)
            } else {
                Text("데이터를 가져오는 중 오류가 발생했습니다.")
            }
        }
        .onReceive(viewModel.$apiCharges) { newCharges in
            self.apiKeyColors = ChartView.generateApiKeyColors(apiCharge: newCharges)
        }
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
    var ListHeader3: some View {
        HStack(alignment: .center) {
            Text("하루 동안 API 호출 횟수")
                .font(.title2)
                .bold()
                .foregroundStyle(Color(.label))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ChartView {
    var barChart: some View {
        Chart {
            ForEach(currentMonthCharges) { charge in
                let apiKey = charge.apiKey
                let barColor = apiKeyColors[apiKey] ?? .blue
                BarMark(
                    x: .value("Day", charge.date, unit: .day),
                    y: .value("Amount", charge.amount),
                    width: .fixed(12)
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
                        position: .top, spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled)
                    ) {
                        if let totalAmount = totalAmountOnDate(date: chartSelection) {
                            let date = currentDayString(date: chartSelection)
                            Text("\(date)\n\(totalAmount)원").bold()
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .bold()
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                    }
            }
        }
        .frame(height: currentMonthCharges.isEmpty ? 100 : 300)
        .chartXVisibleDomain(length: Double(3600 * 24 * 31))
        .chartYAxis {
            AxisMarks {
                AxisValueLabel()
            }
        }
        .chartXSelection(value: $chartSelection)
        .padding()
    }
    
    private func totalAmountOnDate(date: Date) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedInputDate = dateFormatter.string(from: date)
        let dayAmount = viewModel.apiCharges.filter { charge in
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
                    Text("API Key #00\(apiKey)")
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
                let currentMonth = Calendar.current.component(.month, from: Date())
                let barColor: Color = Calendar.current.component(.month, from: monthlyTotal.month) == currentMonth ? Color(.systemBlue) : Color(.systemGray)
                BarMark(
                    x: .value("Month", monthlyTotal.month, unit: .month),
                    y: .value("Total Cost", monthlyTotal.totalCost)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 5))
                .cornerRadius(5, style: .circular)
                .foregroundStyle(barColor)
                .annotation(position: .top, spacing: 10) {
                    Text("\(monthlyTotal.totalCost)원")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(5)
                        .background(barColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .frame(height: totalCostsForLastThreeMonths.isEmpty ? 100 : 300)
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
    
    private var scatterChart: some View {
        Chart {
            ForEach(viewModel.apiHourlyUsage) { usage in
                let apiKey = usage.apiKey
                let pointColor = apiKeyColors[apiKey] ?? .blue
                PointMark(
                    x: .value("Hour", usage.hour),
                    y: .value("Count", usage.count)
                )
                .foregroundStyle(pointColor)
                .annotation(position: .top, spacing: 10) {
                    let components = DateComponents(hour: usage.hour)
                    let date = Calendar.current.date(from: components)!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let hourString = dateFormatter.string(from: date)
                    
                    return Text("\(hourString)\n\(usage.count)회")
                        .font(.caption)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(pointColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .frame(height: viewModel.apiHourlyUsage.isEmpty ? 100 : 300)
        .chartYAxis {
            AxisMarks {
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(values: [0, 6, 12, 18, 24]) { hour in
                AxisValueLabel()
            }
        }
        .padding()
    }
}

#Preview {
    ChartView(viewModel: ChargeViewModel())
}
