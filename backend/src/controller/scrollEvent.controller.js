import { ScrollEventService as scrollEventService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createScrollEvent: catchAsync(async (req, res, next) => {
        const newScrollEvent = await scrollEventService.createScrollEvent(req.body);
        res.status(201).json({ message: `ScrollEvent with details '${JSON.stringify(newScrollEvent.toJSON())}' created.`, data: newScrollEvent },)
    }),

}

export default controller;