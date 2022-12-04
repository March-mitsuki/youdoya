import path from "path";

export async function initDotenv() {
  const dotenv = await import("dotenv").then();
  const dotenvResult = dotenv.config({ path: path.resolve(process.cwd(), ".env.local") });
  if (dotenvResult.error) {
    throw dotenvResult.error;
  } else {
    console.log("\x1b[32m" + "dotenv init successfully" + "\x1b[0m");
  }
}