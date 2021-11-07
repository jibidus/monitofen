import '@testing-library/jest-dom'
import Vue from 'vue'
import Vuetify from 'vuetify'
import moment from 'moment-timezone'
import {DEFAULT_TIMEZONE} from "./constants";
import axios from "axios";
import 'jest-canvas-mock';

Vue.use(Vuetify)
moment.tz.setDefault(DEFAULT_TIMEZONE);

expect.extend({
    toBeSameInstantAs: (actual, expected) => ({
        message: () => `expected that ${actual.format()} equals ${expected.format()}`,
        // isSame() is not used here, because it returns false in some cases for unknown reason
        pass: actual.format() === expected.format(),
    }),
});


jest.mock('axios', () => ({
    isCancel: () => false,
    CancelToken: {source: jest.fn()},
    get: jest.fn(),
}));

jest.mock('use-resize-observer', () => ({
    __esModule: true,
    default: jest.fn().mockImplementation(() => ({
        observe: jest.fn(),
        unobserve: jest.fn(),
        disconnect: jest.fn(),
    })),
}));

window.ResizeObserver =
    window.ResizeObserver ||
    jest.fn().mockImplementation(() => ({
        disconnect: jest.fn(),
        observe: jest.fn(),
        unobserve: jest.fn(),
    }));

var cancelTokenId = 0;
beforeEach(() => {
    jest.clearAllMocks();
    axios.CancelToken.source.mockImplementation(() => ({token: cancelTokenId++}));
});

