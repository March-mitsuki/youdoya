module.exports = {
  extends: "../../.eslintrc.cjs",
  plugins: ["react-hooks"],
  parserOptions: {
    tsconfigRootDir: "./",
    project: ["./tsconfig.json"],
  },
  rules: {
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
  },
};
