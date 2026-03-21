from importlib.metadata import PackageNotFoundError, version


def get_app_version() -> str:
    try:
        return version("k8s-demo-backend")
    except PackageNotFoundError:
        return "dev"
