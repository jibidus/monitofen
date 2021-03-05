module.exports = {
    plugins: ["jest-dom", "jest"],
    extends: ["plugin:jest-dom/recommended", "eslint:recommended", "plugin:vue/recommended"],
    env: {
        "jest/globals": true
    }
};
