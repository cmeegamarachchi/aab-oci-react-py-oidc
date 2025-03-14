#!/bin/bash

set -e  # Exit script on failure
set -a  # Auto-export variables

# Load .env file if it exists
if [ -f .env ]; then
    source .env
fi

set +a  # Disable auto-export

# Define image and container names
IMAGE_NAME="aab-oci-react-py"
CONTAINER_NAME="aab-oci-react-py"

# Read ports from environment variables or set default values
FRONTEND_PORT=${FRONTEND_PORT:-5173}
API_PORT=${API_PORT:-8000}

echo "Building the frontend..."
cd frontend || { echo "Frontend directory not found! Exiting..."; exit 1; }
npm install && npm run build || { echo "Frontend build failed! Exiting..."; exit 1; }
cd - || exit 1

echo "Building the backend..."
cd api || { echo "Backend directory not found! Exiting..."; exit 1; }
pip install --no-cache-dir -r requirements.txt || { echo "Backend dependency installation failed! Exiting..."; exit 1; }
cd - || exit 1

echo "Building the Docker image..."
docker  build --build-arg FRONTEND_PORT="$FRONTEND_PORT" \
             --build-arg API_PORT="$API_PORT" \
             --build-arg VITE_UI_OIDC_AUTHORITY="$VITE_UI_OIDC_AUTHORITY" \
             --build-arg VITE_UI_OIDC_CLIENT_ID="$VITE_UI_OIDC_CLIENT_ID" \
             --build-arg VITE_UI_OIDC_REDIRECT_URI="$VITE_UI_OIDC_REDIRECT_URI" \
             --build-arg VITE_UI_OIDC_SCOPE="$VITE_UI_OIDC_SCOPE" \
             --build-arg API_OIDC_APP_CLIENT_ID="$API_OIDC_APP_CLIENT_ID" \
             --build-arg API_OIDC_JWKS_URL="$API_OIDC_JWKS_URL" \
             --build-arg API_OIDC_ISSUER="$API_OIDC_ISSUER" \
             -t "$IMAGE_NAME" . || { echo "Docker build failed! Exiting..."; exit 1; }

echo "Stopping and removing any existing container..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Running the new container..."
docker run -d --restart=always --name $CONTAINER_NAME --env-file .env \
           -p $FRONTEND_PORT:$FRONTEND_PORT -p $API_PORT:$API_PORT $IMAGE_NAME

echo "Deployment complete!"
echo "Frontend available at: http://localhost:$FRONTEND_PORT"
echo "API available at: http://localhost:$API_PORT"
