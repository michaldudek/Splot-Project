######################################################
# This is a Makefile for a Splot Project application #
######################################################

# show all available commands
help:
	@echo ""
	@echo "Following commands are available:"
	@echo "(this is a summary of the main commands, for more fine-grained commands see the Makefile itself)"
	@echo ""
	@echo "     make help           : This info"
	@echo ""
	@echo "  Splot commands:"
	@echo "     make cache          : Clears all caches"
	@echo "     make workers        : Restarts background workers"
	@echo ""
	@echo "  QA commands:"
	@echo "     make qa             : Run quality assurance on the source code (unit tests, linters, etc)"
	@echo "     make qa_test        : Run quality assurance on the test code (linters, etc)"
	@echo "     make qa_all         : Run quality assurance on both the source code and the test code"
	@echo ""
	@echo "     make test           : Run the PHPUnit tests"
	@echo ""
	@echo "     make phpcs          : Run PHP Code Sniffer to detect code style violations"
	@echo "     make phpmd          : Run PHP Mess Detector to detect potential risks"
	@echo "     make jslint         : Lint the application's JavaScript"
	@echo ""
	@echo "  Build commands:"
	@echo "     make assets         : Installs and builds frontend assets"
	@echo "     make optimize       : Optimizes various aspects of the application"
	@echo ""
	@echo "     make build          : Builds the application for production"
	@echo "     make build_dev      : Builds the application for development"
	@echo ""
	@echo "     make deploy         : Deploys the application"
	@echo ""

# alias for help target
all: help

###########################
# COMMON SPLOT TASKS
###########################

# starts defined Splot Workers
workers_start:
	#@nohup php console workqueue:workers:load --env=prod > /dev/null 2>&1 &

# stops defined Splot Workers
workers_stop:
	#@php console workqueue:workers:stop --env=prod

# restarts Splot Workers
workers: workers_stop workers_start

# installs application assets
assets_install:
	@php console assets:install


# clears known file cache
cache_file:
	@echo "Clearing file cache..."
	@echo rm -rf .cache

# clears app cache
cache_app:
	@php console cache:clear --env=prod

# clears all caches
cache: cache_app cache_file

# optimize knit indexes
knit_indexes:
	@php console knit:indexes:ensure --env=prod

###########################
# QUALITY ASSURANCE
###########################

# run the PHPUnit tests
test:
	@./vendor/bin/phpunit

# run PHPCS on the source code and show any style violations
phpcs:
	@echo "Running PHP Code Sniffer on src/ ..."
	@./vendor/bin/phpcs --standard=psr2 src

# run PHPCBF to auto-fix code style violations
phpcs_fix:
	@echo "Fixing PHP style violations in src/ ..."
	@./vendor/bin/phpcbf --standard=psr2 src

# run PHPCS on the test code and show any style violations
phpcs_test:
	@echo "Running PHP Code Sniffer on tests/ ..."
	@./vendor/bin/phpcs --standard=psr2 tests

# run PHPCBF on the test code to auto-fix code style violations
phpcs_test_fix:
	@echo "Fixing PHP style violations in tests/ ..."
	@./vendor/bin/phpcbf --standard=psr2 tests

# Run PHP Mess Detector on the source code
phpmd:
	@echo "Running PHP Mess Detector on src/ ..."
	@./vendor/bin/phpmd src text naming,codesize,unusedcode,design

# run PHP Mess Detector on the test code
phpmd_test:
	@./vendor/bin/phpmd tests text unusedcode,design

# lint the JavaScript
jslint:
	@gulp js:lint

# run general quality assurance on the source code
qa: test phpcs phpmd jslint

# run general quality assurance on the test code
qa_test: phpcs_test phpmd_test

# run full quality assurance on the source code and the test code
qa_all: qa qa_test

###########################
# BUILDING AND INSTALLING
###########################

##### building frontend assets

# compiles and builds CSS
css:
	@gulp less

# compiles and builds JavaScript
js:
	@gulp js-libs
	@gulp js

# builds application assets
assets: assets_install css js

##### package managers

# install Composer dependencies for production
composer:
	@composer install --no-interaction --no-dev --prefer-dist --optimize-autoloader

# install Composer dependencies for development
composer_dev:
	@composer install --no-interaction

# update Composer dependencies, including development dependencies
composer_update:
	@composer update

# optimize the composer
composer_optimize:
	@composer dumpautoload

# install NPM dependencies for production
npm:
	@npm install --no-dev

# install NPM dependencies for development
npm_dev:
	@npm install

##### building

# optimize the application
optimize: knit_indexes composer_optimize cache

# perform build tasks before switching code to live
build_pre: composer npm cache assets

# perform build tasks after switching code to live
build_post: optimize workers

# perform build dev tasks before switching code to live
build_dev_pre: composer_dev npm_dev cache assets

# perform build dev tasks after switching code to live
build_dev_post: build_post

# build the application for production
build: build_pre build_post

# build the application for development
build_dev: build_dev_pre build_dev_post

# deploy the application to the production environment
deploy:
	@echo ""
	@echo "Deploying the application..."
	@cap prod deploy
