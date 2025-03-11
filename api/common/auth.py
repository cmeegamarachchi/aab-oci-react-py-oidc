import jwt
from api.common.logger_config import logger
from jwt import PyJWKClient
from fastapi import HTTPException, Depends
from fastapi.security import HTTPBearer
from starlette.requests import Request

import os
from dotenv import load_dotenv

load_dotenv()

APP_CLIENT_ID = os.getenv("API_OIDC_APP_CLIENT_ID")
JWKS_URL = os.getenv("API_OIDC_JWKS_URL")
ISSUSR = os.getenv("API_OIDC_ISSUER")

logger.info(f"API_OIDC_APP_CLIENT_ID: {APP_CLIENT_ID}")
logger.info(f"API_OIDC_JWKS_URL: {JWKS_URL}")
logger.info(f"API_OIDC_ISSUER: {ISSUSR}")

jwks_client = PyJWKClient(JWKS_URL)

bearer_scheme = HTTPBearer()

def verify_jwt(token: str):
    try:
        signing_key = jwks_client.get_signing_key_from_jwt(token).key
        
        payload = jwt.decode(
            token,
            signing_key,
            algorithms=["RS256"],
            audience=APP_CLIENT_ID,
            issuer=ISSUSR
        )

        return payload

    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token has expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")
    except ValueError as e:
        raise HTTPException(status_code=500, detail="Invalid token")
    except:
        raise HTTPException(status_code=500, detail="Invalid token")

# Dependency to secure routes
def get_current_user(request: Request, token=Depends(bearer_scheme)):
    return verify_jwt(token.credentials)
