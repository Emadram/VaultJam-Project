# Contributing to VaultJam-Project

Thank you for your interest in contributing to VaultJam-Project! This document provides guidelines and best practices for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Respect different viewpoints and experiences
- Accept responsibility and apologize for mistakes

## Getting Started

### Prerequisites

Before you begin, ensure you have:
- Git installed and configured
- The appropriate game engine installed (Unity, Unreal, or Godot)
- A code editor with EditorConfig support
- Access to the project repository

### Setting Up Your Development Environment

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/Emadram/VaultJam-Project.git
   cd VaultJam-Project
   ```

2. **Create a new branch for your work**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Install any dependencies**
   - Follow the setup instructions in the README.md

## Development Workflow

### Branch Naming Convention

Use descriptive branch names following this pattern:
- `feature/description` - For new features
- `bugfix/description` - For bug fixes
- `hotfix/description` - For urgent fixes
- `docs/description` - For documentation updates
- `refactor/description` - For code refactoring
- `test/description` - For test additions or modifications

### Working on Your Contribution

1. **Keep your branch up-to-date**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. **Make small, focused commits**
   - Each commit should represent a single logical change
   - Write clear commit messages

3. **Test your changes**
   - Run all relevant tests
   - Test manually in the game engine
   - Verify no existing functionality is broken

## Coding Standards

### General Guidelines

- Follow the .editorconfig settings for consistent formatting
- Write clean, readable, and maintainable code
- Use meaningful variable and function names
- Keep functions small and focused on a single responsibility
- Comment complex logic, but prefer self-documenting code
- Remove commented-out code before committing

### Language-Specific Guidelines

#### C# (Unity)
- Follow Microsoft's C# naming conventions
- Use PascalCase for public members and methods
- Use camelCase for private fields (prefix with underscore: `_privateField`)
- Use explicit access modifiers (public, private, protected)
- Avoid using `var` unless the type is obvious

#### C++ (Unreal)
- Follow Unreal Engine coding standards
- Use PascalCase for class names (prefix with appropriate letter: U, A, F, etc.)
- Use CamelCase for function names
- Use lowercase with underscores for local variables
- Always use `nullptr` instead of `NULL`

#### GDScript (Godot)
- Follow Godot's GDScript style guide
- Use snake_case for variables and functions
- Use PascalCase for class names
- Use CONSTANT_CASE for constants
- Indent with tabs (as per Godot convention)

### Asset Guidelines

- Use descriptive names for all assets
- Follow a consistent naming convention: `Type_Description_Variant`
  - Example: `Tex_Wall_Brick_01`, `Sound_Footstep_Concrete`
- Keep file sizes reasonable (optimize textures, audio, etc.)
- Document any special requirements or dependencies in asset directories

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependency updates

#### Examples

```
feat(player): add double jump ability

Implemented double jump mechanic for player character.
Jump can be triggered a second time while in mid-air.

Closes #123
```

```
fix(ui): correct health bar display issue

Health bar was not updating correctly when player took damage.
Fixed synchronization between health value and UI display.
```

## Pull Request Process

### Before Submitting

1. **Ensure your code follows the coding standards**
2. **Write or update tests as needed**
3. **Update documentation if necessary**
4. **Run all tests and ensure they pass**
5. **Rebase your branch on the latest main branch**
6. **Review your own changes first**

### Pull Request Template

When creating a pull request, include:

```markdown
## Description
Brief description of the changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe the tests you ran and their results

## Checklist
- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my code
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass locally
- [ ] Any dependent changes have been merged

## Screenshots (if applicable)
Add screenshots for visual changes
```

### Review Process

- All PRs require at least one approval before merging
- Address all review comments or explain why you disagree
- Keep discussions professional and focused on the code
- Be open to feedback and suggestions

## Testing

### Running Tests

```bash
# Run all tests
npm test  # or appropriate command for your setup

# Run specific test suite
npm test -- --suite=unit
```

### Writing Tests

- Write tests for all new features
- Include edge cases and error conditions
- Use descriptive test names
- Keep tests independent and isolated
- Mock external dependencies

## Documentation

### What to Document

- New features and how to use them
- API changes and breaking changes
- Complex algorithms or logic
- Configuration options
- Setup and installation steps

### Documentation Style

- Use clear, concise language
- Include code examples where helpful
- Keep documentation up-to-date with code changes
- Use proper Markdown formatting

## Asset Contributions

### Contributing Assets

- Ensure you have the rights to contribute the asset
- Provide source files when possible (e.g., .blend for 3D models)
- Optimize assets for game use (texture sizes, poly counts, etc.)
- Include attribution if required by the asset license

### Asset Review

- Assets will be reviewed for quality and performance
- Ensure assets match the project's art style
- Provide documentation on how to use the asset

## Questions or Issues?

- Check existing issues and discussions first
- Create a new issue for bugs or feature requests
- Use discussions for questions and general topics
- Tag issues appropriately (bug, enhancement, question, etc.)

## Recognition

Contributors will be recognized in:
- The project README
- Release notes
- In-game credits (for significant contributions)

Thank you for contributing to VaultJam-Project! Your efforts help make this project better for everyone.
