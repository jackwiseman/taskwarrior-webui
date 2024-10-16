FROM alpine:3.20

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --no-cache add nodejs npm nginx task3 python3 build-base

COPY ./frontend /src/frontend
COPY ./backend /src/backend
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/server.conf /etc/nginx/conf.d/default.conf
COPY ./docker/start.sh /start.sh
COPY ./docker/setup-sync.sh /setup-sync.sh

ENV TASKRC="/taskrc"
ENV TASKDATA="/.task"

# Fix npm build
ENV NODE_OPTIONS="--openssl-legacy-provider"

# Frontend
RUN cd /src/frontend && npm ci \
	&& npm run build && npm run export \
	&& cp -r /src/frontend/dist /static \
	&& rm -r /src/frontend

# Backend
RUN cd /src/backend && npm ci \
	&& npm run build \
	&& npm prune --production \
	&& rm -r /src/backend/src

EXPOSE 80

# sync task data every minute
RUN touch crontab.tmp \
	&& echo "* * * * * /usr/bin/task sync >> /var/log/task_log.txt 2>&1" > crontab.tmp \
	&& crontab crontab.tmp \
	&& rm crontab.tmp

CMD ["/start.sh"]
