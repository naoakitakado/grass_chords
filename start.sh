#!/bin/sh
# bundle exec rails webpacker:compile RAILS_ENV=production
bundle exec rails db:create RAILS_ENV=production
bundle exec rails db:migrate RAILS_ENV=production
bundle exec unicorn -p 3000 -c /grasschords/config/unicorn.rb -E production
