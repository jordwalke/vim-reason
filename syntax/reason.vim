" Vim syntax file
" Language:     Reason (Forked from Rust)
" Maintainer:   (Jordan - for Reason changes) Patrick Walton <pcwalton@mozilla.com>
" Maintainer:   Ben Blum <bblum@cs.cmu.edu>
" Maintainer:   Chris Morgan <me@chrismorgan.info>
" Last Change:  January 29, 2015
" Portions Copyright (c) 2015-present, Facebook, Inc. All rights reserved.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Syntax definitions {{{1
" Basic keywords {{{2
syn keyword   reasonConditional try switch if else for while
syn keyword   reasonOperator    as to downto
syn match     reasonSemicolon   /;/ display

" From xolox shell
" URL = escape('\<\w\{3,}://\(\(\S\&[^"]\)*\w\)\+[/?#]\?', '/')
" == \<\w\{3,}:\/\/\(\(\S\&[^"]\)*\w\)\+[\/?#]\?
" MAIL=- escape('\<\w[^@ \t\r<>]*\w@\w[^@ \t\r<>]\+\w\>', '/') 
" == \<\w[^@ \t\r<>]*\w@\w[^@ \t\r<>]\+\w\>

syntax match reasonCommentURL /\<\w\{3,}:\/\/\(\(\S\&[^"]\)*\w\)\+[\/?#]\?/ contained containedin=reasonCommentLine,reasonComment,reasonCommentBlockDoc,reasonString,reasonMultilineString
syntax match reasonCommentMail /\<\w[^@ \t\r<>]*\w@\w[^@ \t\r<>]\+\w\>/ contained containedin=reasonCommentLine,reasonComment,reasonCommentBlockDoc,reasonString,reasonMultilineString
"
" syn keyword   reasonKeyword     fun nextgroup=reasonFuncName skipwhite skipempty
syn match     reasonAssert      "\<assert\(\w\)*"
syn match     reasonFailwith    "\<failwith\(\w\)*"

syn keyword   reasonTypeKeyword   type       skipwhite nextgroup=reasonRecurseType,reasonTypeDecl
syn keyword   reasonRecurseType   rec nonrec skipwhite nextgroup=reasonTypeDecl

syn keyword   reasonModuleKeyword module     skipwhite nextgroup=reasonRecurseModule,reasonModPath
syn keyword   reasonRecurseModule rec nonrec skipwhite nextgroup=reasonModPath

syn keyword   reasonStorage            let        skipwhite nextgroup=reasonRecurseIdentifier,reasonIdentifier
syn keyword   reasonRecurseIdentifier  rec nonrec skipwhite nextgroup=reasonIdentifier

syn keyword   reasonOpenKeyword   open skipwhite nextgroup=reasonModPath

syn keyword   reasonStorage     when where fun mutable class pub pri val inherit and exception include constraint
" FIXME: Scoped impl's name is also fallen in this category

syn match     reasonUnit /()/ display

syn match     reasonIdentifier  /\<\%(\l\|_\)\%(\k\|'\)*\>/  contained display skipwhite skipnl nextgroup=reasonIdentifierTypeSeparator,reasonIdentifierAssignmentSeparator
syn match     reasonIdentifierAssignmentSeparator /=/ contained display skipwhite skipnl nextgroup=reasonUnaryFunctionDef,reasonFunctionDef
syn match     reasonIdentifierTypeSeparator /:/ contained display skipwhite skipnl nextgroup=reasonTypeDefUnaryFunctionDef,reasonIdentifierType,reasonIdentifierTypeModuleRef
syn match     reasonIdentifierType /\<\%(\l\|_\)\%(\k\|'\)*\(\_s*=>\)\@!\>/ contained display skipwhite skipnl nextgroup=reasonIdentifierTypeArgList
syn match     reasonIdentifierTypeModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1    contained display skipwhite skipnl nextgroup=reasonIdentifierType,reasonIdentifierTypeModuleRef
syn region    reasonIdentifierTypeArgList start="(" end=")"               contained display skipwhite skipnl contains=reasonIdentifierTypeArg,reasonIdentifierTypeArgModuleRef nextgroup=reasonIdentifierSeparator
syn match     reasonIdentifierTypeArg /\<\%(\l\|_\)\%(\k\|'\)*\>/         contained display skipwhite skipnl nextgroup=reasonIdentifierTypeListSeparator
syn match     reasonIdentifierTypeArgModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1 contained display skipwhite skipnl nextgroup=reasonIdentifierTypeArg,reasonIdentifierTypeArgModuleRef

syn match     reasonTypeDecl     /\<\%(\l\|_\)\%(\k\|'\)*\>/ contained display skipwhite skipnl nextgroup=reasonTypeDefAssign,reasonTypeVariablesDecl
syn match     reasonTypeVariablesDecl /\(([^)]\+)\)/             contained display skipwhite skipnl nextgroup=reasonTypeDefAssign
syn match     reasonTypeDefAssign /=/                        contained display skipwhite skipnl nextgroup=reasonTypeDefUnaryFunctionDef,reasonVariantDef,reasonTypeDefRecord,reasonTypeDefVariantSeparator,reasonTypeDefUnaryFunctionDef,reasonTypeAliasDef,reasonTypeDefTuple,reasonTypeAliasDefModuleRef
syn match     reasonTypeAliasDef /\<\%(\l\|_\)\%(\k\|'\)*\>/ contained display skipwhite skipnl nextgroup=reasonTypeAliasDefArgList
syn match     reasonTypeAliasDefModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1    contained display skipwhite skipnl nextgroup=reasonTypeAliasDef,reasonTypeAliasDefModuleRef
syn region    reasonTypeAliasDefArgList start="(" end=")"               contained display skipwhite skipnl contains=reasonTypeAliasDefArg,reasonTypeAliasDefArgModuleRef
syn match     reasonTypeAliasDefArg /\<\%(\l\|_\)\%(\k\|'\)*\>/         contained display skipwhite skipnl nextgroup=reasonTypeAliasDefListSeparator
syn match     reasonTypeAliasDefArgModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1 contained display skipwhite skipnl nextgroup=reasonTypeAliasDefArg,reasonTypeAliasDefArgModuleRef
syn region    reasonTypeDefTuple start="(" end=")"                      contained display skipwhite skipnl contains=reasonVariantDef,reasonTypeDefRecord,reasonTypeDefVariantSeparator,reasonTypeDefUnaryFunctionDef,reasonTypeAliasDef,reasonTypeDefTuple nextgroup=reasonFunctionTypeArrowCharacter

syn match     reasonTypeDefVariantSeparator /|/     contained display skipwhite skipnl nextgroup=reasonVariantDef
syn region    reasonTypeDefRecord start="{" end="}" contained display skipwhite skipnl contains=reasonRecordFieldName,reasonRecordFieldTypeSeparator,reasonRecordFieldSeparator

" record type definition
syn match     reasonRecordFieldName /\<\%(\l\|_\)\%(\k\|'\)*\>/            contained display skipwhite skipnl nextgroup=reasonRecordFieldTypeSeparator
syn match     reasonRecordFieldTypeSeparator /:/                           contained display skipwhite skipnl nextgroup=reasonVariantDef,reasonTypeDefRecord,reasonTypeDefVariantSeparator,reasonTypeDefUnaryFunctionDef,reasonTypeAliasDef,reasonTypeDefTuple,reasonTypeAliasDefModuleRef

" variant type definition
syn match     reasonVariantDef  "\<\u\(\w\|'\)*\>\.\@!"              display skipwhite skipnl nextgroup=reasonVariantArgsDef
syn region    reasonVariantArgsDef start="(" end=")"       contained display skipwhite skipnl contains=reasonVariantArg nextgroup=reasonTypeDefVariantSeparator
syn match     reasonVariantArg /\<\%(\l\|_\)\%(\k\|'\)*\>/ contained display skipwhite skipnl nextgroup=reasonVariantArgListSeparator
syn match     reasonVariantArgListSeparator /,/            contained display skipwhite skipnl nextgroup=reasonVariantArg

syn match     reasonFunctionTypeArrowCharacter display "=>" contained display skipwhite skipnl nextgroup=reasonTypeDefUnaryFunctionDef,reasonVariantDef,reasonTypeDefRecord,reasonTypeDefVariantSeparator,reasonTypeDefUnaryFunctionDef,reasonTypeAliasDef,reasonTypeDefTuple,reasonTypeAliasDefModuleRef

" unary function type
syn match     reasonTypeDefUnaryFunctionDef /\(\(\w\)\(\w\|'\|\.\)*\((.*)\)\=\_s*=>\)\@=/ contained display skipwhite skipnl nextgroup=reasonTypeDefUnaryFunctionArgumentModuleRef,reasonTypeDefUnaryFunctionArgument
syn match     reasonTypeDefUnaryFunctionArgument "\(\l\|_\)\(\w\|'\)*"       contained display skipwhite skipnl nextgroup=reasonTypeDefUnaryFunctionArgumentTypeArgs,reasonFunctionTypeArrowCharacter
syn match     reasonTypeDefUnaryFunctionArgumentModuleRef "\<\u\(\w\|'\)* *\."he=e-1    contained display skipwhite skipnl nextgroup=reasonTypeDefUnaryFunctionArgument,reasonTypeDefUnaryFunctionArgumentModuleRef,reasonFunctionTypeArrowCharacter
syn region    reasonTypeDefUnaryFunctionArgumentTypeArgs start="(" end=")"  contained display skipwhite skipnl contains=reasonTypeAliasDefModuleRef,reasonTypeAliasDef nextgroup=reasonFunctionTypeArrowCharacter

" function definition
syn match     reasonFunctionDef /\((\(\_s\|.\)*)\(\_s*:\_s*.\+\)\=\_s*=>\)\@=/  contained display skipwhite skipnl nextgroup=reasonFunctionArguments
syn region    reasonFunctionArguments start="(" end=")"       contained display skipwhite skipnl contains=reasonArgument,reasonLabeledArgument,reasonFunctionDef nextgroup=reasonArrowCharacter,reasonFunctionDefReturnTypeSeparator
syn match     reasonArgument "\(\l\|_\)\(\w\|'\)*"            contained display skipwhite skipnl nextgroup=reasonArgumentSeparator,reasonArgumentTypeDecl
syn match     reasonLabeledArgument "\~\(\l\|_\)\(\w\|'\)*"   contained display skipwhite skipnl nextgroup=reasonArgumentPunning,reasonArgumentSeparator,reasonLabeledOptionalArgument,reasonArgumentTypeDecl
syn match     reasonLabeledOptionalArgument /=?/              contained display skipwhite skipnl nextgroup=reasonArgumentSeparator
syn keyword   reasonArgumentPunning as                        contained display skipwhite skipnl nextgroup=reasonArgumentAlias
syn match     reasonArgumentAlias /\<\%(\l\|_\)\%(\k\|'\)*\>/ contained display skipwhite skipnl nextgroup=reasonArgumentTypeDecl,reasonArgumentSeparator
syn match     reasonArgumentTypeDecl /:/                      contained display skipwhite skipnl nextgroup=reasonTypeAliasDef,reasonTypeAliasDefModuleRef
syn match     reasonFunctionDefReturnTypeSeparator /:/        contained display skipwhite skipnl nextgroup=reasonTypeAliasDef,reasonTypeAliasDefModuleRef
syn match     reasonArgumentSeparator /,/                     contained display skipwhite skipnl nextgroup=reasonArgument,reasonLabeledArgument
" unary function
syn match     reasonUnaryFunctionDef /\(\(\l\|_\)\(\w\|'\)*\_s*=>\)\@=/ contained display skipwhite skipnl nextgroup=reasonUnaryFunctionArgument
syn match     reasonUnaryFunctionArgument "\(\l\|_\)\(\w\|'\)*"       contained display skipwhite skipnl nextgroup=reasonArrowCharacter

syn match     reasonConstructor  "\<\u\(\w\|'\)*\>" display
" Polymorphic variants
syn match     reasonConstructor  "`\w\(\w\|'\)*\>" display

"syn match     reasonModPath  /\<\u\(\w\|\.\)*\>/ display
syn match     reasonModPath  "\<\u\(\w\|'\)*\_s*\."he=e-1 display
syn match     reasonModPath  "\(\<include\s\+\)\@<=\u\(\w\|\.\)*" display

syn keyword   reasonExternalKeyword external                                   skipwhite skipnl nextgroup=reasonExternalDecl
syn match     reasonExternalDecl /\<\%(\l\|_\)\%(\k\|'\)*\>/ contained display skipwhite skipnl nextgroup=reasonExternalSeparator
syn match     reasonExternalSeparator /:/                    contained display skipwhite skipnl nextgroup=reasonExternalUnaryFunctionDef,reasonExternalFuncDef,reasonExternalValueDef,reasonExternalValueDefModuleRef

" external function definition
syn match     reasonExternalFuncDef /\((.*)\_s*=>\)\@=/                             contained display skipwhite skipnl nextgroup=reasonExternalFuncDefArguments
syn region    reasonExternalFuncDefArguments start="(" end=")"                    contained display skipwhite skipnl contains=reasonExternalFuncDefArgument,reasonExternalFuncDefArgumentModuleRef nextgroup=reasonExternalFuncDefArrowCharacter
syn match     reasonExternalFuncDefArgument "\(\l\|_\)\(\w\|'\)*"                 contained display skipwhite skipnl nextgroup=reasonExternalFuncDefArgumentSeparator,reasonExternalFuncDefTypeArgList
syn match     reasonExternalFuncDefArgumentModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1   contained display skipwhite skipnl nextgroup=reasonExternalFuncDefArgument,reasonExternalFuncDefArgumentModuleRef
syn match     reasonExternalFuncDefArgumentSeparator /,/                          contained display skipwhite skipnl nextgroup=reasonExternalFuncDefArgument
syn region    reasonExternalFuncDefTypeArgList start="(" end=")"                  contained display skipwhite skipnl contains=reasonExternalFuncDefTypeArg,reasonExternalFuncDefTypeArgModuleRef
syn match     reasonExternalFuncDefTypeArg /\<\%(\l\|_\)\%(\k\|'\)*\>/            contained display skipwhite skipnl nextgroup=reasonExternalFuncDefTypeArgListSeparator
syn match     reasonExternalFuncDefTypeArgModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1    contained display skipwhite skipnl nextgroup=reasonExternalFuncDefTypeArg,reasonExternalFuncDefTypeArgModuleRef
syn match     reasonExternalFuncDefTypeArgListSeparator /,/                       contained display skipwhite skipnl nextgroup=reasonVariantArg
syn match     reasonExternalFuncDefArrowCharacter /=>/                            contained display skipwhite skipnl nextgroup=reasonExternalFuncDefReturnType,reasonExternalFuncDefReturnTypeModuleRef
syn match     reasonExternalFuncDefReturnType /\<\%(\l\|_\)\%(\k\|'\)*\>/         contained display skipwhite skipnl nextgroup=reasonExternalFuncDefTypeArgList
syn match     reasonExternalFuncDefReturnTypeModuleRef "\<\u\(\w\|'\)*\_s*\."he=e-1 contained display skipwhite skipnl nextgroup=reasonExternalFuncDefReturnType,reasonExternalFuncDefReturnTypeModuleRef
" external unary function
syn match     reasonExternalUnaryFunctionDef /\(\(\l\|_\)\(\w\|'\)*\_s*=>\)\@=/ contained display skipwhite skipnl nextgroup=reasonExternalUnaryFunctionArgument
syn match     reasonExternalUnaryFunctionArgument "\(\l\|_\)\(\w\|'\)*"       contained display skipwhite skipnl nextgroup=reasonExternalUnaryFunctionArrowCharacter
syn match     reasonExternalUnaryFunctionArrowCharacter /=>/                  contained display skipwhite skipnl nextgroup=reasonExternalFuncDefReturnType,reasonExternalFuncDefReturnTypeModuleRef

" external value definition
syn match     reasonExternalValueDef /\<\%(\l\|_\)\%(\k\|'\)*\( *=>\)\@!\>/     contained display skipwhite skipnl nextgroup=reasonExternalValueDefTypeArgList
syn match     reasonExternalValueDefModuleRef "\<\u\(\w\|'\)* *\."he=e-1        contained display skipwhite skipnl nextgroup=reasonExternalValueDef,reasonExternalValueDefModuleRef
syn region    reasonExternalValueDefTypeArgList start="(" end=")"               contained display skipwhite skipnl contains=reasonExternalValueDefTypeArg,reasonExternalValueDefTypeArgModuleRef nextgroup=reasonExternalValueDefTypeArgSeparator
syn match     reasonExternalValueDefTypeArg /\<\%(\l\|_\)\%(\k\|'\)*\>/         contained display skipwhite skipnl nextgroup=reasonExternalValueDefListSeparator
syn match     reasonExternalValueDefTypeArgModuleRef "\<\u\(\w\|'\)* *\."he=e-1 contained display skipwhite skipnl nextgroup=reasonExternalValueDefTypeArg,reasonExternalValueDefTypeArgModuleRef
syn match     reasonExternalValueDefTypeArgSeparator /,/                        contained display skipwhite skipnl nextgroup=reasonRecordFieldName

" record field access
syn match     reasonRecordFieldAccess /\(\<\%(\l\|_\)\%(\k\|'\)*\>\.\)\@<=\<\%(\l\|_\)\%(\k\|'\)*\>/ display

" {} are handled by reasonFoldBraces

syn region reasonMacroRepeat matchgroup=reasonMacroRepeatDelimiters start="$(" end=")" contains=TOP nextgroup=reasonMacroRepeatCount
syn match reasonMacroRepeatCount ".\?[*+]" contained
syn match reasonMacroVariable "$\w\+"

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   reasonTrait       Copy Send Sized Sync
syn keyword   reasonTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword reasonFunction drop

" Reexported types and traits {{{3
syn keyword reasonTrait ToOwned
syn keyword reasonTrait Clone
syn keyword reasonTrait PartialEq PartialOrd Eq Ord
syn keyword reasonTrait AsRef AsMut Into From
syn keyword reasonTrait Default
syn keyword reasonTrait Iterator Extend IntoIterator
syn keyword reasonTrait DoubleEndedIterator ExactSizeIterator

" Other syntax {{{2
syn keyword   reasonSelf        self
syn keyword   reasonBoolean     true false

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     reasonCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     reasonOperator     "\%($\|:\|?\|\~\|\.\|#\|@\|+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)\+" display
" This one isn't *quite* right, as we could have binary-& with a reference

" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
"syn match     reasonOperator     display "&&\|||"
" This is reasonArrowCharacter rather than reasonArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     reasonArrowCharacter display "=>"

syn match     reasonEscapeError   display contained /\\./
syn match     reasonEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     reasonEscapeUnicode display contained /\\\(u\x\{4}\|U\x\{8}\)/
syn match     reasonEscapeUnicode display contained /\\u{\x\{1,6}}/
syn match     reasonStringContinuation display contained /\\\n\s*/
syn region    reasonString      start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=reasonEscape,reasonEscapeError,reasonStringContinuation
syn region    reasonString      start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=reasonEscape,reasonEscapeUnicode,reasonEscapeError,reasonStringContinuation,@Spell
syn region    reasonString      start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

syn region    reasonMultilineString      start=+b{|+ skip=+\\\\\|\\"+ end=+|}+ contains=reasonEscape,reasonEscapeError,reasonStringContinuation
syn region    reasonMultilineString      start=+{|+ end=+|}+ contains=reasonEscape,reasonEscapeUnicode,reasonEscapeError,reasonStringContinuation,@Spell

syn region    reasonAttribute   start="#!\?\[" end="\]" contains=reasonString,reasonDerive
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).

" Number literals
syn match     reasonDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     reasonHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     reasonOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     reasonBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     reasonFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     reasonFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     reasonFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     reasonFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate

syn match   reasonCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   reasonCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   reasonCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=reasonEscape,reasonEscapeError,reasonCharacterInvalid,reasonCharacterInvalidUnicode
syn match   reasonCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u\x\{4}\|U\x\{8}\|u{\x\{1,6}}\)\)'/ contains=reasonEscape,reasonEscapeUnicode,reasonEscapeError,reasonCharacterInvalid

syn match reasonShebang /\%^#![^[].*/
syn region reasonCommentLine                                        start="//"                      end="$"   contains=reasonTodo,@Spell
" syn region reasonCommentLineDoc                                     start="//\%(//\@!\|!\)"         end="$"   contains=reasonTodo,@Spell
syn region reasonCommentBlock    matchgroup=reasonCommentBlock        start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=reasonTodo,reasonCommentBlockNest,@Spell
syn region reasonCommentBlockDoc matchgroup=reasonCommentBlockDoc     start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=reasonTodo,reasonCommentBlockDocNest,@Spell
syn region reasonCommentBlockNest matchgroup=reasonCommentBlock       start="/\*"                     end="\*/" contains=reasonTodo,reasonCommentBlockNest,@Spell contained transparent
syn region reasonCommentBlockDocNest matchgroup=reasonCommentBlockDoc start="/\*"                     end="\*/" contains=reasonTodo,reasonCommentBlockDocNest,@Spell contained transparent
" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Zust's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...

syn keyword reasonTodo contained TODO FIXME XXX NB NOTE

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region reasonFoldBraces start="{" end="}" transparent fold

" Default highlighting {{{1
hi def link labelArgument       Special
hi def link labelArgumentPunned Special
hi def link reasonDecNumber       reasonNumber
hi def link reasonHexNumber       reasonNumber
hi def link reasonOctNumber       reasonNumber
hi def link reasonBinNumber       reasonNumber
hi def link reasonTrait           reasonType

hi def link reasonMacroRepeatCount   reasonMacroRepeatDelimiters
hi def link reasonMacroRepeatDelimiters   Macro
hi def link reasonMacroVariable Define
hi def link reasonEscape        Special
hi def link reasonEscapeUnicode reasonEscape
hi def link reasonEscapeError   Error
hi def link reasonStringContinuation Special
hi def link reasonString          String
hi def link reasonMultilineString String
hi def link reasonCharacterInvalid Error
hi def link reasonCharacterInvalidUnicode reasonCharacterInvalid
hi def link reasonCharacter     Character
hi def link reasonNumber        Number
hi def link reasonBoolean       Boolean
"hi def link reasonConstructor   Constant
hi def link reasonModPath       Include
hi def link reasonSelf          Constant
hi def link reasonFloat         Float
hi def link reasonKeyword       Keyword
hi def link reasonConditional   Conditional
hi def link reasonIdentifier    Identifier
hi def link reasonCapsIdent     reasonIdentifier
hi def link reasonFunctionDef      Function
hi def link reasonUnaryFunctionDef      Function
hi def link reasonShebang       Comment
hi def link reasonCommentLine   Comment
" hi def link reasonCommentLineDoc Comment
hi def link reasonCommentBlock  Comment
hi def link reasonCommentBlockDoc Comment
hi def link reasonAssert        Precondit
hi def link reasonFailwith      PreCondit
hi def link reasonType          Type
hi def link reasonTodo          Todo
hi def link reasonAttribute     PreProc
hi def link reasonObsoleteStorage Error

highlight def link reasonCommentURL Underlined
highlight def link reasonCommentMail Underlined

" keywords
hi def link reasonRecurseType reasonKeyword
hi def link reasonModuleKeyword reasonKeyword
hi def link reasonStorage reasonKeyword
hi def link reasonTypeKeyword reasonKeyword
hi def link reasonExternalKeyword reasonKeyword
hi def link reasonRecurseIdentifier reasonKeyword
hi def link reasonRecurseModule reasonKeyword

" operators
hi def link reasonArgumentPunning reasonOperator

" separators
hi def link reasonArrowCharacter reasonSeparator
hi def link reasonFunctionTypeArrowCharacter reasonSeparator
hi def link reasonExternalFuncDefArrowCharacter reasonSeparator
hi def link reasonExternalUnaryFunctionArrowCharacter reasonSeparator
hi def link reasonLabeledOptionalArgument reasonSeparator
hi def link reasonExternalSeparator reasonSeparator
hi def link reasonRecordFieldTypeSeparator reasonSeparator
hi def link reasonIdentifierTypeSeparator reasonSeparator
hi def link reasonRecordFieldSeparator reasonSeparator
hi def link reasonExternalValueDefTypeArgSeparator reasonSeparator
hi def link reasonArgumentSeparator reasonSeparator
hi def link reasonTypeDefVariantSeparator reasonSeparator
hi def link reasonVariantArgListSeparator reasonSeparator
hi def link reasonTypeDefAssign reasonSeparator
hi def link reasonSemicolon reasonSeparator
hi def link reasonIdentifierAssignmentSeparator reasonSeparator

" include path
hi def link reasonIdentifierTypeModuleRef reasonModPath
hi def link reasonIdentifierTypeArgModuleRef reasonModPath
hi def link reasonExternalFuncDefReturnTypeModuleRef reasonModPath
hi def link reasonExternalFuncDefTypeArgModuleRef reasonModPath
hi def link reasonExternalValueDefModuleRef reasonModPath
hi def link reasonExternalFuncDefArgumentModuleRef reasonModPath
hi def link reasonExternalValueDefTypeArgModuleRef reasonModPath
hi def link reasonTypeAliasDefModuleRef reasonModPath
hi def link reasonTypeDefUnaryFunctionArgumentModuleRef reasonModPath
hi def link reasonTypeAliasDefArgModuleRef reasonModPath

" types
hi def link reasonIdentifierType reasonType
hi def link reasonVariantArg reasonType
hi def link reasonIdentifierTypeArg reasonType
hi def link reasonExternalFuncDefTypeArg reasonType
hi def link reasonExternalValueDefTypeArg reasonType
hi def link reasonExternalFuncDefArgument reasonType
hi def link reasonExternalValueDef reasonType
hi def link reasonExternalFuncDefReturnType reasonType
hi def link reasonExternalUnaryFunctionArgument reasonType
hi def link reasonTypeDefUnaryFunctionArgument reasonType
hi def link reasonTypeAliasDef reasonType
hi def link reasonTypeAliasDefArg reasonType

syntax sync match reasonSemicolonSync grouphere NONE ";"

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "reason"
