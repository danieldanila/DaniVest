import { ScrollEvent } from "../models/index.js";

const service = {
    createScrollEvent: async (scrollEventBody) => {
        const newScrollEvent = await ScrollEvent.create(scrollEventBody);
        return newScrollEvent;
    }
}

export default service;