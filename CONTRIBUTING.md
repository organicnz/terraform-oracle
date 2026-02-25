# Contributing Guidelines

Thank you for considering contributing to this Terraform configuration!

## Development Setup

1. **Install Required Tools**
   ```bash
   # Terraform
   brew install terraform

   # Optional but recommended
   brew install tflint tfsec terraform-docs pre-commit
   ```

2. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd <repository-name>
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your credentials
   ```

3. **Install Pre-commit Hooks** (Optional)
   ```bash
   pre-commit install
   ```

## Making Changes

1. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Follow Terraform best practices
   - Add validation to new variables
   - Update documentation
   - Add comments for complex logic

3. **Test Your Changes**
   ```bash
   make fmt          # Format code
   make validate     # Validate syntax
   make lint         # Run linting
   make security     # Security scan
   make plan         # Test plan
   ```

4. **Update Documentation**
   - Update README.md if adding features
   - Update CHANGELOG.md
   - Add inline comments
   - Run `make docs` to regenerate docs

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

   Use conventional commits:
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `refactor:` Code refactoring
   - `test:` Test changes
   - `chore:` Maintenance tasks

6. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## Code Standards

### Terraform Style

- Use 2 spaces for indentation
- Run `terraform fmt` before committing
- Use meaningful resource names (snake_case)
- Add descriptions to all variables and outputs
- Include validation rules for variables
- Use locals for computed values
- Add lifecycle rules where appropriate

### Variable Naming

- Use descriptive names
- Follow snake_case convention
- Group related variables
- Add validation rules
- Mark sensitive variables

### Documentation

- Document all variables with descriptions
- Add inline comments for complex logic
- Update README for new features
- Include examples where helpful
- Keep CHANGELOG.md updated

### Security

- Never commit credentials
- Use sensitive = true for secrets
- Validate all inputs
- Follow principle of least privilege
- Run security scans

## Testing Checklist

Before submitting a PR:

- [ ] Code is formatted (`make fmt`)
- [ ] Validation passes (`make validate`)
- [ ] Linting passes (`make lint`)
- [ ] Security scan passes (`make security`)
- [ ] Plan executes successfully (`make plan`)
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Commit messages follow conventions
- [ ] No sensitive data in commits

## Review Process

1. Submit PR with clear description
2. Ensure all checks pass
3. Address review comments
4. Maintain clean commit history
5. Squash commits if requested

## Questions?

Feel free to open an issue for:
- Bug reports
- Feature requests
- Documentation improvements
- Questions about usage

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
