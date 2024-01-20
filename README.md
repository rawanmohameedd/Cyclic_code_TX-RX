MATLAB has built in functions to generate cyclic code parameters: 
• Generator polynomial cyclpoly (n, k) 
• Encode (message, n, k,' cyclic/binary', genpoly) 
but these functions deal with the binary input as the most significant bit is the  
left one but we deal with it as the left one is the least significant one.  
example: u= [1 0 1 1] 
MATLAB deals with it: 𝑋^3 𝑋^2 X 𝑋^0 
we deal with it: 𝑋^0 X 𝑋^2 𝑋^3 

## So, we generate our own code to encode and decode cyclic code that takes an input message and a generator polynomial from the users as zeros & ones and then:
## 1- represents them as polynomials
## 2- encode the message
## 3- generate a single random error in the encoded message every time we run
## 4- detect the error and decode the message
