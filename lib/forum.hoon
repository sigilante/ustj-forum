/-  sur=forum, tp=post
/+  sr=sortug, parser
|%
::  fetching
++  get-thread  |=  [=pid:tp =state:sur]  ^-  (unit thread:sur)
  (get:torm:sur threads.state pid)
++  get-thread-page  |=  [pag=@ud =state:sur]  ^-  (list thread:sur)
  =/  teds  (tap:torm:sur threads.state)
  =/  start  ?:  .=(pag 0)  0  (dec pag)
  =/  end  (add start 9)
  =|  i=@ud
  =|  res=(list thread:sur)
  |-  ?~  teds  (flop res)
    ?:  (gte i end)  (flop res)
    ?:  (lth i start)  $(i +(i), teds t.teds)
    =.  res  [+.i.teds res]
    $(i +(i), teds t.teds)
:: ++  tally
:: |=  votes=(map @p ?)  ^-  [tup=@ud tdo=@ud]
::   %-  ~(rep by votes)  |=  [[s=@p v=?] [tup=@ud tdo=@ud]]
::     ?:  v  
::     [+(tup) tdo]
::     [tup +(tdo)]
:: ++  updown  |=  [tup=@ud tdo=@ud]  ^-  (unit [? @ud])
::   ?:  .=(tup tod)  ~
::   %-  some
::   ?:  (gte tup tod)  [.y tup]  [.n tod]

:: ++  rank-algo
:: |=  [=thread:sur now=@da]
::   =/  tally  (tally leger.votes.thread)
::   =/  score  (sum:si (new:si .y -.tally) (new:si .n +.tally))
::   =/  ago  (sub now +.pid.thread)
::   =/  hours  (add 2 (div ago ~h1))
::   =/  bunbo  (pow (sun:rs hours) .1.8)
::   =/  bunshi  (san:rs (sum:si score (new:si .n 1)))
::   (div:rs bunshi bunbo)
  
:: from lagoon

:: ++  pow-n
::     |=  [x=@rs n=@rs]  ^-  @rs
::     ?:  =(n .0)  .1
::     ?>  &((gth n .0) (is-int n))
::     =/  p  x
::     |-  ^-  @rs
::     ?:  (lth n .2)
::       p
::     $(n (sub n .1), p (mul p x)) 
:: ++  pow
::  =,  rs
::     |=  [x=@rs n=@rs]  ^-  @rs
::     ::  fall through on integers (faster)
::     ?:  =(n (san (need (toi n))))  (pow-n x (san (need (toi n))))
::     (exp (mul n (log x))) 

::  post builders

++  build-thread
|=  [title=@t author=@p date=@da =content:sur]  ^-  thread:sur
  =|  t=thread:sur
  %=  t
    pid  [author date]
    title  title
    content  content
  ==
++  build-comment
  |=  [contents=content-list:tp =bowl:gall thread=pid:tp]
  ^-  comment:tp
  =/  p  *comment:tp
  %=  p
  id  now.bowl
  thread  thread
  author  src.bowl
  contents  contents
  ==
:: ++  build-content
::   |=  [text=@t poll=(unit poll:pols)]  ^-  content-list:tp
::     =/  contents   (tokenize:ui u.text)
::     ?~  contents  ~
::     contents

++  post-date-ago
  |=  [d=@da now=@da length=?(%tam %yau)]  ^-  tape
  =/  diff=@dr  (sub now d)
  ?:  (lth diff ~m1)    %+  weld  (scow %ud (div diff ~s1))  
  ?:  ?=(%tam length)   "m"  " seconds"
  ?:  (lth diff ~h1)    %+  weld  (scow %ud (div diff ~m1))  
  ?:  ?=(%tam length)   "m"  " minutes"
  ?:  (lth diff ~d1)    %+  weld  (scow %ud (div diff ~h1))  
  ?:  ?=(%tam length)   "h"  " hours"
  ?:  (lth diff ~d30)   %+  weld  (scow %ud (div diff ~d1))  
  ?:  ?=(%tam length)   "d"  " days"
  ?:  (lth diff ~d365)  %+  weld  (scow %ud (div diff ~d30))  
  ?:  ?=(%tam length)   "mo"  " months"
                        %+  weld  (scow %ud (div diff ~d365))  
  ?:  ?=(%tam length)   "y"  " years"
--
