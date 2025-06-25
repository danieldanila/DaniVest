import generalValidation from "./general.validation.js";

const validation = {
    checkUserFields: async (
        user,
        existingUsers,
        isUpdateRequest
    ) => {
        const errors = [];

        generalValidation.validateCompletedField(
            generalValidation.emailValidation,
            user.email,
            "Email",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.nameValidation,
            user.firstName,
            "First name",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.nameValidation,
            user.lastName,
            "Last name",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.phoneValidation,
            user.phoneNumber,
            "Phone number",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.dateValidation,
            user.birthdate,
            "Birthdate",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.passwordValidation,
            user.password,
            "Password",
            errors,
            isUpdateRequest
        );

        if (user.id) {
            generalValidation.uuidValidation(user.id, "User id", errors);
        }

        if (existingUsers.length > 0) {
            generalValidation.duplicateFieldValidation(
                user.username,
                "username",
                errors,
                existingUsers,
                "username"
            );

            generalValidation.duplicateFieldValidation(
                user.email,
                "Email",
                errors,
                existingUsers,
                "email"
            );

            generalValidation.duplicateFieldValidation(
                user.phoneNumber,
                "Phone number",
                errors,
                existingUsers,
                "phoneNumber"
            );

            if (user.id) {
                generalValidation.duplicateFieldValidation(
                    user.id,
                    "User id",
                    errors,
                    existingUsers,
                    "id"
                );
            }
        }

        return errors;
    },
};

export default validation;