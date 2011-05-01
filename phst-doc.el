;; Copyright (C) 2010, 2011 by Philipp Stephani <st_philipp@yahoo.de>
;;
;; This file may be distributed and/or modified under the
;; conditions of the LaTeX Project Public License, either
;; version 1.3c of this license or (at your option) any later
;; version.  The latest version of this license is in:
;;
;;    http://www.latex-project.org/lppl.txt
;;
;; and version 1.3c or later is part of all distributions of
;; LaTeX version 2009/09/24 or later.

(TeX-add-style-hook
 "phst-doc"
 (function
  (lambda ()
    (TeX-run-style-hooks
     "etex" "expl3" "ltxdoc" "xparse" "etoolbox"
     "amsmath" "amsfonts" "mathtools"
     "fontspec"
     "lmodern" "textcomp" "fontenc" "inputenc"
     "xspace" "geometry" "xcolor" "graphicx"
     "booktabs" "csquotes" "hologo" "microtype"
     "hypdoc")
    (TeX-add-symbols
     "eg" "ie" "etc"
     '("mail" t)
     '("env" TeX-arg-environment)
     '("term" t)
     "idxformat"
     '("docindex" ["Key"] t)
     '("cls" "Class")
     '("pkg" "Package")
     '("fnt" "Font")
     '("tool" "Program")
     '("SpecialDefinitionIndex" t t TeX-arg-macro t)
     '("DescribeNonterminal" "Nonterminal symbol")
     '("SpecialMainMemberIndex" 3)
     '("SpecialMemberIndex" 3)
     '("msg" "LaTeX 3 message")
     '("opt" "Option")
     '("objtype" "LaTeX 3 object type")
     '("template" "LaTeX 3 template")
     '("instance" "LaTeX 3 template instance")
     '("DescribeMessage" "LaTeX 3 message")
     '("DescribeOption" "Option")
     '("DescribeObjectType" "LaTeX 3 object type")
     '("DescribeTemplate" "LaTeX 3 template")
     '("DescribeInstance" "LaTeX 3 template instance")
     '("DescribeMacros" t)
     "MikTeX" "TeXLive"
     '("vietnamese" t)
     '("genname" [ "Index key" ] "Index entry" t)
     '("nametext" "Last name" "First name")
     '("nameindex" "Last name" "First name")
     '("name" "Last name" "First name")
     '("extname" TeX-arg-macro "Last name" "Index key for last name" "First name" "Index key for first name")
     '("NewName" TeX-define-macro "Last name" "First name")
     '("NewExtName" TeX-define-macro TeX-arg-macro "Last name" "Index key for last name" "First name" "Index key for first name")
     "Knuth" "Arseneau" "Setzer" "Verna" "Wilson" "Kohm" "Marvan" "Robertson" "Hogholm" "MPG" "Thanh"
     "bndefault" "lcdefault"
     "bnseries" "lcseries"
     '("textbn" t)
     '("PrintDescribeDefinition" TeX-arg-macro "Definition name")
     '("PrintDescribeMember" "Member name")
     '("PrintMemberName" "Member name")
     '("tblhead" t)
     '("tlbmath" t))
    (LaTeX-add-environments
     '("l3message" "LaTeX 3 message")
     '("option" "Option")
     '("l3objtype" "LaTeX 3 object type")
     '("l3template" "LaTeX 3 template")
     '("l3instance" "LaTeX 3 template instance")
     '("doctable" "Label" ["Short caption"] "Caption" "Column definition")
     '("narrowtable" "Label" ["Short caption"] "Caption" "Column definition")
     '("docfigure" "Label" ["Short caption"] "Caption")))))
