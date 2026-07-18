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

    property alias cfg_showNet: showNetCheck.checked
    property alias cfg_netSpeedInline: netInlineCheck.checked
    property alias cfg_netIcon: netIconField.text
    property alias cfg_netIconColor: netIconColorField.text
    property alias cfg_netFontFamily: netFontField.text
    property alias cfg_netFontColor: netFontColorField.text
    property alias cfg_netDownColor: netDownColorField.text
    property alias cfg_netUpColor: netUpColorField.text

    property alias cfg_showCpu: showCpuCheck.checked
    property alias cfg_cpuIcon: cpuIconField.text
    property alias cfg_cpuIconColor: cpuIconColorField.text
    property alias cfg_cpuFontFamily: cpuFontField.text
    property alias cfg_cpuFontColor: cpuFontColorField.text

    property alias cfg_showRam: showRamCheck.checked
    property alias cfg_ramIcon: ramIconField.text
    property alias cfg_ramIconColor: ramIconColorField.text
    property alias cfg_ramFontFamily: ramFontField.text
    property alias cfg_ramFontColor: ramFontColorField.text

    property var activeColorField: null

    function openColorPicker(field) {
        activeColorField = field
        colorDialog.selectedColor = field.text
        colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        title: i18n("Choose Color")
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
            Kirigami.FormData.label: i18n("General")
        }

        ColumnLayout {
            Kirigami.FormData.label: i18n("Refresh:")
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

        // ─── NET SPEED ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Net Speed")
        }

        CheckBox {
            id: showNetCheck
            Kirigami.FormData.label: i18n("Show:")
            text: i18n("Show Net Speed")
        }

        CheckBox {
            id: netInlineCheck
            Kirigami.FormData.label: i18n("Panel Layout:")
            text: i18n("Side-by-side download/upload")
            enabled: showNetCheck.checked
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Logo:")
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
            Kirigami.FormData.label: i18n("Logo Color:")
            spacing: 10

            TextField {
                id: netIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#89b4fa"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: netIconColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netIconColorField)
                }
            }
        }

        TextField {
            id: netFontField
            Kirigami.FormData.label: i18n("Font:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Font Color:")
            spacing: 10

            TextField {
                id: netFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#cdd6f4"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: netFontColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netFontColorField)
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Download Color:")
            spacing: 10

            TextField {
                id: netDownColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: netDownColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netDownColorField)
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Upload Color:")
            spacing: 10

            TextField {
                id: netUpColorField
                Layout.preferredWidth: 120
                placeholderText: "#f38ba8"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: netUpColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(netUpColorField)
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
            Kirigami.FormData.label: i18n("Show:")
            text: i18n("Show CPU")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Logo:")
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
            Kirigami.FormData.label: i18n("Logo Color:")
            spacing: 10

            TextField {
                id: cpuIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#cba6f7"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: cpuIconColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(cpuIconColorField)
                }
            }
        }

        TextField {
            id: cpuFontField
            Kirigami.FormData.label: i18n("Font:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Font Color:")
            spacing: 10

            TextField {
                id: cpuFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: cpuFontColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(cpuFontColorField)
                }
            }
        }

        // ─── RAM ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("RAM")
        }

        CheckBox {
            id: showRamCheck
            Kirigami.FormData.label: i18n("Show:")
            text: i18n("Show RAM")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Logo:")
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
            Kirigami.FormData.label: i18n("Logo Color:")
            spacing: 10

            TextField {
                id: ramIconColorField
                Layout.preferredWidth: 120
                placeholderText: "#a6e3a1"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: ramIconColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(ramIconColorField)
                }
            }
        }

        TextField {
            id: ramFontField
            Kirigami.FormData.label: i18n("Font:")
            Layout.preferredWidth: 260
            placeholderText: "JetBrainsMono Nerd Font"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Font Color:")
            spacing: 10

            TextField {
                id: ramFontColorField
                Layout.preferredWidth: 120
                placeholderText: "#f9e2af"
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: ramFontColorField.text
                border.color: "#585b70"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: scrollRoot.openColorPicker(ramFontColorField)
                }
            }
        }

        // ─── PRESETS ───
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Quick Presets")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Theme:")
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
                }
            }
        }

        Label {
            Kirigami.FormData.label: i18n("Tip:")
            text: i18n("Use Nerd Font glyphs for logos.\nRecommended: JetBrainsMono Nerd Font.")
            opacity: 0.65
            wrapMode: Text.WordWrap
        }
    }
}
