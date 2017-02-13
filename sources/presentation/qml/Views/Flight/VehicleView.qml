import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "qrc:/JS/helper.js" as Helper

import "qrc:/Controls"
import "../../Indicators"

ColumnLayout {
    id: root

    property QtObject vehicle

    spacing: palette.controlBaseSize / 4 // TODO: palette spacing

    Item {
        id: sns
        Layout.preferredWidth: root.width
        Layout.preferredHeight: gpsColumn.height

        Column {
            id: gpsColumn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: palette.controlBaseSize / 8

            Label {
                color: fd.snsColor
                font.pixelSize: palette.fontPixelSize * 0.6
                text: qsTr("Lat.:") +
                      (vehicle ? Helper.degreesToDmsString(vehicle.gps.coordinate.latitude,
                                                           false) : qsTr("None"))
            }

            Label {
                color: fd.snsColor
                font.pixelSize: palette.fontPixelSize * 0.6
                text: qsTr("Lon.:") +
                      (vehicle ? Helper.degreesToDmsString(vehicle.gps.coordinate.longitude,
                                                           true) : qsTr("None"))
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: palette.controlBaseSize / 8
            spacing: 5

            GpsIndicator {
                fix: vehicle && vehicle.gpsAvalible ? vehicle.gps.fix : -1
                satellitesVisible: vehicle ? vehicle.gps.satellitesVisible : -1
                anchors.verticalCenter: parent.verticalCenter
                width: palette.controlBaseSize
                height: width
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    color: fd.snsColor
                    font.pixelSize: palette.fontPixelSize * 0.6
                    text: qsTr("HDOP:") + (vehicle ? vehicle.gps.eph : qsTr("None"))
                }

                Label {
                    color: fd.snsColor
                    font.pixelSize: palette.fontPixelSize * 0.6
                    text: qsTr("VDOP:") + (vehicle ? vehicle.gps.epv : qsTr("None"))
                }
            }
        }
    }

    FlightDisplay {
        id: fd
        width: palette.controlBaseSize * 8

        insAvalible: vehicle && vehicle.insAvalible
        pitch: vehicle ? vehicle.attitude.pitch : 0.0
        roll: vehicle ? vehicle.attitude.roll : 0.0
        airSpeedAvalible: vehicle && vehicle.airSpeedAvalible
        indicatedAirSpeed: vehicle ? vehicle.indicatedAirSpeed : 0.0
        trueAirSpeed: vehicle ? vehicle.trueAirSpeed : 0.0
        windSpeed: vehicle ? vehicle.wind.speed: 0.0
        groundSpeed: vehicle ? vehicle.groundSpeed : 0.0
        barometerAvalible: vehicle && vehicle.barometerAvalible
        altitude: vehicle ? vehicle.barometricAltitude : 0.0
        climb: vehicle ? vehicle.barometricClimb : 0.0
        rangeFinderAvalible: vehicle && vehicle.rangeFinderAvalible

        compassAvalible: vehicle && vehicle.compasAvalible
        heading: vehicle ? vehicle.heading : 0.0
        course: vehicle && vehicle.gpsAvalible ? vehicle.gps.course : -1
        windDirection: vehicle ? vehicle.wind.direction : -1
        homeDirection: vehicle ? vehicle.homeDirection : -1
        homeDistance: vehicle ? vehicle.homeDistance : -1
        missionDirection: vehicle ? vehicle.missionDirection : -1
        missionDistance: vehicle ? vehicle.missionDistance : -1

        snsAltitude: vehicle ? vehicle.gps.coordinate.altitude : 0.0
        snsFix: vehicle && vehicle.gpsAvalible ? vehicle.gps.fix : -1

        charge: vehicle ? vehicle.powerSystem.charge : -1
        voltage: vehicle ? vehicle.powerSystem.voltage : -1
        current: vehicle ? vehicle.powerSystem.current : -1

        rollInverted: parseInt(settings.value("Gui/fdRollInverted"))
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: height / 2

        Label {
            text: qsTr("AUTO")
            color: vehicle && vehicle.autonomous ?
                       palette.textColor : palette.disabledColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: qsTr("GUIDED")
            color: vehicle && vehicle.guided ?
                       palette.textColor : palette.disabledColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: qsTr("STAB")
            color: vehicle && vehicle.stabilized ?
                       palette.textColor : palette.disabledColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: qsTr("ARMED")
            color: vehicle && vehicle.armed ?
                       palette.textColor : palette.disabledColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.margins: palette.controlBaseSize / 2

        ComboBox {
            id: commandBox
            model: commandHelper ? commandHelper.avaliableCommands() : 0
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            Layout.fillWidth: true
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Send")
            onClicked: commandHelper.executeCommand(commandBox.currentText, vehicle)
            // TODO: args
        }
    }
}
