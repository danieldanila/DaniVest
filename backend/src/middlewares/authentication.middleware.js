import jwt from "jsonwebtoken";
import { promisify } from "util";
import catchAsync from "../utils/catchAsync.util.js";
import { changedPasswordAfter } from "../utils/authorization.util.js";
import UnauthorizedError from "../errors/unauthorizedError.js";
import { User } from "../models/index.js";

const middleware = {
    protect: catchAsync(async (req, res, next) => {
        let token;

        if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
            token = req.headers.authorization.split(" ")[1];
        } else if (req.cookies.jwt) {
            token = req.cookies.jwt;
        }

        if (!token) {
            throw new UnauthorizedError(
                "You are not logged in! Please log in to get access."
            );
        }

        const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

        const currentUser = await User.findByPk(decoded.id);

        if (!currentUser) {
            throw new UnauthorizedError(
                "The user belonging to this token does no longer exist."
            );
        }

        if (changedPasswordAfter(currentUser.passwordChangedAt, decoded.iat)) {
            throw new UnauthorizedError(
                "User recently changed password! Please log in again."
            );
        }

        req.user = currentUser;
        next();
    }),

    isLoggedIn: async (req, res, next) => {
        let token;

        if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
            token = req.headers.authorization.split(" ")[1];
        }

        if (!token) {
            return next();
        }

        try {
            const decoded = await promisify(jwt.verify)(
                token,
                process.env.JWT_SECRET
            );

            const currentUser = await User.scope("witPasscode").findByPk(decoded.id);

            if (!currentUser) {
                return next();
            }

            if (changedPasswordAfter(currentUser.passwordChangedAt, decoded.iat)) {
                return next();
            }

            const userSafe = currentUser.toJSON();
            delete userSafe.passcode;

            res.locals.user = userSafe;
        } catch (err) {
            return next();
        }


        next();
    },
};


export default middleware;