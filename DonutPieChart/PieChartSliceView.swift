//
//  PieChartSliceView.swift
//  DonutPieChart
//
//  Created by Oleksandr Potryvaiev on 13/02/2023.
//

import SwiftUI

struct PieChartSliceView: View {

    // MARK: - Properties

    var pieSliceData: PieSliceData

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width

                let center = CGPoint(x: width * 0.5, y: height * 0.5)

                path.move(to: center)

                /// This code creates a "triangle" slice without any corner radiuses
                /// It should be replaced by the "donut" slice code you'd create with addCurve, addLine and addArc
                path.addArc(
                    center: center,
                    radius: width * 0.5,
                    startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                    endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                    clockwise: false)
            }
            /// each slice should have a stroke and that stroke should have the same rounded corners as the slice
            .stroke(Color.black, lineWidth: 2)
            /// This is identical to the code above. I'm using the same Path twice,
            /// as that's one of the ways to have both stroke and fill on the slice
            .background(Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width

                let center = CGPoint(x: width * 0.5, y: height * 0.5)

                path.move(to: center)

                path.addArc(
                    center: center,
                    radius: width * 0.5,
                    startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                    endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                    clockwise: false)
            }
                .fill(pieSliceData.color)
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
}


struct PieChartSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartSliceView(pieSliceData: PieSliceData(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 120), color: Color.red))
    }
}
