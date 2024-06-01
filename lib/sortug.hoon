::  Painstakingly built utility functions by Sortug Development Ltd.
::  There's more where it came from
:: Parsing
|%
++  b64  (bass 64 (plus siw:ab))
++  b16  (bass 16 (plus six:ab))
++  scow
|=  [mod=@tas a=@]  ^-  tape
  ?+  mod  ""
  %ud  (a-co:co a)
  %ux  ((x-co:co 0) a)
  %uv  ((v-co:co 0) a)
  %uw  ((w-co:co 0) a)
  ==
++  slaw
  |=  [mod=@tas txt=@t]  ^-  (unit @)
  ?+  mod  ~
  %ud  (rush txt dem)
  %ux  (rush txt b16)
  %uv  (rush txt vum:ag)
  %uw  (rush txt b64)
  ==
++  csplit  |*  =rule  
  (more rule (cook crip (star ;~(less rule next))))
:: List utils
++  foldi
  |*  [a=(list) b=* c=_|=(^ +<+)]
  =|  i=@ud
  |-  ^+  b 
  ?~  a  b
  =/  nb  (c i i.a b)
  $(a t.a, b nb, i +(i))
--
