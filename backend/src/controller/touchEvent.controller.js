import { TouchEventService as touchEventService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createTouchEvent: catchAsync(async (req, res, next) => {
        const newTouchEvent = await touchEventService.createTouchEvent(req.body);
        res.status(201).json({ message: `TouchEvent with details '${JSON.stringify(newTouchEvent.toJSON())}' created.`, data: newTouchEvent },)
    }),

}

export default controller;