import os
from dotenv import load_dotenv

load_dotenv()

API_BASIC_USER = os.getenv("API_BASIC_USER", "appuser")
API_BASIC_PASS = os.getenv("API_BASIC_PASS", "apppassword")