import TimePeriodSelector from "@/components/TimePeriodSelector";
import {fireEvent} from "@testing-library/vue";
import renderCmp from "../../support/render";
import {byLabelText} from "testing-library-selector";
import MockDate from "mockdate";
import moment from "moment-timezone";

const ui = {
    input: byLabelText('Day'),
}

describe('<TimePeriodSelector>', () => {
    beforeEach(() => MockDate.set('2021-02-16T22:26:51+01:00'))
    afterEach(MockDate.reset);

    it('Selects yesterday as default', async () => {
        const wrapper = renderCmp(TimePeriodSelector);

        const yesterday = moment().subtract(1, 'days')
        expect(ui.input.get()).toHaveValue(yesterday.format("YYYY-MM-DD"));
        expect(wrapper.emitted().input).toBeTruthy();
        let emitted = wrapper.emitted().input[0][0];
        expect(emitted.from).toBeSameInstantAs(yesterday.startOf('day'));
        expect(emitted.to).toBeSameInstantAs(yesterday.endOf('day'));
    });

    it('Emits corresponding time period when a day is selected', async () => {
        const wrapper = renderCmp(TimePeriodSelector);

        await fireEvent.update(ui.input.get(), "2021-02-10");

        expect(wrapper.emitted().input).toBeTruthy();
        let emitted = wrapper.emitted().input[1][0];
        expect(emitted.from).toBeSameInstantAs(moment("2021-02-10T00:00:00+01:00"));
        expect(emitted.to).toBeSameInstantAs(moment("2021-02-10T23:59:59+01:00"));
    });
});
