import http from "http";
import express from "express";
import { nodelogger as logger } from "white-logger/node";
import * as ansicode from "white-logger/utils/ansicode";

import { todoRouter } from "./routers";

import type { RequestHandler } from "express";

type MethodColor = ansicode.ansiBack | ansicode.ansiFont;
type ApiLoggerMiddlewareOption = {
  methodColor: MethodColor;
};

const apiLoggerMiddleware = (option?: Partial<ApiLoggerMiddlewareOption>): RequestHandler => {
  let methodColor: MethodColor = ansicode.ansiFont.yellow;
  if (option?.methodColor) {
    methodColor = option?.methodColor;
  }
  return (req, _, next) => {
    logger.infoConsole(
      "api",
      `${methodColor}${req.method}${ansicode.ansiFont.reset}`,
      req.url,
      "ip:",
      req.ip,
      "hostname:",
      req.hostname,
    );
    // To ensure that ansi code is not written to the log file
    logger.infoWrite("api", req.method, req.url, "ip:", req.ip, "hostname:", req.hostname);
    next();

    return;
  };
};

const startServer = (PORT: number) => {
  const app = express();
  app.use(express.json());
  app.use(
    express.urlencoded({
      extended: true,
    }),
  );
  app.use(apiLoggerMiddleware());
  const server = http.createServer(app);

  app.get("/ping", (req, res) => {
    res.json({
      pong: "server is running",
    });
  });

  app.use("/todo", todoRouter);

  server.listen(PORT, () => {
    logger.nomal("server", __filename, "server is running on port", PORT);
  });
};

export default startServer;
