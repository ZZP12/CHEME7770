# set up data types

type SentenceObject
  originalSentence::AbstractString
  sentenceNo::Int64
  function SentenceObject()
    this = new()
  end
end
type sentenceObjectWithType
  originalSentence::String
  sentenceNo::Int64
  actionType::String
  function sentenceObjectWithType()
    this = new()
  end
end


type errorObject
  errorSentence::String
  lineNumber::Int
  columnNumber::Array{Int64,1}
  function errorObject()
    this = new()
  end
end

abstract GeneralToken
# token object
type TokenObject <: GeneralToken
  tokenName::String
  tokenType::String
  function TokenObject()
    this = new()
  end
end
# token object with coefficient
type coTokenObject <: GeneralToken
  tokenName::String
  tokenType::String
  tokenCoefficient::Float64
  function coTokenObject()
    this = new()
  end
end
# phosphorylation token object
type pTokenObject <: GeneralToken
  tokenName::String
  tokenType::String
  pSite::String
  function pTokenObject()
    this = new()
  end
end

# decomposed sentence
type decomposedSentence
  actorGroup::Array{GeneralToken,1}
  targetGroup::Array{GeneralToken,1}
  actionType::String
  function decomposedSentence()
    this = new()
  end
end

# reaction type
type reactionPair
  reactantList::GeneralToken
  reactionType::String
  productList::GeneralToken
  function reactionPair()
    this = new()
  end
end
