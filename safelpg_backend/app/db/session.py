import logging
from supabase import create_client, Client
from app.core.config import settings

logger = logging.getLogger(__name__)

def get_supabase_client() -> Client | None:
    """
    Initialize and return the Supabase client using configuration.
    Returns None if configuration is missing.
    """
    if not settings.SUPABASE_URL or not settings.SUPABASE_SERVICE_ROLE_KEY:
        logger.warning("Supabase URL or Key is missing. Supabase client will not be initialized.")
        return None
        
    try:
        supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_SERVICE_ROLE_KEY)
        logger.info("Supabase client successfully initialized.")
        return supabase
    except Exception as e:
        logger.error(f"Failed to initialize Supabase client: {e}")
        return None

# Singleton instance for use across the application
supabase_client = get_supabase_client()
