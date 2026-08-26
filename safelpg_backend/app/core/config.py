import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "SafeLPG API"
    SUPABASE_URL: str = os.getenv("SUPABASE_URL", "")
    # Use Service Role Key for backend administrative operations
    SUPABASE_SERVICE_ROLE_KEY: str = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")

settings = Settings()
