
clc
clear
close all
% Step 1: Read stego image Sorg
load keys
% Open a dialog box for the user to choose a file
[filename, path] = uigetfile('*.*', 'Select a file');

% Check if the user selected a file
if isequal(filename, 0)
    disp('No file selected.');
else
    % Read the file contents and display them
    fullpath = fullfile(path, filename)
    fileID = fopen(fullpath);
    
end


%textlen = input('Enter Number ');

Sorg = imread(fullpath); % cover file
 
 y =Sorg(:);
 ybin = dec2bin(y,8);
 wavmat = ybin -48;
 txtbits = [];
    for k = 1 : textlen*8
      temp = wavmat(k,:);
      txtbits = [txtbits temp(7)];
      end
     txt_int_bits  =  reshape(txtbits',[],8);
     txt_int = bin2dec(num2str(txt_int_bits));
     extracted_text = char(txt_int)'
     
     
     extracted_array = textToArray(extracted_text)
     
     % Decryption
    decrypted_message = modexp(extracted_array, d, n);

    % Convert ASCII values back to string
    decrypted_text = char(decrypted_message)




 figure(2)
imshow(Sorg)   

% %%%%%%%%%%%%%%%%%% for Bit Error Rate calculations

SNR_val
SPCC_val
Bit_error_rate = ((extracted_text - text)/text)*100

function extractedArray = textToArray(extractedText)
    % Split the text into individual values and convert them to an array
    values = str2double(strsplit(extractedText, ', '));
    extractedArray = values(~isnan(values));
end
    

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

