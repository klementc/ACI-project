FROM node

WORKDIR /front-end

COPY . ./
RUN npm install
 
EXPOSE 8080

ENTRYPOINT ["node", "app.js"]
