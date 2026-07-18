import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid 2.0

MouseArea {
    id: compact

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

    property string cpuIcon: ""
    property string cpuIconColor: "#cba6f7"
    property string cpuFontFamily: "JetBrainsMono Nerd Font"
    property string cpuFontColor: "#a6e3a1"

    property string ramIcon: ""
    property string ramIconColor: "#a6e3a1"
    property string ramFontFamily: "JetBrainsMono Nerd Font"
    property string ramFontColor: "#f9e2af"

    readonly property bool inlineNetActive: compact.netSpeedInline || (compact.showNet && !compact.showCpu && !compact.showRam)

    Layout.preferredWidth: mainRow.implicitWidth + Kirigami.Units.smallSpacing * 4
    Layout.preferredHeight: parent ? parent.height : Kirigami.Units.gridUnit * 2

    hoverEnabled: true

    onClicked: {
        Plasmoid.expanded = !Plasmoid.expanded
    }

    function safeFont(f) {
        return f && f.length > 0 ? f : "JetBrainsMono Nerd Font"
    }

    function formatSpeedShort(bytesPerSec) {
        if (bytesPerSec < 0) bytesPerSec = 0

        if (bytesPerSec < 1024)
            return bytesPerSec.toFixed(0) + " B"

        if (bytesPerSec < 1024 * 1024)
            return (bytesPerSec / 1024).toFixed(0) + " K"

        if (bytesPerSec < 1024 * 1024 * 1024)
            return (bytesPerSec / 1024 / 1024).toFixed(1) + " M"

        return (bytesPerSec / 1024 / 1024 / 1024).toFixed(1) + " G"
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: compact.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent"

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    RowLayout {
        id: mainRow
        anchors.centerIn: parent
        spacing: Kirigami.Units.smallSpacing * 2

        // Net Speed
        RowLayout {
            spacing: 5
            visible: compact.showNet

            Text {
                text: compact.netIcon
                font.family: compact.safeFont(compact.netFontFamily)
                font.pixelSize: 15
                color: compact.netIconColor
            }

            // Stacked (Up/Down 2 line)
            ColumnLayout {
                spacing: -1
                visible: !compact.inlineNetActive

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: 52

                    Text {
                        text: "▼"
                        font.pixelSize: 7
                        color: compact.netDownColor
                    }

                    Text {
                        text: compact.formatSpeedShort(compact.netDown)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 9
                        font.bold: true
                        color: compact.netFontColor
                    }
                }

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: 52

                    Text {
                        text: "▲"
                        font.pixelSize: 7
                        color: compact.netUpColor
                    }

                    Text {
                        text: compact.formatSpeedShort(compact.netUp)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 9
                        font.bold: true
                        color: compact.netFontColor
                    }
                }
            }

            // Inline (Up/Down 1 line)
            RowLayout {
                spacing: 8
                visible: compact.inlineNetActive

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: 58

                    Text {
                        text: "▼"
                        font.pixelSize: 8
                        color: compact.netDownColor
                    }

                    Text {
                        text: compact.formatSpeedShort(compact.netDown)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 10
                        font.bold: true
                        color: compact.netFontColor
                    }
                }

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: 58

                    Text {
                        text: "▲"
                        font.pixelSize: 8
                        color: compact.netUpColor
                    }

                    Text {
                        text: compact.formatSpeedShort(compact.netUp)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 10
                        font.bold: true
                        color: compact.netFontColor
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 22
            radius: 1
            color: "#585b70"
            opacity: 0.35
            visible: compact.showNet && (compact.showCpu || compact.showRam)
        }

        // CPU
        RowLayout {
            spacing: 5
            visible: compact.showCpu

            Text {
                text: compact.cpuIcon
                font.family: compact.safeFont(compact.cpuFontFamily)
                font.pixelSize: 14
                color: compact.cpuIconColor
            }

            Text {
                text: compact.cpuUsage.toFixed(1) + "%"
                font.family: compact.safeFont(compact.cpuFontFamily)
                font.pixelSize: 11
                font.bold: true
                color: compact.cpuFontColor
                Layout.minimumWidth: 40
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 22
            radius: 1
            color: "#585b70"
            opacity: 0.35
            visible: compact.showCpu && compact.showRam
        }

        // RAM
        RowLayout {
            spacing: 5
            visible: compact.showRam

            Text {
                text: compact.ramIcon
                font.family: compact.safeFont(compact.ramFontFamily)
                font.pixelSize: 14
                color: compact.ramIconColor
            }

            Text {
                text: compact.ramUsedGB.toFixed(1) + " G"
                font.family: compact.safeFont(compact.ramFontFamily)
                font.pixelSize: 11
                font.bold: true
                color: compact.ramFontColor
                Layout.minimumWidth: 38
            }
        }
    }
}
