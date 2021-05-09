import MeasuresChartWrapper from '@/components/MeasuresChartWrapper.vue'
import renderCmp from "../../support/render";
import {byTestId, byText} from 'testing-library-selector'
import {screen} from '@testing-library/vue';
import buildMetric from '../factories/metric';
import buildMeasure from '../factories/measure';
import moment from "moment-timezone";
import MockDate from 'mockdate'
import axios from "axios";
import {DEFAULT_TIMEZONE} from "../../support/constants";

jest.mock('axios');
beforeEach(() => axios.get.mockClear());

const ui = {
    placeholder: byText('No measure'),
    chart: byTestId('chart')
}

describe("<MeasuresChartWrapper/>", function () {
    describe('without any measure', () => {
        beforeEach(async () => {
            axios.get.mockResolvedValue({data: [], status: 200});
            await renderCmp(MeasuresChartWrapper, {props: {metric: buildMetric()}});
        });
        it('shows placeholder', () => {
            expect(ui.placeholder.get()).toBeVisible();
        });
    });
    describe('with measures', () => {
        beforeEach(async () => {
            MockDate.set('2021-02-16T22:26:51+01:00');
            axios.get.mockResolvedValue({data: [buildMeasure(), buildMeasure(), buildMeasure()], status: 200});
            await renderCmp(MeasuresChartWrapper, {props: {metric: buildMetric()}});
            MockDate.reset();
        });
        it('requests measures for last 24h', () => {
            expect(axios.get.mock.calls[0][1]).toStrictEqual({
                params: {
                    from: "2021-02-15 22:26:51 +0100",
                    to: "2021-02-16 22:26:51 +0100"
                }
            });
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
            axios.get.mockResolvedValue({data: [buildMeasure()], status: 200});
            const from = moment.tz("2020-04-10T10:20:30+02:00", DEFAULT_TIMEZONE);
            const to = moment.tz("2020-04-11T10:20:30+02:00", DEFAULT_TIMEZONE);
            await renderCmp(MeasuresChartWrapper, {props: {metric: buildMetric(), from, to}});
            expect(axios.get.mock.calls[0][1]).toStrictEqual({
                params: {
                    from: "2020-04-10 10:20:30 +0200",
                    to: "2020-04-11 10:20:30 +0200"
                }
            });
        });
    });
});
