import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore

MouseArea {
    id: compact

    property double cpuUsage: 0
    property double ramUsedGB: 0
    property double ramTotalGB: 0
    property double ramPercent: 0
    property double netDown: 0
    property double netUp: 0
    property double prefwidth: 38

    // New data props
    property double cpuTemp: 0
    property double gpuTemp: 0
    property double gpuMemUsed: 0
    property double gpuMemTotal: 0
    property double batteryPercent: 0
    property string batteryStatus: "Unknown"
    property bool batteryAvailable: false

    // Hover popup extra data
    property double trafficTodayDown: 0
    property double trafficTodayUp: 0
    property double trafficMonthDown: 0
    property double trafficMonthUp: 0
    property double cpuFreqGHz: 0
    property double diskUsagePercent: 0
    property string diskUsageText: ""

    // Separator spacing (user configurable via slider)
    property int separatorSpacing: 6

    property bool showNet: true
    property bool showCpu: true
    property bool showRam: true
    property bool netSpeedInline: false
    property bool showCpuTemp: false
    property bool showGpuTemp: false
    property bool showGpuUsage: false
    property bool showBattery: false

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

    property string cpuTempIcon: ""
    property string cpuTempIconColor: "#fab387"
    property string cpuTempFontFamily: "JetBrainsMono Nerd Font"
    property string cpuTempFontColor: "#f38ba8"

    property string gpuTempIcon: "󰢮"
    property string gpuTempIconColor: "#94e2d5"
    property string gpuTempFontFamily: "JetBrainsMono Nerd Font"
    property string gpuTempFontColor: "#f9e2af"

    property string gpuUsageIcon: "󰾲"
    property string gpuUsageIconColor: "#89dceb"
    property string gpuUsageFontFamily: "JetBrainsMono Nerd Font"
    property string gpuUsageFontColor: "#cdd6f4"

    property string batteryIcon: "󰁹"
    property string batteryIconColor: "#a6e3a1"
    property string batteryFontFamily: "JetBrainsMono Nerd Font"
    property string batteryFontColor: "#f9e2af"

    readonly property bool inlineNetActive: compact.netSpeedInline || (compact.showNet && !compact.showCpu && !compact.showRam)

    // helper: which sections are visible (for separator logic)
    readonly property var visibleSections: {
        var arr = []
        if (compact.showNet) arr.push("net")
        if (compact.showCpu) arr.push("cpu")
        if (compact.showCpuTemp) arr.push("cpuTemp")
        if (compact.showRam) arr.push("ram")
        if (compact.showGpuTemp) arr.push("gpuTemp")
        if (compact.showGpuUsage) arr.push("gpuUsage")
        if (compact.showBattery && compact.batteryAvailable) arr.push("battery")
        return arr
    }

    function needsSeparatorBefore(section) {
        var idx = visibleSections.indexOf(section)
        return idx > 0
    }

    Layout.preferredWidth: mainRow.implicitWidth + Kirigami.Units.smallSpacing * 4
    Layout.preferredHeight: parent ? parent.height : Kirigami.Units.gridUnit * 2

    hoverEnabled: true

    // Disable default Plasmoid tooltip so our custom one shows alone
    Component.onCompleted: {
        Plasmoid.toolTipMainText = ""
        Plasmoid.toolTipSubText = ""
    }

    onClicked: {
        Plasmoid.expanded = !Plasmoid.expanded
    }

    onContainsMouseChanged: {
        if (containsMouse) {
            hoverShowTimer.restart()
            hoverHideTimer.stop()
        } else {
            hoverShowTimer.stop()
            hoverHideTimer.restart()
        }
    }

    Timer {
        id: hoverShowTimer
        interval: 250
        onTriggered: {
            if (compact.containsMouse) {
                hoverDialog.visible = true
            }
        }
    }

    Timer {
        id: hoverHideTimer
        interval: 250
        onTriggered: {
            if (!compact.containsMouse) {
                hoverDialog.visible = false
            }
        }
    }

    function safeFont(f) {
        return f && f.length > 0 ? f : "JetBrainsMono Nerd Font"
    }

    function formatSpeedShort(bytesPerSec) {
        if (bytesPerSec < 0) bytesPerSec = 0
        if (bytesPerSec < 1024) return bytesPerSec.toFixed(0) + " B"
        if (bytesPerSec < 1024 * 1024) return (bytesPerSec / 1024).toFixed(0) + " K"
        if (bytesPerSec < 1024 * 1024 * 1024) return (bytesPerSec / 1024 / 1024).toFixed(1) + " M"
        return (bytesPerSec / 1024 / 1024 / 1024).toFixed(1) + " G"
    }

    function formatGpuMem(mb) {
        if (mb >= 1024) return (mb / 1024).toFixed(1) + " G"
        return mb.toFixed(0) + " M"
    }

    function formatBytes(b) {
        if (b < 0) b = 0
        if (b < 1024) return b.toFixed(0) + " B"
        if (b < 1048576) return (b / 1024).toFixed(2) + " KB"
        if (b < 1073741824) return (b / 1048576).toFixed(2) + " MB"
        return (b / 1073741824).toFixed(2) + " GB"
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: compact.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent"
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    RowLayout {
        id: mainRow
        anchors.centerIn: parent
        spacing: compact.separatorSpacing

        // ─── Net Speed ───
        RowLayout {
            spacing: 5
            visible: compact.showNet

            Text {
                text: compact.netIcon
                font.family: compact.safeFont(compact.netFontFamily)
                font.pixelSize: 15
                color: compact.netIconColor
            }

            ColumnLayout {
                spacing: -1
                visible: !compact.inlineNetActive

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: prefwidth

                    Text { text: "▼"; font.pixelSize: 7; color: compact.netDownColor }
                    Text {
                        text: compact.formatSpeedShort(compact.netDown)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 9; font.bold: true; color: compact.netFontColor
                    }
                }

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: prefwidth

                    Text { text: "▲"; font.pixelSize: 7; color: compact.netUpColor }
                    Text {
                        text: compact.formatSpeedShort(compact.netUp)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 9; font.bold: true; color: compact.netFontColor
                    }
                }
            }

            RowLayout {
                spacing: 8
                visible: compact.inlineNetActive

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: prefwidth

                    Text { text: "▼"; font.pixelSize: 8; color: compact.netDownColor }
                    Text {
                        text: compact.formatSpeedShort(compact.netDown)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 10; font.bold: true; color: compact.netFontColor
                    }
                }

                RowLayout {
                    spacing: 3
                    Layout.preferredWidth: prefwidth

                    Text { text: "▲"; font.pixelSize: 8; color: compact.netUpColor }
                    Text {
                        text: compact.formatSpeedShort(compact.netUp)
                        font.family: compact.safeFont(compact.netFontFamily)
                        font.pixelSize: 10; font.bold: true; color: compact.netFontColor
                    }
                }
            }
        }

        // ─── Sep before RAM ───
        Rectangle {
            Layout.preferredWidth: 1; Layout.preferredHeight: 22; radius: 1
            color: "#585b70"; opacity: 0.35
            visible: compact.needsSeparatorBefore("ram")
        }

        // ─── RAM ───
        RowLayout {
            spacing: 5
            visible: compact.showRam

            Text {
                text: compact.ramIcon
                font.family: compact.safeFont(compact.ramFontFamily)
                font.pixelSize: 14; color: compact.ramIconColor
            }

            Text {
                text: compact.ramUsedGB.toFixed(1) + " G"
                font.family: compact.safeFont(compact.ramFontFamily)
                font.pixelSize: 11; font.bold: true; color: compact.ramFontColor
                Layout.minimumWidth: 38
            }
        }

        // ─── Sep before CPU ───
        Rectangle {
            Layout.preferredWidth: 1; Layout.preferredHeight: 22; radius: 1
            color: "#585b70"; opacity: 0.35
            visible: compact.needsSeparatorBefore("cpu")
        }

        // ─── CPU ───
        RowLayout {
            spacing: 5
            visible: compact.showCpu

            Text {
                text: compact.cpuIcon
                font.family: compact.safeFont(compact.cpuFontFamily)
                font.pixelSize: 14; color: compact.cpuIconColor
            }

            Text {
                text: compact.cpuUsage.toFixed(1) + "%"
                font.family: compact.safeFont(compact.cpuFontFamily)
                font.pixelSize: 11; font.bold: true; color: compact.cpuFontColor
                Layout.minimumWidth: 40
            }
        }

        // ─── Sep before CPU Temp ───
        Rectangle {
            Layout.preferredWidth: 1; Layout.preferredHeight: 22; radius: 1
            color: "#585b70"; opacity: 0.35
            visible: compact.needsSeparatorBefore("cpuTemp")
        }

        // ─── CPU Temp ───
        RowLayout {
            spacing: 5
            visible: compact.showCpuTemp

            Text {
                text: compact.cpuTempIcon
                font.family: compact.safeFont(compact.cpuTempFontFamily)
                font.pixelSize: 14; color: compact.cpuTempIconColor
            }

            Text {
                text: compact.cpuTemp.toFixed(0) + "°C"
                font.family: compact.safeFont(compact.cpuTempFontFamily)
                font.pixelSize: 11; font.bold: true; color: compact.cpuTempFontColor
                Layout.minimumWidth: 35
            }
        }

        // ─── Sep before GPU Usage ───
        Rectangle {
            Layout.preferredWidth: 1; Layout.preferredHeight: 22; radius: 1
            color: "#585b70"; opacity: 0.35
            visible: compact.needsSeparatorBefore("gpuUsage")
        }

        // ─── GPU Memory Usage ───
        RowLayout {
            spacing: 5
            visible: compact.showGpuUsage

            Text {
                text: compact.gpuUsageIcon
                font.family: compact.safeFont(compact.gpuUsageFontFamily)
                font.pixelSize: 14; color: compact.gpuUsageIconColor
            }

            Text {
                text: compact.formatGpuMem(compact.gpuMemUsed)
                font.family: compact.safeFont(compact.gpuUsageFontFamily)
                font.pixelSize: 11; font.bold: true; color: compact.gpuUsageFontColor
                Layout.minimumWidth: 38
            }
        }

        // ─── Sep before GPU Temp ───
        Rectangle {
            Layout.preferredWidth: 1; Layout.preferredHeight: 22; radius: 1
            color: "#585b70"; opacity: 0.35
            visible: compact.needsSeparatorBefore("gpuTemp")
        }

        // ─── GPU Temp ───
        RowLayout {
            spacing: 5
            visible: compact.showGpuTemp

            Text {
                text: compact.gpuTempIcon
                font.family: compact.safeFont(compact.gpuTempFontFamily)
                font.pixelSize: 14; color: compact.gpuTempIconColor
            }

            Text {
                text: compact.gpuTemp.toFixed(0) + "°C"
                font.family: compact.safeFont(compact.gpuTempFontFamily)
                font.pixelSize: 11; font.bold: true; color: compact.gpuTempFontColor
                Layout.minimumWidth: 35
            }
        }

        // ─── Sep before Battery ───
        Rectangle {
            Layout.preferredWidth: 1; Layout.preferredHeight: 22; radius: 1
            color: "#585b70"; opacity: 0.35
            visible: compact.needsSeparatorBefore("battery")
        }

        // ─── Battery ───
        RowLayout {
            spacing: 5
            visible: compact.showBattery && compact.batteryAvailable

            Text {
                text: compact.batteryIcon
                font.family: compact.safeFont(compact.batteryFontFamily)
                font.pixelSize: 14; color: compact.batteryIconColor
            }

            Text {
                text: compact.batteryPercent.toFixed(0) + "%"
                font.family: compact.safeFont(compact.batteryFontFamily)
                font.pixelSize: 11; font.bold: true; color: compact.batteryFontColor
                Layout.minimumWidth: 32
            }
        }
    }

    // ─── Hover Tooltip (KDE native Dialog) ───
    PlasmaCore.Dialog {
        id: hoverDialog
        visualParent: compact
        location: PlasmaCore.Types.Floating
        type: PlasmaCore.Dialog.Tooltip
        flags: Qt.WindowStaysOnTopHint | Qt.ToolTip
        hideOnWindowDeactivate: false

        mainItem: MouseArea {
            id: hoverPopupArea
            width: 300
            height: popupContent.implicitHeight + 28
            hoverEnabled: true

            onContainsMouseChanged: {
                if (containsMouse) {
                    hoverHideTimer.stop()
                } else if (!compact.containsMouse) {
                    hoverHideTimer.restart()
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: "#1e1e2e"
                border.color: "#313244"
                border.width: 1
            }

            ColumnLayout {
                id: popupContent
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                // Header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "☄"; font.pixelSize: 14; color: "#f9e2af" }
                    Text {
                        text: "Quick Stats"
                        font.pixelSize: 12; font.bold: true
                        font.family: compact.safeFont(compact.netFontFamily)
                        color: "#cdd6f4"; font.letterSpacing: 0.5
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a"; opacity: 0.5 }

                // Traffic Today card
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: todayCol.implicitHeight + 18
                    radius: 10; color: "#181825"
                    border.color: "#313244"; border.width: 1

                    Rectangle {
                        width: 3; radius: 2
                        anchors { left: parent.left; top: parent.top; topMargin: 10; bottom: parent.bottom; bottomMargin: 10 }
                        color: compact.netIconColor; opacity: 0.75
                    }

                    ColumnLayout {
                        id: todayCol
                        anchors.fill: parent; anchors.margins: 9; anchors.leftMargin: 14
                        spacing: 4

                        RowLayout {
                            spacing: 8
                            Text { text: "󰃭"; font.family: compact.safeFont(compact.netFontFamily); font.pixelSize: 13; color: compact.netIconColor }
                            Text {
                                text: "Today"; font.pixelSize: 11; font.bold: true; color: compact.netIconColor
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                        }

                        RowLayout {
                            spacing: 8
                            Text { text: "▼"; color: compact.netDownColor; font.pixelSize: 9 }
                            Text {
                                text: "Down"; font.pixelSize: 10; color: "#a6adc8"
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: compact.formatBytes(compact.trafficTodayDown)
                                font.pixelSize: 10; font.bold: true; color: compact.netDownColor
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                        }

                        RowLayout {
                            spacing: 8
                            Text { text: "▲"; color: compact.netUpColor; font.pixelSize: 9 }
                            Text {
                                text: "Up"; font.pixelSize: 10; color: "#a6adc8"
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: compact.formatBytes(compact.trafficTodayUp)
                                font.pixelSize: 10; font.bold: true; color: compact.netUpColor
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                        }
                    }
                }

                // Traffic This Month card
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: monthCol.implicitHeight + 18
                    radius: 10; color: "#181825"
                    border.color: "#313244"; border.width: 1

                    Rectangle {
                        width: 3; radius: 2
                        anchors { left: parent.left; top: parent.top; topMargin: 10; bottom: parent.bottom; bottomMargin: 10 }
                        color: "#cba6f7"; opacity: 0.75
                    }

                    ColumnLayout {
                        id: monthCol
                        anchors.fill: parent; anchors.margins: 9; anchors.leftMargin: 14
                        spacing: 4

                        RowLayout {
                            spacing: 8
                            Text { text: "󰸗"; font.family: compact.safeFont(compact.netFontFamily); font.pixelSize: 13; color: "#cba6f7" }
                            Text {
                                text: "This Month"; font.pixelSize: 11; font.bold: true; color: "#cba6f7"
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                        }

                        RowLayout {
                            spacing: 8
                            Text { text: "▼"; color: compact.netDownColor; font.pixelSize: 9 }
                            Text {
                                text: "Down"; font.pixelSize: 10; color: "#a6adc8"
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: compact.formatBytes(compact.trafficMonthDown)
                                font.pixelSize: 10; font.bold: true; color: compact.netDownColor
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                        }

                        RowLayout {
                            spacing: 8
                            Text { text: "▲"; color: compact.netUpColor; font.pixelSize: 9 }
                            Text {
                                text: "Up"; font.pixelSize: 10; color: "#a6adc8"
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: compact.formatBytes(compact.trafficMonthUp)
                                font.pixelSize: 10; font.bold: true; color: compact.netUpColor
                                font.family: compact.safeFont(compact.netFontFamily)
                            }
                        }
                    }
                }

                // CPU Freq card
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: freqRow.implicitHeight + 18
                    radius: 10; color: "#181825"
                    border.color: "#313244"; border.width: 1

                    Rectangle {
                        width: 3; radius: 2
                        anchors { left: parent.left; top: parent.top; topMargin: 10; bottom: parent.bottom; bottomMargin: 10 }
                        color: compact.cpuIconColor; opacity: 0.75
                    }

                    RowLayout {
                        id: freqRow
                        anchors.fill: parent; anchors.margins: 9; anchors.leftMargin: 14
                        spacing: 10

                        Text {
                            text: ""; font.family: compact.safeFont(compact.cpuFontFamily)
                            font.pixelSize: 14; color: compact.cpuIconColor
                        }
                        Text {
                            text: "CPU Freq"; font.pixelSize: 11; font.bold: true; color: compact.cpuIconColor
                            font.family: compact.safeFont(compact.cpuFontFamily)
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: compact.cpuFreqGHz > 0 ? compact.cpuFreqGHz.toFixed(2) + " GHz" : "—"
                            font.pixelSize: 12; font.bold: true; color: compact.cpuFontColor
                            font.family: compact.safeFont(compact.cpuFontFamily)
                        }
                    }
                }

                // Hard Disk Usage card
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: diskCol.implicitHeight + 18
                    radius: 10; color: "#181825"
                    border.color: "#313244"; border.width: 1

                    Rectangle {
                        width: 3; radius: 2
                        anchors { left: parent.left; top: parent.top; topMargin: 10; bottom: parent.bottom; bottomMargin: 10 }
                        color: "#94e2d5"; opacity: 0.75
                    }

                    ColumnLayout {
                        id: diskCol
                        anchors.fill: parent; anchors.margins: 9; anchors.leftMargin: 14
                        spacing: 6

                        RowLayout {
                            spacing: 10
                            Text {
                                text: "󰋊"; font.family: compact.safeFont(compact.ramFontFamily)
                                font.pixelSize: 14; color: "#94e2d5"
                            }
                            Text {
                                text: "Hard Disk"; font.pixelSize: 11; font.bold: true; color: "#94e2d5"
                                font.family: compact.safeFont(compact.ramFontFamily)
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: compact.diskUsagePercent.toFixed(0) + "%"
                                font.pixelSize: 12; font.bold: true; color: compact.ramFontColor
                                font.family: compact.safeFont(compact.ramFontFamily)
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true; height: 6; radius: 3; color: "#313244"
                            Rectangle {
                                width: parent.width * Math.min(1, compact.diskUsagePercent / 100)
                                height: parent.height; radius: 3
                                color: compact.diskUsagePercent > 90 ? "#f38ba8" : compact.diskUsagePercent > 75 ? "#fab387" : "#94e2d5"
                                Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                            }
                        }

                        Text {
                            visible: compact.diskUsageText.length > 0
                            text: compact.diskUsageText
                            font.pixelSize: 9; color: "#6c7086"
                            font.family: compact.safeFont(compact.ramFontFamily)
                        }
                    }
                }
            }
        }
    }
}