clear
close 
clc

% Public Key Generation
p = 61; % prime number
q = 53; % prime number
n = p * q; % modulus
phi = (p-1) * (q-1); % Euler's totient function
e = 17; % public exponent

% Ensure e and phi are coprime
while gcd(e, phi) ~= 1
    e = e + 2;
end

% Private Key Calculation
d = modinv(e, phi); % modinv is a custom function for modular inverse

% Key Pair
public_key = [n, e];
private_key = [n, d];

% Encryption
plaintext = 'Im sorry, but I dont have access to personal data about individuals unless it has been shared with me in the course of our conversation. My design is rooted in privacy and confidentiality. I can provide information, answer questions, and generate text based on the input I receive, but I don have the ability to know your identity unless you tell me directly.';

message = double(plaintext); % Convert string to ASCII values

ciphertext = modexp(message, e, n); % modexp is a custom function for modular exponentiation
ciphertext = (round(ciphertext));






% Decryption
decrypted_message = modexp(ciphertext, d, n);

% Convert ASCII values back to string
decrypted_text = char(decrypted_message);

% Display results
disp('Original Message: ');
disp(plaintext);
disp('Encrypted Message: ');
disp(ciphertext);
disp('Decrypted Message: ');
disp(decrypted_text);

% Modular Exponentiation Function
function result = modexp(base, exponent, modulus)
    result = 1;
    base = mod(base, modulus);
    while exponent > 0
        if bitget(exponent, 1)
            result = mod(result .* base, modulus);
        end
        base = mod(base .* base, modulus); % Use element-wise multiplication
        exponent = bitshift(exponent, -1);
    end
end

% Modular Inverse Function
function inv = modinv(a, m)
    m0 = m;
    y = 0;
    x = 1;

    if m == 1
        inv = 0;
        return;
    end

    while a > 1
        q = idivide(int32(a), int32(m), 'floor');
        t = m;
        m = mod(int32(a), int32(m));
        a = t;
        t = y;
        y = x - q * y;
        x = t;
    end

    if x < 0
        x = x + m0;
    end

    inv = x;
end
