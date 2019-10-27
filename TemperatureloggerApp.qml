import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import "temperatureLogger.js" as TemperatureLoggerJS


App {
	id: temperatureloggerApp

	// These are the URL's for the QML resources from which our widgets will be instantiated.
	// By making them a URL type property they will automatically be converted to full paths,
	// preventing problems when passing them around to code that comes from a different path.

	property url thumbnailIcon: "qrc:/tsc/buienradar.png"
	property TemperatureloggerScreen temperatureloggerScreen
	property url trayUrl2 : "TemperatureloggerTray.qml";
	property string timeStr

	property variant arycurrentTemp : []
	property variant arycurrentSetpoint : []
	property variant arycurrentBuienradar : []
	property int nowlinexcoordinate : 20
	property string nowleftlabel : "--"
	property string nowrightlabel : "--"
	property real temperatuurGC 
	property int temperatuurGCIndex
	property int tempOffset : -8

	QtObject {
		id: p

		property url temperatureloggerScreenUrl : "TemperatureloggerScreen.qml"
	}

	
	function init() {
		registry.registerWidget("screen", p.temperatureloggerScreenUrl, this, "temperatureloggerScreen");
		registry.registerWidget("systrayIcon", trayUrl2, this, "temperatureloggerTray");
	}


	function readBuienradarTemp() {

		// read Buienradar tmp reading

		var doc2 = new XMLHttpRequest();
		doc2.onreadystatechange = function() {
			if (doc2.readyState == XMLHttpRequest.DONE) {
				if (doc2.responseText.length > 2) {
					var i = doc2.responseText.indexOf(":");
					temperatuurGC = tempOffset + parseFloat(doc2.responseText.substring(0, i));

						//calculate index in array 27.5:08/03/2017 21:00:00

	  				var hour = parseInt(doc2.responseText.substring(i+12, i+14));
         				var min  = parseInt(doc2.responseText.substring(i+15, i+17));
					temperatuurGCIndex = (hour * 6) + Math.round(-0.5 + (min /10));
				}
 			}
		}  		
		doc2.open("GET", "file:///var/volatile/tmp/actualBuienradarTemp.txt", true);
		doc2.send();
	}

	function updateActualAndProgramTemp() {


		var xmlhttpt = new XMLHttpRequest();
		xmlhttpt.onreadystatechange = function() {

			nowleftlabel = xmlhttpt.readyState;
			if  ( xmlhttpt.readyState == 4 ) {
				nowrightlabel = xmlhttpt.status;

				
				if  ( xmlhttpt.status == 200  ) {

					nowleftlabel = xmlhttpt.readyState;
					nowrightlabel = xmlhttpt.status;

						//calculate index in array

				  	var datum = new Date();
	  				var hour = datum.getHours();
         				var min  = datum.getMinutes();
					var index = (hour * 6) + Math.round(-0.5 + (min / 10));

						//read temp readings

					var txtStat = xmlhttpt.responseText;
					var idxcurrentSetpoint = txtStat.indexOf("currentSetpoint");
					var idxcurrentTemp = txtStat.indexOf("currentTemp");
					var currentSetpoint = tempOffset + (parseInt(txtStat.substring(18 + idxcurrentSetpoint, 22 + idxcurrentSetpoint)) / 100);
					var currentTemp = tempOffset + (parseInt(txtStat.substring(14 + idxcurrentTemp , 18 + idxcurrentTemp)) / 100);

						//store values in arrays

					arycurrentTemp = TemperatureLoggerJS.addReading(arycurrentTemp , index, currentTemp);
					arycurrentSetpoint = TemperatureLoggerJS.addReading(arycurrentSetpoint , index, currentSetpoint);
					arycurrentBuienradar = TemperatureLoggerJS.addReading(arycurrentBuienradar , index, temperatuurGC);

						//update positioning line and labels on screen

					if (isNxt) {
						nowlinexcoordinate = (697 * index * 1.25 / 144) + 32;
					} else {
						nowlinexcoordinate = (697 * index / 144) + 25;
					}
					var dag = datum.getDate();
					var maand = datum.getMonth();
					nowleftlabel = dag + "-" + (maand+1);

					datum.setDate(datum.getDate() - 1);
					dag = datum.getDate();
					maand = datum.getMonth();
					nowrightlabel = dag + "-" + (maand+1);

	     			}
 		  	}
		}
		xmlhttpt.open("GET", "http://127.0.0.1/happ_thermstat?action=getThermostatInfo", true );
		xmlhttpt.send();
	}

	function shiftArrays(delta) {
		arycurrentTemp = TemperatureLoggerJS.shiftArray(arycurrentTemp , delta);
		arycurrentSetpoint = TemperatureLoggerJS.shiftArray(arycurrentSetpoint , delta);
		arycurrentBuienradar = TemperatureLoggerJS.shiftArray(arycurrentBuienradar , delta);
		saveTemperatures();
	}

	function readSavedFiles() {
		var doc2 = new XMLHttpRequest();
		doc2.onreadystatechange = function() {
			if (doc2.readyState == XMLHttpRequest.DONE) {
				arycurrentTemp = doc2.responseText.split(",");
 			}
		}  		
		doc2.open("GET", "file:///HCBv2/var/actualTempReading24H.txt", true);
   		doc2.send();

		var doc5 = new XMLHttpRequest();
		doc5.onreadystatechange = function() {
			if (doc5.readyState == XMLHttpRequest.DONE) {
				arycurrentSetpoint = doc5.responseText.split(",");
 			}
		}  		
		doc5.open("GET", "file:///HCBv2/var/actualTempSetpoint24H.txt", true);
   		doc5.send();

		var doc4 = new XMLHttpRequest();
		doc4.onreadystatechange = function() {
			if (doc4.readyState == XMLHttpRequest.DONE) {
				arycurrentBuienradar = doc4.responseText.split(",");
 			}
		}  		
		doc4.open("GET", "file:///HCBv2/var/actualTempBuienradar24H.txt", true);
   		doc4.send();

		var doc3 = new XMLHttpRequest();
		doc3.onreadystatechange = function() {
			if (doc3.readyState == XMLHttpRequest.DONE) {
				tempOffset = parseInt(doc3.responseText);
 			}
		}  		
		doc3.open("GET", "file:///HCBv2/var/actualTempOffset.txt", true);
   		doc3.send();
	}
	
	function saveTemperatures() {
		var doc3 = new XMLHttpRequest();
    		doc3.open("PUT", "file:///HCBv2/var/actualTempReading24H.txt");
   		doc3.send(arycurrentTemp);
 		var doc4 = new XMLHttpRequest();
    		doc4.open("PUT", "file:///HCBv2/var/actualTempSetpoint24H.txt");
   		doc4.send(arycurrentSetpoint);
  		var doc5 = new XMLHttpRequest();
    		doc5.open("PUT", "file:///HCBv2/var/actualTempBuienradar24H.txt");
   		doc5.send(arycurrentBuienradar);
   		var doc6 = new XMLHttpRequest();
    		doc6.open("PUT", "file:///HCBv2/var/actualTempOffset.txt");
   		doc6.send(tempOffset); 
	}

	Component.onCompleted: {

		//read default location
		arycurrentTemp = TemperatureLoggerJS.initArray(arycurrentTemp);
		arycurrentSetpoint = TemperatureLoggerJS.initArray(arycurrentSetpoint);
		arycurrentBuienradar = TemperatureLoggerJS.initArray(arycurrentBuienradar);
		readSavedFiles();
		readBuienradarTemp();
		updateActualAndProgramTemp();
	}

	Timer {
		id: datetimeTimertl
		interval: 600000
		triggeredOnStart: false
		running: true
		repeat: true
		onTriggered: {
			readBuienradarTemp();
			updateActualAndProgramTemp();
			saveTemperatures();
		}
	}

}
