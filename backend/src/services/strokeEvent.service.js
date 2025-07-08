import { StrokeEvent } from "../models/index.js";

const service = {
    createStrokeEvent: async (strokeEventBody) => {
        const newStrokeEvent = await StrokeEvent.create(strokeEventBody);
        return newStrokeEvent;
    }
}

export default service;