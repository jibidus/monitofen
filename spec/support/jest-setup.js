import '@testing-library/jest-dom'
import Vue from 'vue'
import Vuetify from 'vuetify'
import moment from 'moment-timezone'
import {DEFAULT_TIMEZONE} from "./constants";

Vue.use(Vuetify)
moment.tz.setDefault(DEFAULT_TIMEZONE);
