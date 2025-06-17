import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";

const validation = {
    uuidValidation: (field, fieldName, errorsArray) => {
        const uuidRegex =
            /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

        if (!field || !field.match(uuidRegex)) {
            errorsArray.push(`${fieldName} must be a valid uuid.`);
            return false;
        }
        return true;
    },
    idParamaterValidation: (entityId, fieldName, errorsArray) => {
        if (!validation.uuidValidation(entityId, fieldName, errorsArray)) {
            throwValidationErrorWithMessage(errorsArray);
        }
        return entityId;
    },
};

export default validation;