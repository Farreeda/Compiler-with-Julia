@enum TokenType INT FLOAT PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN EOF EQUAL IF ELSE For variable CONST FUNCTION OR AND LSL LSR POWER WHILE SWITCH CASE CURLYLB CURLYRB True False NULL ST STE GT GTE EQUALE
 
mutable struct Position
    col::Int64
    row:: Int64
    index:: Int64
    function Position(ncol::Int64,nrow::Int64,nindex::Int64)
        new(ncol,nrow,nindex)       
    end    
end

function advance(pos::Position,current_ch ::Char)
        pos.index +=1
        pos.col+=1
        if current_ch == '\n'
            self.ln += 1
            self.col = 0
        end
        return pos
end


mutable struct Token
    Type::TokenType
    value::Union{String, Nothing}
    pos_start::Union{Nothing, Position}
    pos_end::Union{Nothing, Position}

    function Token(Type::TokenType, value::Union{String, Nothing}, pos_start::Union{Nothing, Position}=nothing, pos_end::Union{Nothing, Position}=nothing)
        new(Type, value, pos_start, pos_end)
    end
end
#tokens = Vector{Token}()

using Unicode
cc
function lex(input::String)
    tokens = MutableLinkedList{Token}()
    P=Position(-1,0,-1)
    i = 1
    while i <= length(input)
         print(P)
         if input[i] == 'I'
                if input[i+1]=='F'
                     P1=advance(P,input[i])
                     P1=advance(P,input[i])
                     push!(tokens, Token(IF, "F",P1,P1))
                     print("\n\n$(input[i]) : IF at column $(P.col)")
                     i+=2
                else
                   error("No Constants starts with CAPITAL Letters at line  column$(tokens[i-1].pos_start.col) $(input[start:i])")
                end 
       elseif input[i] == 'E'
            if input[i+1]=='L' && input[i+2]=='S' &&input[i+3]=='E' && isspace(input[i+4])
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                P2 = advance(P,input[i+3])
                push!(tokens, Token(ELSE, "ELSE",P1 ,P2))
                i+=5
            else
                error("No Constants starts with CAPITAL Letters at line  column$(tokens[i-1].pos_start.col) $(input[start:i])")
            end
     elseif input[i] == 'F'
           if input[i+1]=='O' && input[i+2]=='R'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                P2=advance(P,input[i+2])
                push!(tokens, Token(ELSE, "ELSE",P1,P2))
                i+=3
            elseif input[i+1]=='a' && input[i+2]=='l' && input[i+3]=='s' && input[i+4]=='e'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                advance(P,input[i+3])
                P2 = advance(P,input[i+4])
                push!(tokens, Token(False, "False",P1,P2))
                i+=5
            else
                error("No Constants starts with CAPITAL Letters at line  column  $(input[start:i])")
            end
    elseif input[i] == 'W'
           if input[i+1]=='H' && input[i+2]=='I' && input[i+3]=='L'&& input[i+4]=='E'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                advance(P,input[i+3])
               
                P2 = advance(P,input[i+4])
                push!(tokens, Token(WHILE, "WHILE",P1,P2))
                print("WHILE : WHILE")
                i+=5
            else
                error("Do you mean WHILE? No Constants starts with CAPITAL Letters at line  column  $(input[start:i])")
            end
    elseif input[i] == 'S'
           if input[i+1]=='W' && input[i+2]=='I' && input[i+3]=='T'&& input[i+4]=='C' && input[i+5]=='H'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                advance(P,input[i+3])
                advance(P,input[i+4])
               
                P2 = advance(P,input[i+5])
                push!(tokens, Token(SWITCH, "SWITCH",P1,P2))
                i+=6
            else
                error("Do you mean SWITCH? No Constants starts with CAPITAL Letters at line  column  $(input[i])")
            end
      elseif input[i] == 'C'
           if input[i+1]=='A' && input[i+2]=='S' && input[i+3]=='E'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                P2 = advance(P,input[i+3])
                push!(tokens, Token(CASE, "CASE",P1,P2))
                i+=4
            else
                error("Do you mean CASE? No Constants starts with CAPITAL Letters at line  column  $(input[i])")
            end
      elseif input[i] == 'T'
           if input[i+1]=='r' && input[i+2]=='u' && input[i+3]=='e'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                P2 = advance(P,input[i+3])
                push!(tokens, Token(True, "True",P1,P2))
                i+=4
            else
                error("Do you mean True? No Constants starts with CAPITAL Letters at line  column  $(input[i])")
            end
      elseif input[i] == 'N'
           if input[i+1]=='U' && input[i+2]=='L' && input[i+3]=='L'
                P1=advance(P,input[i])
                advance(P,input[i+1])
                advance(P,input[i+2])
                P2 = advance(P,input[i+3])
                push!(tokens, Token(NULL, "NULL",P1,P2))
                i+=4
            else
                error("Do you mean NULL? No Constants starts with CAPITAL Letters at line  column  $(input[i])")
            end
      elseif isletter(input[i]) && islowercase(input[i])
            start= i
            while !(isspace(input[i])) && length(input)!= i && input[i] != '='
                if i ==start
                    P1=advance(P,input[i])
                    
                else
                    P2=advance(P,input[i])
                end                    
                i+=1
            end
            push!(tokens,Token(variable,input[start:i-1],P,P))
       elseif input[i] == '='
            P1=advance(P,input[i])
            push!(tokens, Token(EQUAL, "=",P,P))
            print("\n$(input[i]) : EQUAL ")
            i+=1
       elseif input[i] == '+'
            P1=advance(P,input[i])
            push!(tokens, Token(PLUS, "+",P,P))
           # advance(P,input[i])
            print("\n$(input[i]) : PLUS at column: $(P1.col)")
            i += 1
        elseif input[i] == '&'
            P1=advance(P,input[i])
            push!(tokens, Token(AND, "&",P,P))
            print("\n$(input[i]) : AND")
            i += 1
        elseif input[i] == '|'
            P1=advance(P,input[i])
            push!(tokens, Token(OR, "|",P1,P1))
            print("\n$(input[i]) : OR")
            i += 1
        elseif input[i] == '>'
            P1=advance(P,input[i])
            push!(tokens, Token(LSL, ">",P1,P1))
            print("\n$(input[i]) : LSL")
            i += 1
        elseif input[i] == '<'
            push!(tokens, Token(LSR, "<"))
            print("\n$(input[i]) : LSR")
            i += 1
        elseif input[i] == '^'
            P1=advance(P,input[i])
            push!(tokens, Token(POWER, "^",P1,P1))
            print("\n$(input[i]) : exponent")
            i += 1
        elseif input[i] == '{'
            P1=advance(P,input[i])
            push!(tokens, Token(CURLYLB, "{",P1,P1))
            print("\n$(input[i]) : Left Curly Bracket ")
            i += 1
        elseif input[i] == '}'
            P1=advance(P,input[i])
            push!(tokens, Token(CURLYRB, "}",P1,P1))
            print("\n$(input[i]) : Right Curly Bracket ")
            i += 1
        elseif input[i] == '-'
            P1=advance(P,input[i])
            push!(tokens, Token(MINUS, "-",P1,P1))
            print("\n$(input[i]) : MINUS ")
            i += 1
        elseif input[i] == '*'
            P1=advance(P,input[i])
            push!(tokens, Token(MULTIPLY, "*",P1,P1))
            print("\n$(input[i]) : MULTIPLY ")
            i += 1
        elseif input[i] == '/'
            P1=advance(P,input[i])
            push!(tokens, Token(DIVIDE, "/",P1,P1))
            print("\n$(input[i]) : DIVIDE ")
            i += 1
        elseif input[i] == '('
            P1=advance(P,input[i])
            push!(tokens, Token(LPAREN, "(",P1,P1))
            print("\n$(input[i]) : LPAREN ")
            i+=1
        elseif input[i] == ')'
            P1=advance(P,input[i])
            push!(tokens, Token(RPAREN, ")",P1,P1))
            print("\n$(input[i]) : RPAREN ")
            i+=1
        elseif isdigit(input[i])
            dot_num=0
            start = i
            while i <= length(input) && !isspace(input[i]) && input[i] != '+' && input[i] != '*'
                if isdigit(input[i])
                    advance(P,input[i])
                    i += 1
                elseif input[i]=='.' && dot_num ==0
                    dot_num+=1
                    i+=1
                    print("\ndot added")
                elseif dot_num > 1                    
                    error("\nIllegal dot here at line  column $(input[start:i])")
                end
            end
            if dot_num == 0
                push!(tokens, Token(INT, input[start:i-1]))
                print("\n\n$(input[start:i-1]) : INT ")
                i=i-1
            elseif dot_num == 1
                push!(tokens, Token(FLOAT, input[start:i-1]))
                print("\n\n$(input[start:i-1]) : FLOAT ")
                i-=1
            end 
            i+=1
        elseif isspace(input[i])
            i += 1
            continue
        else
            error("\nInvalid character: $(input[i]) at line column ")
        end
        
    end
    push!(tokens, Token(EOF, ""))
    T=collect(tokens)
    print(T)
    return tokens

end


