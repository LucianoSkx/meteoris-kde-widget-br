<div align="center">

# 🌌 Meteoris

### Monitor de sistema moderno e leve para o KDE Plasma 6

Rede, CPU, RAM, temperaturas, GPU e bateria em tempo real — tudo em um
widget de painel limpo e totalmente personalizável que se integra
naturalmente ao seu desktop.

<br>

![Visitantes](https://visitor-badge.laobi.icu/badge?page_id=LucianoSkx.meteoris-kde-widget-br)
![KDE Plasma](https://img.shields.io/badge/KDE%20Plasma-6-3daee9?style=flat-square&logo=kde&logoColor=white)
![Qt](https://img.shields.io/badge/Qt-6-41cd52?style=flat-square&logo=qt&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Suportado-orange?style=flat-square&logo=linux&logoColor=white)
![QML](https://img.shields.io/badge/Linguagem-QML-41cd52?style=flat-square)
![Licença](https://img.shields.io/github/license/LucianoSkx/meteoris-kde-widget-br?style=flat-square)

<br>

<img src="preview/home.png" alt="Meteoris no desktop" width="100%">

<br>

<table align="center">
  <tr>
    <td align="center"><b>Layout empilhado</b><br><img src="preview/comp.png" alt="compacto"></td>
    <td align="center"><b>Layout inline</b><br><img src="preview/extended.png" alt="estendido"></td>
  </tr>
</table>

</div>

<br>

<details open>
<summary align="center"><b>📑 Sumário</b></summary>
<br>

<div align="center">

[Sobre](#-sobre) • [Recursos](#-recursos) • [Popup de estatísticas rápidas](#-popup-de-estatísticas-rápidas) •
[Pré-visualizações](#-pré-visualizações) • [Personalização](#-personalização) • [Instalação](#-instalação) •
[Compatibilidade](#-compatibilidade) • [Contribuindo](#-contribuindo) • [Licença](#-licença)

</div>
</details>

<br>

## 🪐 Sobre

O Meteoris é um widget do KDE Plasma focado em entregar as informações
essenciais do sistema de forma limpa e personalizável.

Em vez de tentar ser um monitor de sistema pesado e completo, ele mostra
o que a maioria dos usuários realmente quer saber — **direto do painel**,
com sobrecarga mínima e zero dependências externas.

> Informativo. Leve. Visualmente consistente.

Tudo é lido direto do kernel do Linux (`/proc`, `/sys`), então funciona
em **qualquer** distribuição — sem pacotes extras, sem daemons.

<br>

## ✨ Recursos

<table>
<tr>
<td width="50%">

### 🌐 Velocidade da rede
- Download / upload em tempo real
- Layout empilhado **ou** lado a lado
- Ícone, fonte e cores personalizáveis

### 🧠 Uso de memória
- Uso de RAM em tempo real num relance
- Ícone e texto totalmente tematizáveis

### ⚙️ Uso da CPU
- Porcentagem ao vivo e suave
- Sobrecarga mínima de leitura

### 🌡️ Temperatura da CPU
- Lê as zonas térmicas diretamente
- Avisos com codificação por cor

</td>
<td width="50%">

### 🎮 Monitoramento de GPU
- Uso de **memória** da GPU
- **Temperatura** da GPU
- Suporta **NVIDIA / AMD / Intel**

### 🔋 Bateria
- Porcentagem + status
- Se oculta automaticamente em desktops

### 🖱️ Estatísticas rápidas no hover
- Tráfego do dia / do mês
- Frequência da CPU e uso do disco
- **Persiste entre reinicializações**

### 🎨 Personalização profunda
- Visibilidade e ordem de cada módulo
- Ícones, cores, fontes, espaçamentos
- Predefinições de tema em um clique

</td>
</tr>
</table>

<br>

## 🖱️ Popup de estatísticas rápidas

Passe o mouse sobre o widget do painel para revelar um popup temático —
sem precisar clicar. Ele mostra os números mais detalhados, que não
poluiriam o painel:

<div align="center">
<img src="preview/hover.png" alt="Popup de estatísticas rápidas" width="420">
</div>

- 📅 **Hoje** — total de upload + download desde a meia-noite
- 🗓️ **Este mês** — total de upload + download neste mês
- ⚡ **Frequência da CPU** — velocidade média atual
- 💾 **Disco rígido** — uso com barra de progresso

> Os totais de tráfego ficam em `~/.cache/meteoris_traffic.conf`, então
> os contadores diários/mensais **sobrevivem a reinicializações e
> reinícios do Plasma**, e se resetam sozinhos em um novo dia/mês.

<br>

## 🖼️ Pré-visualizações

### Layouts do painel

<table>
<tr>
<td align="center" width="50%"><sub><b>Rede empilhada</b></sub><br><img src="preview/comp.png" alt="empilhado"></td>
<td align="center" width="50%"><sub><b>Rede inline</b></sub><br><img src="preview/extended.png" alt="inline"></td>
</tr>
</table>

### No desktop

<img src="preview/home.png" alt="Meteoris no desktop" width="100%">

<br>

## 🎨 Personalização

Cada módulo pode ser ativado/desativado e tematizado de forma
independente. Ajuste ícones, cores, fontes, taxa de atualização,
espaçamento dos separadores e o layout do painel — ou aplique uma
predefinição e pronto.

<div align="center">
<img src="preview/settings.png" alt="Configurações do Meteoris" width="520">
</div>

**Predefinições de tema incluídas:** `Catppuccin` · `Tokyo Night` · `Nord`

Mais um botão de **Redefinir tudo** para começar do zero a qualquer momento.

<br>

## 📦 Instalação

### ⚡ Instalação rápida

```bash
git clone https://github.com/LucianoSkx/meteoris-kde-widget-br.git
cd meteoris-kde-widget-br

chmod +x install.sh
./install.sh
```

Depois: **Área de trabalho → Adicionar widgets → Meteoris**

### 🛠️ Instalação manual

```bash
mkdir -p ~/.local/share/plasma/plasmoids

cp -r . \
  ~/.local/share/plasma/plasmoids/SiyamX7.system.monitor.meteoris
```

Reinicie o Plasma:

```bash
plasmashell --replace &
```

<br>

## 🗂️ Estrutura do projeto

```text
.
├── contents
│   ├── config
│   │   ├── config.qml
│   │   └── main.xml
│   └── ui
│       ├── CompactRepresentation.qml
│       ├── ConfigGeneral.qml
│       ├── FullRepresentation.qml
│       └── main.qml
├── install.sh
├── LICENSE
├── logos.conf
├── metadata.json
├── preview
└── README.md
```

<br>

## 🧩 Compatibilidade

| Componente | Suportado | Observação |
|-----------|:---------:|------|
| KDE Plasma 6 | ✅ | |
| Qt 6 | ✅ | |
| Wayland | ✅ | |
| X11 | ✅ | |
| Qualquer distro Linux | ✅ | Rede / CPU / RAM / disco usam as interfaces do kernel |
| GPU NVIDIA | ✅ | Requer `nvidia-smi` |
| GPU AMD / Intel | ✅ | Usa sensores `sysfs` |

<br>

## 🤝 Contribuindo

Sugestões, relatos de bugs e pull requests são sempre bem-vindos.

Encontrou um bug ou tem uma ideia? [Abra uma issue](https://github.com/LucianoSkx/meteoris-kde-widget-br/issues)
— ou melhor, envie um PR. 🚀

<br>

## ⭐ Histórico de estrelas

<div align="center">
<a href="https://star-history.com/#LucianoSkx/meteoris-kde-widget-br&Date">
  <img src="https://api.star-history.com/svg?repos=LucianoSkx/meteoris-kde-widget-br&type=Date" alt="Gráfico de histórico de estrelas" width="70%">
</a>
</div>

<br>

## 📜 Licença

Distribuído sob a licença **GPL-3.0**. Veja o arquivo [LICENSE](LICENSE) para detalhes.

<br>

<div align="center">

Fork de [SiyamX7/meteoris-kde-widget](https://github.com/SiyamX7/meteoris-kde-widget) —
créditos originais ao **Mohammad Siyam (SiyamX7)**.

Tradução para o português do Brasil.

Feito com ☕ e tempo demais ajustando painéis do KDE.

**LucianoSkx**

</div>
