import QtQuick 1.1

import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: temperatureloggerSystrayIcon
	visible: true
	posIndex: 9000
	property string objectName: "temperatureloggerSystray"

	onClicked: {
		if (app.temperatureloggerScreen) {
				app.temperatureloggerScreen.show();
       		}
   	}
 

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "./drawables/temperatureLoggerTray.png"
	}
}
