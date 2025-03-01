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
echo "1. You will be redirected to a page to choose/login to your google account."
echo "2. After you login, you will be redirected to a page that says 'Google hasn't verified this app'. This is expected. Click 'Advanced' and then 'Go to <Your App Name> (unsafe)'"
echo "3. Next, you will be asked to grant permission to the application. Select All, and continue."
echo "4. Finally, you will be redirected to a an empty page with localhost in the URL. This is expected."
echo '5. Copy the authorization code parameter from your browsers address bar and paste it below. The parameter will be in the form of http://localhost/?code=......&" Copy everything between the = and &. Do not include the = or &.'
echo ""
echo "URL: https://accounts.google.com/o/oauth2/v2/auth?client_id=$CLIENT_ID&response_type=code&redirect_uri=$REDIRECT_URI&scope=$SCOPES&access_type=offline&prompt=consent"
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
