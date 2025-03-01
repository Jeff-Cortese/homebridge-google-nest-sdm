Fork of [homebridge-google-nest-sdm](https://github.com/potmat/homebridge-google-nest-sdm)

- Only supports nest thermostat
- Adds [helper script](./get_refresh_token.sh) to generate refresh token. 
  - This requires a "Desktop App" Google OAuth client.
  - Ensure that `CLIENT_ID` and `CLIENT_SECRET` are set in your terminal session.
  - NOTE: The refresh_token will expire in seven days when the [`Google Auth Platform > Audience > Publishing Status`](https://console.cloud.google.com/auth/audience) is in test mode. Publishing the app removes the expiration (This will not remove expiration from an existing token. You must regenerate the refresh_token one time after turning off test mode)