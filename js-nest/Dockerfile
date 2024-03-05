FROM node:21

RUN corepack enable
USER node
WORKDIR /home/node/nest
COPY --chown=node:node ./nest .
RUN pnpm config set store-dir /home/node/.pnpm; \
    pnpm install && pnpm run build

EXPOSE 3000
CMD [ "pnpm", "run", "start:prod" ]

# for debuging
# CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
