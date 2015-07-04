help:
	@echo ""
	@echo "Following commands are available:"
	@echo " "
	@echo "     make qa             : Run quality assurance on the source code (unit tests, linters, etc)"
	@echo "     make qa_test        : Run quality assurance on the test code (linters, etc)"
	@echo "     make qa_all         : Run quality assurance on both the source code and the test code"
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

# run the PHPUnit tests
test:
	@./vendor/bin/phpunit

# run PHPCS on the source code and show any style violations
phpcs:
	@./vendor/bin/phpcs --standard=psr2 src

# run PHPCBF to auto-fix code style violations
phpcs_fix:
	@./vendor/bin/phpcbf --standard=psr2 src

# run PHPCS on the test code and show any style violations
phpcs_test:
	@./vendor/bin/phpcs --standard=psr2 tests

# run PHPCBF on the test code to auto-fix code style violations
phpcs_test_fix:
	@./vendor/bin/phpcbf --standard=psr2 tests

# Run PHP Mess Detector on the source code
phpmd:
	@./vendor/bin/phpmd src text naming,codesize,unusedcode,design

# run PHP Mess Detector on the test code
phpmd_test:
	@./vendor/bin/phpmd tests text unusedcode,design

# run general quality assurance on the source code
qa: test phpcs phpmd

# run general quality assurance on the test code
qa_test: phpcs_test phpmd_test

# run full quality assurance on the source code and the test code
qa_all: qa qa_test
