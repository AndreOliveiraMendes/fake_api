import os
from dotenv import load_dotenv

load_dotenv()

API_HOST = os.getenv("API_HOST", "0.0.0.0")
API_BASIC_USER = os.getenv("API_BASIC_USER", "appuser")
API_BASIC_PASS = os.getenv("API_BASIC_PASS", "apppassword")
TOKEN = os.getenv("RELOAD_TOKEN", "BATATA")