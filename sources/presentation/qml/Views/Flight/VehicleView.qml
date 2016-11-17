import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "../../Indicators"

ColumnLayout {
    id: root

    property QtObject vehicle

    // TODO: MVP
    FlightDirector {
        id: flightDirector
        Layout.preferredWidth: parent.width

        pitch: vehicle ? vehicle.attitude.pitch : 0.0
        roll: vehicle ? vehicle.attitude.roll : 0.0
        yaw: vehicle ? vehicle.attitude.yaw : 0.0
        velocity: vehicle ? vehicle.trueAirSpeed : 0.0
        altitude: vehicle ? vehicle.barometricAltitude : 0.0
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter

        ColoredIcon {
            source: "qrc:/icons/gps.svg"
            color: {
                if (!vehicle) return palette.disabledColor;

                switch (vehicle.gps.fix) {
                case 0: return palette.disabledColor;
                case 1: return palette.negativeColor;
                case 2: return palette.neutralColor;
                default: return palette.positiveColor;
                }
            }

            Text {
                text: vehicle && vehicle.gps.satellitesVisible > 0 ?
                          vehicle.gps.satellitesVisible : "-"
                font.pixelSize: parent.height / 4
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: parent.color
            }
        }
    }

    // TODO: tools

}
