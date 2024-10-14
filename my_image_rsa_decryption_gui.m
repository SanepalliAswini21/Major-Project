function my_image_rsa_decryption_gui
close all
        % Clear conflicting variable from the workspace
      global SNR_val
      global SPCC_val
      global n
      global d
      global plaintext
      global text
      global textlen




      
    % Load decryption keys and other necessary data
    load('imagekeys.mat');

    % Create a figure window
    fig = figure('Name', 'RSA Decryption GUI', 'Position', [100, 100, 800, 600], 'MenuBar', 'none');

    % Add components to the figure
    uicontrol('Style', 'pushbutton', 'String', 'Select File', 'Position', [50, 500, 100, 30], 'Callback', @selectFile);
    uicontrol('Style', 'edit', 'String', '', 'Position', [180, 500, 400, 30], 'Tag', 'fileEdit');
    uicontrol('Style', 'text', 'String', 'Enter Number:', 'Position', [50, 450, 100, 30]);
    uicontrol('Style', 'edit', 'String', '', 'Position', [180, 450, 100, 30], 'Tag', 'numberEdit');
    uicontrol('Style', 'pushbutton', 'String', 'Decrypt', 'Position', [600, 450, 100, 30], 'Callback', @decryptMessage);
    uicontrol('Style', 'pushbutton', 'String', 'Close', 'Position', [700, 50, 70, 30], 'Callback', 'close(gcf)');

    % Add axes for waveform plot
    axes('Position', [0.1, 0.1, 0.8, 0.55], 'Tag', 'imgdisp');

    % Callback for Select File button
    function selectFile(~, ~)
        [filename, path] = uigetfile('*.*', 'Select a file');
        if filename ~= 0
            fileEdit = findobj('Tag', 'fileEdit');
            set(fileEdit, 'String', fullfile(path, filename));
        end
    end

    % Callback for Decrypt button
    function decryptMessage(~, ~)
        % Get file path and number from GUI
        fileEdit = findobj('Tag', 'fileEdit');
        numberEdit = findobj('Tag', 'numberEdit');
        filepath = get(fileEdit, 'String');
        textlen = str2double(get(numberEdit, 'String'));

        % Check if file path is empty
        if isempty(filepath)
            disp('Please select a file.');
            return;
        end

        % Check if the entered value is a valid number
        if length(textlen) <= 0
            disp('Please enter a valid positive number.');
            return;
        end

        % Perform decryption
        performDecryption(filepath, textlen);
    end

    % Function to perform decryption
    function performDecryption(filepath, textlen)
        % Load decryption keys and other necessary data
        %load('keys.mat');

        % Read the stego img file
Sorg = imread(filepath); % cover file
 
 y =Sorg(:);
 ybin = dec2bin(y,8);
 wavmat = ybin -48;
        txtbits = [];
        for k = 1 : textlen * 8
            temp = wavmat(k,:);
            txtbits = [txtbits temp(7)];
        end
        txt_int_bits  =  reshape(txtbits', [], 8);
        txt_int = bin2dec(num2str(txt_int_bits));
        extracted_text = char(txt_int)'

        % Convert extracted text to array
        extracted_array = textToArray(extracted_text);

        % Decryption
        decrypted_message = modexp(extracted_array, d, n);

        % Convert ASCII values back to string
        decrypted_text = char(decrypted_message)
        %plaintext

        % Calculate Bit Error Rate
        Bit_error_rate = ((decrypted_message - plaintext) / plaintext) * 100;


        % Plot image
        imgdisp = findobj('Tag', 'imgdisp');
        imshow(Sorg, 'Parent', imgdisp);
        title(imgdisp, 'Stego image');

        % Display decrypted text and other values in msgbox
        msg = {sprintf('Decrypted Text:\n%s', decrypted_text), ...
               sprintf('SNR Value: %.2f', SNR_val), ...
               sprintf('SPCC Value: %.2f', SPCC_val), ...
               sprintf('Bit Error Rate: %.2f%%', Bit_error_rate)};
        msgbox(msg, 'Decryption Results');
    end

    % Function to convert extracted text to array
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
end
