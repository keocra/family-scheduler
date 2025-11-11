FROM node:25-alpine3.21 AS builder

COPY . /app

WORKDIR /app

RUN npm install
RUN npm run build

FROM nginx:1.29.3-alpine AS runner

WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist /usr/share/nginx/html
