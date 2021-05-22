import MeasuresChart from '@/components/MeasuresChart.vue'
import buildMeasure from '../factories/measure'
import {mount} from "@vue/test-utils";
import moment from "moment-timezone";

describe('<MeasuresChart>', () => {
    let currentTimezeone ;

    beforeEach(() => currentTimezeone= moment.tz.guess());
    afterEach(() => moment.tz.zone(currentTimezeone))

    it('converts dates to current timezone', () => {
        let measure = buildMeasure({date: "2021-05-18T16:00:00.000Z"});
        moment.tz.zone("Europe/Paris");

        const wrapper = mount(MeasuresChart, {propsData:{measures: [measure]}});

        expect(wrapper.vm.parsedMeasures).toHaveLength(1);
        let parsedDate = wrapper.vm.parsedMeasures[0].date;
        expect(parsedDate).toBeInstanceOf(moment);
        expect(parsedDate.format()).toEqual("2021-05-18T18:00:00+02:00");
    });
});
