release: ./release.sh
web: bin/rails s -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bin/sidekiq -e ${RACK_ENV:-development}
