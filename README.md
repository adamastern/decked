# Decked #

Decked gives you an easy way to accessorize your UI. It aims to provide structure around the common task of adding spinners, alerts, banners and messages to your views. 

### Overview ###

At the core of this library are two protocols: `Decoration` and `Decorated`.

The library extends UIView with implementations of both these protocols, allowing you to do this:

```
func viewDidLoad() {
	super.viewDidLoad()

	let decoration = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
	view.addDecoration(spinner, atPosition: .Center, insets: UIEdgeInsetsZero)
	
}
```

The code above will add the acitivity indicator to your view, and keep it centered horizontally and vertically.

By default, Decked allows you at add decorations at three positions in your views, as specified by the `DecorationPosition` enum

* **.Top** - decoration will be vertically anchored to the top of the view and centered horizontally
* **.Center** - decoration will be centered vertically and horizontally
* **.Bottom** - decoartion will be vertically anchored to the bottom of the view and centered horizontally

###Decoration Queues###

In addition to the three positions above, Decked extends your views with an easy API for adding temporary alerts and banners. This happens in the form of *decoration queues*.



These queues allow you to present temporary decorations (e.g alerts) from the top or bottom or your view using the following API

```
let banner = BannerDecoration(style: .Warning, title: "Oops!") { () -> Bool in
	return true
}
let manager = view.queueDecoration(banner, inQueue: .Top, insets: UIEdgeInsetsZero, dismissAfter: 3)

// or dismiss manaully
manager.dismiss(true)
```

The code above will add a decoration to the view's top deocration queue. As only one decoration can be presented at a time in each 	spot, Decked will queue

You can use he built in `BannerDecoration` class to show alert banners (as seen in the example above), or you can create and queue your own decorations conforming to `ManagedDecoration`


