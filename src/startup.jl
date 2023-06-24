include("Lexer.jl")
include("Semantic_analyzer.jl")

module CompilerwizJulia

	while(true)
	    print("\nfareeda >")
	    Str= readline()
	    print(Str)
	    lexed_tokens = lex(Str)
	    if lexed_tokens[1].Type == INT || lexed_tokens[1].Type == FLOAT
		print("\nAnswer: ")
		print(calculate(Str))
		print(calcu(Str))#d
	#     elseif lexed_tokens[1].Type == IF
	#        result = parse_whole(expr, Str)
	#         print("\n The result: ",result)
	#     elseif lexed_tokens[1].Type == variable
	#         result = parse_whole(Assign, Str)
	#         print("\n The result: ",result)
	#     elseif lexed_tokens[1].Type == WHILE
	#         result = parse_whole(whilelo, Str)
	#         print("\n The result: ",result)
	#     elseif lexed_tokens[1].Type == SWITCH
	#         result = parse_whole(SwitchR, Str)
	#         print("\n The result: ",result)
	#     else
	#         print("\n Error Parsing, Can't start with $(lexed_tokens[1].Type) in \"$(Str)\"")
	     end
	    SemanticAnalyzer(lexed_tokens)
	    tokens = MutableLinkedList{Token}()
	end



end # module CompilerwizJulia
