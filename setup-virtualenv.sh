#!/bin/bash -
virtualenv -p python3 /tmp/devnetvenv
current_dir=$(pwd)
echo "export PYTHONPATH=$current_dir" >> /tmp/devnetvenv/bin/activate
/tmp/devnetvenv/bin/pip install --upgrade pip
/tmp/devnetvenv/bin/pip install --upgrade setuptools