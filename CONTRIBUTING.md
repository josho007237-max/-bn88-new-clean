# 🤝 Contributing to BN88 New Clean

Thank you for your interest in contributing to BN88! This document provides guidelines and instructions for contributing to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors. Please:

- ✅ Be respectful and considerate
- ✅ Welcome newcomers and help them get started
- ✅ Accept constructive criticism gracefully
- ✅ Focus on what's best for the project and community

### Unacceptable Behavior

- ❌ Harassment or discriminatory language
- ❌ Trolling or insulting comments
- ❌ Publishing others' private information
- ❌ Any conduct that would be inappropriate in a professional setting

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

1. Read the `SETUP.md` guide
2. Successfully set up the development environment
3. Run the smoke tests: `.\smoke.ps1`
4. Familiarized yourself with the codebase

### Finding Issues to Work On

1. **Good First Issues:** Look for issues labeled `good first issue`
2. **Help Wanted:** Check issues labeled `help wanted`
3. **Bugs:** Look for issues labeled `bug`
4. **Features:** Check issues labeled `enhancement`

Before starting work:
- Comment on the issue to let others know you're working on it
- Wait for maintainer approval if it's a major change

## 💻 Development Workflow

### 1. Fork and Clone

```powershell
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/-bn88-new-clean.git
cd -bn88-new-clean

# Add upstream remote
git remote add upstream https://github.com/josho007237-max/-bn88-new-clean.git
```

### 2. Create a Branch

```powershell
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions or modifications
- `chore/` - Maintenance tasks

### 3. Make Your Changes

Follow the coding standards (see below) and:

- Write clean, readable code
- Add comments for complex logic
- Update documentation as needed
- Add tests for new features
- Ensure all tests pass

### 4. Test Your Changes

```powershell
# Backend tests
cd bn88-backend-v12
npm run typecheck
npm run build
npm test

# Frontend tests
cd ../bn88-frontend-dashboard-v12
npm run typecheck
npm run build
npm test

# Run smoke tests
cd ..
.\smoke.ps1
```

### 5. Commit Your Changes

Follow the commit message guidelines (see below):

```powershell
git add .
git commit -m "feat: add amazing new feature"
```

### 6. Push and Create PR

```powershell
# Push to your fork
git push origin feature/your-feature-name

# Create a Pull Request on GitHub
```

## 📝 Coding Standards

### General Principles

1. **Keep it Simple:** Write code that's easy to understand
2. **DRY (Don't Repeat Yourself):** Extract common logic
3. **Single Responsibility:** Each function should do one thing well
4. **Consistent Style:** Follow the existing code style

### TypeScript/JavaScript

- Use TypeScript for type safety
- Prefer `const` over `let`, avoid `var`
- Use meaningful variable and function names
- Add JSDoc comments for public APIs
- Handle errors properly - don't swallow them

#### Example:

```typescript
// Good
async function getUserById(userId: string): Promise<User | null> {
  try {
    const user = await prisma.user.findUnique({
      where: { id: userId }
    });
    return user;
  } catch (error) {
    logger.error('Failed to fetch user', { userId, error });
    throw new Error('Database query failed');
  }
}

// Bad
async function getUser(id: any) {
  try {
    return await prisma.user.findUnique({ where: { id } });
  } catch (e) {
    // Silent failure - bad!
  }
}
```

### React/Frontend

- Use functional components with hooks
- Extract complex logic into custom hooks
- Keep components small and focused
- Use proper TypeScript types
- Handle loading and error states

#### Example:

```typescript
// Good
interface UserProfileProps {
  userId: string;
}

export function UserProfile({ userId }: UserProfileProps) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchUser();
  }, [userId]);

  // ... rest of component
}
```

### Backend/API

- Use RESTful conventions
- Validate all inputs with Zod
- Use proper HTTP status codes
- Return consistent error formats
- Add rate limiting for public endpoints
- Use middleware for common concerns (auth, logging)

#### Example:

```typescript
// Good
router.post('/api/users',
  authMiddleware,
  async (req: Request, res: Response) => {
    try {
      const validated = createUserSchema.parse(req.body);
      const user = await createUser(validated);
      res.status(201).json({ success: true, data: user });
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json({
          success: false,
          error: 'Validation failed',
          details: error.errors
        });
      } else {
        res.status(500).json({
          success: false,
          error: 'Internal server error'
        });
      }
    }
  }
);
```

### Database/Prisma

- Use transactions for related updates
- Add proper indexes for queried fields
- Use meaningful model and field names
- Add comments to complex schema relationships

### PowerShell Scripts

- Use approved verbs (Get, Set, Start, Stop, Test)
- Add help comments
- Use proper error handling
- Use `$procId` instead of `$pid` (reserved variable)

## 💬 Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

### Examples

```powershell
# Feature
git commit -m "feat(auth): add password reset functionality"

# Bug fix
git commit -m "fix(api): correct pagination offset calculation"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Breaking change
git commit -m "feat(api): redesign authentication flow

BREAKING CHANGE: Auth endpoints now require x-tenant header"
```

### Best Practices

- Keep the subject line under 50 characters
- Use imperative mood ("add" not "added")
- Don't end the subject line with a period
- Separate subject from body with a blank line
- Wrap body at 72 characters
- Explain what and why, not how

## 🔍 Pull Request Process

### Before Submitting

- [ ] Code follows the style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] No new warnings
- [ ] Commits follow guidelines

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How have you tested this?

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] Added tests
- [ ] Tests pass
- [ ] No new warnings

## Screenshots (if applicable)
Add screenshots for UI changes
```

### Review Process

1. **Automated Checks:** GitHub Actions will run tests
2. **Code Review:** Maintainers will review your code
3. **Feedback:** Address any requested changes
4. **Approval:** Once approved, your PR will be merged

### After Merge

- Delete your feature branch
- Update your fork:
  ```powershell
  git checkout main
  git pull upstream main
  git push origin main
  ```

## ✅ Testing

### Writing Tests

- Write tests for new features
- Update tests for bug fixes
- Aim for good coverage (not 100%, but reasonable)
- Test edge cases and error conditions

### Running Tests

```powershell
# Backend
cd bn88-backend-v12
npm test

# Frontend
cd bn88-frontend-dashboard-v12
npm test

# Smoke tests
.\smoke.ps1
```

## 📚 Documentation

### When to Update Documentation

Update documentation when you:
- Add a new feature
- Change existing behavior
- Fix a bug that affects usage
- Add new configuration options
- Change API endpoints

### Documentation Files

- `README.md` - Project overview
- `SETUP.md` - Installation guide
- `RUNBOOK.md` - Operations guide
- `CONTRIBUTING.md` - This file
- Code comments - Inline documentation
- API documentation - OpenAPI/Swagger

### Documentation Style

- Use clear, simple language
- Include code examples
- Add screenshots for UI changes
- Keep it up-to-date
- Use proper markdown formatting

## 🎯 Areas Needing Contribution

We especially welcome contributions in:

### High Priority
- Bug fixes
- Performance improvements
- Security enhancements
- Documentation improvements
- Test coverage

### Features
- New bot capabilities
- Enhanced dashboard features
- Better error handling
- Improved logging
- Multi-language support

### Infrastructure
- CI/CD improvements
- Deployment automation
- Monitoring setup
- Docker improvements

## ❓ Questions?

If you have questions:

1. Check existing documentation
2. Search closed issues
3. Ask in a new issue
4. Tag it with `question`

## 🙏 Thank You

Thank you for contributing to BN88! Every contribution, no matter how small, helps make this project better for everyone.

---

**Remember:** The goal is to make the project better, not perfect. Don't be afraid to contribute!
