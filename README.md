# Urbit Systems Technical Journal Forum

Created by ~polwex for the Urbit Foundation.

Using MetaMask code by ~rabsef-bicrym adapted by [~hanfel-dovned](https://hanfel-dovned.startram.io/scratch/view/maskauff).

##  Command-Line Interface

```hoon
> :ustj [%ui %submit-thread title='Google Dot Com' url='http://google.com' text=~]

> :ustj [%ui ~zod *@ta %submit-thread title='Google Dot Com' url='http://google.com' text='']

> :ustj [%ui ~rovnys-ricfer %submit-thread title='USTJv1i1 - Eight Years After the Whitepaper' url='https://urbitsystems.tech/article/v01-i01/eight-years-after-the-whitepaper' text='']

:: untested
> :ustj [%ui %del-ted 'w0003jlC~ESp0g0000000040vzC2w081']
```

- stupid compiler thing ++on-fail
- how to get script to run for MetaMask login form
  - script has access to challenge
- make sure to check sessions as appropriate
- time out challenges after 15 minutes
- Add “Hosted on Urbit” at bottom of page.
