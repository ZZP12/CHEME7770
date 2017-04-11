#=
using ArgParse

function parse_commandline()
  # zzp define a command-line interface
  settings_object = ArgParseSettings()
  @add_arg_table settings_object begin
    "-o"
      help = "Directory where the Julia model files will be written."
      arg_type = AbstractString
      default = "."

    "-m"
      help = "Path to the model file written in the NML format."
      arg_type = AbstractString
      required = true

    "-s"
      help = "Host type: HL-60 or PCa?"
      arg_type = Symbol
      default = :Pca
  end
  return parse_args(settings_object)
end

function main()
  parsed_args = parse_commandline()
  =#
  # Load the statement_vector -

include("./src/types.jl")
include("./src/parser.jl")
include("./src/grammar_utility.jl")

path_to_model_file = "./test/pseudoNML.net"
(input_Sentence_Array, unusual_chars_error_messenges) = load_model_statements(path_to_model_file)
# take in model file path,
# split models into sentences with line number, check for unusual char in each sentence
println("========loaded input model=============")
@show (input_Sentence_Array)
if !isempty(unusual_chars_error_messenges)
  println("============unusual chars===========")
  for error in unusual_chars_error_messenges
    println("Invalid char in line $(error.lineNumber) \""*error.errorSentence*"\" at $(error.columnNumber[1])")
  end
elseif !isempty(input_Sentence_Array)
  # clarify each sentence & check for grammar error
  println("=========sort sentence into different types=======================")
  for sentence in input_Sentence_Array
    #decomposed_sentence = sentence_type_finder_sentence_decomposer(sentence)
    sentenceType = find_action_type_of_a_sentence(sentence)
    println("line $(sentence.sentenceNo) is \""*sentenceType*"\"     "*(sentence.originalSentence))
  end
else
  println("The file path $path_to_model_file leads to a file that does not contain any valid sentence")
end
