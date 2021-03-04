module.exports = {
    preset: '@vue/cli-plugin-unit-jest',
    testMatch: ["**/spec/javascripts/**/*.spec.js"],
    roots: ['<rootDir>'],
    moduleNameMapper: {
        "^@/(.*)$": "<rootDir>/app/javascript/$1"
    },
    resolver: null,
    setupFilesAfterEnv: ['./spec/support/jest-setup.js'],
    collectCoverageFrom: ["app/javascript/**/*.{js,vue}"],
    coverageDirectory: "coverage/frontend"
}
