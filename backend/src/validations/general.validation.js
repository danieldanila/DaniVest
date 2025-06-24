import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";

const validation = {
    mandatoryFieldValidation: (field, fieldName, errorsArray) => {
        if (!field) {
            errorsArray.push(`${fieldName} field is mandatory.`);
            return false;
        }
        return true;
    },

    validateCompletedField: (
        validationMethod,
        field,
        fieldName,
        errorsArray,
        isUpdateRequest,
        entityObjects
    ) => {
        if (isUpdateRequest && !field) {
            return true;
        } else if (
            validation.mandatoryFieldValidation(field, fieldName, errorsArray)
        ) {
            return validationMethod(field, fieldName, errorsArray, entityObjects);
        }
        return false;
    },

    passwordValidation: (field, fieldName, errorsArray) => {
        if (
            !field.match(
                /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%^*?&])[A-Za-z\d@$#!%^*?&]{8,}$/
            )
        ) {
            errorsArray.push(
                `${fieldName} field must have minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character.`
            );
            return false;
        }
        return true;
    },

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