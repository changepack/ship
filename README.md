![CI](https://github.com/changepack/changepack/actions/workflows/ci.yml/badge.svg)

Changepack is an open-source changelog for your product. Share updates about your product with your customers and keep people in the loop!

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Build and run locally

```
git clone https://github.com/changepack/changepack.git
cd changepack

# Install dependencies
bundle install
yarn install

# Update environment variables
cp config/application.yml.example config/application.yml

# Run application
bundle exec rails s
```

Use `tmuxinator` or `foreman` to run backgrounds processes like `guard`, a `cypruss` server, or a `tailwindcss` watcher.
