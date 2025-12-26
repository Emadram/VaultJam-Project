# Contributing to VaultJam-Project

Quick and practical guide for contributing to this Godot + Python + Blender project.

## Quick Setup

```bash
# Fork, clone, and setup in one go
git clone https://github.com/YOUR_USERNAME/VaultJam-Project.git && cd VaultJam-Project && git checkout -b feature/my-feature && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt
```

## Branch Naming

- `feature/description` - New features
- `bugfix/description` - Bug fixes  
- `docs/description` - Documentation
- `refactor/description` - Code cleanup

## Coding Standards

### GDScript (Godot)
- Use tabs for indentation (4 spaces wide)
- Follow [Godot's GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- Use `snake_case` for variables/functions, `PascalCase` for classes

### Python (Tools)
- Use spaces (4) for indentation
- Follow PEP 8 style guide
- Use type hints where possible
- Format with Black: `black Tools/`

### Blender
- Save source .blend files in `Assets/Blender/`
- Export models to `Assets/Models/` in GLTF format
- Use descriptive names: `character_player_01.blend`

## Commit Format

```
<type>: <description>

[optional body]
```

**Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

**Examples**:
```bash
git commit -m "feat: add player jump mechanic"
git commit -m "fix: correct collision detection on walls"
git commit -m "docs: update setup instructions"
```

## Workflow Commands

```bash
# Daily workflow
git fetch origin && git rebase origin/main  # Update
# ... make changes ...
git add . && git commit -m "feat: description" && git push origin $(git branch --show-current)

# Create PR
# Go to GitHub and open PR from your branch
```
## Pull Request Process

```bash
# Before submitting PR
git fetch origin && git rebase origin/main  # Update from main
pytest Tests/  # Run tests (if any)
godot --path . --headless --script-test  # Test in Godot (if applicable)

# Review your changes
git diff origin/main

# Push and create PR
git push -u origin feature/your-feature && echo "Now go to GitHub and create PR"
```

### PR Checklist
- [ ] Code follows style guide (.editorconfig)
- [ ] Tests pass (if applicable)
- [ ] Documentation updated (if needed)
- [ ] Commit messages follow format
- [ ] Branch rebased on latest main

## Testing

```bash
# Python tests
pytest Tests/

# Godot tests (if using GUT framework)
godot --path . -s addons/gut/gut_cmdln.gd
```

## Asset Guidelines

### Blender Models
- Keep source files under 50MB when possible
- Use collections for organization
- Apply transforms before exporting
- Export to GLTF 2.0 for Godot compatibility

### Textures
- Use power-of-2 dimensions (512x512, 1024x1024, etc.)
- Compress to appropriate format (PNG for alpha, JPG for photos)
- Keep individual files under 2MB

### Audio
- Use OGG format for music (smaller files)
- Use WAV for short sound effects
- Normalize audio levels

## Common Tasks

```bash
# Format Python code
black Tools/ Tests/

# Check Python style
flake8 Tools/ Tests/

# Run Python type checking  
mypy Tools/

# Export all Blender files
python Tools/batch_export_blender.py

# Clean build artifacts
git clean -fdx
```

## Questions?

- Check existing [Issues](https://github.com/Emadram/VaultJam-Project/issues)
- Join discussions in [Discussions](https://github.com/Emadram/VaultJam-Project/discussions)
- Read the [README](README.md) for setup help

---

**Remember**: Small, focused PRs are easier to review and merge. Break large features into multiple PRs when possible.
