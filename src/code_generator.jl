include("Parser.jl")

# Data structure for quadruple
struct Quadruple
    operator::String
    operand1::Union{Int, Float64, String}
    operand2::Union{Int, Float64, String}
    result::Union{Int, Float64, String}
end

# Data structure for managing temporaries
mutable struct TemporaryManager
    count::Int
end

function TemporaryManager()
    return TemporaryManager(0)
end

function generate_temporary(temp_manager::TemporaryManager)
    temp_manager.count += 1
    return "t$(temp_manager.count)"
end

# Example parse tree node structure
struct ParseNode
    node_type::String
    value::Union{Float64, String}
    children::Vector{ParseNode}
end

# Generate parse tree from AST
function generate_parse_tree(ast::Node)
    return traverse(ast)
end

# Recursive traversal function
function traverse(node::Node)
    if node isa Inv
        ParseNode("inv", "", [isnumeric(node.val) ? ParseNode("value", node.val, []) : traverse(node.val)])
    elseif node isa Prd
        ParseNode("prd", "", [isnumeric(n) ? ParseNode("value", n, []) : traverse(n) for n in node.val])
    elseif node isa Neg
        ParseNode("neg", "", [traverse(node.val)])
    elseif node isa Sum
        ParseNode("sum", "", [traverse(n) for n in node.val])
    elseif node isa Float64
        ParseNode("value", node, [])
    else
        error("Unsupported node type: $(typeof(node))")
    end
end

function isnumeric(value)
    return value isa Int || value isa Float64
end

# Generate quadruples from parse tree
function generate_quadruples(parse_tree::ParseNode)
    quadruples = Vector{Quadruple}()
    temp_manager = TemporaryManager()

    # Traverse the parse tree
    traverse_parse_tree(parse_tree, quadruples, temp_manager)

    return quadruples
end

# Recursive traversal function
function traverse_parse_tree(node::ParseNode, quadruples::Vector{Quadruple}, temp_manager::TemporaryManager)
    if node.node_type == "sum"
        op = find_operator(node.children)

        operand1 = traverse_parse_tree(node.children[op], quadruples, temp_manager)
        operand2 = traverse_parse_tree(node.children[op + 1], quadruples, temp_manager)
        result = generate_temporary(temp_manager)

        push!(quadruples, Quadruple("+", operand1, operand2, result))
        result
    elseif node.node_type == "prd"
        operands = [traverse_parse_tree(child, quadruples, temp_manager) for child in node.children]
        result = generate_temporary(temp_manager)

        for i in 1:length(operands)-1
            push!(quadruples, Quadruple("*", operands[i], operands[i+1], result))
        end
        result
    elseif node.node_type == "neg"
        operand = traverse_parse_tree(node.children[1], quadruples, temp_manager)
        result = generate_temporary(temp_manager)

        push!(quadruples, Quadruple("-", operand, "", result))
        result
    elseif node.node_type == "inv"
        operand = traverse_parse_tree(node.children[1], quadruples, temp_manager)
        result = generate_temporary(temp_manager)

        push!(quadruples, Quadruple("/", "1", operand, result))
        result
    elseif node.node_type == "value"
        node.value
    else
        error("Unsupported node type: $(node.node_type)")
    end
end

function find_operator(children)
    for (i, child) in enumerate(children)
        if child.node_type == "sum" || child.node_type == "prd"
            return i
        end
    end
    error("Operator not found")
end

# Example usage
expression = "1+2*3/4"
parsed = parse_one(expression, all)
if isempty(parsed)
    error("Invalid expression")
end
parse_tree = generate_parse_tree(parsed[1])
quadruples = generate_quadruples(parse_tree)

# Print quadruples
for (i, quad) in enumerate(quadruples)
    println("$i: $(quad.operator), $(quad.operand1), $(quad.operand2), $(quad.result)")
end
