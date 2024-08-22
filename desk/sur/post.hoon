|%
+$  id  @da
+$  pid  [=ship =id]
:: anon post type?


::  instead of using this I'm just gonna jam old names
+$  votes
  $:  tally=@sd
      leger=(map @p ?)
  ==

+$  gfeed  ((mop pid comment) ggth)
++  gorm   ((on pid comment) ggth)
++  ggth   |=([[shipa=@p a=time] [shipb=@p b=time]] (gth a b))
+$  comment
  $:  =id
      author=ship
      thread=pid     
      parent=pid
      children=(set pid)
      contents=content-list
      =votes
  ==


+$  full-node  [p=comment children=$~(~ full-graph)]
+$  full-graph  ((mop pid full-node) ggth)
++  form  ((on pid full-node) ggth)

::  content
+$  content-list  (list block)
+$  block
  $%  [%paragraph p=paragraph]
      [%blockquote p=paragraph]
      [%heading p=cord q=heading]
      [%media =media]
      [%codeblock code=cord lang=cord]
      [%eval hoon=cord]

      
      :: table  
      clist
      [%tasklist p=(list task)]
      ::
      [%ref app=term =ship =path]
      [%json origin=term content=@t]
  ==
+$  heading  $?(%h1 %h2 %h3 %h4 %h5 %h6)
+$  paragraph  (list inline)
:: man tables are a rabbit hole. we'll get to it
++  table
|^        [%table headers=(list cell) rows=(list row)]
+$  row   (list cell)
+$  cell  content-list
--
+$  clist  [%list p=(list li) ordered=?]
+$  li     content-list
+$  task  [p=paragraph q=?]
+$  poll-opt  [option=cord votes=@]
+$  media
  $%  [%images p=(list [url=@t caption=@t])]
      [%video p=cord]
      [%audio p=cord]
  ==
+$  inline
  $%  [%text p=cord]
      [%italic p=cord]
      [%bold p=cord]
      [%strike p=cord]
      [%codespan p=cord]
      [%link href=cord show=cord]
      [%img src=cord alt=cord]
      [%break ~]
      :: not strictly markdown
      [%ship p=ship]
  ==
--
