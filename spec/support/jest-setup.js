import '@testing-library/jest-dom'
import Vue from 'vue'
import Vuetify from 'vuetify'
import moment from 'moment-timezone'

Vue.use(Vuetify)
moment.tz.setDefault("Europe/Paris");
