

function load_model_statements(path_to_model_file::String)
  # take in model file path,
  # split models into sentences with line number, check for unusual char in each sentence
  input_Sentence_Array = SentenceObject[]
  unusual_chars_error_messenges = errorObject[]
  lineNumberCounter::Int = 0
  try
    # open model file and load line-by-line
    open(path_to_model_file, "r") do model_file
      for eachSentence in eachline(model_file)
        lineNumberCounter += 1
        if ((contains(eachSentence, "//") == false) && (eachSentence[1] != '\n'))
          tmp_sentence_object = SentenceObject()
          tmp_sentence_object.originalSentence = chomp(eachSentence)
          tmp_sentence_object.sentenceNo = lineNumberCounter
          # check for unusual chars
          column_number = search(tmp_sentence_object.originalSentence, r"[\%\@\!\$]")
          # only can return the first unusual char, how can return all chars? can do this w/o using regex
          if isempty(column_number)

          else
            error_message = errorObject()
            error_message.errorSentence = tmp_sentence_object.originalSentence
            error_message.lineNumber = tmp_sentence_object.sentenceNo
            error_message.columnNumber = collect(column_number)
            push!(unusual_chars_error_messenges, error_message)
          end
          #? what will happen if return nothing? ==> Void
          println("-----undating error messenges-------")
          @show unusual_chars_error_messenges
          push!(input_Sentence_Array, tmp_sentence_object)
        end
      end
    end
  catch err
    showerror(STDOUT, err, backtrace());println()
  end
  return (input_Sentence_Array, unusual_chars_error_messenges)
end

function find_action_type_of_a_sentence(input_Sentence::SentenceObject)
  # take in sentence object
  # return sentence type as a Stirng: invalid sentence or valid types
  # arrange scenarios in order of occurrence probability can promote running speed
  if !isempty(search(input_Sentence.originalSentence, r" equals? to | = | is TAG| is \_|\) are \("))
    # symbol assignment
    verb_index = collect(search(input_Sentence.originalSentence, r" equals? to | = | is TAG| is \_|\) are \("))
    sentenceType = "symbol assignment"
  elseif !isempty(search(input_Sentence.originalSentence, r" react(s|ed|ing)? "))
    # react
    verb_index = collect(search(input_Sentence.originalSentence, r" react(s|ed|ing)? "))
    react_actor_string = input_Sentence.originalSentence[1:verb_index[1]-1]
    react_target_string = input_Sentence.originalSentence[verb_index[end]+1:end]
    sentenceType = "react"
  elseif !isempty(search(input_Sentence.originalSentence, r" phosphorylat(e|es|ed|ing|ion) "))
    # phosphorylate
    verb_index = collect(search(input_Sentence.originalSentence, r" phosphorylat(e|es|ed|ing|ion) "))
    sentenceType = "phosphorylate"
  elseif !isempty(search(input_Sentence.originalSentence, r" dephosphorylat(e|es|ed|ing|ion) "))
    # dephosphorylate
    verb_index = collect(search(input_Sentence.originalSentence, r" dephosphorylat(e|es|ed|ing|ion) "))
    sentenceType = "dephosphorylate"
  elseif !isempty(search(input_Sentence.originalSentence, r" cataly(z|s)(e|es|ed|ing) "))
    # catalyze
    verb_index = collect(search(input_Sentence.originalSentence, r" cataly(z|s)(e|es|ed|ing) "))
    sentenceType = "catalyze"
  elseif !isempty(search(input_Sentence.originalSentence, r" (upregulat|promot|activat)(e|es|ed|ing) "))
    # activate
    verb_index = collect(search(input_Sentence.originalSentence, r" (upregulat|promot|activat)(e|es|ed|ing) "))
    sentenceType = "activate"
  elseif !isempty(search(input_Sentence.originalSentence, r" ((downregulat|deactivat)(e|es|ed|ing)|repress(es|ed|ing)?|inhibit(s|ed|ing)?) "))
    # inhibit
    verb_index = collect(search(input_Sentence.originalSentence, r" ((downregulat|deactivat)(e|es|ed|ing)|repress(es|ed|ing)?|inhibit(s|ed|ing)?) "))
    sentenceType = "inhibit"
  elseif !isempty(search(input_Sentence.originalSentence, r" (uptak(e|es|ing)|uptook) "))
    # uptakeuptake
    verb_index = collect(search(input_Sentence.originalSentence, r" (uptak(e|es|ing)|uptook) "))
    sentenceType = "uptake"
  elseif !isempty(search(input_Sentence.originalSentence, r" secret(e|es|ed|ing) "))
    # secrete
    verb_index = collect(search(input_Sentence.originalSentence, r" secret(e|es|ed|ing) "))
    sentenceType = "secrete"
  elseif !isempty(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) into "))
    # translocate into
    verb_index = collect(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) into "))
    sentenceType = "translocate into"
  elseif !isempty(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) out"))
    # translocate out
    verb_index = collect(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) out"))
    sentenceType = "translocate out"
  elseif !isempty(search(input_Sentence.originalSentence, r" (bind(s|ing)?|bound|associat(e|es|ed|ing)|complex(es|ed|ing)?)( |;)"))
    # bind
    verb_index = collect(search(input_Sentence.originalSentence, r" (bind(s|ing)?|bound|associat(e|es|ed|ing)|complex(es|ed|ing)?)( |;)"))
    sentenceType = "bind"
  elseif !isempty(search(input_Sentence.originalSentence, r" (unbind(s|ing)?|unbound|disassociat(e|es|ed|ing))( |;)"))
    # unbind
    verb_index = collect(search(input_Sentence.originalSentence, r" (unbind(s|ing)?|unbound|disassociat(e|es|ed|ing))( |;)"))
    sentenceType = "unbind"
  elseif !isempty(search(input_Sentence.originalSentence, r" (splic(e|es|ed|ing) into) "))
    # splice
    verb_index = collect(search(input_Sentence.originalSentence, r" (splic(e|es|ed|ing) into) "))
    sentenceType = "splice"
  elseif !isempty(search(input_Sentence.originalSentence, r" ubiquitinat(e|es|ed|ing|ion) "))
    # ubiquitinate
    verb_index = collect(search(input_Sentence.originalSentence, r" ubiquitinat(e|es|ed|ing|ion) "))
    sentenceType = "ubiquitinate"
  elseif !isempty(search(input_Sentence.originalSentence, r" deubiquitinat(e|es|ed|ing|ion) "))
    # deubiquitinate
    verb_index = collect(search(input_Sentence.originalSentence, r" deubiquitinat(e|es|ed|ing|ion) "))
    sentenceType = "deubiquitinate"
  elseif !isempty(search(input_Sentence.originalSentence, r" acetylat(e|es|ed|ing|ion) "))
    # acetylate
    verb_index = collect(search(input_Sentence.originalSentence, r" acetylat(e|es|ed|ing|ion) "))
    sentenceType = "acetylate"
  elseif !isempty(search(input_Sentence.originalSentence, r" deacetylat(e|es|ed|ing|ion) "))
    # deacetylate
    verb_index = collect(search(input_Sentence.originalSentence, r" deacetylat(e|es|ed|ing|ion) "))
    sentenceType = "deacetylate"
  else
    sentenceType = "invalid sentence type"
  end
  return sentenceType
