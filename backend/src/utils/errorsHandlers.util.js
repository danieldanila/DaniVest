import NotFoundError from "../errors/notFoundError.js";
import CredentialsDoNotMatchError from "../errors/credentialsDoNotMatchError.js";
import UnauthorizedError from "../errors/unauthorizedError.js";
import jwt from 'jsonwebtoken';

const { JsonWebTokenError, TokenExpiredError } = jwt;

const notFoundErrorHandler = (res, err) => {
    res.status(404).json({ message: err.message });
};

const credentialsDoNotMatchErrorHandler = (res, err) => {
    res.status(401).json({ message: err.message });
};

const unauthorizedErrorHandler = (res, err) => {
    res.status(401).json({ message: err.message });
};

const jwtTokenExpiredErrorHandler = (res) => {
    res.status(401).json({ message: "Your session has expired. Please log in again!" });
};

const jwtErrorHandler = (res) => {
    res.status(401).json({ message: "Invalid token. Please log in again!" });
};

const serverErrorHandler = (res, err, message = "Server error.") => {
    console.log(err);
    res.status(500).json({ message: message });
};

const errorsHandlerWrapper = (err, req, res, next) => {
    if (err instanceof NotFoundError) {
        notFoundErrorHandler(res, err);
    } else if (err instanceof CredentialsDoNotMatchError) {
        credentialsDoNotMatchErrorHandler(res, err);
    } else if (err instanceof UnauthorizedError) {
        unauthorizedErrorHandler(res, err);
    } else if (err instanceof TokenExpiredError) {
        jwtTokenExpiredErrorHandler(res);
    } else if (err instanceof JsonWebTokenError) {
        jwtErrorHandler(res);
    } else {
        serverErrorHandler(res, err);
    }
};

export default errorsHandlerWrapper;