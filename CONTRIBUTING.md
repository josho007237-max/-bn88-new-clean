# Contributing to BN88 Project

Thank you for your interest in contributing to the BN88 project! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Focus on constructive feedback
- Accept responsibility for mistakes
- Prioritize the community's best interests

## Getting Started

### Prerequisites

- Node.js 18.x (see `.nvmrc`)
- npm 8.x or higher
- Git
- PowerShell (for Windows scripts)
- Docker (optional, for Redis/PostgreSQL)

### Initial Setup

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/-bn88-new-clean.git
   cd -bn88-new-clean
   ```

2. **Set up upstream remote**
   ```bash
   git remote add upstream https://github.com/josho007237-max/-bn88-new-clean.git
   ```

3. **Install dependencies**
   ```powershell
   # Backend
   cd bn88-backend-v12
   npm install
   
   # Frontend
   cd ..\bn88-frontend-dashboard-v12
   npm install
   
   # LINE Platform (optional)
   cd ..\line-engagement-platform
   npm install
   ```

4. **Set up environment files**
   ```powershell
   cd ..
   Copy-Item .\bn88-backend-v12\.env.example .\bn88-backend-v12\.env
   Copy-Item .\bn88-frontend-dashboard-v12\.env.example .\bn88-frontend-dashboard-v12\.env
   ```

5. **Run smoke test**
   ```powershell
   .\smoke.ps1
   ```

## Development Workflow

### 1. Create a feature branch

```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### Branch Naming Conventions

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions/updates
- `chore/` - Maintenance tasks

### 2. Make your changes

Follow the [Coding Standards](#coding-standards) below.

### 3. Test your changes

```powershell
# Backend tests
cd bn88-backend-v12
npm test
npm run typecheck

# Frontend tests
cd ..\bn88-frontend-dashboard-v12
npm test
npm run typecheck
```

### 4. Run the application locally

```powershell
# Start dev environment
.\start-dev.ps1

# Test your changes at http://localhost:5555

# Stop when done
.\stop-dev.ps1
```

### 5. Commit your changes

See [Commit Guidelines](#commit-guidelines) below.

### 6. Push and create PR

```bash
git push origin feature/your-feature-name
# Then create a Pull Request on GitHub
```

## Coding Standards

### TypeScript

- Use TypeScript for all new code
- Enable strict mode
- Avoid `any` type - use proper typing
- Use interfaces for object shapes
- Use enums for fixed sets of values

**Example:**
```typescript
// Good
interface User {
  id: string;
  email: string;
  role: UserRole;
}

enum UserRole {
  ADMIN = 'admin',
  USER = 'user'
}

// Bad
function getUser(): any {
  // ...
}
```

### Backend (NestJS/Express)

- Follow RESTful conventions
- Use async/await for asynchronous operations
- Implement proper error handling
- Add input validation with Zod
- Use Prisma for database operations
- Keep controllers thin, move logic to services

**Example:**
```typescript
// Good
async function createUser(data: CreateUserDto) {
  const validated = CreateUserSchema.parse(data);
  return await prisma.user.create({ data: validated });
}

// Bad
function createUser(data) {
  return prisma.user.create({ data });
}
```

### Frontend (React)

- Use functional components with hooks
- Implement proper TypeScript typing for props
- Use meaningful component and variable names
- Keep components small and focused
- Extract reusable logic to custom hooks
- Use proper error boundaries

**Example:**
```typescript
// Good
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  return (
    <button className={variant} onClick={onClick}>
      {label}
    </button>
  );
}
```

### PowerShell Scripts

- Use approved verbs (Get-, Set-, New-, Remove-, etc.)
- Add comment-based help
- Use `$procId` instead of `$pid` (automatic variable)
- Implement error handling
- Test on Windows PowerShell and PowerShell Core

**Example:**
```powershell
<#
.SYNOPSIS
    Brief description
.DESCRIPTION
    Detailed description
.EXAMPLE
    .\script.ps1 -Parameter Value
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$RequiredParam
)

$ErrorActionPreference = "Stop"

try {
    # Your code here
} catch {
    Write-Error "Error: $_"
    exit 1
}
```

### Database (Prisma)

- Write clear, descriptive model names
- Add comments to complex fields
- Create indexes for frequently queried fields
- Use proper relations
- Write migrations for schema changes

**Example:**
```prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  role      Role     @default(USER)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  posts     Post[]
  
  @@index([email])
}
```

### General Code Style

- **Formatting:** Use Prettier with default settings
- **Linting:** Fix all ESLint warnings and errors
- **Comments:** Write clear comments for complex logic
- **Naming:**
  - camelCase for variables and functions
  - PascalCase for classes and components
  - UPPER_CASE for constants
  - Descriptive names (avoid abbreviations)

## Commit Guidelines

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions/updates
- `chore`: Build process or auxiliary tool changes

### Examples

```bash
feat(backend): add user profile endpoint

fix(frontend): resolve login redirect issue

docs(readme): update setup instructions

refactor(auth): simplify JWT token validation

test(api): add integration tests for chat endpoints
```

### Best Practices

- Use present tense ("add" not "added")
- Use imperative mood ("move" not "moves")
- Don't capitalize first letter
- No period at the end
- Keep subject line under 50 characters
- Separate subject from body with blank line
- Reference issues/PRs in footer

## Pull Request Process

### Before Submitting

1. ✅ Code follows style guidelines
2. ✅ All tests pass
3. ✅ TypeScript compiles without errors
4. ✅ No console.log or debugging code
5. ✅ Documentation updated (if needed)
6. ✅ Commits follow guidelines
7. ✅ Branch is up to date with main

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Manual testing completed
- [ ] Automated tests added/updated
- [ ] Tests passing locally

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added to complex code
- [ ] Documentation updated
- [ ] No new warnings generated
```

### Review Process

1. At least one maintainer review required
2. Address all review comments
3. CI/CD checks must pass
4. Keep PR scope focused and small
5. Be responsive to feedback

## Testing

### Backend Testing

```powershell
cd bn88-backend-v12

# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Type checking
npm run typecheck

# Lint
npm run lint
```

### Frontend Testing

```powershell
cd bn88-frontend-dashboard-v12

# Run all tests
npm test

# Type checking
npm run typecheck

# Lint
npm run lint
```

### Integration Testing

```powershell
# Run validation script
.\deep-validation.ps1

# Manual testing
.\start-dev.ps1
# Test at http://localhost:5555
```

## Project Structure

```
-bn88-new-clean/
├── bn88-backend-v12/         # Backend API
│   ├── src/
│   │   ├── routes/           # API routes
│   │   ├── services/         # Business logic
│   │   ├── middleware/       # Express middleware
│   │   └── utils/            # Utilities
│   ├── prisma/               # Database schema
│   └── tests/                # Tests
├── bn88-frontend-dashboard-v12/  # Frontend dashboard
│   ├── src/
│   │   ├── components/       # React components
│   │   ├── pages/            # Page components
│   │   ├── hooks/            # Custom hooks
│   │   └── utils/            # Utilities
├── line-engagement-platform/ # LINE integration
├── docs/                     # Documentation
└── tools/                    # Helper scripts
```

## Need Help?

- Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues
- Review [README.md](./README.md) for project overview
- Read [RUNBOOK.md](./RUNBOOK.md) for operational details
- Ask questions in GitHub Issues or Discussions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing to BN88! 🎉**
