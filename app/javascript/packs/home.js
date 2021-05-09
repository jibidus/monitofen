import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import HomePage from "../HomePage";
import MeasuresPage from "../MeasuresPage";
import vuetify from '../plugins/vuetify';
import moment from "moment-timezone";

moment.tz.setDefault("Europe/Paris");
Vue.use(TurbolinksAdapter);
document.addEventListener('turbolinks:load', () => {
    Vue.use(VueRouter);
    const routes = [
        {name: 'home', path: '/', component: HomePage},
        {name: 'measures', path: '/measures', component: MeasuresPage},
    ]
    const router = new VueRouter({
        routes
    })

    new Vue({router, vuetify}).$mount('#app');
});
