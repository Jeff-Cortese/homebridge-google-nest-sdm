#!/bin/bash

set -e

# Replace these with your actual OAuth client credentials
# Get client ID and secret from environment variables
if [[ -z "${CLIENT_ID}" || -z "${CLIENT_SECRET}" ]]; then
  echo "Error: CLIENT_ID and CLIENT_SECRET environment variables must be set"
  exit 1
fi
REDIRECT_URI="http://localhost"

# OAuth 2.0 scopes
SCOPES="https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fsdm.service+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fpubsub"

# Step 1: Generate Authorization URL
echo "Open the following URL in your browser and authorize the application:"
echo ""
echo "https://accounts.google.com/o/oauth2/v2/auth?client_id=$CLIENT_ID&response_type=code&redirect_uri=$REDIRECT_URI&scope=$SCOPES&access_type=offline&prompt=consent"
echo ""
read -p "Enter the authorization code: " AUTH_CODE

# Step 2: Exchange authorization code for tokens
RESPONSE=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "code=$AUTH_CODE" \
  -d "grant_type=authorization_code" \
  -d "redirect_uri=$REDIRECT_URI")

echo "Response: $RESPONSE"

# Extract and output the refresh token
REFRESH_TOKEN=$(echo $RESPONSE | grep -o '"refresh_token": "[^"]*' | cut -d'"' -f4)

if [[ -n "$REFRESH_TOKEN" ]]; then
    echo "Refresh Token: $REFRESH_TOKEN"
else
    echo "Error: Could not retrieve refresh token. Response was:"
    echo $RESPONSE
fi
