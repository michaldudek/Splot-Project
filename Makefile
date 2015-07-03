# run the PHPUnit tests
test:
	@./vendor/bin/phpunit

# run PHPCS on the source code and show any style violations
phpcs:
	@./vendor/bin/phpcs --standard=psr2 src

# run PHPCS on the test code and show any style violations
phpcs_test:
	@./vendor/bin/phpcs --standard=psr2 tests

# Run PHP Mess Detector on the source code
phpmd:
	@./vendor/bin/phpmd src text naming,codesize,unusedcode,design

# run PHP Mess Detector on the test code
phpmd_test:
	@./vendor/bin/phpmd tests text unusedcode,design
