import ValidationError from "../errors/validationError.js";

const throwValidationErrorWithMessage = (errors) => {
    const errorMessage = `${errors.join("; ")}`;
    throw new ValidationError(errorMessage);
};

export default throwValidationErrorWithMessage;