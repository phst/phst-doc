\NeedsTeXFormat{LaTeX2e}
\RequirePackage{etex}
\RequirePackage{expl3}
\ProvidesExplClass{phst-doc}{2011/01/03}{0.1}{Documentation class for Philipp Stephani's packages}
\LoadClassWithOptions{ltxdoc}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{mathtools}

\luatex_if_engine:TF {
  \RequirePackage{fontspec}
} {
  \RequirePackage{lmodern}
  \RequirePackage{textcomp}
  \RequirePackage[T5, T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
}

\RequirePackage{xspace}
\RequirePackage[includemp=true, hmargin=20mm, vmargin=35mm, marginparwidth=40mm]{geometry}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{csquotes}
\RequirePackage{hologo}
\RequirePackage{microtype}

% The following line is a hack that prevents loading the thumbpdf package
\tl_new:N \THB@name

\RequirePackage{hypdoc}

% fix bug in hologo package
\cs_if_exist:cF { HOLOGO@ReflectBox@ \hologodriver } {
  \tl_new:c { HOLOGO@ReflectBox@ \hologodriver }
}

% scratch variables
\tl_new:N \l_phstdoc_tmpa_tl
\tl_new:N \l_phstdoc_tmpb_tl

% additional xspace exceptions
\group_begin:
\char_make_other:n { `\~ }
\luatex_if_engine:TF {
  \xspaceaddexceptions { ~ ’ }
} {
  \xspaceaddexceptions { ~ ^^e2 }  % 0xE2 is the first UTF-8 octet of the right quote ’
}
\group_end:

% abbreviations
\tl_new:Nn \eg  { e.\,g.\@\xspace }
\tl_new:Nn \ie  { i.\,e.\@\xspace }
\tl_new:Nn \etc { etc.  \@\xspace }

\NewDocumentCommand \mail {m} { \href{mailto:#1}{\nolinkurl{#1}} }
\RenewDocumentCommand \cmd {m} { \cs { \cs_to_str:N #1 } }
\RenewDocumentCommand \cs {m} {
  \protected@edef \l_phstdoc_tmpa_tl { #1 }
  \tl_set_rescan:Nno \l_phstdoc_tmpb_tl {
    \char_make_other:N \:
    \char_make_other:N \_
  } \l_phstdoc_tmpa_tl
  \texttt { \char`\\ \l_phstdoc_tmpb_tl }
}
\NewDocumentCommand \env {m} { \texttt{#1} }
\definecolor { term } { rgb } { 0.22, 0.58, 0.09 }
\NewDocumentCommand \term {m} { \textcolor{term}{\meta{#1}} }

\pdfstringdefDisableCommands {
  \cs_set_nopar:Npn \mail #1 { \tl_to_str:n { #1 } }
}

\luatex_if_engine:T {
  \NewDocumentCommand \textlangle { } { 〈 }
  \NewDocumentCommand \textrangle { } { 〉 }
}

% allow hyphenation in metavariables
\RenewDocumentCommand \meta { m } {
  \mode_if_math:TF { \nfss@text } { \use:n } {
    \nobreak \skip_horizontal:N \c_zero_skip
    \textlangle
    \group_begin:
    \meta@font@select
    #1
    \/
    \group_end:
    \textrangle
  }
}

% allow line breaks before and after argument names
\cs_new_protected_nopar:Nn \phstdoc_renew_arg_cmd:Nnn {
  \RenewDocumentCommand #1 { m } {
    \allowbreak
    \texttt { #2 }
    \meta { ##1 }
    \texttt { #3 }
    \allowbreak
  }
}
\phstdoc_renew_arg_cmd:Nnn \marg {\{} {\}}
\phstdoc_renew_arg_cmd:Nnn \oarg {[} {]}
\phstdoc_renew_arg_cmd:Nnn \parg {(} {)}

% indexing
\tl_new:Nn \idxformat { \hdpindex{usage} }
\NewDocumentCommand \docindex { o m } {
  \@bsphack
  \IfValueTF { #1 } {
    \index{#1 \actualchar #2 \encapchar idxformat}
  } {
    \index{#2 \encapchar idxformat}
  }
  \@esphack
}
\cs_new_protected_nopar:Nn \phstdoc_object_index:nnnN {
  \@bsphack
  \index {
    #3
    \actualchar \string #4 { #3 } ~ #1
    \encapchar idxformat
  }
  \index {
    #2 :
    \levelchar #3
    \actualchar \string #4 { #3 }
    \encapchar idxformat
  }
  \@esphack
}
\pdfstringdefDisableCommands {
  \cs_set_eq:NN \phstdoc_object_index:nnnN \use_none:nnnn
}

% units
% <singular name> <plural name> <ref cmd> <format cmd>
\cs_new_protected_nopar:Nn \phstdoc_new_unit_type:nnNN {
  \NewDocumentCommand #3 { m } {
    #4 { ##1 }
    \phstdoc_object_index:nnnN { #1 } { #2 } { ##1 } #4
  }
  \pdfstringdefDisableCommands {
    \cs_set_eq:NN #3 \use:n
  }
}
\cs_new_protected_nopar:Nn \phstdoc_new_unit_type:nNN {
  \phstdoc_new_unit_type:nnNN { #1 } { #1 s } #2 #3
}
\phstdoc_new_unit_type:nnNN {class} {classes} \cls  \textsf
\phstdoc_new_unit_type:nNN  {package}         \pkg  \textsf
\phstdoc_new_unit_type:nNN  {font}            \fnt  \textsf
\phstdoc_new_unit_type:nNN  {tool}            \tool \texttt

% definitions
% <singular name> <plural name> <format cmd> <describe cmd>
\cs_new_protected_nopar:Nn \phstdoc_new_definition_type:nnNN {
  \NewDocumentCommand #4 { m } {
    \leavevmode
    \@bsphack
    \marginpar {
      \raggedleft
      \PrintDescribeDefinition #3 { ##1 }
    }
    \SpecialDefinitionIndex { #1 } { #2 } #3 { ##1 }
    \@esphack
    \ignorespaces
  }
}
\cs_new_protected_nopar:Nn \phstdoc_new_definition_type:nNN {
  \phstdoc_new_definition_type:nnNN { #1 } { #1 s } #2 #3
}
\NewDocumentCommand \SpecialDefinitionIndex { m m m m } {
  \@bsphack
  \HD@target
  \index {
    #4
    \actualchar \string #3 { #4 } ~ (#1)
    \encapchar hdclindex{\the\c@HD@hypercount}{usage}
  }
  \index {
    #2 :
    \levelchar #4
    \actualchar \string #3 { #4 }
    \encapchar hdclindex{\the\c@HD@hypercount}{usage}
  }
  \@esphack
}

\phstdoc_new_definition_type:nNN { nonterminal~ symbol } \meta \DescribeNonterminal

% members
% <singular name> <plural name> <ref cmd> <describe cmd> <code env>
\cs_new_protected_nopar:Nn \phstdoc_new_member_type:nnNNn {
  \NewDocumentCommand #3 { m } {
    \texttt { ##1 }
    \phstdoc_object_index:nnnN { #1 } { #2 } { ##1 } \texttt
  }
  \pdfstringdefDisableCommands {
    \cs_set_eq:NN #3 \use:n
  }
  \NewDocumentCommand #4 { } {
    \leavevmode
    \@bsphack
    \group_begin:
    \MakePrivateLetters
    \phstdoc_describe_member:nnn { #1 } { #2 }
  }
  \NewDocumentEnvironment { #5 } { } {
    \group_begin:
    \MakePrivateLetters
    \phstdoc_member_code:nnn { #1 } { #2 }
  } {
    \endtrivlist
  }
}
\cs_new_protected_nopar:Nn \phstdoc_new_member_type:nNNn {
  \phstdoc_new_member_type:nnNNn { #1 } { #1 s } #2 #3 { #4 }
}
\cs_new_protected_nopar:Nn \phstdoc_describe_member:nnn {
  \group_end:
  \marginpar {
    \raggedleft
    \PrintDescribeMember { #3 }
  }
  \SpecialMemberIndex { #1 } { #2 } { #3 }
  \@esphack
  \ignorespaces
}
  
\cs_new_protected_nopar:Nn \phstdoc_member_code:nnn {
  \group_end:
  \topsep = \MacroTopsep
  \trivlist
  \tl_set:Nx \saved@macroname { #3 }
  \cs_set:Npn \makelabel ##1 { \llap { ##1 } }
  \if@inlabel
    \cs_set:Npx \makelabel ##1 {
      \llap {
        \vtop to \baselineskip {
          \prg_replicate:nn { \macro@cnt } { \hbox{\strut} }
          \hbox { ##1 }
          \vss
        }
      }
    }
    \int_incr:N \macro@cnt
  \else:
    \int_set:Nn \macro@cnt { \c_one }
  \fi:
  \protected@edef \l_phstdoc_tmpa_tl {
    \exp_not:N \item [ \exp_not:N \PrintMemberName { #3 } ]
  }
  \tl_use:N \l_phstdoc_tmpa_tl
  \int_gincr:N \c@CodelineNo
  \SpecialMainMemberIndex { #1 } { #2 } { #3 }
  \nobreak
  \int_gdecr:N \c@CodelineNo
  \ignorespaces
}
\NewDocumentCommand \SpecialMainMemberIndex { m m m } {
  \@bsphack
  \special@index {
    #3
    \actualchar \string\texttt { #3 } ~ (#1)
    \encapchar main
  }
  \special@index {
    #2 :
    \levelchar #3
    \actualchar \string\texttt { #3 }
    \encapchar main
  }
  \@esphack
}
\NewDocumentCommand \SpecialMemberIndex { m m m } {
  \@bsphack
  \HD@target
  \index {
    #3
    \actualchar \string\texttt { #3 } ~ (#1)
    \encapchar hdclindex{\the\c@HD@hypercount}{usage}
  }
  \index {
    #2 :
    \levelchar #3
    \actualchar \string\texttt { #3 }
    \encapchar hdclindex{\the\c@HD@hypercount}{usage}
  }
  \@esphack
}

\phstdoc_new_member_type:nNNn {message}             \msg      \DescribeMessage     {l3message}
\phstdoc_new_member_type:nNNn {option}              \opt      \DescribeOption      {option}
\phstdoc_new_member_type:nNNn {object~ type}        \objtype  \DescribeObjectType  {l3objtype}
\phstdoc_new_member_type:nNNn {template}            \template \DescribeTemplate    {l3template}
\phstdoc_new_member_type:nNNn {instance}            \instance \DescribeInstance    {l3instance}

% multiple macros in margin
\NewDocumentCommand \DescribeMacros { } {
  \leavevmode
  \@bsphack
  \group_begin:
  \MakePrivateLetters
  \phstdoc_describe_macros:n
}
\bool_new:N \l_phstdoc_first_bool
\box_new:N \l_phstdoc_comma_box
\cs_new_protected_nopar:Nn \phstdoc_describe_macros:n {
  \group_end:
  \marginpar {
    \raggedleft
    \hbox_set:Nn \l_phstdoc_comma_box { , ~ }
    \bool_set_true:N \l_phstdoc_first_bool
    \tl_map_inline:nn { #1 } {
      \bool_if:NTF \l_phstdoc_first_bool {
        \bool_set_false:N \l_phstdoc_first_bool
      } {
        \unskip
        \discretionary { } { } { \box_use:N \l_phstdoc_comma_box }
      }
      \PrintDescribeMacro { ##1 }
    }
  }
  \tl_map_function:nN { #1 } \SpecialUsageIndex
  \@esphack
  \ignorespaces
}

% product names
\NewDocumentCommand \MiKTeX  { } { MiK \TeX \xspace }
\NewDocumentCommand \TeXLive { } { \TeX \nobreakspace Live \xspace }

% persons
\luatex_if_engine:TF {
  \NewDocumentCommand \vietnamese { m } { #1 }
} {
  \NewDocumentCommand \vietnamese { m } {
    \group_begin:
    \fontencoding { T5 }
    \selectfont
    #1
    \group_end:
  }
}
\NewDocumentCommand \genname { o m m } {
  #3
  \docindex[#1]{#2}
}
\cs_new_nopar:Npn \nametext  #1 #2 { #2  ~ #1 }
\cs_new_nopar:Npn \nameindex #1 #2 { #1, ~ #2 }
\NewDocumentCommand \name { m m } {
  \genname {
    \nameindex { #1 } { #2 }
  } {
    \nametext  { #1 } { #2 }
  }
}
\NewDocumentCommand \extname { m m m m m } {
  \genname [ \nameindex { #3 } { #5 } ] {
    #1 { \nameindex { #2 } { #4 } }
  } {
    #1 { \nametext  { #2 } { #4 } }
  }
}
\NewDocumentCommand \NewName { m m m } {
  \NewDocumentCommand #1 { } { \name{#2}{#3} \xspace }
}
\NewDocumentCommand \NewExtName { m m m m m m } {
  \NewDocumentCommand #1 { } { \extname{#2}{#3}{#4}{#5}{#6} \xspace }
}
\NewName \Knuth     {Knuth}     {Donald \nobreakspace E.}
\NewName \Arseneau  {Arseneau}  {Donald}
\NewName \Setzer    {Setzer}    {Nick}
\NewName \Verna     {Verna}     {Didier}
\NewName \Wilson    {Wilson}    {Peter}
\NewName \Kohm      {Kohm}      {Markus}
\NewName \Marvan    {Marvan}    {Michal}
\NewName \Robertson {Robertson} {Will}
\NewExtName \Hogholm {\use:n}      {Høgholm}          {Hogholm}          {Morten}  {Morten}
\NewExtName \MPG     {\use:n}      {Pégourié-Gonnard} {Pegourie-Gonnard} {Manuel}  {Manuel}
\NewExtName \Thanh   {\vietnamese} {Thành}            {Thanh}            {Hàn Thế} {Han The}

% boldface, normal width
\tl_new:Nn \bndefault { b }
\NewDocumentCommand \bnseries { } { \fontseries\bndefault \selectfont }
\DeclareTextFontCommand \textbn \bnseries

% light condensed monospaced
\tl_new:Nn \lcdefault { lc }
\NewDocumentCommand \lcseries { } { \fontseries\lcdefault \selectfont }
\RenewDocumentCommand \HDorg@PrintDescribeMacro { m } {
  \strut
  \MacroFont
  \lcseries
  \string #1
  \tex_space:D
}
\RenewDocumentCommand \HDorg@PrintMacroName { m } {
  \strut
  \MacroFont
  \lcseries
  \string #1
  \tex_space:D
}
\RenewDocumentCommand \PrintDescribeEnv { m } {
  \strut
  \MacroFont
  \lcseries
  #1
  \tex_space:D
}
\RenewDocumentCommand \PrintEnvName { m } {
  \strut
  \MacroFont
  \lcseries
  #1
  \tex_space:D
}
\NewDocumentCommand \PrintDescribeDefinition { m m } {
  \strut
  \HD@target
  #1 { #2 }
  \tex_space:D
}
\NewDocumentCommand \PrintDescribeMember { m } {
  \strut
  \HD@target
  \MacroFont
  \lcseries
  #1
  \tex_space:D
}
\NewDocumentCommand \PrintMemberName { m } {
  \strut
  \HD@target
  \MacroFont
  \lcseries
  #1
  \tex_space:D
}
\cs_set_nopar:Npn \HDorg@theCodelineNo {
  \normalfont
  \scriptsize
  \color{darkgray}
  \arabic{CodelineNo}
}


\EnableCrossrefs         
\CodelineIndex
\RecordChanges

\tl_put_right:Nn \IndexParms {
  \RenewDocumentCommand \ttfamily { } {
    \fontfamily\ttdefault
    \fontseries\lcdefault
    \selectfont
  }
  \ExplSyntaxNamesOn
}

\RenewDocumentCommand \MakePrivateLetters { } {
  \makeatletter
  \ExplSyntaxNamesOn
}

% special tables
\NewDocumentCommand \tblhead { m } { \hfil \textbf{#1} \hfil }
\NewDocumentCommand \tblmath { m } { \( #1 \vphantom{\underline{\overline{#1}}} \) }
\NewDocumentEnvironment { doctable } { m o +m m } {
  \table
  \centering
  \tabular{#4}
  \toprule
} {
  \tabularnewline
  \bottomrule
  \endtabular
  \IfValueTF { #2 } {
    \caption[#2]{#3}
  } {
    \caption    {#3}
  }
  \label{#1}
  \endtable
}
\NewDocumentEnvironment { narrowtable } { } {
  \setlength{\tabcolsep}{2pt}
  \doctable
} {
  \enddoctable
}
\setlength{\tabcolsep}{5pt}

% special figures
\NewDocumentEnvironment { docfigure } { m o m } {
  \figure
  \centering
} {
  \IfValueTF { #2 } {
    \caption[#2]{#3}
  } {
    \caption    {#3}
  }
  \label{#1}
  \endfigure
}

\luatex_if_engine:T {
  \setmainfont { Latin~ Modern~ Roman }
}

\setcounter{IndexColumns}{2}
\hypersetup{%
  colorlinks=true,%
  linkcolor=blue,%
  pdfstartview=FitH%
}
\endinput
