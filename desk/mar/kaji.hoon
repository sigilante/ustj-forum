::
::::  /hoon/kaji/mar
  ::
/?    310
/+  kaji
::::  A kaji html string mark
|_  efs=(list effect:kaji)  :: this only affects +grow
++  grab  |%
          ++  noun  @
          ++  json  |=  jon=^json 
          =/  mp  ((om:dejs:format so:dejs:format) jon)
          =/  action  ~|  'action not set by web input'  (~(got by mp) 'action')
          :-  action  (~(del by mp) 'action')
          --
++  grow  |%
          ++  noun  efs
          ::  for scries
          :: ++  mime  [/application/x-urb-jam (as-octs:mimes:html (crip (en-xml:html *manx)))]
          ::  for facts
          ++  json  =,  enjs:format
          |^  :-  %a  %+  turn  efs  |=  e=effect:kaji  %+  frond  -.e  
          ?-  -.e
            %refresh  ~
            %redi    [%s url.e]
            %focus   [%s sel.e]
            %scroll  [%s sel.e]
            %url     [%s url.e]
            %custom  %-  pairs 
                     :~  [%manx %s (crip (en-xml:html manx.e))] 
                         [%event data.e]
                     ==
            %modal   %+  frond  %manx  [%s (crip (en-xml:html manx.e))]
            %alert   %-  pairs  
                     :~  [%manx %s (crip (en-xml:html manx.e))] 
                         [%duration (numb dur.e)]
                     ==
            %swap    %-  pairs
                     :~  [%manx %s (crip (en-xml:html manx.e))] 
                         [%sel %s sel.e]
                         [%inner %b inner.e]
                     ==
            %add     %-  pairs
                     :~  [%manx %s (crip (en-xml:html manx.e))] 
                         [%container %s container.e]
                         [%where (en-where where.e)]
                     ==
          ==
          ++  en-where  |=  w=where.kaji  %+  frond  -.w
            ?-  -.w
              %top     ~  
              %bottom  ~
              %before  [%s sibling.w]
            ==
          --
          --
--
