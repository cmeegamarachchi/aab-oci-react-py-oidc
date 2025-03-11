#!/bin/bash

# Load .env file
if [ -f .env ]; then
    while IFS='=' read -r key value; do
        # Skip empty lines and comments
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        # Remove potential surrounding quotes
        value=$(echo "$value" | sed -E 's/^"(.*)"$/\1/;s/^'\''(.*)'\''$/\1/')
        export "$key=$value"
    done < .env
fi


# Define image name and container name
IMAGE_NAME="aab-oci-react-py"
CONTAINER_NAME="aab-oci-react-py"

# Read ports from environment variables or set default values
FRONTEND_PORT=${FRONTEND_PORT:-5173}
API_PORT=${API_PORT:-8000}

echo "Building the frontend..."
cd frontend || exit 1
npm install && npm run build
cd - || exit 1

echo "Building the backend..."
cd api || exit 1
pip install --no-cache-dir -r requirements.txt
cd - || exit 1

echo "Building the Docker image..."
docker build --build-arg FRONTEND_PORT=$FRONTEND_PORT \
             --build-arg API_PORT=$API_PORT \
             --build-arg VITE_UI_OIDC_AUTHORITY=$VITE_UI_OIDC_AUTHORITY \
             --build-arg VITE_UI_OIDC_CLIENT_ID=$VITE_UI_OIDC_CLIENT_ID \
             --build-arg VITE_UI_OIDC_REDIRECT_URI=$VITE_UI_OIDC_REDIRECT_URI \
             --build-arg VITE_UI_OIDC_SCOPE=$VITE_UI_OIDC_SCOPE \
             --build-arg API_OIDC_APP_CLIENT_ID=$API_OIDC_APP_CLIENT_ID \
             --build-arg API_OIDC_JWKS_URL=$API_OIDC_JWKS_URL \
             --build-arg API_OIDC_ISSUER=$API_OIDC_ISSUER \
             -t $IMAGE_NAME .

echo "Stopping and removing any existing container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "Running the new container..."
docker run -d --name $CONTAINER_NAME --env-file .env -p $FRONTEND_PORT:$FRONTEND_PORT -p $API_PORT:$API_PORT $IMAGE_NAME

echo "Deployment complete!"
echo "Frontend available at: http://localhost:$FRONTEND_PORT"
echo "API available at: http://localhost:$API_PORT"
