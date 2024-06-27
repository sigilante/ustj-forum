::  Painstakingly built utility functions by Sortug Development Ltd.
::  There's more where it came from
|%
++  b64  (bass 64 (plus siw:ab))
++  b16  (bass 16 (plus six:ab))
++  scow
|=  [mod=@tas a=@]  ^-  tape
  ?+  mod  ""
  %s   (signed-scow a)
  %ud  (a-co:co a)
  %ux  ((x-co:co 0) a)
  %uv  ((v-co:co 0) a)
  %uw  ((w-co:co 0) a)
  ==
++  signed-scow  |=  a=@s  ^-  tape
  =/  old  (old:si a)
  =/  num  (scow %ud +.old)
  =/  sign=tape  ?:  -.old  ""  "-"
  "{sign}{num}"
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
++  parsing
  |%
  ++  link  auri:de-purl:html
  ++  para
    |%
    ++  eof        ;~(less next (easy ~))
    ++  white      (mask "\09 ")
    ++  blank      ;~(plug (star white) (just '\0a'))
    ++  hard-wrap  (cold ' ' ;~(plug blank (star white)))
    ++  one-space  (cold ' ' (plus white))
    ++  empty
      ;~  pose
        ;~(plug blank (plus blank))
        ;~(plug (star white) eof)
        ;~(plug blank (star white) eof)
      ==
    ++  para
      %+  ifix
        [(star white) empty]
      %-  plus
      ;~  less
        empty
        next
      ==
    --
  ++  trim  para:para  ::  from whom/lib/docu
  ++  youtube
    ;~  pfix
      ;~  plug
          (jest 'https://')
          ;~  pose
              (jest 'www.youtube.com/watch?v=')
              (jest 'youtube.com/watch?v=')
              (jest 'youtu.be/')
          ==
      ==
      ;~  sfix
          (star aln)
          (star next)
      ==
    ==
  ++  twatter
    ;~  pfix
      ;~  plug
          (jest 'https://')
          ;~  pose
              (jest 'x.com/')
              (jest 'twitter.com/')
          ==
          (star ;~(less fas next))
          (jest '/status/')
      ==
      ;~  sfix
          (star nud)
          (star next)
      ==
    ==
  ++  img-set
    %-  silt
    :~  ~.webp
        ~.png
        ~.jpeg
        ~.jpg
        ~.svg
    ==
  ++  is-img
  |=  t=@ta
    (~(has in img-set) t)
  ++  is-image
  |=  url=@t  ^-  ?
    =/  u=(unit purl:eyre)  (de-purl:html url)
      ?~  u  .n
    =/  ext  p.q.u.u
    ?~  ext  .n
    (~(has in img-set) u.ext)
  --
--
