import MetricsSelect from '@/components/MetricsSelect.vue'
import axios from 'axios';
import userEvent from '@testing-library/user-event'
import {byRole, byLabelText} from 'testing-library-selector'
import buildMetric from '../factories/metric'
import buildResponse from "../factories/http_response";
import renderCmp from "../../support/render";

const ui = {
    spinner: byRole('progressbar'),
    errorMessage: byRole('aria-errormessage'),
    metricSelect: byLabelText('Metric'),
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
        wrapper = renderCmp(MetricsSelect);
    });
    it('shows spinner', async () => {
        expect(await ui.spinner.find()).toBeVisible();
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
        beforeEach(() => axiosGetResolve(buildResponse.Forbidden()));
        it('shows error message', async () => {
            expect(await ui.errorMessage.find()).toBeVisible();
        });
    });

    describe('when request returns 2 metrics, and we select one', () => {
        const metric1 = buildMetric();
        const metric2 = buildMetric();
        beforeEach(async () => {
            axiosGetResolve(buildResponse.Successful([metric1, metric2]));
            userEvent.click(await ui.metricSelect.find());
            userEvent.click(await wrapper.findByText(metric2.label));
        });

        it('an event is emitted with selected metric', () => {
            expect(wrapper.emitted().input).toEqual([[metric2]]);
        });
    });
});
