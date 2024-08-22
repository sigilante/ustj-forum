/-  sur=forum, tp=post
/+  sr=sortug, parser, cons=constants
|%
::  fetching
++  get-thread  |=  [=pid:tp =state:sur]  ^-  (unit thread:sur)
  (get:torm:sur threads.state pid)
++  get-thread-page  |=  [pag=@ud =state:sur]  ^-  (list thread:sur)
  =/  teds  (tap:torm:sur threads.state)
  =/  pagenum  ?:  .=(pag 0)  0  (dec pag)
  =/  start  (mul pagenum page-size:cons)
  =/  end  (add start page-size:cons)
  =|  i=@ud
  =|  res=(list thread:sur)
  |-  ?~  teds  (flop res)
    ?:  (gte i end)  (flop res)
    ?:  (lth i start)  $(i +(i), teds t.teds)
    =.  res  [+.i.teds res]
    $(i +(i), teds t.teds)


++  get-comment  |=  [=pid:tp =state:sur]  ^-  (unit comment:tp)
  (get:gorm:tp comments.state pid)
++  get-comment-list  
|=  [ted=thread:sur f=gfeed:tp]  ^-  (list full-node:tp)
  %-  flop
  %+  roll  replies.ted  |=  [=pid:tp acc=(list full-node:tp)]
    =/  com  (get:gorm:tp f pid)
    ?~  com  acc
    =/  fn  (node-to-full u.com f)
    [fn acc]

:: ++  node-to-full-fake
:: |=  p=post:post  ^-  full-node:post
:: =/  fake-children=full-graph:post  %-  ~(rep in children.p)
:: |=  [=id:post acc=full-graph:post]
:: (put:form:post acc id *full-node:post)
:: p(children fake-children)
++  node-to-full
|=  [p=comment:tp f=gfeed:tp]  ^-  full-node:tp
  =/  =full-graph:tp  (convert-children children.p f)
  [p full-graph]
++  convert-children
|=  [children=(set pid:tp) f=gfeed:tp]
^-  full-graph:tp
%-  ~(rep in children)
    |=  [=pid:tp acc=full-graph:tp]
    =/  n  (get:gorm:tp f pid)
    ?~  n  acc
    =/  full-node  (node-to-full u.n f)
    (put:form:tp acc pid full-node)

++  total-comments
|=  [ted=thread:sur =state:sur]  ^-  @ud
  =/  total  0
  =/  reps  replies.ted
  |-  ?~  reps  total
    =/  =pid:tp  i.reps
    =/  com  (get-comment pid state)
    ?~  com  $(reps t.reps)
    =/  fn  (node-to-full u.com comments.state)
    =/  subt  (get-total fn)
    =/  ntotal  (add total subt)
    $(total ntotal, reps t.reps)

++  get-total  |=  fn=full-node:tp  ^-  @ud
  ?~  children.fn  1
  =/  lst  (tap:form:tp children.fn)
  %+  add  (lent lst)
  %+  roll  lst
  |=  [[=pid:tp n=full-node:tp] acc=@ud]
  (add acc (get-total n))


++  get-user-teds   |=  [who=@p =state:sur]
  ^-  threads:sur
  =|  teds=threads:sur
  =/  l  (tap:torm:sur threads.state)
  |-  ?~  l  teds
    =/  ted=thread.sur  +.i.l
    ?.  .=(ship.pid.ted who)  $(l t.l)
    =/  nteds  (put:torm:sur teds pid.ted ted)
    $(l t.l, teds nteds)
++  get-user-coms   |=  [who=@p =state:sur]
  ^-  gfeed:tp
  =|  gf=gfeed:tp
  =/  l  (tap:gorm:tp comments.state)
  |-  ?~  l  gf
    =/  com=comment:tp  +.i.l
    ?.  .=(author.com who)  $(l t.l)
    =/  ngf  (put:gorm:tp gf [author.com id.com] com)
    $(l t.l, gf ngf)

++  get-user-karma  |=  [who=@p =state:sur]
  ^-  @sd
  =/  kar  (~(get by karma.state) who)
  ?~  kar  `@sd`0
  u.kar

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
  |=  [contents=content-list:tp =bowl:gall thread=pid:tp parent=pid:tp]
  ^-  comment:tp
  =/  p  *comment:tp
  %=  p
  id  now.bowl
  thread  thread
  author  src.bowl
  contents  contents
  parent  parent
  ==
++  build-content
  |=  [text=@t]  ^-  content-list:tp
    =/  tokens  (tokenise:parser text)
    ?-  -.tokens
      %|  ~
      %&  +.tokens
    ==

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
