# Stage 1
FROM alpine AS build
WORKDIR /app
COPY index.html .

# Stage 2
FROM nginx:alpine
COPY --from=build /app/index.html /usr/share/nginx/html/index.html
