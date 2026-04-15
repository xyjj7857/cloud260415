# 使用 Node.js 20 作为基础镜像
FROM node:20-bullseye

# 设置工作目录
WORKDIR /app

# 安装 better-sqlite3 所需的编译工具
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装所有依赖（包括开发依赖，因为构建前端和运行 tsx 需要它们）
RUN npm install

# 复制项目所有文件
COPY . .

# 构建前端静态文件
RUN npm run build

# 暴露端口（与 docker-compose.yml 一致）
EXPOSE 3333

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=3333

# 启动应用
# 使用 package.json 中的 start 脚本: NODE_ENV=production tsx server.ts
CMD ["npm", "start"]
