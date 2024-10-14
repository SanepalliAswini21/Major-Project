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



% Step 1: Read cover audio C and secret audio S and convert the secret audio to .wav format
Corg = imread(fullpath); % cover file
[nrow,ncol,colr] = size(Corg)  



C = Corg(:);

    CAs = C;

CAs_bin = dec2bin(CAs,8);
% % convert text to binary and pad with zeros if necessary
 %text = 'This is the hidden text what are doing.';

 % Encryption
plaintext = input(' Enter Secret Message:  ','s');

message = double(plaintext); % Convert string to ASCII values

ciphertext = modexp(message, e, n); % modexp is a custom function for modular exponentiation
ciphertext = (round(ciphertext))
 
 
 
 
 text =  arrayToText(ciphertext);
 

 textlen = length(text);
 text_bin = dec2bin(text, 8);
 text_bin = text_bin(:)'; % convert to row vector
 signal_bin = CAs_bin;
 signal_bin = signal_bin -48;
 text_bin = text_bin - 48;
  for k = 1 : length(text_bin)
     
      temp = signal_bin(k,:);
      temp(7) = text_bin(k);
     signal_bin(k,:) = temp;
     
  end
  
signal_int = bin2dec(num2str(signal_bin));

signal_adj = uint8(signal_int);
signal_adj_1 = signal_adj;
signal_adj  = reshape(signal_adj,nrow,ncol,colr);
imwrite(signal_adj,'stego.bmp','bmp');
  figure(1)
  subplot(2,1,1)
   imshow(Corg)
   title('Orignal')
  
   subplot(2,1,2)
  imshow(signal_adj)
  title('Stego img')
  
  
  ms =sprintf('Encoded message Length is !! %d',textlen);
  disp(ms)
  % for only otput 
  %save ('keys.mat','d','n','textlen');
  
   % for error calculation 

   SNR_val = 10*log10(sum(CAs.^2)/sum(signal_adj_1'.^2))

CAs_double = double(CAs);
signal_adj_1_double = double(signal_adj_1);

% Compute Pearson correlation coefficient
SPCC_val = corr(CAs_double, signal_adj_1_double)

   %SPCC_val =  corr(CAs, signal_adj_1);
   save ('keys.mat','d','n','textlen','text','SNR_val','SPCC_val');

%  save ('mesg.mat', 'text','SNR_val', 'SPCC_val')
 



function textData = arrayToText(secret_data)
    % Convert array to a string with comma-separated values
    textData = sprintf('%d, ', secret_data);
    textData = textData(1:end-2); % Remove the trailing comma and space
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

