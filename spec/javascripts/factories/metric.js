let lastId = 0
const build = () => {
    const id = lastId++;
    return {id, label: `metric #${id}`}
}

export default build;
