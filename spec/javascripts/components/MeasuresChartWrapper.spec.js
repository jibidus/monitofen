import MeasuresChartWrapper from '@/components/MeasuresChartWrapper.vue'
import renderCmp from "../../support/render";
import {byTestId, byText} from 'testing-library-selector'
import {screen} from '@testing-library/vue';
import buildMetric from '../factories/metric';
import buildMeasure from '../factories/measure';
import buildResponse from "../factories/http_response";
import moment from "moment-timezone";
import MockDate from 'mockdate'
import axios from "axios";
import {DEFAULT_TIMEZONE} from "../../support/constants";
import { createLocalVue } from '@vue/test-utils';


const ui = {
    placeholder: byText('No measure'),
    chart: byTestId('chart')
};

describe("<MeasuresChartWrapper/>", function () {
    let localVue;
    beforeEach(() => {
        localVue = createLocalVue();
    });
    describe('without any measure', () => {
        beforeEach(async () => {
            axios.get.mockResolvedValue(buildResponse.Successful([]));
            await renderCmp(MeasuresChartWrapper, {localVue, props: {metric: buildMetric()}});
        });
        it('shows placeholder', () => {
            expect(ui.placeholder.get()).toBeVisible();
        });
    });
    describe('with measures', () => {
        beforeEach(async () => {
            MockDate.set('2021-02-16T22:26:51+01:00');
            axios.get.mockResolvedValue(buildResponse.Successful([buildMeasure(), buildMeasure(), buildMeasure()]));
            await renderCmp(MeasuresChartWrapper, {localVue, props: {metric: buildMetric()}});
            MockDate.reset();
        });
        it('requests measures for last 24h', () => {
            let firstParamCall = axios.get.mock.calls[0][1].params;
            expect(firstParamCall.from).toEqual("2021-02-15 22:26:51 +0100");
            expect(firstParamCall.to).toEqual( "2021-02-16 22:26:51 +0100");
        });
        it('does not show placeholder', () => {
            expect(ui.placeholder.query()).toBeNull();
        });
        it('displays measures count', () => {
            screen.getByText('3 measure(s) found');
        });
        it('displays a chart', async () => {
            expect(ui.chart.get()).toBeVisible();
        });
    });
    describe('when time period is given', () => {
        it('fetches measures with this time period', async () => {
            axios.get.mockResolvedValue(buildResponse.Successful([buildMeasure()]));
            const from = moment.tz("2020-04-10T10:20:30+02:00", DEFAULT_TIMEZONE);
            const to = moment.tz("2020-04-11T10:20:30+02:00", DEFAULT_TIMEZONE);
            await renderCmp(MeasuresChartWrapper, {localVue, props: {metric: buildMetric(), from, to}});
            let firstParamCall = axios.get.mock.calls[0][1].params;
            expect(firstParamCall.from).toEqual("2020-04-10 10:20:30 +0200");
            expect(firstParamCall.to).toEqual( "2020-04-11 10:20:30 +0200");
        });
    });
});
