let lastId = 0
const build = (attributes) => {
    return {id: lastId++, date: '2021-02-21T13:00:00.000Z', value: 3, ...attributes}
}

export default build;
