// Requires an async method fetchData()
import axios from "axios";

const FetchData = {
    data() {
        return {
            loading: true,
            error: null,
        }
    },
    created() {
        this.loadData();
    },
    methods: {
        async loadData() {
            this.loading = true
            try {
                await this.fetchData();
            } catch (e) {
                if (!axios.isCancel(e)) {
                    this.error = `cannot fetch metrics (${e})`;
                }
            } finally {
                this.loading = false;
            }
        },
    }
}

export default FetchData;
