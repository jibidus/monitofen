export default {
    Successful(data) {
        return {status: 200, data};
    }, Forbidden() {
        return {status: 403};
    }
};
