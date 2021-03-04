import MeasuresChartWrapper from '@/components/MeasuresChartWrapper.vue'
import {render} from '@testing-library/vue'
import {byTestId, byText} from 'testing-library-selector'
import {    screen} from '@testing-library/vue';
import buildMetric from '../factories/metric';
import buildMeasure from '../factories/measure';
import axios from "axios";

jest.mock('axios');

const ui = {
    placeholder: byText('No measure'),
    chart: byTestId('chart')
}

describe("<MeasuresChartWrapper/>", function () {
    describe('without any measure', () => {
        beforeEach(async () => {
            axios.get.mockResolvedValue({data: [], status: 200});
            await render(MeasuresChartWrapper, {props: {metric: buildMetric()}});
        });
        it('shows placeholder', () => {
            expect(ui.placeholder.get()).toBeVisible();
        });
    });
    describe('with measures', () => {
        beforeEach(async () => {
            axios.get.mockResolvedValue({data: [buildMeasure(), buildMeasure(), buildMeasure()], status: 200});
            await render(MeasuresChartWrapper, {props: {metric: buildMetric()}});
        });
        it('does not show placeholder', () => {
            expect(ui.placeholder.query()).toBeNull();
        });
        it('displays measures count', () => {
            screen.getByText('3 measure(s) found');
        });
        it('displays a chart', () => {
            expect(ui.chart.get()).toBeVisible();
        });
    });
});
