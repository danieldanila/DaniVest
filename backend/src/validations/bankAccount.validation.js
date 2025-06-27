import generalValidation from "./general.validation.js";

const validation = {
    checkBankAccountFields: async (
        bankAccount,
        existingBankAccounts,
        existingUsers,
        isUpdateRequest
    ) => {
        const errors = [];

        generalValidation.validateCompletedField(
            generalValidation.moneyFieldValidation,
            bankAccount.amount,
            "Amount",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.ibanFieldValidation,
            bankAccount.iban,
            "IBAN",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.cardNumberFieldValidation,
            bankAccount.cardNumber,
            "Card Number",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.dateValidation,
            bankAccount.expiryDate,
            "Expiry Date",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.cvvFieldValidation,
            bankAccount.cvv,
            "CVV",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.booleanFieldValidation,
            bankAccount.isMain,
            "Is Main",
            errors,
            isUpdateRequest
        );

        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            bankAccount.userId,
            "User id",
            errors,
            isUpdateRequest,
            existingUsers
        );

        if (bankAccount.id) {
            generalValidation.uuidValidation(bankAccount.id, "BankAccount id", errors);
        }

        if (existingBankAccounts.length > 0) {
            generalValidation.duplicateFieldValidation(
                bankAccount.iban,
                "IBAN",
                errors,
                existingBankAccounts,
                "iban"
            );

            generalValidation.duplicateFieldValidation(
                bankAccount.cardNumber,
                "Card Number",
                errors,
                existingBankAccounts,
                "cardNumber"
            );

            if (bankAccount.id) {
                generalValidation.duplicateFieldValidation(
                    bankAccount.id,
                    "BankAccount id",
                    errors,
                    existingBankAccounts,
                    "id"
                );
            }
        }

        return errors;
    },
};

export default validation;