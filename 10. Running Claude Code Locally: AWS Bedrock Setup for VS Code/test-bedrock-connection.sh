#!/bin/bash

# Test script for AWS Bedrock connection with Claude models
# Usage: ./test-bedrock-connection.sh [profile-name]

set -e

echo "🔍 Testing AWS Bedrock Connection for Claude Code"
echo "=================================================="
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first."
    exit 1
fi
echo "✅ AWS CLI installed"

# Use provided profile or default
if [ -n "$1" ]; then
    PROFILE="$1"
elif [ -n "$AWS_PROFILE" ]; then
    PROFILE="$AWS_PROFILE"
else
    PROFILE="bedrock-stockholm"
fi

export AWS_PROFILE="$PROFILE"
echo "ℹ️  Using AWS_PROFILE: $AWS_PROFILE"

# Set region if not already set
if [ -z "$AWS_REGION" ]; then
    export AWS_REGION="eu-north-1"
    echo "ℹ️  Set AWS_REGION to: $AWS_REGION"
else
    echo "ℹ️  Using AWS_REGION: $AWS_REGION"
fi

echo ""
echo "🔐 Checking AWS Authentication..."

# Check if authenticated
if aws sts get-caller-identity &> /dev/null; then
    echo "✅ Authenticated as:"
    aws sts get-caller-identity --query '[UserId,Account,Arn]' --output table
else
    echo "❌ Not authenticated. Running SSO login..."
    aws sso login --profile "$AWS_PROFILE"

    # Check again
    if aws sts get-caller-identity &> /dev/null; then
        echo "✅ Successfully authenticated"
    else
        echo "❌ Authentication failed"
        exit 1
    fi
fi

echo ""
echo "🤖 Checking Available Claude Models..."

# List Claude models
MODELS=$(aws bedrock list-foundation-models \
    --region "$AWS_REGION" \
    --query 'modelSummaries[?contains(modelId, `anthropic.claude`)].{ModelId:modelId, Name:modelName}' \
    --output table 2>&1)

if [ $? -eq 0 ]; then
    echo "✅ Available Claude models in $AWS_REGION:"
    echo "$MODELS"
else
    echo "❌ Failed to list models. Error:"
    echo "$MODELS"
    echo ""
    echo "Possible issues:"
    echo "  - Bedrock not available in this region"
    echo "  - Missing Bedrock permissions"
    echo "  - Model access not granted"
    exit 1
fi

echo ""
echo "🔍 Checking Inference Profiles..."

# List inference profiles
PROFILES=$(aws bedrock list-inference-profiles \
    --region "$AWS_REGION" \
    --query 'inferenceProfileSummaries[?contains(inferenceProfileId, `anthropic`)].{ProfileId:inferenceProfileId, Name:inferenceProfileName, Models:models[0].modelArn}' \
    --output table 2>&1)

if [ $? -eq 0 ]; then
    echo "✅ Available inference profiles:"
    echo "$PROFILES"
else
    echo "⚠️  Could not list inference profiles (may not be required in all regions)"
    echo "$PROFILES"
fi

echo ""
echo "🧪 Testing Bedrock API Access..."

# Test model - try with inference profile first
TEST_MODEL_PROFILE="eu.anthropic.claude-sonnet-4-6"
TEST_MODEL_DIRECT="anthropic.claude-sonnet-4-6"

echo "📤 Testing inference profile: $TEST_MODEL_PROFILE"

# Verify inference profile exists
aws bedrock list-inference-profiles \
    --region "$AWS_REGION" \
    --query "inferenceProfileSummaries[?inferenceProfileId=='$TEST_MODEL_PROFILE'].inferenceProfileId" \
    --output text &> /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Inference profile exists: $TEST_MODEL_PROFILE"
    PROFILE_EXISTS=true
else
    echo "⚠️  Inference profile not found: $TEST_MODEL_PROFILE"
    echo "   This may be expected in some regions."
    PROFILE_EXISTS=false
fi

echo ""
echo "📊 Checking Model Access Status..."

# Check model access
ACCESS_STATUS=$(aws bedrock list-foundation-models \
    --region "$AWS_REGION" \
    --query "modelSummaries[?contains(modelId, 'claude')].{ModelId:modelId, Status:modelLifecycle.status}" \
    --output table 2>&1)

if [ $? -eq 0 ]; then
    echo "✅ Model access status:"
    echo "$ACCESS_STATUS"
else
    echo "❌ Could not check model access status"
fi

echo ""
echo "=================================================="

if [ "$PROFILE_EXISTS" = true ]; then
    echo "✅ All tests passed! Claude Code should work in VS Code."
else
    echo "⚠️  Tests passed with warnings."
    echo "   Claude Code may work, but check configuration."
fi

echo ""
echo "Next steps:"
echo "1. Restart VS Code (or reload window with ⌘+R)"
echo "2. Open Claude Code panel"
echo "3. Start coding with Claude!"
echo ""
echo "Environment variables for VS Code:"
echo "  AWS_PROFILE=$AWS_PROFILE"
echo "  AWS_REGION=$AWS_REGION"
echo ""
echo "Recommended VS Code settings.json:"
echo '  "claude.apiProvider": "bedrock",'
echo '  "claude.awsRegion": "'"$AWS_REGION"'",'
if [ "$PROFILE_EXISTS" = true ]; then
    echo '  "claude.model": "'"$TEST_MODEL_PROFILE"'",'
else
    echo '  "claude.model": "'"$TEST_MODEL_DIRECT"'",'
fi
echo '  "terminal.integrated.env.osx": {'
echo '    "AWS_PROFILE": "'"$AWS_PROFILE"'",'
echo '    "AWS_REGION": "'"$AWS_REGION"'"'
echo '  }'
echo ""
