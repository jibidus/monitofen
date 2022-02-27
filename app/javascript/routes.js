import HomePage from "./HomePage";
import MeasurementsPage from "./MeasurementsPage";

export default [
    {name: 'home', path: '/', component: HomePage, meta: {title: 'Home'}},
    {name: 'measurements', path: '/measurements', component: MeasurementsPage, meta: {title: 'Measurements'}},
]
