#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Global variables for input string and the current lookahead character
char *input;
char lookahead;

// Function Prototypes (for recursive calls)
void E();
void E_prime();
void T();
void T_prime();
void F();

// Function to match a character from the input
void match(char token)
{
    // Skip any whitespace characters
    while (isspace(lookahead))
    {
        lookahead = *++input;
    }

    // If the lookahead character matches the expected token, move forward in the input
    if (lookahead == token)
    {
        lookahead = *++input;
    }
    else
    {
        // If there's a mismatch, print an error and terminate the program
        printf("Error: Expected %c\n", token);
        exit(1);
    }
}

// E -> TE'
void E()
{
    printf("E -> TE'\n");
    T();      // Parse the T (Term)
    E_prime(); // Parse the E' (E Prime)
}

// E' -> +TE' | epsilon (Empty production)
void E_prime()
{
    // If the next token is '+', parse it
    if (lookahead == '+')
    {
        printf("E' -> +TE'\n");
        match('+'); // Match the '+' operator
        T();        // Parse the next term (T)
        E_prime();  // Recursively parse E' for further additions
    }
    else
    {
        // If there's no '+', E' can be epsilon (empty), i.e., end the production here
        printf("E' -> epsilon\n");
    }
}

// T -> FT'
void T()
{
    printf("T -> FT'\n");
    F();       // Parse the F (Factor)
    T_prime(); // Parse the T' (T Prime)
}

// T' -> *FT' | epsilon (Empty production)
void T_prime()
{
    // If the next token is '*', parse it
    if (lookahead == '*')
    {
        printf("T' -> *FT'\n");
        match('*'); // Match the '*' operator
        F();        // Parse the next factor (F)
        T_prime();  // Recursively parse T' for further multiplications
    }
    else
    {
        // If there's no '*', T' can be epsilon (empty), i.e., end the production here
        printf("T' -> epsilon\n");
    }
}

// F -> (E) | id (Identifier)
void F()
{
    // If the next token is '(', it's the start of a sub-expression
    if (lookahead == '(')
    {
        printf("F -> (E)\n");
        match('('); // Match the '('
        E();        // Parse the sub-expression E
        match(')');  // Match the closing ')'
    }
    // If the next token is a letter (id), parse it as an identifier
    else if (isalpha(lookahead))
    {
        printf("F -> id\n");
        while (isalnum(lookahead))  // Match the entire identifier (which can be alphanumeric)
        {
            match(lookahead); // Move through the characters of the identifier
        }
    }
    else
    {
        // If neither '(' nor an identifier is found, it's an unexpected token
        printf("Error: Unexpected token %c\n", lookahead);
        exit(1);
    }
}

// Main parsing function that starts the parsing process
void parse(char *inputString)
{
    input = inputString;  // Set the input to the string provided
    size_t len = strlen(inputString);
    
    // Remove trailing newline character from input (if present)
    if (len > 0 && inputString[len - 1] == '\n')
    {
        inputString[len - 1] = '\0';
    }

    lookahead = *input;  // Set the lookahead to the first character of input
    E();  // Start parsing from the start symbol (E)

    // If we have reached the end of the input (lookahead is null), the parsing is successful
    if (lookahead == '\0')
    {
        printf("Parsing Successful!\n");
    }
    else
    {
        // If there is still input left, parsing failed
        printf("Parsing Failed. Remaining input: %s\n", input);
    }
}

// Main function that runs the parser
int main()
{
    char inputString[100];  // Buffer to hold the input expression

    printf("\n\nEnter an expression: ");
    fgets(inputString, sizeof(inputString), stdin);  // Read input from the user

    parse(inputString);  // Call the parse function with the input string

    return 0;
}
