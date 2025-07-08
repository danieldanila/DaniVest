import { OneFingerTouchEvent } from "../models/index.js";

const service = {
    createOneFingerTouchEvent: async (oneFingerTouchEventBody) => {
        const newOneFingerTouchEvent = await OneFingerTouchEvent.create(oneFingerTouchEventBody);
        return newOneFingerTouchEvent;
    }
}

export default service;