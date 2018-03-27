.PHONY: unit bootstrap

pipeline:
	sh -c 'docker-compose up -d'

unit: check_ansible_syntax check_openvswitch_playbook

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

bootstrap: virtualenv
ifneq ($(wildcard requirements.txt),)
	/tmp/devnetvenv/bin/pip install -r requirements.txt
endif

virtualenv:
	virtualenv -p python3 /tmp/devnetvenv
	/tmp/devnetvenv/bin/pip install --upgrade pip
	/tmp/devnetvenv/bin/pip install --upgrade setuptools
