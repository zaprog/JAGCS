import QtQuick 2.6
import "qrc:/JS/helper.js" as Helper

Canvas {
    id: root

    property real value: minValue
    property real minValue: 0
    property real maxValue: 1
    property color fillColor: value

    onValueChanged: requestPaint()
    onMinValueChanged: requestPaint()
    onMaxValueChanged: requestPaint()
    onFillColorChanged: requestPaint()

    onPaint: {
        var ctx = root.getContext('2d');

        ctx.clearRect(0, 0, width, height);

        var offset = Helper.mapToRange(value, minValue, maxValue, height);
        var zero = Helper.mapToRange(0, minValue, maxValue, height);

        ctx.beginPath();
        ctx.fillStyle = palette.sunkenColor;
        ctx.fillRect(0, 0, width, height);

        ctx.fillStyle = fillColor;
        ctx.fillRect(1, zero, width - 2, zero - offset);

        ctx.strokeStyle = palette.textColor;
        ctx.moveTo(0, zero);
        ctx.lineTo(width, zero);
        ctx.stroke();
    }
}