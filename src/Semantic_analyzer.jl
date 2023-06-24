using DataStructures
include("Lexer.jl")

mutable struct Symbol
    name::String
    s_type::TokenType
    pos_start::Union{Nothing, Position}
    pos_end::Union{Nothing, Position}
    function Symbol(name::String, s_type::TokenType, pos_start::Union{Nothing, Position}=nothing, pos_end::Union{Nothing, Position}=nothing)
        new(name, s_type, pos_start, pos_end)
    end
end

mutable struct SymbolTable
    table::Vector{Symbol}
    parent::Union{SymbolTable, Nothing}
    function SymbolTable(table::Vector{Symbol} ,parent::Union{SymbolTable,Nothing}=nothing)
        new(table,parent)
    end
end
function create_symboltable()
    T= Vector{Symbol}()
    temp = SymbolTable(T,  nothing)
    return temp
end

function print_symbol_table(sym_table::SymbolTable)
    print("$(sym_table.table)")
end


function SemanticAnalyzer(lexed_tokens::MutableLinkedList{Token})
    if(!isempty(lexed_tokens))
        T= Vector{Symbol}()
        Global_symbolTable= create_symboltable()
        current_symbolTable = Global_symbolTable
    end
    while(!isempty(lexed_tokens))
        temp_token = popfirst!(lexed_tokens)
        if (temp_token.Type == CURLYLB)
            T= Vector{Symbol}()
            current_symbolTable= SymbolTable(T,current_symbolTable)
        elseif(temp_token.Type == CURLYRB)
            print("\n///////////////////////////////////////////////\n")
            print(current_symbolTable.table)
            print("\n///////////////////////////////////////////////\n")
            current_symbolTable= current_symbolTable.parent 
        elseif (temp_token.Type == variable)
            temp2_token = popfirst!(lexed_tokens)
            if (temp2_token.Type != EQUAL)
                pushfirst!(lexed_tokens,temp2_token)
                push!(current_symbolTable.table,Symbol(temp_token.value,temp_token.Type))
            else
                temp2_token = popfirst!(lexed_tokens)
                for i in current_symbolTable.table
                    if i.name == temp_token.value
                        if i.s_type != temp2_token.Type
                            print("\nError assign type $(temp2_token.Type) to variable of type $(i.s_type)\n")
                        end
                    end
                end
            end
        end
    end 
    print(Global_symbolTable.table)
end

