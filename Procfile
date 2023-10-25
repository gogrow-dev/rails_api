release: ./release.sh
web: bin/rails s -p ${PORT:-3000} -e ${RAILS_ENV:-development}
worker: bin/sidekiq -e ${RAILS_ENV:-development}
