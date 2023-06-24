using ParserCombinator
using PEG

# The AST nodes we will construct, with evaluation via calc()
abstract type Node end
Base.:(==)(n1::Node, n2::Node) = n1.val == n2.val
calc(n::Float64) = n
struct Inv<:Node val end
calc(i::Inv) = 1.0 / calc(i.val)
struct Prd<:Node val end
calc(p::Prd) = Base.prod(map(calc, p.val))
struct Neg<:Node val end
calc(n::Neg) = -calc(n.val)
struct Sum<:Node val end
calc(s::Sum) = Base.sum(map(calc, s.val))

# The grammar (the combinators!)
sum = Delayed()
val = E"(" + sum + E")" | PFloat64()

neg = Delayed()       # allow multiple (or no) negations (e.g., ---3)
neg.matcher = val | (E"-" + neg > Neg)

mul = E"*" + neg
div = E"/" + neg > Inv
prd = neg + (mul | div)[0:end] |> Prd

add = E"+" + prd
sub = E"-" + prd > Neg
sum.matcher = prd + (add | sub)[0:end] |> Sum

all = sum + Eos()

function calcu(input::String)
    resu = parse_one(input, all)
    return resu
end




@rule expr = "IF" & "(" & condition & ")" & "{" & statement & else_stmt[*]  
@rule else_stmt = "ELSE {" & statement&"}"
@rule condition = cond & whitespace & operator & whitespace & cond,Variable
@rule cond = Variable , number
@rule statement = r"[a-zA-Z]+"&"()" & whitespace & "}"
@rule int = r"[-+]?\d+"
@rule float= r"[-+]?\d*\.\d+"
@rule number = int,float
@rule Variable = r"[a-zA-Z]+"
@rule whitespace = r"(\s)"
@rule operator = "==" , ">=" , "<=" , ">" , "<"
#"IF(INT == INT){funct() }ELSE{funct() }}"


# input_string = "IF(ser >= 5){y() }ELSE {z() }}"
# result = parse_whole(expr, input_string)

@rule Assign= Variable & "=" & things
@rule things= float,Variable,int
@rule int = r"[-+]?\d+"
@rule float= r"[-+]?\d*\.\d+" 

@rule whitespace = r"(\s*)"

# input_string = "x=5.6"
# result = parse_whole(Assign, input_string)

@rule whilelo = "WHILE" & condition & "{" & Wstatement & "}"
@rule Wstatement = expr , statement, Assign
@rule expr = "IF" & condition & "{" & statement & "ELSE {" & statement&"}"
@rule condition = "(" & cond & whitespace & operator & whitespace & cond & ")",Variable
@rule cond = Variable , number
@rule statement = r"[a-zA-Z]+"&"()" & whitespace & "}",Assign
@rule Assign= Variable & "=" & things
@rule things= float,Variable,int 
@rule int = r"[-+]?\d+"
@rule float= r"[-+]?\d*\.\d+"
@rule number = int,float
@rule whitespace = r"(\s*)"
@rule operator = "==" , ">=" , "<=" , ">" , "<"
#"IF(INT == INT){funct() }ELSE{funct() }}"

# input_string = "WHILE(ser >= 5){IF(ser >= 5){y() }ELSE {z() }}}"
# result = parse_whole(whilelo, input_string)
# w

@rule SwitchR= "SWITCH" & whitespace& "(" & whitespace & Variable & whitespace &"){"& whitespace & cases[*] &"}" & whitespace & "Default:"&statement
@rule cases = "CASE"& whitespace & int & ":" & whitespace & statement & whitespace & "Break"
@rule statement = r"[a-zA-Z]+"&"()" & whitespace & "}" & Assign
@rule Assign= Variable & "=" & things
@rule things= float,Variable,int
@rule float= r"[-+]?\d*\.\d+" 
@rule int = r"[-+]?\d+"
@rule whitespace = r"(\s*)" 

input_string = "SWITCH( x ){ CASE 1:
        printf()
        Break
    CASE 2:
        printf()
        Break
    CASE 3:
        printf()
        Break
    Default:
        printf()
}
"
result = parse_whole(SwitchR, input_string)


@rule SwitchR= "SWITCH" & whitespace& "(" & whitespace & Variable & whitespace & "){" & whitespace & cases[*] & "}" & whitespace & "Default:" & statement
@rule cases = "CASE"& whitespace & int & ":" & whitespace & statement & whitespace & "Break"
@rule statement = r"[a-zA-Z]+"&"()"
@rule Assign= Variable & "=" & things
@rule things= float,Variable,int
@rule float= r"[-+]?\d*\.\d+" 
@rule int = r"[-+]?\d+"
@rule whitespace = r"(\s*)" 

input_string = "SWITCH( x ){ CASE 1:
        printf()
        Break
    CASE 2:
        printf()
        Break
    CASE 3:
        printf()
        Break
    Default:
        printf()
}
"
result = parse_whole(SwitchR, input_string)

using ParserCombinator
using PEG

abstract type Node end
Base.:(==)(n1::Node, n2::Node) = n1.val == n2.val

function calc(n::Float64)
    return n
end

struct Inv<:Node val end
function calc(i::Inv)
    return 1.0 / calc(i.val)
end

mutable struct Prd<:Node
    val::Vector{Node}
    function Prd(val)    
        if length(val)==2
            print("\nop: product")
            print("\narg1:",val[1])
            print("\narg2:",val[2])
        end
    end
end

function calc(p::Prd)
    x = generate_temp_var()   
    #print(p.val) 
    print("\ndestination:",x.name,"\n")
    return Base.prod(map(calc, p.val))
end
    
mutable struct Neg<:Node val end
    
function calc(n::Neg) 
    return -calc(n.val)
end
    
function calc(s::Sum)
    x=generate_temp_var()
    print("\ndestination:",x.name)
    return Base.sum(map(calc, s.val))
end
struct TempVariable
    name::String
end
struct Quadruple
    op::String
    arg1::Node
    arg2::Node
    result::Node
end

# Initialize the temp_var_num variable to 0 before using it
global temp_var_num = 0

function generate_temp_var()
    global temp_var_num += 1
    return TempVariable("t$temp_var_num")
end
global quadruples = []
function generate_quadruple(op, arg1, arg2, result)
    q = Quadruple(op, arg1, arg2, result)
    push!(quadruples, q)
    return result
end

function calculate(input::String)
    result = calc(parse_one(input, all)[1])
    if result == nothing
        println("Parsing failed")
    else
        println("Parsed expression: ", result)
    end
    return result
end
function calcu(input::String)
    resu = parse_one(input, all)
    return resu
end
        
@rule Assign= Variable & "=" & things
@rule things= float,Variable,int
@rule int = r"[-+]?\d+"
@rule float= r"[-+]?\d*\.\d+" 
@rule whitespace = r"(\s*)"
