#!/bin/bash
PROFILE=${1:-torremocha-johnkristan}

echo "🔎 Checking AWS profile: $PROFILE"

# Show basic config
aws configure list --profile "$PROFILE"

# Show the account + user identity
echo -e "\n👤 AWS Identity:"
aws sts get-caller-identity --profile "$PROFILE"
