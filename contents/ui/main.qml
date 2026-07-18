import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as P5Support

PlasmoidItem {
    id: root

    property double cpuUsage: 0.0
    property double ramUsedGB: 0.0
    property double ramTotalGB: 0.0
    property double ramPercent: 0.0
    property double netDown: 0.0
    property double netUp: 0.0
    property double prevDownBytes: 0.0
    property double prevUpBytes: 0.0
    property bool firstRun: true

    property bool showNet: Plasmoid.configuration.showNet
    property bool showCpu: Plasmoid.configuration.showCpu
    property bool showRam: Plasmoid.configuration.showRam
    property bool netSpeedInline: Plasmoid.configuration.netSpeedInline

    property string netIcon: Plasmoid.configuration.netIcon
    property string netIconColor: Plasmoid.configuration.netIconColor
    property string netFontFamily: Plasmoid.configuration.netFontFamily
    property string netFontColor: Plasmoid.configuration.netFontColor
    property string netDownColor: Plasmoid.configuration.netDownColor
    property string netUpColor: Plasmoid.configuration.netUpColor

    property string cpuIcon: Plasmoid.configuration.cpuIcon
    property string cpuIconColor: Plasmoid.configuration.cpuIconColor
    property string cpuFontFamily: Plasmoid.configuration.cpuFontFamily
    property string cpuFontColor: Plasmoid.configuration.cpuFontColor

    property string ramIcon: Plasmoid.configuration.ramIcon
    property string ramIconColor: Plasmoid.configuration.ramIconColor
    property string ramFontFamily: Plasmoid.configuration.ramFontFamily
    property string ramFontColor: Plasmoid.configuration.ramFontColor

    preferredRepresentation: compactRepresentation

    compactRepresentation: CompactRepresentation {
        cpuUsage: root.cpuUsage
        ramUsedGB: root.ramUsedGB
        ramTotalGB: root.ramTotalGB
        ramPercent: root.ramPercent
        netDown: root.netDown
        netUp: root.netUp

        showNet: root.showNet
        showCpu: root.showCpu
        showRam: root.showRam
        netSpeedInline: root.netSpeedInline

        netIcon: root.netIcon
        netIconColor: root.netIconColor
        netFontFamily: root.netFontFamily
        netFontColor: root.netFontColor
        netDownColor: root.netDownColor
        netUpColor: root.netUpColor

        cpuIcon: root.cpuIcon
        cpuIconColor: root.cpuIconColor
        cpuFontFamily: root.cpuFontFamily
        cpuFontColor: root.cpuFontColor

        ramIcon: root.ramIcon
        ramIconColor: root.ramIconColor
        ramFontFamily: root.ramFontFamily
        ramFontColor: root.ramFontColor
    }

    fullRepresentation: FullRepresentation {
        cpuUsage: root.cpuUsage
        ramUsedGB: root.ramUsedGB
        ramTotalGB: root.ramTotalGB
        ramPercent: root.ramPercent
        netDown: root.netDown
        netUp: root.netUp

        showNet: root.showNet
        showCpu: root.showCpu
        showRam: root.showRam
        netSpeedInline: root.netSpeedInline

        netIcon: root.netIcon
        netIconColor: root.netIconColor
        netFontFamily: root.netFontFamily
        netFontColor: root.netFontColor
        netDownColor: root.netDownColor
        netUpColor: root.netUpColor

        cpuIcon: root.cpuIcon
        cpuIconColor: root.cpuIconColor
        cpuFontFamily: root.cpuFontFamily
        cpuFontColor: root.cpuFontColor

        ramIcon: root.ramIcon
        ramIconColor: root.ramIconColor
        ramFontFamily: root.ramFontFamily
        ramFontColor: root.ramFontColor
    }

    P5Support.DataSource {
        id: cpuCalcSource
        engine: "executable"
        connectedSources: []

        property double prevIdle: 0.0
        property double prevTotal: 0.0
        property bool cpuFirstRun: true

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) {
                disconnectSource(source)
                return
            }

            var lines = stdout.trim().split("\n")

            for (var i = 0; i < lines.length; i++) {
                if (lines[i].indexOf("cpu ") === 0) {
                    var p = lines[i].split(/\s+/)

                    var user = parseFloat(p[1])
                    var nice = parseFloat(p[2])
                    var system = parseFloat(p[3])
                    var idle = parseFloat(p[4])
                    var iowait = parseFloat(p[5])
                    var irq = parseFloat(p[6])
                    var softirq = parseFloat(p[7])
                    var steal = parseFloat(p[8]) || 0

                    var totalIdle = idle + iowait
                    var total = user + nice + system + idle + iowait + irq + softirq + steal

                    if (!cpuCalcSource.cpuFirstRun) {
                        var di = totalIdle - cpuCalcSource.prevIdle
                        var dt = total - cpuCalcSource.prevTotal

                        if (dt > 0) {
                            root.cpuUsage = Math.round((1.0 - di / dt) * 1000) / 10
                        }
                    }

                    cpuCalcSource.prevIdle = totalIdle
                    cpuCalcSource.prevTotal = total
                    cpuCalcSource.cpuFirstRun = false
                    break
                }
            }

            disconnectSource(source)
        }
    }

    P5Support.DataSource {
        id: ramSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) {
                disconnectSource(source)
                return
            }

            var lines = stdout.trim().split("\n")

            for (var i = 0; i < lines.length; i++) {
                if (lines[i].indexOf("Mem:") !== -1) {
                    var p = lines[i].split(/\s+/)
                    var total = parseFloat(p[1])
                    var used = parseFloat(p[2])

                    root.ramTotalGB = Math.round(total / 1024 / 1024 / 1024 * 100) / 100
                    root.ramUsedGB = Math.round(used / 1024 / 1024 / 1024 * 100) / 100

                    if (total > 0) {
                        root.ramPercent = Math.round(used / total * 1000) / 10
                    }

                    break
                }
            }

            disconnectSource(source)
        }
    }

    P5Support.DataSource {
        id: netSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) {
                disconnectSource(source)
                return
            }

            var lines = stdout.trim().split("\n")
            var totalDown = 0
            var totalUp = 0

            for (var i = 2; i < lines.length; i++) {
                var line = lines[i].trim()

                if (line.length === 0 || line.indexOf("lo:") !== -1) {
                    continue
                }

                var p = line.split(/\s+/)

                if (p.length >= 10) {
                    totalDown += parseFloat(p[1])
                    totalUp += parseFloat(p[9])
                }
            }

            if (root.firstRun) {
                root.prevDownBytes = totalDown
                root.prevUpBytes = totalUp
                root.firstRun = false
            } else {
                var interval = refreshTimer.interval / 1000

                root.netDown = (totalDown - root.prevDownBytes) / interval
                root.netUp = (totalUp - root.prevUpBytes) / interval

                root.prevDownBytes = totalDown
                root.prevUpBytes = totalUp
            }

            disconnectSource(source)
        }
    }

    Timer {
        id: refreshTimer
        interval: Plasmoid.configuration.refreshInterval > 0 ? Plasmoid.configuration.refreshInterval : 1500
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            cpuCalcSource.connectSource("cat /proc/stat")
            ramSource.connectSource("free -b")
            netSource.connectSource("cat /proc/net/dev")
        }
    }
}
