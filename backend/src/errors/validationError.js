class ValidationError extends Error {
    constructor(message = "Validations failed.", ...args) {
        super(message, ...args);
        this.message = message;
    }
}

export default ValidationError;