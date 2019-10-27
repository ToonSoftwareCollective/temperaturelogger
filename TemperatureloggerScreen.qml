import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0
import GraphUtils 1.0;

Screen {

	id: temperatureloggerScreen

	screenTitle: "Temperatuurlog afgelopen 24 uur";

	Rectangle {
		id: graphRect

		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
		}

		color: colors.graphScreenBackground
		height: isNxt ? 440 : 350
		width: isNxt ? 992 : 768
		
		Rectangle {
			id: legendTemp
			height: isNxt ? 25 : 20
			width: isNxt ? 38 : 30
			anchors {
				baseline: graphRect.top
				baselineOffset: isNxt ? -75 : -60
				left: graphRect.left
				leftMargin: isNxt ? 38 :30
			}
			color: "#0000FF"
			opacity: 0.5
		}
		Text {
			id: legendTempText
			text: "actuele temperatuur"
			anchors {
				baseline: graphRect.top
				baselineOffset: isNxt ? -55 : -45
				left: legendTemp.right
				leftMargin: isNxt ? 13 : 10
			}
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: colors.clockTileColor

		}

		
		Rectangle {
			id: legendSetpoint
			height: isNxt ? 25 : 20
			width: isNxt ? 38 : 30
			anchors {
				baseline: graphRect.top
				baselineOffset: isNxt ? -75 : -60
				left: graphRect.left
				leftMargin: isNxt ? 345 : 275
			}
			color: "#FF0000"
			opacity: 0.5
		}

		Text {
			id: legendSetpointText
			text: "programma temperatuur"
			anchors {
				baseline: graphRect.top
				baselineOffset: isNxt ? -55 : -45
				left: legendSetpoint.right
				leftMargin: isNxt ? 13 : 10
			}
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: colors.clockTileColor

		}

		
		Rectangle {
			id: legendBuienradar
			height: isNxt ? 25 : 20
			width: isNxt ? 38 : 30
			anchors {
				baseline: graphRect.top
				baselineOffset: isNxt ? -75 : -60
				left: graphRect.left
				leftMargin: isNxt ? 660 : 530
			}
			color: "#FFFF00"
			opacity: 0.5
		}

		Text {
			id: legendBuienradarText
			text: "buitentemperatuur"
			anchors {
				baseline: graphRect.top
				baselineOffset: isNxt ? -55 : -45
				left: legendBuienradar.right
				leftMargin: isNxt ? 13 : 10
			}
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: colors.clockTileColor

		}



		AreaGraphMod {
			id: areaGraph

			width: graphRect.width
			height: graphRect.height
			visible: true
			anchors {
				top: graphRect.top
				left: graphRect.left
			}

			graphColor: "#0000FF"
			graph2Color: "#FF0000"
			graph3Color: "#FFFF00"

			graphValues: app.arycurrentTemp
			graph2Values: app.arycurrentSetpoint
			graph3Values: app.arycurrentBuienradar

			graphVisible: true
			graph2Visible: true
			graph3Visible: true
			maxValue: 16		// 16 + 12 (offset) = max value is 28
		}

		Rectangle {
			id: nowverticalline
			height: isNxt ? graphRect.height - 37 : graphRect.height - 30
			width: 1
			anchors {
				baseline: graphRect.top
				left: graphRect.left
				leftMargin: app.nowlinexcoordinate
			}
			color: colors.clockTileColor
		}
		Text {
			id: nowleftlabelid
			text: app.nowleftlabel
			anchors {
				baseline: nowverticalline.top
				baselineOffset: -15
				right: nowverticalline.left
				rightMargin: 5
			}
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: colors.clockTileColor

		}

		Image {
			id: leftarrow
			source: "qrc:/tsc/icon_arrowLeft_shadow.png"
			anchors {
				baseline: nowverticalline.top
				baselineOffset: isNxt ? -38 : -30
				right: nowleftlabelid.left
				rightMargin: 0
			}
		}

		Text {
			id: nowrightlabelid
			text: app.nowrightlabel
			anchors {
				baseline: nowverticalline.top
				baselineOffset: -15
				left: nowverticalline.right
				leftMargin: 5
			}
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: colors.clockTileColor

		}

		Image {
			id: rightarrow
			source: "qrc:/tsc/icon_arrowRight_shadow.png"
			anchors {
				baseline: nowverticalline.top
				baselineOffset: isNxt ? -38 : -30
				left: nowrightlabelid.right
				leftMargin: 0
			}
		}

		IconButton {
			id: upButton;
			width: isNxt ? 50 : 40
			height: isNxt ? 25 : 20
			iconSource: "qrc:/tsc/up.png"

			anchors {
				right: parent.right
				baseline: nowverticalline.top
				baselineOffset: 0
			}

			bottomClickMargin: 3
			onClicked: {
				app.tempOffset = app.tempOffset - 2;
				app.shiftArrays(-2);
			}
		}

		IconButton {
			id: downButton;
			width: isNxt ? 50 : 40
			height: isNxt ? 25 : 20
			iconSource: "qrc:/tsc/down.png"

			anchors {
				bottom: areaGraph.bottom
				right: areaGraph.right
			}

			bottomClickMargin: 3
			onClicked: {
				app.tempOffset = app.tempOffset + 2;
				app.shiftArrays(2);
			}
		}
	}
}
