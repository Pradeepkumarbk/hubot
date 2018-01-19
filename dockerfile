FROM node:carbon

# Create app directory
WORKDIR /usr/src/bot

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
COPY bin/ ./
COPY scripts/ ./
COPY Procfile ./
COPY .env ./

ENV HUBOT_GITHUB_USER ""
ENV HUBOT_GITHUB_API ""
ENV HUBOT_GITHUB_ACCESS_TOKEN ""
ENV SLACK_VERIFICATION_TOKEN ""
ENV HUBOT_GITHUB_ORG_NAME ""
ENV PORT ""
ENV BIND_ADDRESS ""

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 80
CMD [ "npm", "start" ]
