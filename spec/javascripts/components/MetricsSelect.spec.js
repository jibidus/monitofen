import MetricsSelect from '@/components/MetricsSelect.vue'
import axios from 'axios';
import {render} from '@testing-library/vue'
import userEvent from '@testing-library/user-event'
import {byRole, byLabelText} from 'testing-library-selector'
import buildMetric from '../factories/metric'

jest.mock('axios');

const ui = {
    spinner: byRole('progressbar'),
    errorMessage: byRole('aria-errormessage'),
    metricSelect: byLabelText('Metric'),
    metricOption: byRole('option')
}

describe("<MetricsSelect/>", function () {
    let wrapper;
    let axiosGetResolve, axiosGetReject;
    beforeEach(() => {
        const axiosGet = new Promise((resolve, reject) => {
            axiosGetResolve = resolve;
            axiosGetReject = reject;
        });
        axios.get.mockImplementation(() => axiosGet);
        wrapper = render(MetricsSelect)
    });
    it('shows spinner', () => {
        expect(ui.spinner.get()).toBeVisible();
        expect(wrapper.container.firstChild).toHaveAttribute('aria-busy', 'true');
    });

    describe('when request failed', () => {
        beforeEach(() => axiosGetReject('request failed'));
        it('shows error message', async () => {
            let errorMessage = await ui.errorMessage.find();
            expect(errorMessage).toBeVisible();
            expect(errorMessage).toHaveTextContent('request failed')
        });
    });

    describe('when request response is not 200', () => {
        beforeEach(() => axiosGetResolve({status: 403}));
        it('shows error message', async () => {
            expect(await ui.errorMessage.find()).toBeVisible();
        });
    });

    describe('when request returns 2 metrics', () => {
        const metric1 = buildMetric();
        const metric2 = buildMetric();
        beforeEach(() => axiosGetResolve({
            status: 200,
            data: [metric1, metric2]
        }));
        it('shows 2 metrics', async () => {
            expect(await ui.metricOption.findAll()).toHaveLength(2);
        });

        describe('and we select a metric', () => {
            beforeEach(async () => {
                const metricSelect = await ui.metricSelect.find();
                let metric2Option = await wrapper.findByText(metric2.label);
                userEvent.selectOptions(metricSelect, metric2Option);
            });
            it('emits event with selected metric', () => {
                expect(wrapper.emitted().input).toEqual([[metric2]]);
            });
        });
    });
});
