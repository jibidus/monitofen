import MeasurementsPage from "@/MeasurementsPage";
import buildMetric from './factories/metric';
import buildMeasurement from './factories/measurement';
import buildResponse from "./factories/http_response";
import renderCmp from "../support/render";
import userEvent from "@testing-library/user-event";
import axios from "axios";
import {when} from 'jest-when'

describe('<MeasurementsPage>', () => {
    it('when a metric is selected', async () => {
        let metric = buildMetric();
        when(axios.get)
            .calledWith("/metrics")
            .mockResolvedValue(buildResponse.Successful([metric]));

        let twoMeasurements = [buildMeasurement(), buildMeasurement()];
        when(axios.get)
            .calledWith(`/metrics/${metric.id}/measurements`, expect.anything())
            .mockResolvedValue(buildResponse.Successful(twoMeasurements));

        const wrapper = renderCmp(MeasurementsPage);

        await userEvent.click(await wrapper.findByLabelText('Metric'));
        await userEvent.click(await wrapper.findByText(metric.label));
        await wrapper.findByText("2 measurement(s) found");
    });
});
