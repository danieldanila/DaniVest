import jwt from "jsonwebtoken";
import crypto from "crypto";

const signToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN,
    });
};

const changedPasswordAfter = (changedPasswordAt, jwtTimestamp) => {
    if (changedPasswordAt) {
        const changedTimestamp = parseInt(changedPasswordAt.getTime() / 1000, 10);

        return jwtTimestamp < changedTimestamp;
    }
    return false;
};

const createPasswordResetToken = (user) => {
    const resetToken = crypto.randomBytes(32).toString("hex");

    user.passwordResetToken = crypto
        .createHash("sha256")
        .update(resetToken)
        .digest("hex");

    user.passwordResetExpires = Date.now() + 10 * 60 * 1000;

    return resetToken;
};

export {
    signToken,
    changedPasswordAfter,
    createPasswordResetToken
}