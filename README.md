# 🌌 Meteoris

<div align="center">

### A sleek and lightweight KDE Plasma 6 system monitor

Monitor CPU usage, RAM usage, and network speed in real time with a clean, modern, and highly customizable widget.

![Plasma](https://img.shields.io/badge/KDE%20Plasma-6-blue)
![Qt](https://img.shields.io/badge/Qt-6-green)
![License](https://img.shields.io/badge/License-MIT-orange)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

</div>

---

## ✨ Features

* 📊 Live CPU usage monitoring
* 🧠 Real-time RAM usage display
* 🌐 Network download/upload speed monitoring
* 🎨 Customizable icons and appearance
* ⚡ Lightweight and efficient
* 🖥️ Native KDE Plasma integration

---

## 📸 Screenshots

> Add screenshots inside the `screenshots/` folder and update the links below.

```text
screenshots/
├── preview-1.png
├── preview-2.png
└── preview-3.png
```

Example:

```markdown
![Preview](screenshots/preview-1.png)
```

---

## 🚀 Installation

### Clone the repository

```bash
git clone https://github.com/SiyamX7/meteoris-kde-widget.git
cd meteoris-kde-widget
```

### Run the installer

```bash
chmod +x install.sh
./install.sh
```

After installation:

**Desktop → Add Widgets → Search for "Meteoris"**

---

## 🛠️ Manual Installation

```bash
mkdir -p ~/.local/share/plasma/plasmoids

cp -r SiyamX7.system.monitor.meteoris \
~/.local/share/plasma/plasmoids/
```

Restart Plasma:

```bash
plasmashell --replace &
```

---

## 📂 Project Structure

```text
SiyamX7.system.monitor.meteoris/
├── contents/
│   ├── config/
│   ├── ui/
│   └── code/
├── metadata.json
├── logos.conf
├── install.sh
└── README.md
```

---

## ⚙️ Requirements

| Component  | Version   |
| ---------- | --------- |
| KDE Plasma | 6.x       |
| Qt         | 6.x       |

---

## 🎨 Customization

Meteoris is designed to be customizable.

You can adjust:

* Icons
* Layout
* Fonts
* Widget appearance
* Logo configuration
* Display behavior

through Plasma settings and project configuration files.

---

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome.

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Open a Pull Request

---

## 🐞 Reporting Issues

Found a bug or have a feature request?

Open an issue on GitHub and include:

* Plasma version
* Distribution name
* Screenshots (if applicable)
* Steps to reproduce

---

## 📜 License

This project is licensed under the MIT License.

See the `LICENSE` file for details.

---

<div align="center">

### Made with ❤️ for KDE Plasma

**Created by SiyamX7**

</div>
