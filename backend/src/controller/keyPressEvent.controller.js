import { KeyPressEventService as keyPressEventService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createKeyPressEvent: catchAsync(async (req, res, next) => {
        const newKeyPressEvent = await keyPressEventService.createKeyPressEvent(req.body);
        res.status(201).json({ message: `KeyPressEvent with details '${newKeyPressEvent}' created.`, data: newKeyPressEvent },)
    }),

}

export default controller;