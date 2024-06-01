/-  tp=post
/+  sr=sortug
|%
::  tape -> post:trill, parsing user input from Sail
+$  heading  $?(%h1 %h2 %h3 %h4 %h5 %h6)

++  parse  :: Markdown parser. Actually udon parser but it'll do
  |=  s=tape  ^-  (unit marl:hoot) :: finally
  :: Annoying it requires a line break but then parses it as a space wtf
  =,  vast
  (rust s cram:(sail .y))
++  tokenize  
|=  s=@t  ^-  content-list:tp
  =/  t  (weld (trip s) "\0a")
  =/  parsed  (parse t)
  :: =/  parsed2  (parse:md t)
  :: ~&  >    diary-parser=parsed2
  ::  \0a can't be followed by a space. ever. those are the rules
  ?~  parsed  ~&  error-parsing-markdown=t  ~
  (marl-to-cl u.parsed)
++  marl-to-cl
|=  =marl:hoot  ^-  content-list:tp
  %-  flop
  %+  roll  marl
  |=  [=tuna:hoot acc=content-list:tp]
  :: man this is an annoying type if I ever saw one
  ?@  -.tuna  acc
  =/  blk  (manx-to-block tuna)
  ?~  blk  acc  :_  acc  u.blk
++  manx-to-block
  |=  =manx:hoot  ^-  (unit block:tp)
  ?+  n.g.manx  ~
  heading      %-  some   [%heading (phead n.g.manx c.manx)]
  %p           %-  some   [%paragraph (inline-list c.manx)]
  %blockquote  %-  some   [%blockquote (inline-list c.manx)]
  %pre         %-  some   [%codeblock (pre c.manx)]
  %hr          %-  some   [%paragraph ~[[%break ~]]]
  %ul          %-  some   [%list (list-items c.manx) .n]
  %ol          %-  some   [%list (list-items c.manx) .y]
  :: %table       %-  some   (table-rows c.manx)
  ==
++  list-items
|=  =marl:hoot  ^-  (list li:clist:tp)
%-  flop
  %+  roll  marl  |=  [=tuna:hoot acc=(list li:clist:tp)]
  ?@  -.tuna  acc
  ?.  ?=(%li n.g.tuna)  acc  :_  acc  (marl-to-cl c.tuna)
  ++  phead
  |=  [h=heading c=marl:hoot]  ^-  [p=cord q=heading]
  :-  (get-tag-text c)  h
++  inline-list
  |=  c=marl:hoot  ^-  (list inline:tp)
  %-  flop
  %+  roll  c
  |=  [=tuna:hoot acc=(list inline:tp)]
  ?@  -.tuna  acc  :_  acc  (inline tuna)
  ++  inline
  |=  =manx:hoot  ^-  inline:tp
  ?:  ?=(%$ n.g.manx)  [%text (get-attrs-text a.g.manx)]
  =/  text=@t  (get-tag-text c.manx)
  ?+  n.g.manx  [%text text]
  %i     [%italic text]
  %b     [%bold text]
  %code  [%codespan text]
  %br    [%break ~]
  %a    :+  %link  (get-attrs-text a.g.manx)  (get-tag-text c.manx)
  %img  :+  %link  (get-attr-text a.g.manx %src)  (get-attr-text a.g.manx %alt)
  ==
::
++  reduce-block
|=  c=marl:hoot  ^-  @t
  %+  roll  c
  |=  [=tuna:hoot acc=@t]
  ?@  -.tuna  acc
  ?+  n.g.tuna  acc
  %p  (get-tag-text c.tuna)
  ==
++  get-attr-text
|=  [a=mart:hoot attr=@tas]  ^-  @t
  %-  crip  %-  flop
  %+  roll  a
  |=  [[n=mane v=(list beer:hoot)] acc=tape]
  ?.  .=(attr n)  acc
  %+  roll  v
  |=  [b=beer:hoot acc=tape]
  ?^  b  acc  [b acc]
++  get-attrs-text  :: this assumes we don't care about which attr, which we usually don't
|=  a=mart:hoot  ^-  @t
  :: ?:  (gte (lent a) 1)  
  %-  crip  %-  flop
  %+  roll  a
  |=  [[n=mane v=(list beer:hoot)] acc=tape]
  %+  roll  v
  |=  [b=beer:hoot acc=tape]
  ?^  b  acc  [b acc]
