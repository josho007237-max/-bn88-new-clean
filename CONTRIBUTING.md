 copilot/fix-bn88-project-issues
# Contributing to BN88 Project

Thank you for your interest in contributing to the BN88 project! This document provides guidelines and instructions for contributing.

## Table of Contents
=======
# 🤝 Contributing to BN88

Thank you for your interest in contributing to the BN88 platform! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

 main
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
 copilot/fix-bn88-project-issues

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
=======
- [Documentation](#documentation)

---

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive experience for everyone. We expect all contributors to:

- Be respectful and considerate
- Use welcoming and inclusive language
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

---

## 🚀 Getting Started

### Prerequisites

Before you start contributing, make sure you have:

1. **Completed the setup** - Follow [SETUP.md](SETUP.md)
2. **Read the documentation** - Familiarize yourself with [README.md](README.md)
3. **Understood the codebase** - Browse through the code structure

### Finding Issues to Work On

1. Check the [Issues](https://github.com/josho007237-max/-bn88-new-clean/issues) page
2. Look for issues labeled:
   - `good first issue` - Great for newcomers
   - `help wanted` - Need contributors
   - `bug` - Bug fixes needed
   - `enhancement` - New features

### Claiming an Issue

Before starting work:

1. **Comment on the issue** to let others know you're working on it
2. **Wait for assignment** or approval from maintainers
3. **Ask questions** if anything is unclear

---

## 💻 Development Workflow

### 1. Fork the Repository

Click the "Fork" button on GitHub to create your own copy.

### 2. Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/-bn88-new-clean.git
cd -bn88-new-clean
```

### 3. Add Upstream Remote

```bash
git remote add upstream https://github.com/josho007237-max/-bn88-new-clean.git
```

### 4. Create a Feature Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name

# Examples:
# git checkout -b feature/add-user-profile
# git checkout -b fix/login-token-expiration
# git checkout -b docs/update-api-documentation
```

**Branch naming conventions:**
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding tests
- `chore/` - Maintenance tasks

### 5. Make Your Changes

Work on your feature or fix following our [coding standards](#coding-standards).

### 6. Keep Your Branch Updated

Regularly sync with the main repository:

```bash
git fetch upstream
git rebase upstream/main
```

### 7. Test Your Changes

Before committing, ensure:

```bash
# Backend tests
cd bn88-backend-v12
npm run typecheck
npm test

# Frontend tests
cd ../bn88-frontend-dashboard-v12
npm run typecheck
npm run lint
npm test
```

### 8. Commit Your Changes

Follow our [commit guidelines](#commit-guidelines):

```bash
git add .
git commit -m "feat: Add user profile page"
```

### 9. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 10. Create a Pull Request

Go to GitHub and create a Pull Request from your branch to the main repository.

---

## 🎨 Coding Standards

### General Principles

- **Keep it simple** - Write clear, readable code
- **Follow existing patterns** - Match the style of existing code
- **Comment wisely** - Explain "why", not "what"
- **Test your changes** - Ensure nothing breaks

### TypeScript

```typescript
// ✅ Good - Clear type definitions
interface User {
  id: string;
  email: string;
  roles: string[];
}

function getUserById(id: string): Promise<User | null> {
  // Implementation
}

// ❌ Bad - Using 'any' type
function getUser(id: any): any {
  // Implementation
 main
}
```

### Backend (NestJS/Express)
 copilot/fix-bn88-project-issues
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
=======
```typescript
// ✅ Good - Proper error handling
app.post("/api/users", async (req, res) => {
  try {
    const user = await createUser(req.body);
    res.json({ success: true, user });
  } catch (error) {
    console.error("Failed to create user:", error);
    res.status(500).json({ error: "Failed to create user" });
  }
});

// ❌ Bad - No error handling
app.post("/api/users", async (req, res) => {
  const user = await createUser(req.body);
  res.json(user);
});
main
```

### Frontend (React)

 copilot/fix-bn88-project-issues
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
=======
```typescript
// ✅ Good - Functional component with proper hooks
import { useState, useEffect } from "react";

function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  
  if (!user) return <div>Loading...</div>;
  
  return <div>{user.email}</div>;
}

// ❌ Bad - Missing types and dependencies
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, []); // Missing userId dependency
  
  return <div>{user.email}</div>;
}
```

### File Organization

```
src/
├── components/       # Reusable UI components
├── pages/           # Page components
├── lib/             # Utilities and helpers
├── hooks/           # Custom React hooks
├── types/           # TypeScript type definitions
├── api/             # API client functions
└── config/          # Configuration files
```

### Naming Conventions

- **Files**: `kebab-case.tsx` or `PascalCase.tsx` for components
- **Components**: `PascalCase`
- **Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Interfaces/Types**: `PascalCase`

---

## 📝 Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Format

```
<type>(<scope>): <subject>

<body>

<footer>
main
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
copilot/fix-bn88-project-issues
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions/updates
- `chore`: Build process or auxiliary tool changes
=======
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
 main

### Examples

```bash
copilot/fix-bn88-project-issues
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
=======
# Feature
git commit -m "feat(auth): Add password reset functionality"

# Bug fix
git commit -m "fix(api): Resolve token expiration issue"

# Documentation
git commit -m "docs(readme): Update installation instructions"

# Refactor
git commit -m "refactor(utils): Simplify date formatting function"

# Multiple lines
git commit -m "feat(dashboard): Add user analytics page

- Add analytics API endpoint
- Create charts component
- Update navigation menu

Closes #123"
```

### Commit Message Best Practices

- **Use imperative mood**: "Add feature" not "Added feature"
- **Be concise**: Keep the subject line under 50 characters
- **Be specific**: Describe what changed and why
- **Reference issues**: Use "Fixes #123" or "Closes #123"

---

## 🔄 Pull Request Process

### Before Creating a PR

- [ ] Your code follows the coding standards
- [ ] You've tested your changes locally
- [ ] All tests pass
- [ ] You've updated documentation if needed
- [ ] Your commits follow the commit guidelines
- [ ] Your branch is up to date with main

### Creating the PR

1. **Title**: Use a clear, descriptive title
   ```
   feat: Add user profile page
   fix: Resolve login token expiration
   docs: Update API documentation
   ```

2. **Description**: Provide context and details
   ```markdown
   ## Description
   Adds a new user profile page with the following features:
   - Display user information
   - Edit profile functionality
   - Avatar upload
   
   ## Changes
   - Added ProfilePage component
   - Created profile API endpoints
   - Updated navigation menu
   
   ## Testing
   - Tested profile editing
   - Verified avatar upload
   - Checked responsive design
   
   ## Screenshots
   [If applicable, add screenshots]
   
   Fixes #123
   ```

3. **Link Issues**: Reference related issues using keywords:
   - `Fixes #123` - Closes the issue when PR is merged
   - `Closes #123` - Same as Fixes
   - `Related to #123` - References without closing

### PR Review Process

1. **Automated Checks**: Wait for CI/CD to pass
2. **Code Review**: Address reviewer comments
3. **Make Changes**: Push additional commits if needed
4. **Approval**: Get approval from maintainers
5. **Merge**: Maintainers will merge your PR

### Responding to Feedback

- **Be respectful**: Accept criticism professionally
- **Ask questions**: If feedback is unclear
- **Make changes**: Update your code based on feedback
- **Explain decisions**: If you disagree, explain why

---

## 🧪 Testing

### Running Tests

```bash
# Backend
cd bn88-backend-v12
npm test                  # Run all tests
npm run typecheck         # Type checking

# Frontend
cd bn88-frontend-dashboard-v12
npm test                  # Run all tests
npm run typecheck         # Type checking
npm run lint              # Linting
```

### Writing Tests

```typescript
// Example test
describe("User Authentication", () => {
  it("should login with valid credentials", async () => {
    const response = await login("user@example.com", "password");
    expect(response.token).toBeDefined();
  });
  
  it("should reject invalid credentials", async () => {
    await expect(
      login("user@example.com", "wrong")
    ).rejects.toThrow();
  });
});
```

### Manual Testing

Before submitting a PR:

1. **Start the dev servers**: `.\start-dev.ps1`
2. **Test your changes**: Verify functionality works
3. **Test edge cases**: Try invalid inputs, errors, etc.
4. **Test on different browsers**: Chrome, Firefox, Safari
5. **Run smoke tests**: `.\smoke.ps1`

---

## 📚 Documentation

### When to Update Documentation

Update documentation when you:

- Add new features
- Change existing functionality
- Add new configuration options
- Fix significant bugs
- Add new APIs or endpoints

### Documentation Files

- `README.md` - Main project documentation
- `SETUP.md` - Setup and installation guide
- `CONTRIBUTING.md` - This file
- `RUNBOOK.md` - Operations guide
- Code comments - Inline documentation

### Writing Good Documentation

```markdown
## Good Example

### User Authentication

To authenticate a user, send a POST request to `/api/auth/login`:

\`\`\`http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
\`\`\`

Response:
\`\`\`json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "123",
    "email": "user@example.com"
  }
}
\`\`\`
```

---

## ❓ Questions?

If you have questions:

1. Check existing [documentation](README.md)
2. Search [issues](https://github.com/josho007237-max/-bn88-new-clean/issues)
3. Ask in the issue you're working on
4. Create a new issue with the `question` label

---

## 🎉 Thank You!

Your contributions help make BN88 better for everyone. We appreciate your time and effort!

---

**Happy Contributing! 🚀**
 main
