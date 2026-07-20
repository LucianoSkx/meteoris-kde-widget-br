import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as P5Support
import Qt.labs.settings 1.0

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

    // New properties
    property double cpuTemp: 0.0
    property double gpuTemp: 0.0
    property double gpuMemUsed: 0.0
    property double gpuMemTotal: 0.0
    property double batteryPercent: 0.0
    property string batteryStatus: "Unknown"
    property bool batteryAvailable: false

    // Separator spacing config
    property int separatorSpacing: Plasmoid.configuration.separatorSpacing

    // Hover popup data
    property double trafficTodayDown: 0.0
    property double trafficTodayUp: 0.0
    property double trafficMonthDown: 0.0
    property double trafficMonthUp: 0.0
    property double cpuFreqGHz: 0.0
    property double diskUsagePercent: 0.0
    property string diskUsageText: ""

    // Traffic accumulator (bytes since widget started; also stored to cache)
    property double totalDownAccum: 0.0
    property double totalUpAccum: 0.0
    property string currentDayKey: ""
    property string currentMonthKey: ""
    property bool trafficStatsLoaded: false

    property bool showNet: Plasmoid.configuration.showNet
    property bool showCpu: Plasmoid.configuration.showCpu
    property bool showRam: Plasmoid.configuration.showRam
    property bool netSpeedInline: Plasmoid.configuration.netSpeedInline

    property bool showCpuTemp: Plasmoid.configuration.showCpuTemp
    property bool showGpuTemp: Plasmoid.configuration.showGpuTemp
    property bool showGpuUsage: Plasmoid.configuration.showGpuUsage
    property bool showBattery: Plasmoid.configuration.showBattery
    property int gpuType: Plasmoid.configuration.gpuType  // 0=NVIDIA, 1=AMD, 2=Intel

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

    property string cpuTempIcon: Plasmoid.configuration.cpuTempIcon
    property string cpuTempIconColor: Plasmoid.configuration.cpuTempIconColor
    property string cpuTempFontFamily: Plasmoid.configuration.cpuTempFontFamily
    property string cpuTempFontColor: Plasmoid.configuration.cpuTempFontColor

    property string gpuTempIcon: Plasmoid.configuration.gpuTempIcon
    property string gpuTempIconColor: Plasmoid.configuration.gpuTempIconColor
    property string gpuTempFontFamily: Plasmoid.configuration.gpuTempFontFamily
    property string gpuTempFontColor: Plasmoid.configuration.gpuTempFontColor

    property string gpuUsageIcon: Plasmoid.configuration.gpuUsageIcon
    property string gpuUsageIconColor: Plasmoid.configuration.gpuUsageIconColor
    property string gpuUsageFontFamily: Plasmoid.configuration.gpuUsageFontFamily
    property string gpuUsageFontColor: Plasmoid.configuration.gpuUsageFontColor

    property string batteryIcon: Plasmoid.configuration.batteryIcon
    property string batteryIconColor: Plasmoid.configuration.batteryIconColor
    property string batteryFontFamily: Plasmoid.configuration.batteryFontFamily
    property string batteryFontColor: Plasmoid.configuration.batteryFontColor

    preferredRepresentation: compactRepresentation

    // ─── Persistent Settings (ডেটা সেভ করার জন্য) ─
    Settings {
        id: trafficSettings
        category: "TrafficStats"
        
        property string savedDayKey: ""
        property string savedMonthKey: ""
        property double savedTodayDown: 0.0
        property double savedTodayUp: 0.0
        property double savedMonthDown: 0.0
        property double savedMonthUp: 0.0
    }

    function todayKey() {
        var d = new Date()
        return d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate()
    }

    function monthKey() {
        var d = new Date()
        return d.getFullYear() + "-" + (d.getMonth() + 1)
    }

    function saveTrafficStats() {
        if (!root.trafficStatsLoaded) return
        
        trafficSettings.savedDayKey = root.currentDayKey
        trafficSettings.savedMonthKey = root.currentMonthKey
        trafficSettings.savedTodayDown = root.trafficTodayDown
        trafficSettings.savedTodayUp = root.trafficTodayUp
        trafficSettings.savedMonthDown = root.trafficMonthDown
        trafficSettings.savedMonthUp = root.trafficMonthUp
        
        // Settings অটোমেটিক সেভ হয়, তবে নিশ্চিত হতে sync() কল করতে পারেন
        trafficSettings.sync()
    }

    compactRepresentation: CompactRepresentation {
        cpuUsage: root.cpuUsage
        ramUsedGB: root.ramUsedGB
        ramTotalGB: root.ramTotalGB
        ramPercent: root.ramPercent
        netDown: root.netDown
        netUp: root.netUp

        cpuTemp: root.cpuTemp
        gpuTemp: root.gpuTemp
        gpuMemUsed: root.gpuMemUsed
        gpuMemTotal: root.gpuMemTotal
        batteryPercent: root.batteryPercent
        batteryStatus: root.batteryStatus
        batteryAvailable: root.batteryAvailable

        separatorSpacing: root.separatorSpacing

        trafficTodayDown: root.trafficTodayDown
        trafficTodayUp: root.trafficTodayUp
        trafficMonthDown: root.trafficMonthDown
        trafficMonthUp: root.trafficMonthUp
        cpuFreqGHz: root.cpuFreqGHz
        diskUsagePercent: root.diskUsagePercent
        diskUsageText: root.diskUsageText

        showNet: root.showNet
        showCpu: root.showCpu
        showRam: root.showRam
        netSpeedInline: root.netSpeedInline
        showCpuTemp: root.showCpuTemp
        showGpuTemp: root.showGpuTemp
        showGpuUsage: root.showGpuUsage
        showBattery: root.showBattery

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

        cpuTempIcon: root.cpuTempIcon
        cpuTempIconColor: root.cpuTempIconColor
        cpuTempFontFamily: root.cpuTempFontFamily
        cpuTempFontColor: root.cpuTempFontColor

        gpuTempIcon: root.gpuTempIcon
        gpuTempIconColor: root.gpuTempIconColor
        gpuTempFontFamily: root.gpuTempFontFamily
        gpuTempFontColor: root.gpuTempFontColor

        gpuUsageIcon: root.gpuUsageIcon
        gpuUsageIconColor: root.gpuUsageIconColor
        gpuUsageFontFamily: root.gpuUsageFontFamily
        gpuUsageFontColor: root.gpuUsageFontColor

        batteryIcon: root.batteryIcon
        batteryIconColor: root.batteryIconColor
        batteryFontFamily: root.batteryFontFamily
        batteryFontColor: root.batteryFontColor
    }

    fullRepresentation: FullRepresentation {
        cpuUsage: root.cpuUsage
        ramUsedGB: root.ramUsedGB
        ramTotalGB: root.ramTotalGB
        ramPercent: root.ramPercent
        netDown: root.netDown
        netUp: root.netUp

        cpuTemp: root.cpuTemp
        gpuTemp: root.gpuTemp
        gpuMemUsed: root.gpuMemUsed
        gpuMemTotal: root.gpuMemTotal
        batteryPercent: root.batteryPercent
        batteryStatus: root.batteryStatus
        batteryAvailable: root.batteryAvailable

        showNet: root.showNet
        showCpu: root.showCpu
        showRam: root.showRam
        netSpeedInline: root.netSpeedInline
        showCpuTemp: root.showCpuTemp
        showGpuTemp: root.showGpuTemp
        showGpuUsage: root.showGpuUsage
        showBattery: root.showBattery

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

        cpuTempIcon: root.cpuTempIcon
        cpuTempIconColor: root.cpuTempIconColor
        cpuTempFontFamily: root.cpuTempFontFamily
        cpuTempFontColor: root.cpuTempFontColor

        gpuTempIcon: root.gpuTempIcon
        gpuTempIconColor: root.gpuTempIconColor
        gpuTempFontFamily: root.gpuTempFontFamily
        gpuTempFontColor: root.gpuTempFontColor

        gpuUsageIcon: root.gpuUsageIcon
        gpuUsageIconColor: root.gpuUsageIconColor
        gpuUsageFontFamily: root.gpuUsageFontFamily
        gpuUsageFontColor: root.gpuUsageFontColor

        batteryIcon: root.batteryIcon
        batteryIconColor: root.batteryIconColor
        batteryFontFamily: root.batteryFontFamily
        batteryFontColor: root.batteryFontColor
    }

    // ─── CPU calc ───
    P5Support.DataSource {
        id: cpuCalcSource
        engine: "executable"
        connectedSources: []

        property double prevIdle: 0.0
        property double prevTotal: 0.0
        property bool cpuFirstRun: true

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

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
                        if (dt > 0) root.cpuUsage = Math.round((1.0 - di / dt) * 1000) / 10
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

    // ─── RAM ───
    P5Support.DataSource {
        id: ramSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var lines = stdout.trim().split("\n")
            for (var i = 0; i < lines.length; i++) {
                if (lines[i].indexOf("Mem:") !== -1) {
                    var p = lines[i].split(/\s+/)
                    var total = parseFloat(p[1])
                    var used = parseFloat(p[2])

                    root.ramTotalGB = Math.round(total / 1024 / 1024 / 1024 * 100) / 100
                    root.ramUsedGB = Math.round(used / 1024 / 1024 / 1024 * 100) / 100
                    if (total > 0) root.ramPercent = Math.round(used / total * 1000) / 10
                    break
                }
            }
            disconnectSource(source)
        }
    }

    // ─── Net ───
    P5Support.DataSource {
        id: netSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var lines = stdout.trim().split("\n")
            var totalDown = 0, totalUp = 0

            for (var i = 2; i < lines.length; i++) {
                var line = lines[i].trim()
                if (line.length === 0 || line.indexOf("lo:") !== -1) continue
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
                var deltaDown = totalDown - root.prevDownBytes
                var deltaUp = totalUp - root.prevUpBytes
                if (deltaDown < 0) deltaDown = 0
                if (deltaUp < 0) deltaUp = 0

                root.netDown = deltaDown / interval
                root.netUp = deltaUp / interval
                root.prevDownBytes = totalDown
                root.prevUpBytes = totalUp

                // Accumulate for today / month tracking
                if (root.trafficStatsLoaded) {
                    var nowDay = root.todayKey()
                    var nowMonth = root.monthKey()

                    if (nowDay !== root.currentDayKey) {
                        root.currentDayKey = nowDay
                        root.trafficTodayDown = 0
                        root.trafficTodayUp = 0
                    }
                    if (nowMonth !== root.currentMonthKey) {
                        root.currentMonthKey = nowMonth
                        root.trafficMonthDown = 0
                        root.trafficMonthUp = 0
                    }

                    root.trafficTodayDown += deltaDown
                    root.trafficTodayUp += deltaUp
                    root.trafficMonthDown += deltaDown
                    root.trafficMonthUp += deltaUp

                    trafficSaveTimer.restart()
                }
            }
            disconnectSource(source)
        }
    }

    // ─── CPU Temp ───
    P5Support.DataSource {
        id: cpuTempSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var val = parseFloat(stdout.trim())
            if (!isNaN(val)) {
                // sysfs gives millidegrees
                if (val > 1000) val = val / 1000
                root.cpuTemp = Math.round(val * 10) / 10
            }
            disconnectSource(source)
        }
    }

    // ─── GPU (NVIDIA) ───
    P5Support.DataSource {
        id: gpuNvidiaSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var parts = stdout.trim().split(", ")
            if (parts.length >= 3) {
                var temp = parseFloat(parts[0])
                var memUsed = parseFloat(parts[1])
                var memTotal = parseFloat(parts[2])

                if (!isNaN(temp)) root.gpuTemp = temp
                if (!isNaN(memUsed)) root.gpuMemUsed = memUsed
                if (!isNaN(memTotal)) root.gpuMemTotal = memTotal
            }
            disconnectSource(source)
        }
    }

    // ─── GPU (AMD) temp ───
    P5Support.DataSource {
        id: gpuAmdTempSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var val = parseFloat(stdout.trim())
            if (!isNaN(val)) {
                if (val > 1000) val = val / 1000
                root.gpuTemp = Math.round(val * 10) / 10
            }
            disconnectSource(source)
        }
    }

    // ─── GPU (AMD) memory ───
    P5Support.DataSource {
        id: gpuAmdMemSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var lines = stdout.trim().split("\n")
            for (var i = 0; i < lines.length; i++) {
                var line = lines[i].trim()
                if (line.indexOf("vram") !== -1 || line.indexOf("VRAM") !== -1) {
                    // try to parse "used: XXX MiB" pattern
                    var usedMatch = line.match(/(\d+)\s*(MiB|MB|mib)/i)
                    if (usedMatch) {
                        root.gpuMemUsed = parseFloat(usedMatch[1])
                    }
                }
                if (line.indexOf("total") !== -1 && (line.indexOf("vram") !== -1 || line.indexOf("VRAM") !== -1)) {
                    var totalMatch = line.match(/(\d+)\s*(MiB|MB|mib)/i)
                    if (totalMatch) {
                        root.gpuMemTotal = parseFloat(totalMatch[1])
                    }
                }
            }
            disconnectSource(source)
        }
    }

    // ─── GPU (Intel) ───
    P5Support.DataSource {
        id: gpuIntelTempSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var val = parseFloat(stdout.trim())
            if (!isNaN(val)) {
                if (val > 1000) val = val / 1000
                root.gpuTemp = Math.round(val * 10) / 10
            }
            disconnectSource(source)
        }
    }

    // ─── Battery ───
    P5Support.DataSource {
        id: batterySource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) {
                root.batteryAvailable = false
                disconnectSource(source)
                return
            }

            var lines = stdout.trim().split("\n")
            if (lines.length >= 2) {
                var cap = parseFloat(lines[0])
                var status = lines[1].trim()

                if (!isNaN(cap)) {
                    root.batteryPercent = cap
                    root.batteryStatus = status
                    root.batteryAvailable = true
                } else {
                    root.batteryAvailable = false
                }
            } else if (lines.length === 1) {
                var cap2 = parseFloat(lines[0])
                if (!isNaN(cap2)) {
                    root.batteryPercent = cap2
                    root.batteryStatus = "Unknown"
                    root.batteryAvailable = true
                } else {
                    root.batteryAvailable = false
                }
            } else {
                root.batteryAvailable = false
            }
            disconnectSource(source)
        }
    }

    // ── CPU Frequency (for hover popup) ───
    P5Support.DataSource {
        id: cpuFreqSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var lines = stdout.trim().split("\n")
            var sum = 0
            var count = 0
            for (var i = 0; i < lines.length; i++) {
                var line = lines[i].trim()
                if (line.indexOf("cpu MHz") !== -1 || line.indexOf("cpu\tMHz") !== -1) {
                    var parts = line.split(":")
                    if (parts.length >= 2) {
                        var v = parseFloat(parts[1].trim())
                        if (!isNaN(v)) {
                            sum += v
                            count++
                        }
                    }
                }
            }
            if (count > 0) {
                var avgMHz = sum / count
                root.cpuFreqGHz = Math.round(avgMHz / 1000 * 100) / 100
            }
            disconnectSource(source)
        }
    }

    // ─── Disk Usage (for hover popup) ───
    P5Support.DataSource {
        id: diskUsageSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (!stdout) { disconnectSource(source); return }

            var lines = stdout.trim().split("\n")
            // Expect: "Filesystem Size Used Avail Use% Mounted"
            //         "/dev/xxx    100G  40G  60G  40%  /"
            for (var i = 1; i < lines.length; i++) {
                var p = lines[i].trim().split(/\s+/)
                if (p.length >= 6) {
                    var usePct = p[4].replace("%", "")
                    var pctVal = parseFloat(usePct)
                    if (!isNaN(pctVal)) {
                        root.diskUsagePercent = pctVal
                        root.diskUsageText = p[2] + " / " + p[1] + " used"
                    }
                    break
                }
            }
            disconnectSource(source)
        }
    }

    // Debounced save timer (avoid disk write every tick)
    Timer {
        id: trafficSaveTimer
        interval: 15000
        repeat: false
        onTriggered: root.saveTrafficStats()
    }

    // ─── Load traffic stats from Settings on startup ──
    Component.onCompleted: {
        // Settings থেকে ডেটা লোড করুন
        var nowDay = root.todayKey()
        var nowMonth = root.monthKey()
        
        root.currentDayKey = nowDay
        root.currentMonthKey = nowMonth
        
        // যদি সেভ করা দিন আজকের দিন হয়, তবে ডেটা লোড করুন
        if (trafficSettings.savedDayKey === nowDay) {
            root.trafficTodayDown = trafficSettings.savedTodayDown
            root.trafficTodayUp = trafficSettings.savedTodayUp
        } else {
            root.trafficTodayDown = 0
            root.trafficTodayUp = 0
        }
        
        // যদি সেভ করা মাস এই মাস হয়, তবে ডেটা লোড করুন
        if (trafficSettings.savedMonthKey === nowMonth) {
            root.trafficMonthDown = trafficSettings.savedMonthDown
            root.trafficMonthUp = trafficSettings.savedMonthUp
        } else {
            root.trafficMonthDown = 0
            root.trafficMonthUp = 0
        }
        
        root.trafficStatsLoaded = true
    }

    // ─── Save traffic stats on widget destruction ──
    Component.onDestruction: {
        saveTrafficStats()
    }

    Timer {
        id: refreshTimer
        interval: Plasmoid.configuration.refreshInterval > 0 ? Plasmoid.configuration.refreshInterval : 1500
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            // Always fetch CPU, RAM, Net
            cpuCalcSource.connectSource("cat /proc/stat")
            ramSource.connectSource("free -b")
            netSource.connectSource("cat /proc/net/dev")

            // CPU Freq + Disk usage (for hover popup - lightweight)
            cpuFreqSource.connectSource("cat /proc/cpuinfo")
            diskUsageSource.connectSource("df -h / | tail -n +1")

            // CPU Temp
            if (root.showCpuTemp) {
                cpuTempSource.connectSource("cat /sys/class/thermal/thermal_zone0/temp")
            }

            // GPU based on type
            if (root.showGpuTemp || root.showGpuUsage) {
                if (root.gpuType === 0) {
                    // NVIDIA
                    gpuNvidiaSource.connectSource("nvidia-smi --query-gpu=temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits")
                } else if (root.gpuType === 1) {
                    // AMD
                    if (root.showGpuTemp) {
                        gpuAmdTempSource.connectSource("cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null || cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null")
                    }
                    if (root.showGpuUsage) {
                        gpuAmdMemSource.connectSource("cat /sys/class/drm/card0/device/mem_info_vram_used 2>/dev/null && echo ' used' && cat /sys/class/drm/card0/device/mem_info_vram_total 2>/dev/null && echo ' total'")
                    }
                } else if (root.gpuType === 2) {
                    // Intel
                    if (root.showGpuTemp) {
                        gpuIntelTempSource.connectSource("cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null || cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null")
                    }
                }
            }

            // Battery
            if (root.showBattery) {
                batterySource.connectSource("cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status 2>/dev/null || cat /sys/class/power_supply/BAT1/capacity /sys/class/power_supply/BAT1/status 2>/dev/null")
            }
        }
    }
}