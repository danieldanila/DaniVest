import { TouchEvent } from "../models/index.js";

const service = {
    createTouchEvent: async (touchEventBody) => {
        const newTouchEvent = await TouchEvent.create(touchEventBody);
        return newTouchEvent;
    }
}

export default service;