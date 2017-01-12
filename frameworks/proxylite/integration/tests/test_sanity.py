import dcos.http
import dcos.marathon
import json
import pytest
import re
import shakedown

from tests.test_utils import (
    check_health,
    get_deployment_plan,
    install,
    request,
    uninstall
)


def setup_module(module):
    uninstall()
    install()
    check_health()


@pytest.mark.sanity
def test_example():
    request(
        dcos.http.get,
        '{}/example'.format(shakedown.dcos_service_url('proxylite')))


@pytest.mark.sanity
def test_google():
    request(
        dcos.http.get,
        '{}/google'.format(shakedown.dcos_service_url('proxylite')))


@pytest.mark.sanity
def test_httpd():
    request(
        dcos.http.get,
        '{}/httpd'.format(shakedown.dcos_service_url('proxylite')))


@pytest.mark.sanity
def test_plan():
    get_deployment_plan()

