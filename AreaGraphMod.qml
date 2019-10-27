import QtQuick 2.1

import BasicUIControls 1.0;

/**
 * Component extending AreaGraphControl with other features such as X legend representing 24 hours, Y legend values, horizontal guiding lines, warning icon when there are missing (NaN) values.
 * Y legend values starts at @maxValue and drops to 0 by fixed delta (dependant on @yLegendItemCount).
 * X legend values represents hours from 0:00 till 24:00 with visible only each 2nd hour.
 */
Item {
	id: root

	/// xLegend left margin - right side of the 0 hour (0 hour minutes "00" are anchored left here)
	property int xLegendLeftMargin: isNxt ? 30 : 24
	/// distance from xLegend hour text right till next hour text right
	property int xLegendItemWidth: isNxt ? 73 : 58
	property color xLegendTextColor: colors.graphXLegendText
	property int xLegendTextSize: isNxt ? 15 : 12
	/// baseline offset from xLegend top
	property int xLegendTextBaselineOffset: isNxt ? 30 : 24
	/// yLegend text right margin
	property int yLegendRightMargin: isNxt ? 12 : 10
	/// yLegend text bttom margin from horizontal guiding lines
	property int yLegendBottomMargin: 0
	/// horizontal guiding lines left margin from component left
	property int yLinesLeftMargin: isNxt ? 17 : 13
	/// horizontal guiding lines right margin from component right
	property int yLinesRightMargin: 5
	/// yLegend item height - horizontal guiding lines gap
	property int yLegendItemHeight: isNxt ? 50 : 40
	/// number of yLegend texts and lines, including zero and with @maxValue as top value
	property int yLegendItemCount: 8
	property color yLegendTextColor: colors.graphYLegendText
	property int yLegendTextSize: isNxt ? 18 : 15
	property color yLinesColor: colors.graphHorizontalLine
	/// default graph color
	property alias graphColor: graph.color
	property alias graph2Color: graph2.color
	property alias graph3Color: graph3.color
	/// values for graph Y positions scaled by the ratio of @maxValue and the graph area height (without xLegend), effectivly yLegend height
	property alias graphValues: graph.values
	property alias graph2Values: graph2.values
	property alias graph3Values: graph3.values
	/// maximum value for yLegend texts and also used to scale graph Y positions by the graph height
	property real maxValue: 250
	property alias graphVisible: graph.visible
	property alias graph2Visible: graph2.visible
	property alias graph3Visible: graph3.visible

	property bool dstStart: false
	property bool dstEnd: false
	property int dstHourChange: 0

	property string kpiPostfix: "areaGraph"

	QtObject {
		id: p

		property int xLegendItemWidthDstStart: Math.floor(xLegendItemWidth * 12 / 11.5)
		property int xLegendItemWidthDstEnd: Math.floor(xLegendItemWidth * 12 / 12.5)
	}

	/// vertical Repeater representing yLegend containing texts for values and horizontal guiding lines. The text values going from @maxValue as top down to 0 with
	/// delta deducted from @yLegendItemCount and @maxValue. Each item has the same width as the root component (displaying the horizontal guiding lines).
	Column {
		id: yLegendColumn
		Repeater {
			id: yLegendRepeater
			model: yLegendItemCount
			Item {
				id: yLegendItem
				width: root.width
				height: yLegendItemHeight
				Rectangle {
					id: yLine
					height: 1
					width: root.width - yLinesLeftMargin - yLinesRightMargin
					anchors.bottom: parent.bottom
					anchors.left: parent.left
					anchors.leftMargin: yLinesLeftMargin
					color: yLinesColor
				}
				Rectangle {
					id: yLine2
					height: 1
					width: isNxt ? root.width - yLinesLeftMargin - yLinesRightMargin - 50 : root.width - yLinesLeftMargin - yLinesRightMargin - 40
					anchors.top: yLegendItem.top
					anchors.topMargin : isNxt ? 12 : 9
					anchors.left: parent.left
					anchors.leftMargin: yLinesLeftMargin
					color: "#dbe5f2"
				}
				Rectangle {
					id: yLine3
					height: 1
					width: isNxt ? root.width - yLinesLeftMargin - yLinesRightMargin - 50 : root.width - yLinesLeftMargin - yLinesRightMargin - 40
					anchors.top: yLegendItem.top
					anchors.topMargin : isNxt ? 25 : 19
					anchors.left: parent.left
					anchors.leftMargin: yLinesLeftMargin
					color: yLinesColor
				}
				Rectangle {
					id: yLine4
					height: 1
					width: isNxt ? root.width - yLinesLeftMargin - yLinesRightMargin - 50 : root.width - yLinesLeftMargin - yLinesRightMargin - 40
					anchors.top: yLegendItem.top
					anchors.topMargin : isNxt ? 37 : 29
					anchors.left: parent.left
					anchors.leftMargin: yLinesLeftMargin
					color: "#dbe5f2"
				}

				Text {
					anchors {
						right: parent.right
						rightMargin: yLegendRightMargin
						bottom: yLine.top
						bottomMargin: yLegendBottomMargin
					}
					font {
						pixelSize: yLegendTextSize
						family: qfont.regular.name
					}
					color: yLegendTextColor
					// text starting with @maxValue and decreased with each index by yDelta (max/(count-1))
					text: (app.tempOffset * -1) + ((maxValue - 2) / (yLegendItemCount - 1)) * (yLegendRepeater.count - index - 1)
				}
			}
		}
	}

	/// Horizontal Repeater representing xLegend containing texts for hours 0:00 till 24:00 with evry 2nd hour shown.
	/// Each Repeater item contains only minutes text "00" on the left and next hour text (e.g. "4") on the right. The zero hour
	/// text "0" and the 24 hour minutes "00" are added separately.
	Row {
		id: xLegendRow
		anchors.top: yLegendColumn.bottom
		anchors.left: parent.left
		anchors.leftMargin: xLegendLeftMargin

		Repeater {
			id: xLegendRepeater
			model: 12
			Item {
				height: root.height - yLegendColumn.height
				width: {
					if (dstStart) {
						index === Math.floor(dstHourChange / 2) ? p.xLegendItemWidthDstStart * 0.5 : p.xLegendItemWidthDstStart;
					} else if (dstEnd) {
						index === Math.floor(dstHourChange / 2) ? p.xLegendItemWidthDstEnd * 1.5 : p.xLegendItemWidthDstEnd;
					} else {
						xLegendItemWidth;
					}
				}

				Text {
					id: hourText
					anchors {
						baseline: parent.top
						baselineOffset: xLegendTextBaselineOffset
						right: parent.right
					}
					font {
						family: qfont.semiBold.name
						pixelSize: xLegendTextSize
					}
					color: xLegendTextColor
					// show only evry 2nd hour
					text: 2 * (index+1)
				}
				Text {
					anchors {
						bottom: hourText.verticalCenter
						left: parent.left
					}
					font {
						family: qfont.semiBold.name
						pixelSize: xLegendTextSize / 2
					}
					color: xLegendTextColor
					text: "00"
				}
			}
		}
	}

	/// separate zero hour text "0" on the left of xLegendRow
	Text {
		id: hour0
		anchors {
			baseline: xLegendRow.top
			baselineOffset: xLegendTextBaselineOffset
			right: xLegendRow.left
		}
		font {
			family: qfont.semiBold.name
			pixelSize: xLegendTextSize
		}
		color: xLegendTextColor
		text: "0"
	}

	/// separate 24 hour minutes text "00" on the right of xLegendRow
	Text {
		id: minute24_00
		anchors {
			bottom: hour0.verticalCenter
			left: xLegendRow.right
		}
		font {
			family: qfont.semiBold.name
			pixelSize: xLegendTextSize / 2
		}
		color: xLegendTextColor
		text: "00"
	}



	AreaGraphControl {
		id: graph
		opacity: 0.5
		width: xLegendRow.width;
//		height: yLegendColumn.height - yLegendItemHeight
		height: yLegendColumn.height
		anchors.left: xLegendRow.left
		anchors.bottom: yLegendColumn.bottom
//		yScale: (yLegendItemHeight * (yLegendItemCount - 1)) / (maxValue - 4)
		yScale: (yLegendItemHeight * yLegendItemCount) / (maxValue)
	}

	AreaGraphControl {
		id: graph2
		opacity: 0.5
		width: graph.width
		height: graph.height
		anchors.left: graph.left
		anchors.bottom: graph.bottom
		yScale: graph.yScale
	}

	AreaGraphControl {
		id: graph3
		opacity: 0.5
		width: graph.width
		height: graph.height
		anchors.left: graph.left
		anchors.bottom: graph.bottom
		yScale: graph.yScale
	}
}

