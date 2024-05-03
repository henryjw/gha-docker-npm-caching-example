FROM node:21-slim AS base

ENV PNPM_HOME="/pnpm"

RUN corepack enable

# Copy your application code
WORKDIR /app
COPY . .

RUN  --mount=type=cache,target=/pnpm \
  pnpm install --frozen-lockfile

# Use a smaller Node.js image for the final image
FROM node:alpine AS prod

# Set working directory
WORKDIR /app

# Copy only the production dependencies and application code
COPY --from=base /app/node_modules /app/node_modules
COPY --from=base /app .

CMD ["npm", "start"]

