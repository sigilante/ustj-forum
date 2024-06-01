/-  tp=post
|%
+$  state
$%  state-0
==
+$  state-0
$:  %0
    =threads
    popular=pfeed
    comments=gfeed:tp
    karma=(map @p @ud)
    ::
    mods=(set @p)
    admins=(set @p)
==
+$  threads  ((mop pid:tp thread) ggth:tp)
++  torm     ((on pid:tp thread) ggth:tp)
+$  pfeed    ((mop sd pid:tp) cmp)
++  porm     ((on sd pid:tp) cmp)
+$  sd  [s=? d=@ud]
++  cmp  |=  [a=sd b=sd]  ?:  .=(s.a s.b)  (gte d.a d.b)  s.a
+$  thread-page
  $:  page=@ud
      threads=(list thread)
  ==
+$  thread
  $:  =pid:tp
      title=@t
      =content
      replies=(list pid:tp)  ::  key should be the head of this list
      =votes:tp
  ==
+$  content
  $%  [%link @t]
      [%text content-list:tp]
  ==
--
