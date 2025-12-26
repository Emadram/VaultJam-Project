# VaultJam-Project

A game development project using **Godot Engine**, **Python**, and **Blender** for 3D modeling.

## 📋 Table of Contents

- [About](#about)
- [Quick Start Cheatsheet](#quick-start-cheatsheet)
- [Project Structure](#project-structure)
- [Development Setup](#development-setup)
- [Contributing](#contributing)

## 🎮 About

VaultJam-Project is a game development repository built with Godot Engine, Python scripting for tools, and Blender for 3D asset creation.

### Tech Stack

- **Game Engine**: Godot 4.x (GDScript)
- **Scripting/Tools**: Python 3.x
- **3D Modeling**: Blender 3.x or later
- **Version Control**: Git

## ⚡ Quick Start Cheatsheet

### Clone & Setup (Copy-Paste)
```bash
# Clone and enter project
git clone https://github.com/Emadram/VaultJam-Project.git && cd VaultJam-Project

# Create your feature branch
git checkout -b feature/my-feature

# Check status and see changes
git status && git diff
```

### Daily Workflow (Bulk Commands)
```bash
# Stage, commit, and push in one go
git add . && git commit -m "feat: your message" && git push origin $(git branch --show-current)

# Pull latest changes and rebase your work
git fetch origin && git rebase origin/main

# Quick status check
git status && git log --oneline -5 && git branch
```

### Common Operations
```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard all local changes
git checkout . && git clean -fd

# Create and push new branch
git checkout -b feature/new-feature && git push -u origin feature/new-feature

# Update branch from main
git fetch origin && git merge origin/main

# View changes before staging
git diff && git status
```

### GitHub PR Workflow
```bash
# Fork workflow: add upstream and sync
git remote add upstream https://github.com/Emadram/VaultJam-Project.git && git fetch upstream && git merge upstream/main

# Create PR-ready branch
git checkout -b feature/pr-ready && git add . && git commit -m "feat: ready for PR" && git push -u origin feature/pr-ready
```

### Godot Specific
```bash
# Run Godot project from CLI
godot --path . --editor  # Open editor
godot --path . res://Scenes/MainScene.tscn  # Run scene

# Export project
godot --export "Linux/X11" ./Builds/game.x86_64
```

### Python Tools
```bash
# Setup virtual environment and install deps
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

# Run Python tools
python Tools/asset_processor.py && python Tools/build_script.py
```

## 📁 Project Structure

```
VaultJam-Project/
├── Assets/                 # Game assets organized by type
│   ├── Audio/              # Sound effects and music
│   ├── Blender/            # Blender project files (.blend)
│   ├── Materials/          # Godot materials and shaders
│   ├── Models/             # 3D models (exported from Blender)
│   ├── Scenes/             # Godot scenes
│   ├── Scripts/            # GDScript game logic
│   ├── Sprites/            # 2D images and textures
│   └── Textures/           # Texture maps for 3D models
├── Documentation/          # Design docs, technical specs, tutorials
├── Source/                 # Additional source code (if needed)
├── Tests/                  # Unit and integration tests
├── Tools/                  # Python scripts for automation
├── Config/                 # Configuration files
├── .editorconfig           # Code formatting rules
├── .gitignore              # Git ignore patterns
└── CONTRIBUTING.md         # Contribution guidelines
```

## 🚀 Development Setup

### Prerequisites
- **Godot Engine**: 4.x or later
- **Python**: 3.8 or later
- **Blender**: 3.x or later
- **Git**: Latest version
- **Code Editor**: VS Code with Godot/Python extensions

### Setup Commands (Copy-Paste)
```bash
# Clone and setup in one go
git clone https://github.com/Emadram/VaultJam-Project.git && cd VaultJam-Project && git checkout -b dev/$(whoami)

# Setup Python environment
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

# Open in Godot (Linux/Mac)
godot --path . --editor
```

## 🤝 Contributing

Quick contribution workflow:
```bash
# Fork, clone, branch, commit, push - all in one
git checkout -b feature/my-feature && git add . && git commit -m "feat: description" && git push -u origin feature/my-feature
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on code standards, commit format, and PR process.

## 📖 Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution workflow and standards
- [Assets/README.md](Assets/README.md) - Asset organization
- [Documentation/](Documentation/README.md) - Design docs and tutorials

## 🔧 Tools

- **Game Engine**: Godot (GDScript)
- **Scripting**: Python 3.x
- **3D Modeling**: Blender
- **Version Control**: Git

## 📜 License

MIT License - see [LICENSE](LICENSE) file.

---

**Quick Reference Card** - Common Git commands with `&&` chains are in the [Quick Start Cheatsheet](#quick-start-cheatsheet) section above.