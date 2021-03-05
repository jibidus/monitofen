module.exports = {
    plugins: ["jest-dom", "jest", "testing-library"],
    extends: ["plugin:jest-dom/recommended", "eslint:recommended", "plugin:vue/recommended", "plugin:testing-library/recommended", "plugin:testing-library/vue"],
    env: {
        "jest/globals": true
    }
};
