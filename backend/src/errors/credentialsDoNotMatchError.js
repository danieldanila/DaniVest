class CredentialsDoNotMatchError extends Error {
    constructor(message = "Credentials do not match.", ...args) {
        super(message, ...args);
        this.message = message;
    }
}

export default CredentialsDoNotMatchError;