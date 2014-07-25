[![Build Status](https://travis-ci.org/turbonetix/bus.io-common.svg?branch=master)](https://travis-ci.org/turbonetix/bus.io-common)
[![NPM version](https://badge.fury.io/js/bus.io-common.svg)](http://badge.fury.io/js/bus.io-common)
[![David DM](https://david-dm.org/turbonetix/bus.io-common.png)](https://david-dm.org/turbonetix/bus.io-common.png)

![Bus.IO](https://raw.github.com/turbonetix/bus.io/master/logo.png)

The common commopnents for bus.io

# API

Access the common library

```javascript
var common = require('bus.io-common')
  , Mesage = common.Message
  , Builder = common.Builder
  , Controller = common.Controller
  ;
```

## Message

The message encapulates a few core components.

* `actor` The person that created this message.
* `action` The action the actor performed.
* `target` The other actor the action was performed on.
* `content` The data associated with the action performed on the target.

### Message#()

Simply creating a mesage.

```javascript
var message = Mesage();
```

All positional parameters.

### Message#(actor:String, action:String, content:mixed, target:String, created:Date, id:String, reference:String, published:Date)

```javascript
var message = Message('i', 'said', 'hello', 'you', new Date(), uuid.v1(), null, null);
```

If you miss any tailing parameters they will be set to defaults which means you can do.

```javascript
var message = Message('i', 'said', 'hello', 'you');
```

### Message#(data:Object)

Pass in an `object` with the attributes.

```javascript
var message = Message({ 
  actor: 'I', 
  action: 'say',
  content: 'hello',
  target: 'you'
});
```

### Message#(message:Message)

Simply returns the passed instnace

```javascript
var a = new Message();
var b = new Message(a);

assert.equal(a, b);
```

### Message#clone()

Returns a cloned instance of this message, however has a new `id`.

```javascript
var a = new Message();
var b = a.clone();

assert.notEqual(a.id(), b.id());
```

### Message#actor()

```javascript
var actor = message.actor();
```

### Message#actor(v:String)

```javascript
var actor = message.actor('me').actor();

assert.equal(actor, 'me');
```

### Message#action()

```javascript
var action = message.action();
```

### Message#action(v:String)

```javascript
var action = message.action('spoke').action();

assert.equal(action, 'spoke');
```

### Message#content()

```javascript
var content = message.content();
```

### Message#content(v:mixed)

```javascript
var content = message.content('stuff').content();

assert.equal(content, 'stuff');
```

### Message#target()

```javascript
var target = message.target();
```

### Message#target(v:String)

```javascript
var target = message.target('spoke').target();

assert.equal(target, 'spoke');
```

### Message#id()

Gets the message `id` which is a UUID version 1.

```javascript
var id = message.id();
```

### Message#created()

Gets the time message was `created`.

```javascript
var created = message.created();

assert.equal(created intanceof Date, true);
```

### Message#reference()

Gets the `id` of the message in which this message references.

```javascript
var reference = message.reference();
```

### Message#published()

Gets the time in which the message was published or `null` if it wasn't.

```javscript
var published = message.published();
```

## Builder

This is used to build a message.  It is an `EventEmitter` and when it is done
building a message it publishes a `built` event with the `Message` instance.

To listen to the `built` event.

```javascript
var builder = Builder();
builder.on('built', function (message) {
  // do something with the message
});
```

### Builder#()

Gets a builder instance and uses internally a blank `Message` instance.

```javascript
var builder = Builder();
```

### Builder#(data:Mixed)

An `Object` instance or a `Message` instance or `null` value can be passed in.  It
will be base for the object being built.

```javascript
var builder = Builder({actor: 'I'});
```

### Builder#content(v:mixed)

```javascript
var content = builder.content('stuff').content();

assert.equal(content, 'stuff');
```

### Builder#target()

```javascript
var target = builder.target();
```

### Builder#target(v:String)

```javascript
var target = builder.target('spoke').target();

assert.equal(target, 'spoke');
```

### Builder#id()

Gets the message `id` which is a UUID version 1.

```javascript
var id = builder.id();
```

### Builder#created()

Gets the time the message was `created`.

```javascript
var created = builder.created();

assert.equal(created intanceof Date, true);
```

### Builder#reference()

Gets the `id` of the message in which this builder references.

```javascript
var reference = builder.reference();
```

### Builder#published()

Gets the time in which the message was published or `null` if it wasn't.

```javscript
var published = builder.published();
```

### Builder#i(v:String) Builder#actor(v:String)

Sets the `actor` on the message.

```javascript 
builder.i('actor');
```

### Builder#did(v:String) Builder#action(v:String)

Sets the `action` on the message.

```javascript 
builder.did('action');
```

### Builder#what(v:mixed) Builder#content(v:mixed)

Sets the `content` on the message.

```javascript 
builder.what('some content');
```

### Builder#data()

Gets the message data.

```javascript 
var data = builder.data();
```

### Builder#data(v:Object)

Sets the message data.

```javascript 
builder.data({actor:'me', target:'you', action:'say', content:'hello'});
```

### Builder#deliver() Builder#to()

Triggers the `built` event.

```javascript
builder.on('built', function (message) {
  console.log('the message', message);
});

builder.deliver();
```

### Builder#deliver(a,b,c...) Builder#to(a,b,c...)

You can pass in multiple targets so the builder will build a message
for each passed in target.

```javascript
builder.to('joe','jim','john','jack');
```

## Controller

The `Controller` controls the message and delegates function calls to the `Message` instance
it is controlling.  The controller will emit an event when you manipulate the message.

### Controller#(message:Message)

The `message` must be a `Message` instance.

```javascript
var controller = Controller( Message() );
```

### Controller#actor()

```javascript
var actor = controller.actor();
```

### Controller#actor(v:String)

```javascript
var actor = controller.actor('me').actor();

assert.equal(actor, 'me');
```

### Controller#action()

```javascript
var action = controller.action();
```

### Controller#action(v:String)

```javascript
var action = controller.action('spoke').action();

assert.equal(action, 'spoke');
```

### Controller#content()

```javascript
var content = controller.content();
```

### Controller#content(v:mixed)

```javascript
var content = controller.content('stuff').content();

assert.equal(content, 'stuff');
```

### Controller#target()

```javascript
var target = controller.target();
```

### Controller#target(v:String)

```javascript
var target = controller.target('spoke').target();

assert.equal(target, 'spoke');
```

### Controller#id()

Gets the message `id` which is a UUID version 1.

```javascript
var id = controller.id();
```

### Controller#created()

Gets the time the message was `created`.

```javascript
var created = controller.created();

assert.equal(created intanceof Date, true);
```

### Controller#reference()

Gets the `id` of the message in which this controller references.

```javascript
var reference = controller.reference();
```

### Controller#published()

Gets the time in which the message was published or `null` if it wasn't.

```javscript
var published = controller.published();
```

### Controller#respond(content:Mixed)

The controller will emit a `respond` event with a new message. The new message's
actor and target are swapped and the new content is replaced with the passed in
argument.  Calling `respond` will stop propagation of the message in any of the event handlers.

```javascript
contoller.on('respond', function (message) {
  console.log('message', message);
});

controller.respond('hello');
```

### Controller#deliver()

The controller will emit a `deliver` event  and set the `delivered` flag to the time it was triggered.
This is how to respond to the actor as if you are the target the message was being sent to.
Calling `deliver` will stop propagation of the message in any of the event handlers.


```javascript
contoller.on('deliver', function (message) {
  console.log('message', message);
});

controller.deliver();
```

### Controller#deliver(a,b,c...)

The controller will emit a `deliver` event to each of passed in targets.  This is how
you deliver a message to the targret. Calling `deliver` will stop propagation of the message
in any of the event handlers.

```javascript
contoller.on('deliver', function (message) {
  console.log('message', message);
});

controller.deliver('you', 'me', 'dupree');
```

### Controller#consume()

This will consume the message and propagation of the message either to the bus, on the bus, or
to the socket will be halted.

```javascript
controller.consume();
```

### Controller#errored(err:Error)

When processing a message you decide that you want to *respond* with an error simply call `errored`.

```javascript
controller.errored(new Error('Some Error'));
```

# Installation and Environment Setup

Install node.js (See download and install instructions here: http://nodejs.org/).

Clone this repository

    > git clone git@github.com:turbonetix/bus.io-common.git

cd into the directory and install the dependencies

    > cd bus.io-common
    > npm install && npm shrinkwrap --dev

# Running Tests

Install coffee-script

    > npm install coffee-script -g

Tests are run using grunt.  You must first globally install the grunt-cli with npm.

    > sudo npm install -g grunt-cli

## Unit Tests

To run the tests, just run grunt

    > grunt spec
