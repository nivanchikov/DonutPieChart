import SwiftUI
import Foundation

struct PieChartSliceShape: Shape {
	private let pieSliceData: PieSliceData
	private let innerRadiusOffset: CGFloat
	private let cornerRadius: CGFloat

	init(pieSliceData: PieSliceData,
		 innerRadiusOffset: CGFloat = 84.0,
		 cornerRadius: CGFloat = 4.0) {
		self.pieSliceData = pieSliceData
		self.innerRadiusOffset = innerRadiusOffset
		self.cornerRadius = cornerRadius
	}

	func path(in rect: CGRect) -> Path {
		var path = Path()

		var cornerRadius = cornerRadius

		let outerRadius = min(rect.width, rect.height) / 2.0
		let innerRadius = outerRadius - innerRadiusOffset
		let center = CGPoint(x: rect.midX, y: rect.midY)

		var angleDiff = pieSliceData.endAngle.radians - pieSliceData.startAngle.radians

		if angleDiff < 0 {
			angleDiff = 2 * .pi - angleDiff
		}

		let innerArcLength = angleDiff * innerRadius

		var outerAngleBeta = calculateAngleBeta(cornerRadius: cornerRadius, radius: outerRadius)
		var innerAngleBeta = calculateAngleBeta(cornerRadius: cornerRadius, radius: innerRadius)

		// try adjusting the corner radius if it's bigger than the inner arc length of the pie slice.
		// There might be a smarter way, but at least this insures the corner centers won't overlap if the pie slice is too small
		while cornerRadius * 3.0 > innerArcLength {
			cornerRadius = cornerRadius / 1.2

			outerAngleBeta = calculateAngleBeta(cornerRadius: cornerRadius, radius: outerRadius)

			innerAngleBeta = calculateAngleBeta(cornerRadius: cornerRadius, radius: innerRadius)
		}

		// top arc
		path.addArc(
			center: center,
			radius: outerRadius,
			startAngle: pieSliceData.startAngle + outerAngleBeta,
			endAngle: pieSliceData.endAngle - outerAngleBeta,
			clockwise: false
		)

		// center of the top right rounded corner
		let rTopCenter = pointOnCircle(
			center: center,
			radius: outerRadius,
			at: pieSliceData.endAngle
		)

		// top right corner point for doughnut side
		let rTopLinePoint = pointOnCircle(
			center: center,
			radius: outerRadius - cornerRadius,
			at: pieSliceData.endAngle
		)

		// add arc for the top right corner
		path.addQuadCurve(to: rTopLinePoint, control: rTopCenter)

		// bottom right corner point for doughnut side
		let rBottomLinePoint = pointOnCircle(
			center: center,
			radius: innerRadius + cornerRadius,
			at: pieSliceData.endAngle
		)

		path.addLine(to: rBottomLinePoint)

		// center of the bottom right rounded corner arc
		let rBottomCenter = pointOnCircle(
			center: center,
			radius: innerRadius,
			at: pieSliceData.endAngle
		)

		let bottomArcStart = pointOnCircle(
			center: center,
			radius: innerRadius,
			at: pieSliceData.endAngle - innerAngleBeta)

		path.addQuadCurve(to: bottomArcStart, control: rBottomCenter)

		// add arc for the inner radius
		path.addArc(
			center: center,
			radius: innerRadius,
			startAngle: pieSliceData.endAngle - innerAngleBeta,
			endAngle: pieSliceData.startAngle + innerAngleBeta,
			clockwise: true
		)

		// center of the bottom left rounded corner arc
		let lBottomCenter = pointOnCircle(
			center: center,
			radius: innerRadius,
			at: pieSliceData.startAngle
		)

		// bottom left corner point for doughnut side
		let lBottomLinePoint = pointOnCircle(
			center: center,
			radius: innerRadius + cornerRadius,
			at: pieSliceData.startAngle
		)

		path.addQuadCurve(to: lBottomLinePoint, control: lBottomCenter)

		// top left corner point for doughnut side
		let lTopLinePoint = pointOnCircle(
			center: center,
			radius: outerRadius - cornerRadius,
			at: pieSliceData.startAngle
		)

		path.addLine(to: lTopLinePoint)

		// center of the top left rounded corner arc
		let lTopCenter = pointOnCircle(
			center: center,
			radius: outerRadius,
			at: pieSliceData.startAngle
		)

		let topArcStart = pointOnCircle(
			center: center,
			radius: outerRadius,
			at: pieSliceData.startAngle + outerAngleBeta)

		path.addQuadCurve(to: topArcStart, control: lTopCenter)

		path.closeSubpath()

		return path
	}

	private func calculateAngleBeta(cornerRadius: Double, radius: Double) -> Angle {
		let cosAlpha = cornerRadius / (2.0 * radius)
		let beta = Angle(radians: Double.pi - acos(cosAlpha) * 2)
		return beta
	}

	private func pointOnCircle(center: CGPoint, radius: Double, at angle: Angle) -> CGPoint {
		CGPoint(
			x: center.x + radius * cos(angle.radians),
			y: center.y + radius * sin(angle.radians)
		)
	}
}

struct PieChartSliceShape_Previews: PreviewProvider {
	static var previews: some View {
		PieChartSliceShape(pieSliceData: .init(
			startAngle: .radians(.pi * 1.25),
			endAngle: .radians(.pi * 1.6),
			color: .red)
		)
		.stroke(lineWidth: 0.5)
		.padding()
	}
}
