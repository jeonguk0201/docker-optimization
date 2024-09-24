# Step 1: Use a larger Node.js image
FROM node:16

# Step 2: Set working directory
WORKDIR /usr/src/app

# Step 3: Copy package.json and install dependencies
COPY app/package*.json ./
RUN npm install

# Step 4: Copy application code
COPY app/ .

# Step 5: Expose the application port
EXPOSE 3000

# Step 6: Start the application
CMD ["npm", "start"]
