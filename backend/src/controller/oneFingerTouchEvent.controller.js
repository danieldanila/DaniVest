import { OneFingerTouchEventService as oneFingerTouchEventService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createOneFingerTouchEvent: catchAsync(async (req, res, next) => {
        const newOneFingerTouchEvent = await oneFingerTouchEventService.createOneFingerTouchEvent(req.body);
        res.status(201).json({ message: `OneFingerTouchEvent with details '${JSON.stringify(newOneFingerTouchEvent.toJSON())}' created.`, data: newOneFingerTouchEvent },)
    }),

}

export default controller;