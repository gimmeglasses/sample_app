#!/usr/bin/env bash
# exit on error
set -o errexit
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate:reset
#DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load
# bundle exec rails db:seed

# The above codes caused the following error:

# I, [2025-06-01T14:06:51.267540 #117] INFO -- : [595f0b44-02ff-4613-a92e-86e3828d9a77] Completed 200 OK in 104ms (Views: 98.6ms | Allocations: 6743)
# I, [2025-06-01T14:07:41.498957 #117] INFO -- : [e1afa421-21d4-4cf9-81dc-1bbbdeb14033] Started GET "/" for 172.68.119.87 at 2025-06-01 14:07:41 +0000
# I, [2025-06-01T14:07:41.499866 #117] INFO -- : [e1afa421-21d4-4cf9-81dc-1bbbdeb14033] Processing by StaticPagesController#home as HTML
# I, [2025-06-01T14:07:41.864873 #117] INFO -- : [e1afa421-21d4-4cf9-81dc-1bbbdeb14033] Completed 500 Internal Server Error in 365ms (ActiveRecord: 90.3ms | Allocations: 9546)
# F, [2025-06-01T14:07:41.865513 #117] FATAL -- : [e1afa421-21d4-4cf9-81dc-1bbbdeb14033]
# [e1afa421-21d4-4cf9-81dc-1bbbdeb14033] BCrypt::Errors::InvalidHash (invalid hash):

