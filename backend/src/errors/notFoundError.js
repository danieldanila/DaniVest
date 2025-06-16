class NotFoundError extends Error {
    constructor(message = "Not found.", ...args) {
        super(message, ...args);
        this.message = message;
    }
}

export default NotFoundError;