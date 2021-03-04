// Requires an async method fetchData()
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
                this.error = `cannot fetch metrics (${e})`;
            } finally {
                this.loading = false;
            }
        },
    }
}

export default FetchData;
