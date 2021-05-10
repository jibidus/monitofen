import MeasuresPage from "@/MeasuresPage";
import buildMetric from './factories/metric';
import buildMeasure from './factories/measure';
import buildResponse from "./factories/http_response";
import renderCmp from "../support/render";
import userEvent from "@testing-library/user-event";
import axios from "axios";
import {when} from 'jest-when'

describe('<MeasuresPage>', () => {
    it('when a metric is selected', async () => {
        let metric = buildMetric();
        when(axios.get)
            .calledWith("/metrics")
            .mockResolvedValue(buildResponse.Successful([metric]));

        let twoMeasures = [buildMeasure(), buildMeasure()];
        when(axios.get)
            .calledWith(`/metrics/${metric.id}/measures`, expect.anything())
            .mockResolvedValue(buildResponse.Successful(twoMeasures));

        const wrapper = renderCmp(MeasuresPage);

        await userEvent.click(await wrapper.findByLabelText('Metric'));
        await userEvent.click(await wrapper.findByText(metric.label));
        await wrapper.findByText("2 measure(s) found");
    });
});
