const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const MomentTimezoneDataPlugin = require('moment-timezone-data-webpack-plugin');

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.plugins.prepend('MomentTimezoneDataPlugin', new MomentTimezoneDataPlugin({matchZones: /^Europe\/Paris/}))
environment.loaders.prepend('vue', vue)
environment.config.resolve.alias = { 'vue$': 'vue/dist/vue.esm.js' };
module.exports = environment
