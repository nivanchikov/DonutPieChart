//
//  PieChartView.swift
//  DonutPieChart
//
//  Created by Oleksandr Potryvaiev on 13/02/2023.
//

import SwiftUI

struct PieChartView: View {

    // MARK: - Properties

    /// FYI: there will be no more than 8 pie slices, but the sizes of slices could be dynamic
    @State private var amounts: [Double] = []
    let colors = [Color.red, Color.blue, Color.yellow, Color.mint, Color.gray, Color.purple, Color.pink, Color.green]
    @State private var slices: [PieSliceData] = []

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(0 ..< slices.count, id: \.self) { index in
                        PieChartSliceView(pieSliceData: slices[index])
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width)

                    /// this circle is just a hack to create a donut pie chart effect
                    Circle()
                        .fill(Color.black)
                    /// In this hack, this ensures that the difference between outer
                    /// and inner chart radius would always be 84 px.
                        .frame(width: geometry.size.width - 168, height: geometry.size.width  - 168)
                    }
            }
            .onAppear() {
                generateRandomSlices()
            }
        }
        .padding(24)
        .background(.black)
    }

    // MARK: - Private methods

    private func generateRandomSlices() {
        /// we generate a random number of slices each time to test for different edge cases.
        /// for simplicity, we're only doing between 2 and 8
        let numberOfSlices = Int.random(in: 2..<9)
        /// we are generating an array of random amounts to mimic how real data would be dynamic
        for _ in 1 ... numberOfSlices {
            amounts.append(Double.random(in: 1..<100))
        }
        /// then we calculate start and end angles for drawing each slice,
        /// depending on the  amount each slice should represent
        var totalAmount: Double = 0.0
        var endDegree: Double = 0.0
        var tempSlices: [PieSliceData] = []
        for amount in amounts {
            totalAmount += Double(amount)
        }
        for (index, amount) in amounts.enumerated() {
            let degrees: Double = Double(amount) * 360 / totalAmount
            tempSlices.append(PieSliceData(
                startAngle: Angle(degrees: endDegree),
                /// FYI: always assigning the endAngle to 359 for the last slice ensures that
                /// the gap between it and the first one is the same as between the rest of the slices.
                endAngle: Angle(degrees: index == amounts.count - 1 ? 359.5 : endDegree + degrees),
                color: colors[index]))

            endDegree += degrees
        }

        slices = tempSlices
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView()
    }
}
