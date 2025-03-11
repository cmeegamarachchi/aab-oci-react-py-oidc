# Use multi-stage build to build frontend and backend separately

# Stage 1: Build the frontend
FROM node:18 AS frontend-build
WORKDIR /app/frontend
COPY frontend/ .

ARG VITE_UI_OIDC_AUTHORITY
ARG VITE_UI_OIDC_CLIENT_ID
ARG VITE_UI_OIDC_REDIRECT_URI
ARG VITE_UI_OIDC_SCOPE
ENV VITE_UI_OIDC_AUTHORITY=$VITE_UI_OIDC_AUTHORITY
ENV VITE_UI_OIDC_CLIENT_ID=$VITE_UI_OIDC_CLIENT_ID
ENV VITE_UI_OIDC_REDIRECT_URI=$VITE_UI_OIDC_REDIRECT_URI
ENV VITE_UI_OIDC_SCOPE=$VITE_UI_OIDC_SCOPE

RUN npm install && npm run build

# Stage 2: Build the backend
FROM python:3.10 AS backend-build
WORKDIR /app/api
COPY api/ .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 3: Final image
FROM python:3.10
WORKDIR /app
COPY --from=backend-build /app/api /app/api
COPY --from=frontend-build /app/frontend/dist /app/frontend
RUN pip install --no-cache-dir -r api/requirements.txt

# Load environment variables at runtime from the .env file
COPY .env /app/.env

# Environment variables for ports
ENV FRONTEND_PORT=5173
ENV API_PORT=8000
ARG API_OIDC_APP_CLIENT_ID
ARG API_OIDC_JWKS_URL
ARG API_OIDC_ISSUER
ENV API_OIDC_APP_CLIENT_ID=$API_OIDC_APP_CLIENT_ID
ENV API_OIDC_JWKS_URL=$API_OIDC_JWKS_URL
ENV API_OIDC_ISSUER=$API_OIDC_ISSUER

# Serve frontend and API using a simple Python server for static files
CMD ["sh", "-c", "uvicorn api:app --host 0.0.0.0 --port $API_PORT & python -m http.server $FRONTEND_PORT --directory /app/frontend"]
