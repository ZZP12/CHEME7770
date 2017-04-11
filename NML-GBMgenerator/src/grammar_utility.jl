#
function check_for_unusual_chars(sentence_object::SentenceObject)
  try
    column_number = search(sentence_object.originalSentence, r"[\%\#\@\!\$]")
    if isempty(column_number)
         println("check w/o error")
    else
        println("-----check for unusual chars-----")
        println(column_number)
        error_message = errorObject()
        error_message.errorSentence = sentence_object.originalSentence
        error_message.lineNumber = sentence_object.sentenceNo
        error_message.columnNumber = column_number
        return error_message
    end
  catch err
    showerror(STDOUT, err, backtrace()); println()
  end
end

function decomposed_actor_bio_symbols(biosymbol_string::String, sentenceType::String)
  #take in String
  #return Array{TokenObject,1}
  if !isempty(search(biosymbol_string, r"[\(\)]"))
    biosymbol_token = decomposed_bio_symbols_with_parentheses(biosymbol_string)
  else
    push!(biosymbol_token, decomposed_a_bio_symbol(biosymbol_string))
  end
  return biosymbol_token
end

function decomposed_bio_symbols_with_parentheses(biosymbol_string::String)




end


function decomposed_a_bio_symbol(biosymbol_string)
  # take in a string in formats such as: g_A, speciesType_symbolName
  # return a TokenObject
  bio_token = TokenObject()
  bio_token.tokenType = biosymbol_string[1:search(biosymbol_string, '_')-1]
  bio_token.tokenName = biosymbol_string[search(biosymbol_string, '_')+1:end]
  return bio_token
end