++  get-tag-text
|=  c=marl:hoot  ^-  @t
::  there's only really one child in these things
  %+  roll  c
  |=  [=tuna:hoot acc=@t]
  ?@  -.tuna  acc
  %-  crip
  %-  flop
  %+  roll  a.g.tuna
  |=  [[n=mane v=(list beer:hoot)] acc=tape]
  %+  roll  v
  |=  [b=beer:hoot acc=tape]
  ?^  b  acc  [b acc]

++  pre
  |=  c=marl:hoot  ^-  [cord cord]
  :_  ''  :: lang not supported, duh
  %+  roll  c
  |=  [=tuna:hoot acc=@t]
  ?@  -.tuna  acc
  (get-attrs-text a.g.tuna)

++  parse-tags
|=  t=@t  ^-  (unit (set @t))
  =/  lst  (rush t (csplit:sr com))
  ?~  lst  ~  (some (sy u.lst))
:: post:trill -> (markdown) tape for display on sail
++  block-to-md
|=  b=block:tp  ^-  tape
  ?+  -.b  ""
%paragraph    
  %^  foldi:sr  p.b  ""  |=  [in=@ud i=inline:tp acc=tape]
    =/  il  (inline-to-tape i)  
    ?:  .=(+(in) (lent p.b))
    "{acc}{il}"
    "{acc}{il} "
%blockquote   
  %+  weld  "> "
  %^  foldi:sr  p.b  ""  |=  [in=@ud i=inline:tp acc=tape]
  =/  il  (inline-to-tape i)  
  ?:  .=(+(in) (lent p.b))
  "{acc}{il}"
  "{acc}{il} "
%list  
  %^  foldi:sr  p.b  ""  |=  [in=@ud =li:tp acc=tape]
  =/  li-tape  (content-list-to-md li)
  =/  line  ?:  ordered.b  
  "{<+(in)>}. {li-tape}"
  "- {li-tape}"
  ?:  .=(+(in) (lent p.b))
  "{acc}{line}"
  "{acc}{line}\0a"
%media  
  ?+  -.media.b  "![{(trip p.media.b)}]({(trip p.media.b)})"
%images  %^  foldi:sr  p.media.b  ""  |=  [i=@ud [url=@t caption=@t] acc=tape]
  =/  line  "![{(trip caption)}]({(trip url)})"
  ?:  .=(+(i) (lent p.media.b))
  "{acc}{line}"
  "{acc}{line}\0a"
  ==
%codeblock
  """
  ```
  {(trip code.b)}
  ```
  """
%heading  =/  dashes=tape  ?-  q.b
  %h1  "# "
  %h2  "## "
  %h3  "### "
  %h4  "#### "
  %h5  "##### "
  %h6  "###### "
  ==  "{dashes}{(trip p.b)}"
%tasklist  ""  ::TODO
  ::
  :: %table  acc
  :: %eval  acc
  :: %ref   acc
  :: %json  acc
  ==  
++  content-list-to-md
|=  =content-list:tp  ^-  tape
  %^  foldi:sr  content-list  ""  |=  [i=@ud b=block:tp acc=tape]
  =/  block-tape  (block-to-md b)
  ?:  .=(+(i) (lent content-list))
  "{acc}{block-tape}"
  "{acc}{block-tape}\0a\0a"
++  inline-to-tape
|=  i=inline:tp  ^-  tape
  ?-  -.i  
  %text  (trip p.i)
  %italic  "_{(trip p.i)}_"
  %bold    "*{(trip p.i)}*" 
  %strike   "~~{(trip p.i)}~~"
  %ship     (scow %p p.i)
  %codespan   "`{(trip p.i)}`"  
  %link   "[{(trip show.i)}]({(trip href.i)})"
  %break  "\0a"
  :: TODO custom syntax
  %date  
  =/  t  (time:enjs:format p.i)
  ?.  ?=(%n -.t)  ""  (trip p.t)
  %note  ""  :: TODO
  %underline   (trip p.i)
  %sup   (trip p.i)
  %sub   (trip p.i)
  %ruby   (trip p.i) 
  ==
++  tags-to-tape
|=  t=(set @t)  ^-  tape
  %^  foldi:sr  ~(tap in t)  ""  |=  [i=@ud c=@t acc=tape]
  ?:  .=(+(i) ~(wyt in t))
  "{acc}{(trip c)}"
  "{acc}{(trip c)},"
--
