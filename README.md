# Appsolve Application Blocks React Fast-api starter kit with OpenID Connect authentication

This project is a starter kit for building OpenID Connect authentication enabled, full-stack web applications using React.js for the frontend and FastAPI for the backend. It is designed for flexibility, allowing you to run the application either within a containerized environment or as standalone services.

> [!WARNING]  
> Current implementation is using `id-token` for api authentication, which is not a good practice. This will be fixed in an up comming release

## Environment variables

Plesae create an `.env` file at project root and add following variables. This .env file will also get copied to container to be used at runtime

### Frontend
* `VITE_UI_OIDC_AUTHORITY` : Sets authority. 
    * For Entra, `"https://login.microsoftonline.com/[TENENT_ID]/v2.0"`. 
    * For cognito `"https://cognito-idp.[REGION].amazonaws.com/[USER_POOL_ID]"`
* `VITE_UI_OIDC_CLIENT_ID`
    * For Entra, `"[APP_CLIENT_ID]"`. 
    * For cognito `"[APP_CLIENT_ID]"`    
* `VITE_UI_OIDC_REDIRECT_URI`: Apps redirect url. Generally this would be something like `"http://localhost:8000"`    
* `VITE_UI_OIDC_SCOPE`: Define a list of application scopes. For entra, remember to add `"[APP_CLIENT_ID]/.default"`
    * For Entra, `"openid profile email fa966437-8284-4257-b497-4d30a7e7e1f1/.default`. 
    * For cognito `"email openid phone"` 

### API
* `API_OIDC_APP_CLIENT_ID`: App client id
* `API_OIDC_JWKS_URL`: JWT keys url
    * For Azure: `https://login.microsoftonline.com/[TENENT_ID]/discovery/v2.0/keys`
    * For cognito: `https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_USERPOOL_ID}/.well-known/jwks.json`
* `API_OIDC_ISSUER`:
    * For Azure: `https://login.microsoftonline.com/[TENENT_ID]/v2.0`
    * For cognito: `https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_USERPOOL_ID}` 


## To start in non container mode
### Frontend
```bash
cd frontend
npm install
npm run dev
```

### API
```bash
cd api
pip install -r requirements.txt
cd ..
uvicorn api:app --reload
```

## To run in container mode
```bash
chmod +c build-n-run.sh
sudo ./build-n-run.sh
```

## Logging
### API Logging
`api/common/logging_config.yaml` can be used to customised logging

