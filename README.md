# Compiler with Julia
 Automata and compiler design using julia language. The language was designed to support
basic programming constructs as variable declaration, assignment statements,
conditional statements, and loops. Julia was chosen for
its ease of use, flexibility, and compatibility with other programming languages.
 # Lexer.jl
Lexer identifies each word such as integer, floar, string, left curly bracket, keyword,...etc (for all token types documentation, check the attached report).
The lexer then creates a list of tokens including their position and passes them to the parser.
# Parser
We used ParserCombinator.jl and PEG.jl packages in the implementation of our parser. PEG.jl is easy in in creating rules for generating an Abstract Syntax Tree (AST) such as IF statements, for loops, while loop, Assignment stamtements ...etc. But we couldn't find a method to parse mathmetical equation. ParserCombinator.jl solved the mathmetical equations problem instantly! It is a package used in Haskel programming language.
disclaimer: I couldn't create assignment statement with equation, I look for a way that links both packages together, ping me if you got an idea! (JuliaSlack: Fareeda Abdelazeez, Email: fareedaabdelazeez@gmail.com)
# Semantic analyzer
when parser gives no errors, we identify scopes and monitor them to check the grammar of the code for example if a variable is being identified twice in one scope or a variable being called without being declared in its scope or parent scope or error as changing the type of variable as mentioned here:
![image](https://github.com/Farreeda/Compiler-with-Julia/assets/94711213/4e554a73-f8ed-4485-b49c-8ba1d2022915)
Variables are stored in the Symbol table with their scopes to help the semantic analyzer do its job!
![image](https://github.com/Farreeda/Compiler-with-Julia/assets/94711213/336eb22b-c056-47c3-9b5e-12e0505c9509)
This example illustrates how scopes and symbol table work simultinously (but this is with disabling the parser for sure hahahahaha!)
The Input: c {v {g} y }k {o}
The outputs: it generated 4 scopes in the symbol table
1. “g” 
2. “V ” & “y” 
3. “O” 
4. “C” & “K” in the global symbol table

# Code generation
![image](https://github.com/Farreeda/Compiler-with-Julia/assets/94711213/835a4715-7ac4-4b9a-a0da-022d5feee24e)

In this step we are sure about the validity of the given code, now we are in an early stage of translating the peice of code to the machine, we are generating quadruples (bytecode)
![image](https://github.com/Farreeda/Compiler-with-Julia/assets/94711213/958f589f-a062-4190-afec-25628e530b58)


