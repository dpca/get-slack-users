# Get slack users

Gets slack users and records their names and emails in a CSV.

## Setup

Get a test token from https://api.slack.com/docs/oauth-test-tokens and put it
in a .env file as `SLACK_TOKEN`.

You will also need to install the `dotenv` and `rest-client` gems.

## Usage

Simply `./run.rb` and you should get a `team.csv` written.
