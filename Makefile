######################################################
# This is a Makefile for a Splot Project application #
######################################################

# show all available commands
help:
	@echo ""
	@echo "Following commands are available:"
	@echo ""
	@echo "Splot commands:"
	@echo ""
	@echo "     make assets 		: Installs application assets"
	@echo "     make cache_file     : Clears file cache"
	@echo "     make cache_app      : Clears application cache"
	@echo "     make cache          : Clears all caches"
	@echo ""
	@echo "QA commands:"
	@echo ""
	@echo "     make qa             : Run quality assurance on the source code (unit tests, linters, etc)"
	@echo "     make qa_test        : Run quality assurance on the test code (linters, etc)"
	@echo "     make qa_all         : Run quality assurance on both the source code and the test code"
	@echo ""
	@echo "     make workers_start  : Starts Splot Workers defined in the app config"
	@echo "     make workers_stop   : Stops all running Splot Workers"
	@echo "     make workers        : Restarts all running Splot Workers and loads any not-running"
	@echo ""
	@echo "     make test           : Run the PHPUnit tests"
	@echo ""
	@echo "     make phpcs          : Run PHP Code Sniffer to detect code style violations"
	@echo "     make phpcs_fix      : Run PHPCBF to auto-fix any style violations"
	@echo "     make phpcs_test     : Run PHP Code Sniffer on the test code to detect code style violations"
	@echo "     make phpcs_test_fix : Run PHPCBF on the test code to auto-fix any style violations"
	@echo "     make phpmd          : Run PHP Mess Detector to detect potential risks"
	@echo "     make phpmd_test     : Run PHP Mess Detector on the test code to detect potential risks"
	@echo ""

# alias for help target
all: help

###########################
# COMMON SPLOT TASKS
###########################

# starts defined Splot Workers
workers_start:
	@echo ""
	@echo "Starting Splot Workers from the config ..."
	#@nohup php console workqueue:workers:load --env=prod > /dev/null 2>&1 &

# stops defined Splot Workers
workers_stop:
	@echo ""
	@echo "Stopping Splot Workers ..."
	#@php console workqueue:workers:stop --env=prod

# restarts Splot Workers
workers: workers_stop workers_start

# installs application assets
assets:
	@php console assets:install

# clears known file cache
cache_file:
	@echo ""
	@echo "Clearing file cache..."
	@echo rm -rf .cache

# clears app cache
cache_app:
	@echo ""
	@echo "Clearing application cache..."
	@php console cache:clear --env=prod

# clears all caches
cache: cache_app cache_file

# optimize knit indexes
knit_indexes:
	@echo ""
	@echo "Optimizing Knit indexes..."


# optimize the application
optimize: knit_indexes
	@php console knit:indexes:ensure --env=prod

###########################
# QUALITY ASSURANCE
###########################

# run the PHPUnit tests
test:
	@echo ""
	@echo "Running PHPUnit tests ..."
	@./vendor/bin/phpunit

# run PHPCS on the source code and show any style violations
phpcs:
	@echo ""
	@echo "Running PHP Code Sniffer on src/ ..."
	@./vendor/bin/phpcs --standard=psr2 src

# run PHPCBF to auto-fix code style violations
phpcs_fix:
	@echo ""
	@echo "Fixing PHP style violations in src/ ..."
	@./vendor/bin/phpcbf --standard=psr2 src

# run PHPCS on the test code and show any style violations
phpcs_test:
	@echo ""
	@echo "Running PHP Code Sniffer on tests/ ..."
	@./vendor/bin/phpcs --standard=psr2 tests

# run PHPCBF on the test code to auto-fix code style violations
phpcs_test_fix:
	@echo ""
	@echo "Fixing PHP style violations in tests/ ..."
	@./vendor/bin/phpcbf --standard=psr2 tests

# Run PHP Mess Detector on the source code
phpmd:
	@echo ""
	@echo "Running PHP Mess Detector on src/ ..."
	@./vendor/bin/phpmd src text naming,codesize,unusedcode,design

# run PHP Mess Detector on the test code
phpmd_test:
	@echo ""
	@echo "Running PHP Code Sniffer on tests/ ..."
	@./vendor/bin/phpmd tests text unusedcode,design

# run general quality assurance on the source code
qa: test phpcs phpmd

# run general quality assurance on the test code
qa_test: phpcs_test phpmd_test

# run full quality assurance on the source code and the test code
qa_all: qa qa_test

###########################
# BUILDING AND INSTALLING
###########################

# install Composer dependencies for production
composer:
	@echo ""
	@echo "Installing Composer dependencies..."
	@composer install --no-interaction --no-dev --prefer-dist --optimize-autoloader

# install Composer dependencies for development
composer_dev:
	@echo ""
	@echo "Installing Composer dependencies for dev purposes..."
	@composer install --no-interaction

# install NPM dependencies for production
npm:
	@echo ""
	@echo "Installing NPM dependencies..."
	@npm install --no-dev

# install NPM dependencies for development
npm_dev:
	@echo ""
	@echo "Installing NPM dependencies for dev purposes..."
	@npm install

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