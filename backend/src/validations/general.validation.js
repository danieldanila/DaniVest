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

    lengthGreaterThanThreeValidation: (field, fieldName, errorsArray) => {
        if (field.length < 3) {
            errorsArray.push(
                `${fieldName} field must have a length greater than 3 characters!`
            );
            return false;
        }
        return true;
    },

    onlyLettersAndSpacesAndHyphensValidation: (field, fieldName, errorsArray) => {
        const onlyLettersAndSpacesAndHyphensRegex = /^[a-zA-Z]+(?:[- ][a-zA-Z]+)*$/;

        if (!field.match(onlyLettersAndSpacesAndHyphensRegex)) {
            errorsArray.push(
                `${fieldName} field must contain only letters, hyphens and spaces!`
            );
            return false;
        }

        return true;
    },

    nameValidation: (field, fieldName, errorsArray) => {
        return (
            validation.lengthGreaterThanThreeValidation(
                field,
                fieldName,
                errorsArray
            ) &&
            validation.onlyLettersAndSpacesAndHyphensValidation(
                field,
                fieldName,
                errorsArray
            )
        );
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

    passcodeValidation: (field, fieldName, errorsArray) => {
        if (!field.match(/^\d{4}$/)) {
            errorsArray.push(`${fieldName} field must have 4 digits.`);
            return false;
        }
        return true;
    },

    emailValidation: (field, fieldName, errorsArray) => {
        if (
            !field.match(
                /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            )
        ) {
            errorsArray.push(
                `${fieldName} field must use 'example@domain.net' format.`
            );
            return false;
        }
        return true;
    },

    phoneValidation: (field, fieldName, errorsArray) => {
        if (!field.match(/^\d+$/) || !(field.length === 10)) {
            errorsArray.push(`${fieldName} field must have a length of 10 digits.`);
            return false;
        }
        return true;
    },

    dateValidation: (field, fieldName, errorsArray) => {
        if (!field.match(/^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)) {
            errorsArray.push(`${fieldName} field must use yyyy-mm-dd fomrat.`);
            return false;
        }
        return true;
    },

    datetimeValidation: (field, fieldName, errorsArray) => {
        // Match: 2025-06-25T14:30:00 or 2025-06-25 14:30:00
        const isoRegex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])[T ]([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$/;

        if (!isoRegex.test(field)) {
            errorsArray.push(`${fieldName} field must use format YYYY-MM-DDTHH:mm[:ss].`);
            return false;
        }

        const parsedDate = new Date(field);
        if (isNaN(parsedDate.getTime())) {
            errorsArray.push(`${fieldName} field is not a valid datetime.`);
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

    foreignUuidValidation: (field, fieldName, errorsArray, entityObjects) => {
        validation.uuidValidation(field, fieldName, errorsArray);

        let doesUuidExists = false;
        entityObjects.forEach((entityObject) => {
            if (entityObject.id === field) {
                doesUuidExists = true;
            }
        });

        if (!doesUuidExists) {
            errorsArray.push(`${fieldName} with the value "${field}" doesn't exist.`);
        }
    },

    duplicateFieldValidation: (
        field,
        fieldName,
        errorsArray,
        entityObjects,
        propertyName
    ) => {
        entityObjects.forEach((entityObject) => {
            if (
                field &&
                entityObject[propertyName].toString().toLowerCase() ===
                field.toString().toLowerCase()
            ) {
                errorsArray.push(
                    `${fieldName} with the value "${field}" already exists.`
                );
            }
        });
    },

    duplicateCompositeIdValidation: (
        firstId,
        firstIdName,
        secondId,
        secondIdName,
        errorsArray,
        entityObjects
    ) => {
        entityObjects.forEach((entityObject) => {
            if (
                firstId &&
                secondId &&
                entityObject[firstIdName].toString().toLowerCase() ===
                firstId.toString().toLowerCase() &&
                entityObject[secondIdName].toString().toLowerCase() ===
                secondId.toString().toLowerCase()
            ) {
                errorsArray.push(
                    `The combination of ${firstIdName}: ${firstId} with ${secondIdName}: ${secondId} already exists.`
                );
            }
        });
    },

    booleanFieldValidation: (field, fieldName, errorsArray) => {
        if (
            field &&
            !(
                field === "true" ||
                field === "false" ||
                field === true ||
                field === false
            )
        ) {
            errorsArray.push(`${fieldName} must be a boolean value.`);
        }
    },

    idParamaterValidation: (entityId, fieldName, errorsArray) => {
        if (!validation.uuidValidation(entityId, fieldName, errorsArray)) {
            throwValidationErrorWithMessage(errorsArray);
        }
        return entityId;
    },

    moneyFieldValidation: (field, fieldName, errorsArray) => {
        if (!field.match(/^(\d+(\.\d{1,2})?)$/)) {
            errorsArray.push(
                `${fieldName} must be a number with a maximum of 2 decimals.`
            );
        }
    },

    ibanFieldValidation: (field, fieldName, errorsArray) => {
        field = field.replace(/\s+/g, '').toUpperCase();

        let isValid;

        if (!field.startsWith("RO") || field.length !== 24 || !/^[A-Z0-9]+$/.test(field)) {
            isValid = false;
        } else {
            const rearranged = field.slice(4) + field.slice(0, 4);

            const converted = rearranged.split('').map(char => {
                if (/[A-Z]/.test(char)) {
                    return char.charCodeAt(0) - 55;
                }
                return char;
            }).join('');

            let remainder = converted;
            while (remainder.length > 2) {
                const block = remainder.slice(0, 9);
                remainder = (parseInt(block, 10) % 97).toString() + remainder.slice(block.length);
            }

            isValid = (parseInt(remainder, 10) % 97 === 1);
        }

        if (!isValid) {
            errorsArray.push(
                `${fieldName} must be a valid IBAN.`
            );
        }
    },

    cardNumberFieldValidation: (field, fieldName, errorsArray) => {
        field = field.replace(/[\s-]/g, '');

        let isValid;

        if (!/^\d{13,19}$/.test(field)) {
            isValid = false;
        } else {
            let sum = 0;
            let shouldDouble = false;

            for (let i = field.length - 1; i >= 0; i--) {
                let digit = parseInt(field.charAt(i), 10);

                if (shouldDouble) {
                    digit *= 2;
                    if (digit > 9) digit -= 9;
                }

                sum += digit;
                shouldDouble = !shouldDouble;
            }

            isValid = (sum % 10 === 0);
        }

        if (!isValid) {
            errorsArray.push(
                `${fieldName} must be a valid card number.`
            );
        }
    },

    cvvFieldValidation: (field, fieldName, errorsArray) => {
        if (!field.match(/^\d{3}$/)) {
            errorsArray.push(
                `${fieldName} must have 3 digits.`
            );
        }
    }
};

export default validation;