import { KeyPressEvent } from "../models/index.js";

const service = {
    createKeyPressEvent: async (keyPressEventBody) => {
        const newKeyPressEvent = await KeyPressEvent.create(keyPressEventBody);
        return newKeyPressEvent;
    }
}

export default service;