# Stage 1: Build Frontend
FROM node:latest AS frontend-build
WORKDIR /app/frontend

# Copy dependencies frontend
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend files and build
COPY frontend/ .
RUN npm run build

# Stage 2: Backend Setup
FROM node:latest AS backend
WORKDIR /app/backend

# Copy dependencies backend
COPY backend/package*.json ./
RUN npm install

# Copy the rest of the backend files
COPY backend/ .

# Expose the backend server port
EXPOSE 3000

# Command to run the backend
CMD ["node", "index.js"]

# Stage 3: Combine Backend and Frontend for Production
FROM nginx:alpine AS production
WORKDIR /usr/share/nginx/html

# Copy frontend build output to Nginx html directory
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy the backend server files
COPY --from=backend /app/backend /app/backend

# Expose frontend and backend ports if necessary
EXPOSE 80
EXPOSE 3000
