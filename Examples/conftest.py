import pytest

def pytest_addoption(parser):
    parser.addoption(
        "--detailed", action="store_true", help="detailed test"
    )


@pytest.fixture
def detailed(request):
    return request.config.getoption("--detailed")