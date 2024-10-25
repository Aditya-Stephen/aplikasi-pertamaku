# BAGIAN FRONTEND
FROM node:20 AS frontend-builder
WORKDIR /usr/src/frontend
COPY frontend/package.json ./

# Mengatur variabel lingkungan yang diperlukan
ENV VITE_USER_NAME=${USER_NAME}

# Instal dependensi secara otomatis
RUN npm install
COPY frontend/ .
RUN npm run build

# BAGIAN BACKEND
FROM node:20 AS backend
WORKDIR /usr/src/backend
COPY backend/package.json ./

# Instal dependensi secara otomatis
RUN npm install
COPY backend/ .

# Memindahkan hasil build dari frontend ke folder public di backend
COPY --from=frontend-builder /usr/src/frontend/dist ./public

# Mengekspos port yang digunakan
EXPOSE 3000

# Menentukan perintah untuk menjalankan aplikasi backend
CMD ["npm", "start"]
