import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue'
import VueRouter from 'vue-router'
import vuetify from '../plugins/vuetify';
import App from '../App';
import moment from "moment-timezone";
import routes from "../routes";

moment.tz.setDefault("Europe/Paris");
Vue.use(TurbolinksAdapter);
document.addEventListener('turbolinks:load', () => {
    Vue.use(VueRouter);
    const router = new VueRouter({routes})
    new Vue({router, vuetify, render: h => h(App)}).$mount('#app');
});
