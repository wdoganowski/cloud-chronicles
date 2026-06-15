# Claude Code with AWS Bedrock - Quick Reference

One-page reference for daily use with Claude Code and AWS Bedrock.

---

## Daily Startup (30 seconds)

```bash
# 1. Login to AWS SSO
aws sso login --profile bedrock-stockholm

# 2. Open VS Code
code

# 3. Start using Claude!
```

---

## Essential Commands

### AWS Authentication

```bash
# Login to AWS SSO
aws sso login --profile bedrock-stockholm

# Check authentication status
aws sts get-caller-identity

# Logout (forces fresh login next time)
aws sso logout
```

### Verify Bedrock Access

```bash
# List available Claude models
aws bedrock list-foundation-models \
  --region eu-north-1 \
  --query 'modelSummaries[?contains(modelId, `anthropic.claude`)].[modelId,modelName]' \
  --output table

# List inference profiles
aws bedrock list-inference-profiles \
  --region eu-north-1 \
  --query 'inferenceProfileSummaries[?contains(inferenceProfileId, `anthropic`)]' \
  --output table
```

### VS Code Commands

```bash
# Reload VS Code window (after config changes)
# Press: ⌘+R (Mac) or Ctrl+R (Windows/Linux)

# Open VS Code settings
# Press: ⌘+, (Mac) or Ctrl+, (Windows/Linux)

# Open command palette
# Press: ⌘+Shift+P (Mac) or Ctrl+Shift+P (Windows/Linux)

# Focus Claude Code panel
# Command palette → "Claude: Focus"
```

---

## VS Code Configuration

### User Settings Location

**Mac**: `~/Library/Application Support/Code/User/settings.json`
**Windows**: `%APPDATA%\Code\User\settings.json`
**Linux**: `~/.config/Code/User/settings.json`

### Minimal Configuration

```json
{
  "claude.apiProvider": "bedrock",
  "claude.awsRegion": "eu-north-1",
  "claude.model": "eu.anthropic.claude-sonnet-4-6",
  "terminal.integrated.env.osx": {
    "AWS_PROFILE": "bedrock-stockholm",
    "AWS_REGION": "eu-north-1"
  },
  "terminal.integrated.inheritEnv": true
}
```

### Project-Specific Settings

Create `.vscode/settings.json` in project root:

```json
{
  "claude.model": "eu.anthropic.claude-opus-4-8"
}
```

---

## Available Models

| Model | Inference Profile ID | Best For | Cost |
|-------|---------------------|----------|------|
| **Sonnet 4.6** | `eu.anthropic.claude-sonnet-4-6` | Daily coding (recommended) | Medium |
| **Opus 4.8** | `eu.anthropic.claude-opus-4-8` | Complex problems | High |
| **Haiku 4.5** | `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | Quick queries | Low |

**Important**: Always use inference profile IDs (with `eu.` prefix for eu-north-1)

---

## Troubleshooting

### "Authentication Error"

```bash
# Re-login to AWS SSO
aws sso login --profile bedrock-stockholm

# Reload VS Code
# Press ⌘+R
```

### "Model Not Found"

Check your `settings.json`:
- ✅ Use: `eu.anthropic.claude-sonnet-4-6`
- ❌ Not: `anthropic.claude-sonnet-4-6`

### Environment Variables Not Set

```bash
# In VS Code terminal, check:
echo $AWS_PROFILE
echo $AWS_REGION

# If empty:
# 1. Verify settings.json has terminal.integrated.env.*
# 2. Fully restart VS Code (not just reload)
# 3. Open new terminal
```

### Session Expired

```bash
# Check if expired
aws sts get-caller-identity

# If error, re-login
aws sso login --profile bedrock-stockholm

# Reload VS Code
```

> **Tip**: You don't need to quit VS Code to refresh. Run `aws sso login` in any terminal — VS Code's integrated terminal, iTerm, or system Terminal — and it works. The SSO token is stored in `~/.aws/sso/cache/` (not in the terminal session), so Claude Code picks up the refreshed credentials automatically on its next call.

### Test Connection

```bash
# Run test script
cd "path/to/10. AWS Bedrock, Claude Code and VSCode"
./test-bedrock-connection.sh
```

---

## IAM Permissions Required

Your IAM role/user needs these Bedrock permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:ListFoundationModels",
        "bedrock:GetFoundationModel",
        "bedrock:ListInferenceProfiles"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## AWS CLI Profile Configuration

Located at: `~/.aws/config`

```ini
[profile bedrock-stockholm]
sso_session = my-sso
sso_account_id = 123456789012
sso_role_name = BedrockUserAccess
region = eu-north-1
output = json

[sso-session my-sso]
sso_start_url = https://your-company.awsapps.com/start
sso_region = eu-central-1
sso_registration_scopes = sso:account:access
```

---

## Common Regions

| Region | Code | Bedrock Available | Common Models |
|--------|------|-------------------|---------------|
| Stockholm | `eu-north-1` | ✅ | All Claude 4.x |
| Ireland | `eu-west-1` | ✅ | All Claude 4.x |
| N. Virginia | `us-east-1` | ✅ | All Claude 4.x |
| Oregon | `us-west-2` | ✅ | All Claude 4.x |

Check current region availability:
```bash
aws bedrock list-foundation-models --region <region-code>
```

---

## Cost Optimization

### Model Selection Strategy

- **Haiku**: Quick questions, simple code gen (~$0.50/day)
- **Sonnet**: Daily development work (~$5/day)
- **Opus**: Complex architecture, critical bugs (~$20/day)

### Monitor Costs

```bash
# Check Bedrock usage in AWS Console
# Navigate to: Cost Explorer → Filter by: "Amazon Bedrock"
```

### Best Practices

1. Start conversations fresh (don't accumulate long context)
2. Be specific in questions (reduces token usage)
3. Use appropriate model for task complexity
4. Set billing alerts in AWS Console

---

## Security Checklist

- [ ] Using AWS SSO (not access keys)
- [ ] Credentials expire automatically (8-12 hours)
- [ ] No credentials committed to git
- [ ] `.aws/` directory in `.gitignore`
- [ ] Using least-privilege IAM permissions
- [ ] Monitoring usage via CloudTrail

---

## Quick Health Check

```bash
# 1. AWS authenticated?
aws sts get-caller-identity

# 2. Bedrock accessible?
aws bedrock list-foundation-models --region eu-north-1

# 3. Environment vars set?
echo $AWS_PROFILE $AWS_REGION

# 4. VS Code extension installed?
code --list-extensions | grep anthropic.claude-code
```

If all return success, you're good to go!

---

## Support & Resources

- **AWS SSO Issues**: Contact AWS administrator
- **Claude Code Extension**: https://github.com/anthropics/claude-code/issues
- **Bedrock Documentation**: https://docs.aws.amazon.com/bedrock/
- **IAM Identity Center**: See article in cloud-chronicles repo

---

## Useful Links

- Test script: `./test-bedrock-connection.sh`
- Full article: `README.md`
- Example settings: `vscode-settings.json`
- Workspace settings: `workspace-settings.json`

---

**Last Updated**: June 2026
**Tested With**: Claude Code extension v1.x, AWS CLI v2.x
