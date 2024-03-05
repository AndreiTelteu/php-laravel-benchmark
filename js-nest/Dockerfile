FROM oven/bun:1

USER bun
WORKDIR /usr/src/app/nest
COPY --chown=bun:bun ./nest .
RUN bun install && bun run build

EXPOSE 3000
CMD [ "bun", "run", "start:prod" ]

# for debuging
# CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
