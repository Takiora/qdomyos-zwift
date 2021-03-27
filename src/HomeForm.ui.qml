import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12
import QtCharts 2.15

Page {

    title: qsTr("qDomyos-Zwift")
    id: page

    property alias start: start
    property alias stop: stop
    property alias lap: lap
    property alias row: row

    property alias series1: series1

    Item {
        width: parent.width
        height: rootItem.topBarHeight
        id: topBar

        Row {
            id: row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: topBar.height - 20
            spacing: 5
            padding: 5

            Rectangle {
                width: 50
                height: row.height
                color: Material.backgroundColor
                Column {
                    id: column
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: row.height
                    spacing: 0
                    padding: 0
                    Rectangle {
                        width: 50
                        height: row.height
                        color: Material.backgroundColor

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            id: treadmill_connection
                            width: 48
                            height: row.height - 52
                            source: "icons/icons/bluetooth-icon.png"
                            enabled: rootItem.device
                            smooth: true
                        }
                        ColorOverlay {
                            anchors.fill: treadmill_connection
                            source: treadmill_connection
                            color: treadmill_connection.enabled ? "#00000000" : "#B0D3d3d3"
                        }
                    }
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: treadmill_signal
                        width: 24
                        height: row.height - 76
                        source: rootItem.signal
                        smooth: true
                    }
                }
            }

            Rectangle {
                width: 120
                height: row.height
                color: Material.backgroundColor
                RoundButton {
                    icon.source: rootItem.startIcon
                    icon.height: row.height - 54
                    icon.width: 46
                    text: rootItem.startText
                    enabled: true
                    id: start
                    width: 120
                    height: row.height - 4
                }
                ColorOverlay {
                    anchors.fill: start
                    source: start
                    color: rootItem.startColor
                    enabled: rootItem.startColor === "red" ? true : false
                }
            }

            Rectangle {
                width: 120
                height: row.height
                color: Material.backgroundColor

                RoundButton {
                    icon.source: rootItem.stopIcon
                    icon.height: row.height - 54
                    icon.width: 46
                    text: rootItem.stopText
                    enabled: true
                    id: stop
                    width: 120
                    height: row.height - 4
                }
                ColorOverlay {
                    anchors.fill: stop
                    source: stop
                    color: rootItem.stopColor
                    enabled: rootItem.stopColor === "red" ? true : false
                }
            }

            Rectangle {
                id: item2
                width: 50
                height: row.height
                color: Material.backgroundColor
                RoundButton {
                    anchors.verticalCenter: parent.verticalCenter
                    id: lap
                    width: 48
                    height: row.height - 52
                    icon.source: "icons/icons/lap.png"
                    icon.width: 48
                    icon.height: 48
                    enabled: rootItem.lap
                    smooth: true
                }
                ColorOverlay {
                    anchors.fill: lap
                    source: lap
                    color: lap.enabled ? "#00000000" : "#B0D3d3d3"
                }
            }
        }

        Row {
            id: row1
            width: parent.width
            anchors.bottom: row.bottom
            anchors.bottomMargin: -10

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: rootItem.info
            }
        }

        Label {
            id: lblHelp
            width: parent.width
            anchors.top: row1.bottom
            anchors.topMargin: 30
            text: "This app should automatically connects to your bike/treadmill. <b>If it doesn't, please check</b>:<br>1) your Echelon/Domyos App MUST be closed while qdomyos-zwift is running;<br>2) bluetooth and bluetooth permission MUST be on<br>3) your bike/treadmill should be turned on BEFORE starting this app<br>4) try to restart your device<br><br>If your bike/treadmill disconnects every 30 seconds try to disable the 'virtual device' setting on the left bar.<br><br>In case of issue, please, feel free to contact me to roberto.viola83@gmail.com.<br><br><b>Have a nice ride!</b><br>Roberto Viola"
            wrapMode: Label.WordWrap
            visible: rootItem.labelHelp
        }
    }

    footer:
        ChartView {
            id: chartView
            backgroundColor: Material.backgroundColor
            margins.bottom: 0
            margins.left: 0
            margins.right: 0
            margins.top: 0
            plotAreaColor: Material.backgroundColor
            //title: "Spline"
            anchors.top: gridView.bottom
            antialiasing: true
            legend.visible: false
            width: parent.width
            height: 130 * settings.ui_zoom / 100
            //Label.visible: false

            ValueAxis {
                id: valueAxisX
                min: 0
                max: 60
                tickCount: 60
                labelFormat: "%.0f"
                labelsVisible: false
                gridVisible: false
                lineVisible: false
            }

            ValueAxis {
                id: valueAxisY
                min: 0
                max: rootItem.wattMax
                //tickCount: 60
                labelFormat: "%.0f"
                labelsVisible: false
                gridVisible: false
                lineVisible: false
            }

            SplineSeries {
                id: series1
                useOpenGL: true
                axisX: valueAxisX
                axisY: valueAxisY
                name: "SplineSeries"
                /*XYPoint { x: 0; y: 0.0 }
                XYPoint { x: 1.1; y: 3.2 }
                XYPoint { x: 1.9; y: 2.4 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 2.6 }
                XYPoint { x: 3.4; y: 2.3 }
                XYPoint { x: 4.1; y: 3.1 }*/
            }
        }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.6600000262260437;height:480;width:640}
}
##^##*/

