import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import org.kde.kirigami 2.20 as Kirigami

ScrollView {
    id: scrollRoot

    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    property alias cfg_refreshInterval: refreshSlider.value

    // Compact panel separator spacing
    property alias cfg_separatorSpacing: separatorSpacingSlider.value

    // NET SPEED
    property alias cfg_showNet: showNetCheck.checked
    property alias cfg_netSpeedInline: netInlineCheck.checked
    property alias cfg_netIcon: netIconField.text
    property alias cfg_netIconColor: netIconColorField.text
    property alias cfg_netFontFamily: netFontField.text
    property alias cfg_netFontColor: netFontColorField.text
    property alias cfg_netDownColor: netDownColorField.text
    property alias cfg_netUpColor: netUpColorField.text

    // CPU
    property alias cfg_showCpu: showCpuCheck.checked
    property alias cfg_cpuIcon: cpuIconField.text
    property alias cfg_cpuIconColor: cpuIconColorField.text
    property alias cfg_cpuFontFamily: cpuFontField.text
    property alias cfg_cpuFontColor: cpuFontColorField.text

    // RAM
    property alias cfg_showRam: showRamCheck.checked
    property alias cfg_ramIcon: ramIconField.text
    property alias cfg_ramIconColor: ramIconColorField.text
    property alias cfg_ramFontFamily: ramFontField.text
    property alias cfg_ramFontColor: ramFontColorField.text

    // CPU Temp
    property alias cfg_showCpuTemp: showCpuTempCheck.checked
    property alias cfg_cpuTempIcon: cpuTempIconField.text
    property alias cfg_cpuTempIconColor: cpuTempIconColorField.text
    property alias cfg_cpuTempFontFamily: cpuTempFontField.text
    property alias cfg_cpuTempFontColor: cpuTempFontColorField.text

    // GPU Usage
    property alias cfg_showGpuUsage: showGpuUsageCheck.checked
    property alias cfg_gpuUsageIcon: gpuUsageIconField.text
    property alias cfg_gpuUsageIconColor: gpuUsageIconColorField.text
    property alias cfg_gpuUsageFontFamily: gpuUsageFontField.text
    property alias cfg_gpuUsageFontColor: gpuUsageFontColorField.text

    // GPU Temp
    property alias cfg_showGpuTemp: showGpuTempCheck.checked
    property int cfg_gpuType: 0
    property alias cfg_gpuTempIcon: gpuTempIconField.text
    property alias cfg_gpuTempIconColor: gpuTempIconColorField.text
    property alias cfg_gpuTempFontFamily: gpuTempFontField.text
    property alias cfg_gpuTempFontColor: gpuTempFontColorField.text


    // Battery
    property alias cfg_showBattery: showBatteryCheck.checked
    property alias cfg_batteryIcon: batteryIconField.text
    property alias cfg_batteryIconColor: batteryIconColorField.text
    property alias cfg_batteryFontFamily: batteryFontField.text
    property alias cfg_batteryFontColor: batteryFontColorField.text

    property var activeColorField: null

    function openColorPicker(field) {
        activeColorField = field
        colorDialog.selectedColor = field.text
        colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        title: i18n("Escolher cor")
        onAccepted: {
            if (scrollRoot.activeColorField) {
                scrollRoot.activeColorField.text = selectedColor.toString()
            }
        }
    }

    Kirigami.FormLayout {
        id: formLayout
        width: scrollRoot.availableWidth

        // ─── GENERAL ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Geral")
        }

        ColumnLayout {
            Kirigami.FormData.label: i18n("Atualização:")
            spacing: 4

            Slider {
                id: refreshSlider
                from: 500
                to: 5000
                stepSize: 250
                Layout.preferredWidth: 260
            }

            Label {
                text: Math.round(refreshSlider.value) + " ms"
                opacity: 0.7
            }
        }

        // ─── Separator Spacing (Compact Panel) ───
        ColumnLayout {
            Kirigami.FormData.label: i18n("Espaçamento do separador:")
            spacing: 4

            Slider {
                id: separatorSpacingSlider
                from: 0
                to: 20
                stepSize: 1
                Layout.preferredWidth: 260
            }

            Label {
                text: Math.round(separatorSpacingSlider.value) + " px  (espaço ao redor do separador | no painel)"
                opacity: 0.7
            }
        }

        // ─── NET SPEED ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Velocidade da rede")
        }

        CheckBox {
            id: showNetCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar velocidade da rede")
        }

        CheckBox {
            id: netInlineCheck
            Kirigami.FormData.label: i18n("Layout do painel:")
            text: i18n("Download/upload lado a lado")
            enabled: showNetCheck.checked
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: netIconField
                Layout.preferredWidth: 90
                font.family: netFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: netIconField.text
                font.family: netFontField.text
                font.pixelSize: 26
                color: netIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: netIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#89b4fa"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: netIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netIconColorField)
                }
            }
        }

        TextField {
            id: netFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: netFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#cdd6f4"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: netFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netFontColorField)
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do download:")
            spacing: 10

            TextField {
                id: netDownColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: netDownColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netDownColorField)
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do upload:")
            spacing: 10

            TextField {
                id: netUpColorField
                Layout.preferredWidth: 120
                placeholderText: "#f38ba8"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: netUpColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netUpColorField)
                }
            }
        }


        // ─── RAM ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Memória RAM")
        }

        CheckBox {
            id: showRamCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar memória RAM")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: ramIconField
                Layout.preferredWidth: 90
                font.family: ramFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: ramIconField.text
                font.family: ramFontField.text
                font.pixelSize: 26
                color: ramIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: ramIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: ramIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(ramIconColorField)
                }
            }
        }

        TextField {
            id: ramFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: ramFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#f9e2af"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: ramFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(ramFontColorField)
                }
            }
        }

        // ─── CPU ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("CPU")
        }

        CheckBox {
            id: showCpuCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar CPU")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: cpuIconField
                Layout.preferredWidth: 90
                font.family: cpuFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: cpuIconField.text
                font.family: cpuFontField.text
                font.pixelSize: 26
                color: cpuIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: cpuIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#cba6f7"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: cpuIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(cpuIconColorField)
                }
            }
        }

        TextField {
            id: cpuFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: cpuFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: cpuFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(cpuFontColorField)
                }
            }
        }


        // ─── CPU TEMP ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Temperatura da CPU")
        }

        CheckBox {
            id: showCpuTempCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar temperatura da CPU")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: cpuTempIconField
                Layout.preferredWidth: 90
                font.family: cpuTempFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: cpuTempIconField.text
                font.family: cpuTempFontField.text
                font.pixelSize: 26
                color: cpuTempIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: cpuTempIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#fab387"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: cpuTempIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(cpuTempIconColorField)
                }
            }
        }

        TextField {
            id: cpuTempFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: cpuTempFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#f38ba8"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: cpuTempFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(cpuTempFontColorField)
                }
            }
        }


        // ─── GPU USAGE ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Uso de memória da GPU")
        }

        CheckBox {
            id: showGpuUsageCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar memória da GPU")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: gpuUsageIconField
                Layout.preferredWidth: 90
                font.family: gpuUsageFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: gpuUsageIconField.text
                font.family: gpuUsageFontField.text
                font.pixelSize: 26
                color: gpuUsageIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: gpuUsageIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#89dceb"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: gpuUsageIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(gpuUsageIconColorField)
                }
            }
        }

        TextField {
            id: gpuUsageFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: gpuUsageFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#cdd6f4"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: gpuUsageFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(gpuUsageFontColorField)
                }
            }
        }

        // ─── GPU TEMP ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Temperatura da GPU")
        }

        CheckBox {
            id: showGpuTempCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar temperatura da GPU")
        }

        ComboBox {
            id: gpuTypeCombo
            Kirigami.FormData.label: i18n("Tipo de GPU:")
            model: ["NVIDIA", "AMD", "Intel"]
            currentIndex: scrollRoot.cfg_gpuType
            onCurrentIndexChanged: scrollRoot.cfg_gpuType = currentIndex
            Layout.preferredWidth: 200
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: gpuTempIconField
                Layout.preferredWidth: 90
                font.family: gpuTempFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: gpuTempIconField.text
                font.family: gpuTempFontField.text
                font.pixelSize: 26
                color: gpuTempIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: gpuTempIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#94e2d5"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: gpuTempIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(gpuTempIconColorField)
                }
            }
        }

        TextField {
            id: gpuTempFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: gpuTempFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#f9e2af"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: gpuTempFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(gpuTempFontColorField)
                }
            }
        }

        // ─── BATTERY ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Bateria")
        }

        CheckBox {
            id: showBatteryCheck
            Kirigami.FormData.label: i18n("Mostrar:")
            text: i18n("Mostrar % da bateria")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ícone:")
            spacing: 10

            TextField {
                id: batteryIconField
                Layout.preferredWidth: 90
                font.family: batteryFontField.text
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: batteryIconField.text
                font.family: batteryFontField.text
                font.pixelSize: 26
                color: batteryIconColorField.text
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor do ícone:")
            spacing: 10

            TextField {
                id: batteryIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: batteryIconColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(batteryIconColorField)
                }
            }
        }

        TextField {
            id: batteryFontField
            Kirigami.FormData.label: i18n("Fonte:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Cor da fonte:")
            spacing: 10

            TextField {
                id: batteryFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#f9e2af"
            }

            Rectangle {
                width: 24; height: 24; radius: 12
                color: batteryFontColorField.text
                border.color: "#585b70"; border.width: 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(batteryFontColorField)
                }
            }
        }

        // ─── RESET TO DEFAULT ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Redefinir")
        }

        Button {
            Kirigami.FormData.label: i18n("Ação:")
            text: i18n("Redefinir todas as configurações")
            icon.name: "edit-undo"
            onClicked: {

                // General
                refreshSlider.value = 1500
                separatorSpacingSlider.value = 6

                // Net Speed
                showNetCheck.checked = true
                netInlineCheck.checked = false
                netIconField.text = "󰓅"
                netIconColorField.text = "#89b4fa"
                netFontField.text = "JetBrainsMono Nerd Font"
                netFontColorField.text = "#cdd6f4"
                netDownColorField.text = "#a6e3a1"
                netUpColorField.text = "#f38ba8"

                // RAM
                showRamCheck.checked = true
                ramIconField.text = ""
                ramIconColorField.text = "#a6e3a1"
                ramFontField.text = "JetBrainsMono Nerd Font"
                ramFontColorField.text = "#f9e2af"

                // CPU
                showCpuCheck.checked = true
                cpuIconField.text = ""
                cpuIconColorField.text = "#cba6f7"
                cpuFontField.text = "JetBrainsMono Nerd Font"
                cpuFontColorField.text = "#a6e3a1"

                // CPU Temp
                showCpuTempCheck.checked = true
                cpuTempIconField.text = ""
                cpuTempIconColorField.text = "#fab387"
                cpuTempFontField.text = "JetBrainsMono Nerd Font"
                cpuTempFontColorField.text = "#f38ba8"

                // GPU Usage
                showGpuUsageCheck.checked = true
                gpuUsageIconField.text = "󰾲"
                gpuUsageIconColorField.text = "#89dceb"
                gpuUsageFontField.text = "JetBrainsMono Nerd Font"
                gpuUsageFontColorField.text = "#cdd6f4"

                // GPU Temp
                showGpuTempCheck.checked = true
                gpuTypeCombo.currentIndex = 0
                gpuTempIconField.text = ""
                gpuTempIconColorField.text = "#94e2d5"
                gpuTempFontField.text = "JetBrainsMono Nerd Font"
                gpuTempFontColorField.text = "#f9e2af"

                // Battery
                showBatteryCheck.checked = true
                batteryIconField.text = "󰁹"
                batteryIconColorField.text = "#a6e3a1"
                batteryFontField.text = "JetBrainsMono Nerd Font"
                batteryFontColorField.text = "#f9e2af"
            }
        }

        // ─── PRESETS ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Predefinições rápidas")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Tema:")
            spacing: 8

            Button {
                text: "Catppuccin"
                onClicked: {
                    netIconColorField.text = "#89b4fa"
                    netFontColorField.text = "#cdd6f4"
                    netDownColorField.text = "#a6e3a1"
                    netUpColorField.text = "#f38ba8"

                    cpuIconColorField.text = "#cba6f7"
                    cpuFontColorField.text = "#a6e3a1"

                    ramIconColorField.text = "#a6e3a1"
                    ramFontColorField.text = "#f9e2af"

                    cpuTempIconColorField.text = "#fab387"
                    cpuTempFontColorField.text = "#f38ba8"

                    gpuTempIconColorField.text = "#94e2d5"
                    gpuTempFontColorField.text = "#f9e2af"

                    gpuUsageIconColorField.text = "#89dceb"
                    gpuUsageFontColorField.text = "#cdd6f4"

                    batteryIconColorField.text = "#a6e3a1"
                    batteryFontColorField.text = "#f9e2af"
                }
            }

            Button {
                text: "Tokyo Night"
                onClicked: {
                    netIconColorField.text = "#7aa2f7"
                    netFontColorField.text = "#c0caf5"
                    netDownColorField.text = "#9ece6a"
                    netUpColorField.text = "#f7768e"

                    cpuIconColorField.text = "#bb9af7"
                    cpuFontColorField.text = "#9ece6a"

                    ramIconColorField.text = "#9ece6a"
                    ramFontColorField.text = "#e0af68"

                    cpuTempIconColorField.text = "#ff9e64"
                    cpuTempFontColorField.text = "#f7768e"

                    gpuTempIconColorField.text = "#2ac3de"
                    gpuTempFontColorField.text = "#e0af68"

                    gpuUsageIconColorField.text = "#7dcfff"
                    gpuUsageFontColorField.text = "#c0caf5"

                    batteryIconColorField.text = "#9ece6a"
                    batteryFontColorField.text = "#e0af68"
                }
            }

            Button {
                text: "Nord"
                onClicked: {
                    netIconColorField.text = "#88c0d0"
                    netFontColorField.text = "#eceff4"
                    netDownColorField.text = "#a3be8c"
                    netUpColorField.text = "#bf616a"

                    cpuIconColorField.text = "#b48ead"
                    cpuFontColorField.text = "#a3be8c"

                    ramIconColorField.text = "#a3be8c"
                    ramFontColorField.text = "#ebcb8b"

                    cpuTempIconColorField.text = "#d08770"
                    cpuTempFontColorField.text = "#bf616a"

                    gpuTempIconColorField.text = "#8fbcbb"
                    gpuTempFontColorField.text = "#ebcb8b"

                    gpuUsageIconColorField.text = "#88c0d0"
                    gpuUsageFontColorField.text = "#eceff4"

                    batteryIconColorField.text = "#a3be8c"
                    batteryFontColorField.text = "#ebcb8b"
                }
            }
        }

        Label {
            Kirigami.FormData.label: i18n("Dica:")
            text: i18n("Use glifos de Nerd Font nos ícones.\nRecomendado: JetBrainsMono Nerd Font.\n\nGPU: selecione o tipo de GPU para leitura correta de temperatura/memória.\nNVIDIA requer nvidia-smi.\nAMD/Intel usa sensores sysfs.")
            opacity: 0.65
            wrapMode: Text.WordWrap
        }
    }
}