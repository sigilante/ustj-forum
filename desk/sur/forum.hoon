/-  tp=post
::
|%
+$  pokes  [%ui ship=@p eyre-id=@ta p=ui-pokes]
+$  ui-pokes
  $%  [%submit-comment ted=thread text=@t]
      [%submit-reply =comment:tp text=@t]
      [%submit-thread title=@t url=@t text=@t]
      [%vote ted=? =pid:tp vote=?]
      [%del ted=? =pid:tp]
      :: [%auth who=@p =secret adr=tape sig=tape]
  ==
::
+$  state
  $%  state-0
  ==
+$  state-0
  $:  %0
      =threads
      popular=pfeed
      comments=gfeed:tp
      karma=(map @p @sd)
      ::
      mods=(set @p)
      admins=(set @p)
      blacklist=(set @p)
      ::
      sessions=(map comet=@p id=@p)
      =challenges
      last-challenge=(unit secret)
  ==
::
+$  secret      @uv
+$  challenges  (set secret)
+$  authorization
  $:  who=@p
      =secret
      adr=tape
      sig=tape
  ==
+$  threads  ((mop pid:tp thread) ggth:tp)
++  torm     ((on pid:tp thread) ggth:tp)
+$  pfeed    ((mop sd pid:tp) cmp)
++  porm     ((on sd pid:tp) cmp)
+$  sd  [s=? d=@ud]
++  cmp
  |=  [a=sd b=sd]
  ?.  .=(s.a s.b)
    s.a
  (gte d.a d.b)
::
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
