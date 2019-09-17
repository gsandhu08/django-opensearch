# django-opensearch
# Makefile


.ONESHELL:
PHONY: tox test makemessages compilemessages bumpversion build check twine-check twine-upload clean coverage help
TEST_PYPI_URL=https://test.pypi.org/legacy/
NAME=opensearch
EXTENSIONS=py,html,txt
TRASH_DIRS=build dist *.egg-info .tox .mypy_cache __pycache__
TRASH_FILES=.coverage coverage.xml Pipfile.lock
BUILD_TYPES=bdist_wheel sdist
VERSION=`python -c "import configparser; config = configparser.ConfigParser(); config.read('setup.cfg'); print(config['metadata']['version']);"`

tox:
	tox;\

test:
	./manage.py test $(TESTS);\

makemessages:
	cd $(NAME);\
	for locale in `ls locale`; do\
		django-admin makemessages --locale=$$locale --extension=$(EXTENSIONS);\
	done;\

compilemessages:
	django-admin compilemessages;\

bumpversion:
	git tag -a $(VERSION) -m 'v$(VERSION)'

build:
	python setup.py $(BUILD_TYPES);\

check:
	pre-commit run --all-files

twine-check:
	twine check dist/*;\
	twine upload -s --repository-url $(TEST_PYPI_URL) dist/*;\

twine-upload:
	twine upload -s dist/*;\

clean:
	for file in $(TRASH_FILES); do\
		find -iname $${file} -print0 | xargs -0 rm -rf;\
	done;\
	for dir in $(TRASH_DIRS); do\
		find -type d -name $${dir} -print0 | xargs -0 rm -rf;\
	done;\

coverage:
	coverage xml;\
	python-codacy-coverage -r coverage.xml;\

help:
	@echo "    help:"
	@echo "        Show this help."
	@echo "    tox:"
	@echo "        Run tox."
	@echo "    test:"
	@echo "        Run tests, can specify tests with 'TESTS' variable."
	@echo "    makemessages:"
	@echo "        Harvest translations."
	@echo "    compilemessages:"
	@echo "        Compile translations."
	@echo "    bumpversion:"
	@echo "        Tag current code revision with version."
	@echo "    build:"
	@echo "        Build python packages, can specify packages types with 'BUILD_TYPES' variable."
	@echo "    check:"
	@echo "        Perform some code checks."
	@echo "    twine-check:"
	@echo "        Run some twine checks."
	@echo "    twine-upload:"
	@echo "        Uload package to PyPi using twine."
	@echo "    clean:"
	@echo "        Recursively delete useless autogenerated files and directories, directories and files list can be overriden through 'TRASH_DIRS' and 'TRASH_FILES' variables."
	@echo "    coverage:"
	@echo "        Generate and upload coverage report to Codacy."
