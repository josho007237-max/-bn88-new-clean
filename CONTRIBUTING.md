# Contributing to BN88 New Clean

Thank you for your interest in contributing to the BN88 platform! This document provides guidelines and instructions for contributing to the project.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## 🚀 Getting Started

1. **Fork the repository** (if external contributor)
2. **Clone your fork**
   ```bash
   git clone <your-fork-url>
   cd ./-bn88-new-clean
   ```

3. **Set up development environment**
   - Follow setup instructions in [README.md](./README.md)
   - Ensure Node.js version matches `.nvmrc` (v18)
   - Install dependencies in both backend and frontend

4. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 💻 Development Workflow

### Backend Development (`bn88-backend-v12`)

1. **Start the development server**
   ```bash
   cd bn88-backend-v12
   npm run dev
   ```

2. **Run database migrations**
   ```bash
   npx prisma migrate dev
   ```

3. **Seed test data**
   ```bash
   npm run seed:dev
   ```

4. **Type checking**
   ```bash
   npm run typecheck
   ```

### Frontend Development (`bn88-frontend-dashboard-v12`)

1. **Start the development server**
   ```bash
   cd bn88-frontend-dashboard-v12
   npm run dev
   ```

2. **Linting**
   ```bash
   npm run lint
   npm run lint:fix  # Auto-fix issues
   ```

3. **Type checking**
   ```bash
   npm run typecheck
   ```

### LINE Engagement Platform

1. **Start with Docker**
   ```bash
   cd line-engagement-platform
   docker compose up --build
   ```

## 📝 Code Standards

### TypeScript

- Use TypeScript for all new code
- Enable strict mode in `tsconfig.json`
- Avoid `any` types - use proper typing
- Use interfaces for object shapes
- Use type aliases for complex types

### Naming Conventions

- **Files**: Use kebab-case (`user-service.ts`)
- **Classes**: Use PascalCase (`UserService`)
- **Functions/Variables**: Use camelCase (`getUserById`)
- **Constants**: Use UPPER_SNAKE_CASE (`API_BASE_URL`)
- **Interfaces**: Use PascalCase with descriptive names (`UserInterface` or `IUser`)

### Code Style

- Use 2 spaces for indentation
- Use single quotes for strings
- Add semicolons at end of statements
- Maximum line length: 100 characters
- Use async/await over promises
- Use ES6+ features (arrow functions, destructuring, etc.)

### Comments

- Write clear, concise comments
- Document complex logic
- Use JSDoc for functions and classes
- Keep comments up-to-date with code changes

Example:
```typescript
/**
 * Authenticates a user with email and password
 * @param email - User's email address
 * @param password - User's password
 * @returns Authentication token and user data
 * @throws AuthenticationError if credentials are invalid
 */
async function authenticateUser(email: string, password: string): Promise<AuthResponse> {
  // Implementation
}
```

## 🧪 Testing

### Running Tests

**Backend**
```bash
cd bn88-backend-v12
npm test
```

**Frontend**
```bash
cd bn88-frontend-dashboard-v12
npm test
```

### Smoke Tests

Run smoke tests to verify basic functionality:
```powershell
.\smoke.ps1
```

### Deep Validation

Run comprehensive validation:
```powershell
.\deep-validation.ps1
```

### Writing Tests

- Write unit tests for business logic
- Write integration tests for API endpoints
- Aim for >80% code coverage
- Use descriptive test names
- Follow AAA pattern: Arrange, Act, Assert

Example:
```typescript
describe('UserService', () => {
  it('should create a new user with valid data', async () => {
    // Arrange
    const userData = { email: 'test@example.com', password: 'password123' };
    
    // Act
    const user = await userService.create(userData);
    
    // Assert
    expect(user.email).toBe(userData.email);
    expect(user.id).toBeDefined();
  });
});
```

## 📜 Commit Guidelines

### Commit Message Format

Use conventional commits format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add JWT token refresh endpoint

fix(frontend): resolve proxy configuration for API calls

docs(readme): update installation instructions

chore(deps): upgrade Prisma to v6.19.2
```

### Commit Best Practices

- Keep commits small and focused
- Write clear, descriptive commit messages
- Reference issue numbers when applicable
- Don't commit sensitive data (API keys, passwords, etc.)
- Don't commit `node_modules` or build artifacts

## 🔄 Pull Request Process

1. **Update your branch**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. **Run all checks**
   ```bash
   # Backend
   cd bn88-backend-v12
   npm run typecheck
   npm test
   
   # Frontend
   cd ../bn88-frontend-dashboard-v12
   npm run lint
   npm run typecheck
   npm test
   ```

3. **Create Pull Request**
   - Use a descriptive title
   - Reference related issues
   - Describe what changed and why
   - Include screenshots for UI changes
   - Mark as draft if work in progress

4. **PR Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update
   
   ## Testing
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed
   
   ## Screenshots (if applicable)
   [Add screenshots here]
   
   ## Related Issues
   Closes #123
   ```

5. **Review Process**
   - Address review comments
   - Update code as needed
   - Request re-review when ready

6. **After Merge**
   - Delete your feature branch
   - Pull latest changes from main

## 🔐 Security

- Never commit sensitive data
- Use environment variables for secrets
- Review `.gitignore` before committing
- Report security vulnerabilities privately
- Follow security best practices

## 🐛 Bug Reports

When reporting bugs, include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, Node version, etc.)
- Error messages or logs
- Screenshots if applicable

## 💡 Feature Requests

When requesting features, include:
- Clear description of the feature
- Use case and benefits
- Any relevant examples or mockups
- Potential implementation approach

## 📞 Getting Help

- Check existing documentation
- Search closed issues
- Ask in project discussions
- Contact maintainers

## 🙏 Thank You

Your contributions help make this project better!

---

**Note**: These guidelines may evolve over time. Check back regularly for updates.
