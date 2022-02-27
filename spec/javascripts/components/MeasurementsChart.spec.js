import MeasurementsChart from '@/components/MeasurementsChart.vue'
import buildMeasurement from '../factories/measurement'
import {mount} from "@vue/test-utils";
import moment from "moment-timezone";

describe('<MeasurementsChart>', () => {
    let previousTimezeone;

    beforeEach(() => previousTimezeone = moment.tz.guess());
    afterEach(() => moment.tz.zone(previousTimezeone))

    it('converts dates to current timezone', () => {
        let measurement = buildMeasurement({date: "2021-05-18T16:00:00.000Z"});
        moment.tz.zone("Europe/Paris");

        const wrapper = mount(MeasurementsChart, {propsData: {measurements: [measurement], metricLabel: "my metric"}});

        expect(wrapper.vm.parsedMeasurements).toHaveLength(1);
        let parsedDate = wrapper.vm.parsedMeasurements[0].date;
        expect(parsedDate).toBeInstanceOf(moment);
        expect(parsedDate.format()).toEqual("2021-05-18T18:00:00+02:00");
    });
});
