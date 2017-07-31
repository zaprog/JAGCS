import QtQuick 2.6

import "qrc:/Indicators" as Indicators

Item {
    id: root

    property bool ahrsEnabled: false
    property bool ahrsOperational: false
    property alias pitch: af.pitch
    property alias roll: af.roll
    property alias armed: af.armed

    property int throttle: 0

    property bool satelliteEnabled: false
    property bool satelliteOperational: false
    property real groundspeed: 0
    property int satelliteAltitude: 0

    property bool pitotEnabled: false
    property bool pitotOperational: false
    property real indicatedAirspeed: 0
    property real trueAirspeed: 0

    property bool barometricEnabled: false
    property bool barometricOperational: false
    property int barometricAltitude: 0
    property real barometricClimb: 0

    property bool rangefinderEnabled: false
    property bool rangefinderOperational: false
    property int rangefinderHeight: 0

    property int minSpeed: -settings.value("Gui/fdSpeedStep") * 2.7
    property int maxSpeed: settings.value("Gui/fdSpeedStep") * 2.7
    property int speedStep: settings.value("Gui/fdSpeedStep")

    property int minAltitude: -settings.value("Gui/fdAltitudeStep") * 2.7
    property int maxAltitude: settings.value("Gui/fdAltitudeStep") * 2.7
    property int altitudeStep: settings.value("Gui/fdAltitudeStep")

    implicitHeight: af.height

    Indicators.FdLabel {
        anchors.top: parent.top
        anchors.left: parent.left
        prefix: qsTr("GS")
        digits: 1
        value: groundspeed
        enabled: satelliteEnabled
        operational: satelliteOperational
        width: speedLadder.width
    }

    Indicators.BarIndicator {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: speedLadder.right
        width: speedLadder.majorTickSize
        height: parent.height * 0.7
        value: throttle
    }

    Indicators.Ladder {
        id: speedLadder
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: parent.width * 0.2
        height: parent.height * 0.7
        value: indicatedAirspeed
        minValue: indicatedAirspeed + minSpeed
        maxValue: indicatedAirspeed + maxSpeed
        valueStep: speedStep
        enabled: pitotEnabled
        operational: pitotOperational
        canvasRotation: 90
        prefix: qsTr("IAS")
    }

    Indicators.FdLabel {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        prefix: qsTr("TAS")
        digits: 1
        value: trueAirspeed
        enabled: pitotEnabled
        operational: pitotOperational
        width: speedLadder.width
    }

    Indicators.ArtificialHorizon {
        id: af
        anchors.centerIn: parent
        width: parent.width * 0.58
        enabled: ahrsEnabled
        operational: ahrsOperational
        rollInverted: settings.boolValue("Gui/fdRollInverted")
    }

    Indicators.FdLabel {
        anchors.top: parent.top
        anchors.right: parent.right
        prefix: qsTr("SAT")
        value: satelliteAltitude
        enabled: satelliteEnabled
        operational: satelliteOperational
        width: altitudeLadder.width
    }

    Indicators.BarIndicator {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: altitudeLadder.left
        width: altitudeLadder.majorTickSize
        height: parent.height * 0.7
        value: barometricClimb
        fillColor: barometricClimb > 0 ? palette.skyColor : palette.groundColor
        minValue: -10
        maxValue: 10
    }

    Indicators.Ladder {
        id: altitudeLadder
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: parent.width * 0.2
        height: parent.height * 0.7
        value: barometricAltitude
        minValue: barometricAltitude + minAltitude
        maxValue: barometricAltitude + maxAltitude
        valueStep: altitudeStep
        enabled: barometricEnabled
        operational: barometricOperational
        canvasRotation: -90
        prefix: qsTr("ALT")
    }

    Indicators.FdLabel {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        prefix: qsTr("RF")
        value: rangefinderHeight
        enabled: rangefinderEnabled
        operational: rangefinderOperational
        width: altitudeLadder.width
    }
}