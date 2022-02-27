import MeasurementsChartWrapper from '@/components/MeasurementsChartWrapper.vue'
import renderCmp from "../../support/render";
import {byTestId, byText} from 'testing-library-selector'
import {screen} from '@testing-library/vue';
import buildMetric from '../factories/metric';
import buildMeasurement from '../factories/measurement';
import buildResponse from "../factories/http_response";
import moment from "moment-timezone";
import MockDate from 'mockdate'
import axios from "axios";
import {DEFAULT_TIMEZONE} from "../../support/constants";
import { createLocalVue } from '@vue/test-utils';


const ui = {
    placeholder: byText('No measurement'),
    chart: byTestId('chart')
};

describe("<MeasurementsChartWrapper/>", function () {
    let localVue;
    beforeEach(() => {
        localVue = createLocalVue();
    });
    describe('without any measurement', () => {
        beforeEach(async () => {
            axios.get.mockResolvedValue(buildResponse.Successful([]));
            await renderCmp(MeasurementsChartWrapper, {localVue, props: {metric: buildMetric()}});
        });
        it('shows placeholder', () => {
            expect(ui.placeholder.get()).toBeVisible();
        });
    });
    describe('with measurements', () => {
        beforeEach(async () => {
            MockDate.set('2021-02-16T22:26:51+01:00');
            axios.get.mockResolvedValue(buildResponse.Successful([buildMeasurement(), buildMeasurement(), buildMeasurement()]));
            await renderCmp(MeasurementsChartWrapper, {localVue, props: {metric: buildMetric()}});
            MockDate.reset();
        });
        it('requests measurements for last 24h', () => {
            let firstParamCall = axios.get.mock.calls[0][1].params;
            expect(firstParamCall.from).toEqual("2021-02-15 22:26:51 +0100");
            expect(firstParamCall.to).toEqual( "2021-02-16 22:26:51 +0100");
        });
        it('does not show placeholder', () => {
            expect(ui.placeholder.query()).toBeNull();
        });
        it('displays measurements count', () => {
            screen.getByText('3 measurement(s) found');
        });
        it('displays a chart', async () => {
            expect(ui.chart.get()).toBeVisible();
        });
    });
    describe('when time period is given', () => {
        it('fetches measurements with this time period', async () => {
            axios.get.mockResolvedValue(buildResponse.Successful([buildMeasurement()]));
            const from = moment.tz("2020-04-10T10:20:30+02:00", DEFAULT_TIMEZONE);
            const to = moment.tz("2020-04-11T10:20:30+02:00", DEFAULT_TIMEZONE);
            await renderCmp(MeasurementsChartWrapper, {localVue, props: {metric: buildMetric(), from, to}});
            let firstParamCall = axios.get.mock.calls[0][1].params;
            expect(firstParamCall.from).toEqual("2020-04-10 10:20:30 +0200");
            expect(firstParamCall.to).toEqual( "2020-04-11 10:20:30 +0200");
        });
    });
});