end

function sentence_type_finder_sentence_decomposer(input_sentence::SentenceObject)
  # take in sentence object
  # return sentence type as a Stirng: invalid sentence or valid types
  # arrange scenarios in order of occurrence probability can promote running speed
  decomposed_sentence = decomposedSentence()
  if !isempty(search(input_Sentence.originalSentence, r" equals? to | = | is TAG| is \_|\) are \("))
    # symbol assignment
    verb_index = collect(search(input_Sentence.originalSentence, r" equals? to | = | is | are "))
    actor_string = input_Sentence.originalSentence[1:verb_index[1]-1]
    actor_group = decomposed_actor_bio_symbols(actor_string, "symbol assignment")
    target_string = input_Sentence.originalSentence[verb_index[end]+1:end]
    target_group = decomposed_bio_symbols(target_string)
    decomposed_sentence.actionType = "symbol assignment"
    decomposed_sentence.actorGroup =actor_group
    decomposed_sentence.target_group = target_group
  elseif !isempty(search(input_Sentence.originalSentence, r" react(s|ed|ing)? "))
    # react
    verb_index = collect(search(input_Sentence.originalSentence, r" react(s|ed|ing)? "))
    react_actor_string = input_Sentence.originalSentence[1:verb_index[1]-1]
    react_target_string = input_Sentence.originalSentence[verb_index[end]+1:end]
    sentenceType = "react"
  elseif !isempty(search(input_Sentence.originalSentence, r" phosphorylat(e|es|ed|ing|ion) "))
    # phosphorylate
    verb_index = collect(search(input_Sentence.originalSentence, r" phosphorylat(e|es|ed|ing|ion) "))
    sentenceType = "phosphorylate"
  elseif !isempty(search(input_Sentence.originalSentence, r" dephosphorylat(e|es|ed|ing|ion) "))
    # dephosphorylate
    verb_index = collect(search(input_Sentence.originalSentence, r" dephosphorylat(e|es|ed|ing|ion) "))
    sentenceType = "dephosphorylate"
  elseif !isempty(search(input_Sentence.originalSentence, r" cataly(z|s)(e|es|ed|ing) "))
    # catalyze
    verb_index = collect(search(input_Sentence.originalSentence, r" cataly(z|s)(e|es|ed|ing) "))
    sentenceType = "catalyze"
  elseif !isempty(search(input_Sentence.originalSentence, r" (upregulat|promot|activat)(e|es|ed|ing) "))
    # activate
    verb_index = collect(search(input_Sentence.originalSentence, r" (upregulat|promot|activat)(e|es|ed|ing) "))
    sentenceType = "activate"
  elseif !isempty(search(input_Sentence.originalSentence, r" ((downregulat|deactivat)(e|es|ed|ing)|repress(es|ed|ing)?|inhibit(s|ed|ing)?) "))
    # inhibit
    verb_index = collect(search(input_Sentence.originalSentence, r" ((downregulat|deactivat)(e|es|ed|ing)|repress(es|ed|ing)?|inhibit(s|ed|ing)?) "))
    sentenceType = "inhibit"
  elseif !isempty(search(input_Sentence.originalSentence, r" (uptak(e|es|ing)|uptook) "))
    # uptakeuptake
    verb_index = collect(search(input_Sentence.originalSentence, r" (uptak(e|es|ing)|uptook) "))
    sentenceType = "uptake"
  elseif !isempty(search(input_Sentence.originalSentence, r" secret(e|es|ed|ing) "))
    # secrete
    verb_index = collect(search(input_Sentence.originalSentence, r" secret(e|es|ed|ing) "))
    sentenceType = "secrete"
  elseif !isempty(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) into "))
    # translocate into
    verb_index = collect(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) into "))
    sentenceType = "translocate into"
  elseif !isempty(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) out"))
    # translocate out
    verb_index = collect(search(input_Sentence.originalSentence, r" translocat(e|es|ed|ing) out"))
    sentenceType = "translocate out"
  elseif !isempty(search(input_Sentence.originalSentence, r" (bind(s|ing)?|bound|associat(e|es|ed|ing)|complex(es|ed|ing)?)( |;)"))
    # bind
    verb_index = collect(search(input_Sentence.originalSentence, r" (bind(s|ing)?|bound|associat(e|es|ed|ing)|complex(es|ed|ing)?)( |;)"))
    sentenceType = "bind"
  elseif !isempty(search(input_Sentence.originalSentence, r" (unbind(s|ing)?|unbound|disassociat(e|es|ed|ing))( |;)"))
    # unbind
    verb_index = collect(search(input_Sentence.originalSentence, r" (unbind(s|ing)?|unbound|disassociat(e|es|ed|ing))( |;)"))
    sentenceType = "unbind"
  elseif !isempty(search(input_Sentence.originalSentence, r" (splic(e|es|ed|ing) into) "))
    # splice
    verb_index = collect(search(input_Sentence.originalSentence, r" (splic(e|es|ed|ing) into) "))
    sentenceType = "splice"
  elseif !isempty(search(input_Sentence.originalSentence, r" ubiquitinat(e|es|ed|ing|ion) "))
    # ubiquitinate
    verb_index = collect(search(input_Sentence.originalSentence, r" ubiquitinat(e|es|ed|ing|ion) "))
    sentenceType = "ubiquitinate"
  elseif !isempty(search(input_Sentence.originalSentence, r" deubiquitinat(e|es|ed|ing|ion) "))
    # deubiquitinate
    verb_index = collect(search(input_Sentence.originalSentence, r" deubiquitinat(e|es|ed|ing|ion) "))
    sentenceType = "deubiquitinate"
  elseif !isempty(search(input_Sentence.originalSentence, r" acetylat(e|es|ed|ing|ion) "))
    # acetylate
    verb_index = collect(search(input_Sentence.originalSentence, r" acetylat(e|es|ed|ing|ion) "))
    sentenceType = "acetylate"
  elseif !isempty(search(input_Sentence.originalSentence, r" deacetylat(e|es|ed|ing|ion) "))
    # deacetylate
    verb_index = collect(search(input_Sentence.originalSentence, r" deacetylat(e|es|ed|ing|ion) "))
    sentenceType = "deacetylate"
  else
    sentenceType = "invalid sentence type"
  end
  return decomposed_sentence
end
