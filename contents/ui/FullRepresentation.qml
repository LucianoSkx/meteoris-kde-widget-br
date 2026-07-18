import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid 2.0

Item {
    id: full

    property double cpuUsage: 0
    property double ramUsedGB: 0
    property double ramTotalGB: 0
    property double ramPercent: 0
    property double netDown: 0
    property double netUp: 0

    property bool showNet: true
    property bool showCpu: true
    property bool showRam: true
    property bool netSpeedInline: false

    property string netIcon: "󰓅"
    property string netIconColor: "#89b4fa"
    property string netFontFamily: "JetBrainsMono Nerd Font"
    property string netFontColor: "#cdd6f4"
    property string netDownColor: "#a6e3a1"
    property string netUpColor: "#f38ba8"

    property string cpuIcon: ""
    property string cpuIconColor: "#cba6f7"
    property string cpuFontFamily: "JetBrainsMono Nerd Font"
    property string cpuFontColor: "#a6e3a1"

    property string ramIcon: ""
    property string ramIconColor: "#a6e3a1"
    property string ramFontFamily: "JetBrainsMono Nerd Font"
    property string ramFontColor: "#f9e2af"

    implicitWidth: 380
    implicitHeight: Math.max(360, mainColumn.implicitHeight + 44)

    function safeFont(f) {
        return f && f.length > 0 ? f : "JetBrainsMono Nerd Font"
    }

    function formatSpeed(b) {
        if (b < 0) b = 0
        if (b < 1024) return b.toFixed(0) + " B/s"
        if (b < 1048576) return (b / 1024).toFixed(1) + " KB/s"
        if (b < 1073741824) return (b / 1048576).toFixed(2) + " MB/s"
        return (b / 1073741824).toFixed(2) + " GB/s"
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#1e1e2e"
        border.color: "#313244"
        border.width: 1
    }

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        anchors.margins: 22
        spacing: 12

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Text {
                text: "☄"
                font.pixelSize: 20
                color: "#f9e2af"
            }

            Text {
                text: "Meteoris"
                font.pixelSize: 18
                font.bold: true
                font.family: full.safeFont(full.netFontFamily)
                color: "#cdd6f4"
                font.letterSpacing: 1
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#45475a"
            opacity: 0.5
        }

        // Quick toggles card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: optionsCol.implicitHeight + 24
            radius: 14
            color: "#181825"
            border.color: "#313244"
            border.width: 1

            ColumnLayout {
                id: optionsCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "Display Options"
                    font.pixelSize: 13
                    font.bold: true
                    color: "#f9e2af"
                    font.family: full.safeFont(full.netFontFamily)
                }

                RowLayout {
                    spacing: 14

                    Switch {
                        text: "Net"
                        checked: full.showNet
                        onToggled: Plasmoid.configuration.showNet = checked
                    }

                    Switch {
                        text: "CPU"
                        checked: full.showCpu
                        onToggled: Plasmoid.configuration.showCpu = checked
                    }

                    Switch {
                        text: "RAM"
                        checked: full.showRam
                        onToggled: Plasmoid.configuration.showRam = checked
                    }
                }

                RowLayout {
                    visible: full.showNet
                    spacing: 10

                    Text {
                        text: "Net panel layout"
                        font.pixelSize: 11
                        color: "#a6adc8"
                        font.family: full.safeFont(full.netFontFamily)
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: inlineSwitch.checked ? "Side-by-side" : "Stacked"
                        font.pixelSize: 11
                        color: inlineSwitch.checked ? full.netIconColor : "#6c7086"
                        font.family: full.safeFont(full.netFontFamily)
                    }

                    Switch {
                        id: inlineSwitch
                        checked: full.netSpeedInline
                        onToggled: Plasmoid.configuration.netSpeedInline = checked
                    }
                }
            }
        }

        // Net card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: netCol.implicitHeight + 28
            radius: 14
            color: "#181825"
            border.color: "#313244"
            border.width: 1
            visible: full.showNet

            Rectangle {
                width: 3
                radius: 2
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 14
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                color: full.netIconColor
                opacity: 0.75
            }

            ColumnLayout {
                id: netCol
                anchors.fill: parent
                anchors.margins: 14
                anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10

                    Text {
                        text: full.netIcon
                        font.family: full.safeFont(full.netFontFamily)
                        font.pixelSize: 22
                        color: full.netIconColor
                    }

                    Text {
                        text: "Network"
                        font.pixelSize: 14
                        font.bold: true
                        color: full.netIconColor
                        font.family: full.safeFont(full.netFontFamily)
                    }
                }

                RowLayout {
                    spacing: 10

                    Text {
                        text: "▼"
                        color: full.netDownColor
                        font.pixelSize: 11
                    }

                    Text {
                        text: "Download"
                        font.pixelSize: 11
                        color: "#a6adc8"
                        font.family: full.safeFont(full.netFontFamily)
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: full.formatSpeed(full.netDown)
                        font.pixelSize: 12
                        font.bold: true
                        color: full.netDownColor
                        font.family: full.safeFont(full.netFontFamily)
                    }
                }

                RowLayout {
                    spacing: 10

                    Text {
                        text: "▲"
                        color: full.netUpColor
                        font.pixelSize: 11
                    }

                    Text {
                        text: "Upload"
                        font.pixelSize: 11
                        color: "#a6adc8"
                        font.family: full.safeFont(full.netFontFamily)
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: full.formatSpeed(full.netUp)
                        font.pixelSize: 12
                        font.bold: true
                        color: full.netUpColor
                        font.family: full.safeFont(full.netFontFamily)
                    }
                }
            }
        }

        // CPU card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: cpuCol.implicitHeight + 28
            radius: 14
            color: "#181825"
            border.color: "#313244"
            border.width: 1
            visible: full.showCpu

            Rectangle {
                width: 3
                radius: 2
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 14
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                color: full.cpuIconColor
                opacity: 0.75
            }

            ColumnLayout {
                id: cpuCol
                anchors.fill: parent
                anchors.margins: 14
                anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10

                    Text {
                        text: full.cpuIcon
                        font.family: full.safeFont(full.cpuFontFamily)
                        font.pixelSize: 20
                        color: full.cpuIconColor
                    }

                    Text {
                        text: "CPU"
                        font.pixelSize: 14
                        font.bold: true
                        color: full.cpuIconColor
                        font.family: full.safeFont(full.cpuFontFamily)
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: full.cpuUsage.toFixed(1) + "%"
                        font.pixelSize: 18
                        font.bold: true
                        color: full.cpuFontColor
                        font.family: full.safeFont(full.cpuFontFamily)
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 10
                    radius: 5
                    color: "#313244"

                    Rectangle {
                        width: parent.width * Math.min(1, full.cpuUsage / 100)
                        height: parent.height
                        radius: 5
                        color: full.cpuIconColor

                        Behavior on width {
                            NumberAnimation {
                                duration: 450
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }

        // RAM card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: ramCol.implicitHeight + 28
            radius: 14
            color: "#181825"
            border.color: "#313244"
            border.width: 1
            visible: full.showRam

            Rectangle {
                width: 3
                radius: 2
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 14
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                color: full.ramIconColor
                opacity: 0.75
            }

            ColumnLayout {
                id: ramCol
                anchors.fill: parent
                anchors.margins: 14
                anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10

                    Text {
                        text: full.ramIcon
                        font.family: full.safeFont(full.ramFontFamily)
                        font.pixelSize: 20
                        color: full.ramIconColor
                    }

                    Text {
                        text: "RAM"
                        font.pixelSize: 14
                        font.bold: true
                        color: full.ramIconColor
                        font.family: full.safeFont(full.ramFontFamily)
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: full.ramUsedGB.toFixed(1) + " / " + full.ramTotalGB.toFixed(1) + " GB"
                        font.pixelSize: 12
                        font.bold: true
                        color: full.ramFontColor
                        font.family: full.safeFont(full.ramFontFamily)
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 10
                    radius: 5
                    color: "#313244"

                    Rectangle {
                        width: parent.width * Math.min(1, full.ramPercent / 100)
                        height: parent.height
                        radius: 5
                        color: full.ramIconColor

                        Behavior on width {
                            NumberAnimation {
                                duration: 450
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                RowLayout {
                    spacing: 6

                    Text {
                        text: full.ramPercent.toFixed(1) + "% used"
                        font.pixelSize: 10
                        color: "#6c7086"
                        font.family: full.safeFont(full.ramFontFamily)
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: (full.ramTotalGB - full.ramUsedGB).toFixed(1) + " GB free"
                        font.pixelSize: 10
                        color: "#585b70"
                        font.family: full.safeFont(full.ramFontFamily)
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            Text {
                text: "☄"
                font.pixelSize: 11
                color: "#585b70"
            }

            Text {
                text: "Meteoris v2.1 by SiyamX7"
                font.pixelSize: 10
                color: "#585b70"
                font.family: full.safeFont(full.netFontFamily)
                font.italic: true
            }
        }
    }
}
