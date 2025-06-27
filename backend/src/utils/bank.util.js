function generateRandomRomanianIBAN() {
    const bankCode = Array.from({ length: 4 }, () =>
        String.fromCharCode(65 + Math.floor(Math.random() * 26))
    ).join('');

    const accountNumber = Array.from({ length: 16 }, () => {
        const n = Math.floor(Math.random() * 36);
        return n < 10 ? n.toString() : String.fromCharCode(65 + n - 10);
    }).join('');

    const iban = `RO00${bankCode}${accountNumber}`;

    const rearranged = `${bankCode}${accountNumber}RO00`;

    const numericIban = rearranged
        .split('')
        .map(ch =>
            /[A-Z]/.test(ch) ? (ch.charCodeAt(0) - 55).toString() : ch
        )
        .join('');

    const remainder = BigInt(numericIban) % 97n;
    const checksum = (98n - remainder).toString().padStart(2, '0');

    return `RO${checksum}${bankCode}${accountNumber}`;
}

function generateRandomCVV() {
    return String(Math.floor(100 + Math.random() * 900));
}

function generateRandomCardNumber(prefix = '4', length = 16) {
    let number = prefix;

    while (number.length < length - 1) {
        number += Math.floor(Math.random() * 10).toString();
    }

    const digits = number.split('').map(Number).reverse();
    let sum = 0;

    for (let i = 0; i < digits.length; i++) {
        let digit = digits[i];
        if (i % 2 === 0) {
            digit *= 2;
            if (digit > 9) digit -= 9;
        }
        sum += digit;
    }

    const checksum = (10 - (sum % 10)) % 10;
    return number + checksum;
}

export {
    generateRandomRomanianIBAN,
    generateRandomCVV,
    generateRandomCardNumber
}