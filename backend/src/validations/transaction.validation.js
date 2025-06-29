import generalValidation from "./general.validation.js";

const validation = {
    checkTransactionsFields: async (
        transaction,
        existingTransactions,
        existingBankAccounts,
        isUpdateRequest
    ) => {
        const errors = [];

        generalValidation.validateCompletedField(
            generalValidation.moneyFieldValidation,
            transaction.amount,
            "Amount",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.datetimeValidation,
            transaction.datetime,
            "Datetime",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.lengthGreaterThanThreeValidation,
            transaction.details,
            "Details",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.booleanFieldValidation,
            transaction.isApproved,
            "Is Approved",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            transaction.senderBankAccountId,
            "Sender bank account id",
            errors,
            isUpdateRequest,
            existingBankAccounts
        );
        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            transaction.receiverBankAccountId,
            "Receiver bank account id",
            errors,
            isUpdateRequest,
            existingBankAccounts
        );

        if (transaction.id) {
            generalValidation.uuidValidation(transaction.id, "Transaction id", errors);
        }

        if (existingTransactions.length > 0) {
            if (transaction.id) {
                generalValidation.duplicateFieldValidation(
                    transaction.id,
                    "Transaction id",
                    errors,
                    existingTransactions,
                    "id"
                );
            }
        }

        return errors;
    },
};

export default validation;