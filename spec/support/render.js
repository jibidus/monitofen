import Vuetify from "vuetify";
import {render} from "@testing-library/vue";

const renderCmp = (...opts) => {
    const vuetify = new Vuetify()
    document.body.setAttribute('data-app', true);
    if (opts.length > 1) {
        opts[1] = {...opts[1], vuetify}
    } else {
        opts[1] = {vuetify}
    }
    return render(...opts);
}

export default renderCmp
