import logging.config
import yaml
import os


def setup_logger():
    config_file = file_path = os.path.join(os.path.dirname(__file__), 'logging_config.yaml')
    with open(config_file, "r") as file:
        config = yaml.safe_load(file)
        logging.config.dictConfig(config)

    return logging.getLogger("aab-api")

logger = setup_logger()
