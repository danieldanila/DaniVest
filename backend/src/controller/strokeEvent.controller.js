import { StrokeEventService as strokeEventService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createStrokeEvent: catchAsync(async (req, res, next) => {
        const newStrokeEvent = await strokeEventService.createStrokeEvent(req.body);
        res.status(201).json({ message: `StrokeEvent with details '${JSON.stringify(newStrokeEvent.toJSON())}' created.`, data: newStrokeEvent },)
    }),

}

export default controller;