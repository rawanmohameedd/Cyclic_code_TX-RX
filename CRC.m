% Get user input for u and g values
u = input('Enter the message polynomial coefficients: ');
g = input('Enter the generator polynomial coefficients: '); %n-k+1
%extract k and n values
k = length(u);
n = length(g) - 1 + k;

% represent u(X) and g(X) as polynomials 
u_represent = sym(0);
u_division = sym(0);
g_represent = sym(0);

for i = 1:length(u)
    if u(i) == 1
        power = (i - 1) ;
        u_represent = u_represent + sym('x')^power;
        
%         multiply u(x) by x^(n-k)
        power_encode = power + n - k;
        u_division= u_division + sym('x')^power_encode;
        
    end
end

for i = 1:length(g)
    if g(i) == 1
        g_represent = g_represent + sym('x')^(i - 1);
    end
end

% display g(x) and u(x).x^(n-k) polynomials
disp(['u represenation: ', char(u_represent)]);
disp(['g representation: ', char(g_represent)]);
disp(['u(x).x^(n-k): ', char(u_division)]);

% u.x^(n-k)in binary to preform long division  0 0 1 1
u_coeffs = fliplr(sym2poly(u_division));

disp(['u(x).x^(n-k)in binary:', num2str(u_coeffs)]);

%the long division
[~, remainder] = gfdeconv(u_coeffs,g);
disp(['Remainder: ', num2str(remainder)]);

% Convert remainder to binary and add zeros until it is the same length of u_coeffs
remainder_binary = dec2bin(remainder, length(u_coeffs)) - '0';
remainder_padded = fliplr([remainder_binary, zeros(1, length(u_coeffs) - length(remainder_binary))]);
encoded_message = u_coeffs + remainder_padded;
disp(['encoded message in binary: ', num2str(encoded_message)]);

%convert the encoded message to a polynomial
encoded_message_poly = sym(0);

for i = 1:length(encoded_message)
    if encoded_message(i) == 1
        power = i - 1;
        encoded_message_poly = encoded_message_poly + sym('x')^power;
    end
end
disp(['Encoded Message as Polynomial: ', char(encoded_message_poly)]);

% change a random bit in the encoded message to make a single error in the received message 
 received_message=encoded_message;
 bit_to_flip = randi(length(received_message));
 received_message(bit_to_flip) = 0;
received_message_poly = sym(0);

for i = 1:length(encoded_message)
    if received_message(i) == 1
        power = i - 1;
        received_message_poly = received_message_poly + sym('x')^power;
    end
end

% Display the received message
disp(['Received Message: ', num2str(received_message)]);
disp(['Received Message as Polynomial: ', char(received_message_poly)]);

%Decode the received message:
        % 1- received message / g(x)to get error location
[~, recevied_remainder] = gfdeconv(received_message,g);
disp(['error location: ', num2str(double(recevied_remainder))]);

recevied_remainder_poly=sym(0);
error_location=0;
for i = 1:length(recevied_remainder)
    if recevied_remainder(i) == 1
        power = i - 1;
        recevied_remainder_poly = recevied_remainder_poly + sym('x')^power;
        error_location=power;
    end
end
disp(['error as Polynomial: ', char(recevied_remainder_poly)]);
        % 2- no of shifts=n and after[n-1-error_location] shifts change the last bit
decoded_message = circshift(received_message, n);
decoded_message(error_location+1) = ~decoded_message(error_location+1);
disp(['Decoded Message: ', num2str(decoded_message)]);





