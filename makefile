.PHONY: unit bootstrap

lint_yaml:
	sh -c '. /tmp/devnetvenv/bin/activate; /tmp/devnetvenv/bin/yamllint .'

lint_python:
	sh -c '. /tmp/devnetvenv/bin/activate; /tmp/devnetvenv/bin/flake8 . --ignore F811'

unit: check_openvswitch_playbook

contract: bootstrap
	sh -c '. /tmp/devnetvenv/bin/activate; pytest tests/contract --capture=no'

integration: bootstrap
	sh -c '. /tmp/devnetvenv/bin/activate; cd tests/smoke && behave'

check_ansible_syntax: bootstrap
	sh -c '. /tmp/devnetvenv/bin/activate; ansible-playbook playbook/site.yml -i playbook/hosts --syntax-check'

check_openvswitch_playbook: bootstrap
	sh -c '. /tmp/devnetvenv/bin/activate; pytest tests/unit --capture=no'

openvswitch_box:
	cd ovs-vagrant && vagrant up
	cd ovs-vagrant && vagrant package --output openvswitch.box
	cd ovs-vagrant && vagrant box add openvswitch openvswitch.box --force

bootstrap:
	./setup-virtualenv.sh