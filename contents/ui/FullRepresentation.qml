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

    property double cpuTemp: 0
    property double gpuTemp: 0
    property double gpuMemUsed: 0
    property double gpuMemTotal: 0
    property double batteryPercent: 0
    property string batteryStatus: "Unknown"
    property bool batteryAvailable: false

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

    function formatGpuMem(mb) {
        if (mb >= 1024) return (mb / 1024).toFixed(1) + " GB"
        return mb.toFixed(0) + " MB"
    }

    function batteryStatusLabel(s) {
        if (s === "Charging") return "⚡ Carregando"
        if (s === "Discharging") return "🔋 Descarregando"
        if (s === "Full") return "🔋 Completa"
        if (s === "Not charging") return "🔌 Não carregando"
        if (s === "Unknown") return "🔌 Desconhecido"
        return "🔌 " + s
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

        // Header
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Text { text: "☄"; font.pixelSize: 20; color: "#f9e2af" }
            Text {
                text: "Meteoris"
                font.pixelSize: 18; font.bold: true
                font.family: full.safeFont(full.netFontFamily)
                color: "#cdd6f4"; font.letterSpacing: 1
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#45475a"; opacity: 0.5 }

        // ─── Quick Toggles ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: optionsCol.implicitHeight + 24
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1

            ColumnLayout {
                id: optionsCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "Opções de exibição"
                    font.pixelSize: 13; font.bold: true; color: "#f9e2af"
                    font.family: full.safeFont(full.netFontFamily)
                }

                RowLayout {
                    spacing: 14

                    Switch {
                        text: "Rede"
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
                    spacing: 14

                    Switch {
                        text: "CPU °C"
                        checked: full.showCpuTemp
                        onToggled: Plasmoid.configuration.showCpuTemp = checked
                    }
                    Switch {
                        text: "GPU °C"
                        checked: full.showGpuTemp
                        onToggled: Plasmoid.configuration.showGpuTemp = checked
                    }
                    Switch {
                        text: "Mem. GPU"
                        checked: full.showGpuUsage
                        onToggled: Plasmoid.configuration.showGpuUsage = checked
                    }
                }

                RowLayout {
                    spacing: 14

                    Switch {
                        text: "Bateria"
                        checked: full.showBattery
                        onToggled: Plasmoid.configuration.showBattery = checked
                    }
                }

                RowLayout {
                    visible: full.showNet
                    spacing: 10

                    Text {
                        text: "Layout da rede no painel"; font.pixelSize: 11; color: "#a6adc8"
                        font.family: full.safeFont(full.netFontFamily)
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: inlineSwitch.checked ? "Lado a lado" : "Empilhado"
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

        // ─── Net Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: netCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showNet

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.netIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: netCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.netIcon; font.family: full.safeFont(full.netFontFamily); font.pixelSize: 22; color: full.netIconColor }
                    Text { text: "Rede"; font.pixelSize: 14; font.bold: true; color: full.netIconColor; font.family: full.safeFont(full.netFontFamily) }
                }

                RowLayout {
                    spacing: 10
                    Text { text: "▼"; color: full.netDownColor; font.pixelSize: 11 }
                    Text { text: "Download"; font.pixelSize: 11; color: "#a6adc8"; font.family: full.safeFont(full.netFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.formatSpeed(full.netDown); font.pixelSize: 12; font.bold: true; color: full.netDownColor; font.family: full.safeFont(full.netFontFamily) }
                }

                RowLayout {
                    spacing: 10
                    Text { text: "▲"; color: full.netUpColor; font.pixelSize: 11 }
                    Text { text: "Upload"; font.pixelSize: 11; color: "#a6adc8"; font.family: full.safeFont(full.netFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.formatSpeed(full.netUp); font.pixelSize: 12; font.bold: true; color: full.netUpColor; font.family: full.safeFont(full.netFontFamily) }
                }
            }
        }

        // ─── RAM Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: ramCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showRam

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.ramIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: ramCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.ramIcon; font.family: full.safeFont(full.ramFontFamily); font.pixelSize: 20; color: full.ramIconColor }
                    Text { text: "RAM"; font.pixelSize: 14; font.bold: true; color: full.ramIconColor; font.family: full.safeFont(full.ramFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.ramUsedGB.toFixed(1) + " / " + full.ramTotalGB.toFixed(1) + " GB"; font.pixelSize: 12; font.bold: true; color: full.ramFontColor; font.family: full.safeFont(full.ramFontFamily) }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 10; radius: 5; color: "#313244"
                    Rectangle {
                        width: parent.width * Math.min(1, full.ramPercent / 100)
                        height: parent.height; radius: 5; color: full.ramIconColor
                        Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                    }
                }

                RowLayout {
                    spacing: 6
                    Text { text: full.ramPercent.toFixed(1) + "% em uso"; font.pixelSize: 10; color: "#6c7086"; font.family: full.safeFont(full.ramFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: (full.ramTotalGB - full.ramUsedGB).toFixed(1) + " GB livres"; font.pixelSize: 10; color: "#585b70"; font.family: full.safeFont(full.ramFontFamily) }
                }
            }
        }

        // ─── CPU Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: cpuCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showCpu

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.cpuIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: cpuCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.cpuIcon; font.family: full.safeFont(full.cpuFontFamily); font.pixelSize: 20; color: full.cpuIconColor }
                    Text { text: "CPU"; font.pixelSize: 14; font.bold: true; color: full.cpuIconColor; font.family: full.safeFont(full.cpuFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.cpuUsage.toFixed(1) + "%"; font.pixelSize: 18; font.bold: true; color: full.cpuFontColor; font.family: full.safeFont(full.cpuFontFamily) }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 10; radius: 5; color: "#313244"
                    Rectangle {
                        width: parent.width * Math.min(1, full.cpuUsage / 100)
                        height: parent.height; radius: 5; color: full.cpuIconColor
                        Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                    }
                }
            }
        }

        // ─── CPU Temp Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: cpuTempCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showCpuTemp

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.cpuTempIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: cpuTempCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.cpuTempIcon; font.family: full.safeFont(full.cpuTempFontFamily); font.pixelSize: 20; color: full.cpuTempIconColor }
                    Text { text: "Temp. da CPU"; font.pixelSize: 14; font.bold: true; color: full.cpuTempIconColor; font.family: full.safeFont(full.cpuTempFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.cpuTemp.toFixed(0) + "°C"; font.pixelSize: 18; font.bold: true; color: full.cpuTempFontColor; font.family: full.safeFont(full.cpuTempFontFamily) }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 10; radius: 5; color: "#313244"
                    Rectangle {
                        width: parent.width * Math.min(1, full.cpuTemp / 100)
                        height: parent.height; radius: 5
                        color: full.cpuTemp > 80 ? "#f38ba8" : full.cpuTemp > 60 ? "#fab387" : full.cpuTempIconColor
                        Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                    }
                }
            }
        }


        // ─── GPU Memory Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: gpuMemCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showGpuUsage && full.gpuMemTotal > 0

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.gpuUsageIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: gpuMemCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.gpuUsageIcon; font.family: full.safeFont(full.gpuUsageFontFamily); font.pixelSize: 20; color: full.gpuUsageIconColor }
                    Text { text: "Memória da GPU"; font.pixelSize: 14; font.bold: true; color: full.gpuUsageIconColor; font.family: full.safeFont(full.gpuUsageFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: full.formatGpuMem(full.gpuMemUsed) + " / " + full.formatGpuMem(full.gpuMemTotal)
                        font.pixelSize: 12; font.bold: true; color: full.gpuUsageFontColor
                        font.family: full.safeFont(full.gpuUsageFontFamily)
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 10; radius: 5; color: "#313244"
                    Rectangle {
                        width: parent.width * (full.gpuMemTotal > 0 ? Math.min(1, full.gpuMemUsed / full.gpuMemTotal) : 0)
                        height: parent.height; radius: 5; color: full.gpuUsageIconColor
                        Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                    }
                }

                RowLayout {
                    spacing: 6
                    Text {
                        text: (full.gpuMemTotal > 0 ? (full.gpuMemUsed / full.gpuMemTotal * 100).toFixed(1) : "0.0") + "% em uso"
                        font.pixelSize: 10; color: "#6c7086"; font.family: full.safeFont(full.gpuUsageFontFamily)
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: full.formatGpuMem(Math.max(0, full.gpuMemTotal - full.gpuMemUsed)) + " livre"
                        font.pixelSize: 10; color: "#585b70"; font.family: full.safeFont(full.gpuUsageFontFamily)
                    }
                }
            }
        }

        // ─── GPU Temp Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: gpuTempCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showGpuTemp

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.gpuTempIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: gpuTempCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.gpuTempIcon; font.family: full.safeFont(full.gpuTempFontFamily); font.pixelSize: 20; color: full.gpuTempIconColor }
                    Text { text: "Temp. da GPU"; font.pixelSize: 14; font.bold: true; color: full.gpuTempIconColor; font.family: full.safeFont(full.gpuTempFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.gpuTemp.toFixed(0) + "°C"; font.pixelSize: 18; font.bold: true; color: full.gpuTempFontColor; font.family: full.safeFont(full.gpuTempFontFamily) }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 10; radius: 5; color: "#313244"
                    Rectangle {
                        width: parent.width * Math.min(1, full.gpuTemp / 100)
                        height: parent.height; radius: 5
                        color: full.gpuTemp > 80 ? "#f38ba8" : full.gpuTemp > 60 ? "#fab387" : full.gpuTempIconColor
                        Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                    }
                }
            }
        }

        // ─── Battery Card ───
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: batCol.implicitHeight + 28
            radius: 14; color: "#181825"
            border.color: "#313244"; border.width: 1
            visible: full.showBattery && full.batteryAvailable

            Rectangle {
                width: 3; radius: 2
                anchors { left: parent.left; top: parent.top; topMargin: 14; bottom: parent.bottom; bottomMargin: 14 }
                color: full.batteryIconColor; opacity: 0.75
            }

            ColumnLayout {
                id: batCol
                anchors.fill: parent; anchors.margins: 14; anchors.leftMargin: 18
                spacing: 10

                RowLayout {
                    spacing: 10
                    Text { text: full.batteryIcon; font.family: full.safeFont(full.batteryFontFamily); font.pixelSize: 20; color: full.batteryIconColor }
                    Text { text: "Bateria"; font.pixelSize: 14; font.bold: true; color: full.batteryIconColor; font.family: full.safeFont(full.batteryFontFamily) }
                    Item { Layout.fillWidth: true }
                    Text { text: full.batteryPercent.toFixed(0) + "%"; font.pixelSize: 18; font.bold: true; color: full.batteryFontColor; font.family: full.safeFont(full.batteryFontFamily) }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 10; radius: 5; color: "#313244"
                    Rectangle {
                        width: parent.width * Math.min(1, full.batteryPercent / 100)
                        height: parent.height; radius: 5
                        color: full.batteryPercent > 50 ? full.batteryIconColor : full.batteryPercent > 20 ? "#fab387" : "#f38ba8"
                        Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                    }
                }

                RowLayout {
                    spacing: 6
                    Text {
                        text: full.batteryStatusLabel(full.batteryStatus)
                        font.pixelSize: 10; color: "#6c7086"; font.family: full.safeFont(full.batteryFontFamily)
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: full.batteryPercent.toFixed(0) + "% restante"
                        font.pixelSize: 10; color: "#585b70"; font.family: full.safeFont(full.batteryFontFamily)
                    }
                }
            }
        }

        // ─── Footer ───
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            Text { text: "☄"; font.pixelSize: 11; color: "#585b70" }
            Text {
                text: "Meteoris v2.2 por SiyamX7"
                font.pixelSize: 10; color: "#585b70"
                font.family: full.safeFont(full.netFontFamily)
                font.italic: true
            }
        }
    }
}