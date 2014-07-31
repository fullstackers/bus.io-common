var util = require('util')
  , events = require('events')
  , debug = require('debug')('bus.io-common:controller')
  , Message = require('./message')
  , slice = Array.prototype.slice
  ;

module.exports = Controller;

/**
 * When handling a message we use a controller
 *
 * @param {Message} message
 * @throws Error
 */

function Controller (message) {

  if (!(message instanceof Message)) throw new Error('message must be an instanceof Message');

  if (!(this instanceof Controller)) return new Controller(message);

  debug('new controller');

  events.EventEmitter.call(this);

  this.message = message;

  this.data = this.message.data;

}

util.inherits(Controller, events.EventEmitter);

/**
 * Flags the message as consumed
 *
 * @return Controller
 */

Controller.prototype.consume = function () {
  debug('consuming message %s', this.message.id());
  this.message.consumed = new Date();
  this.emit('consume', this.message);
  return this;
};

/**
 * Responds to the message with the given content
 *
 * @param {mixed} content
 * @return Controller
 */

Controller.prototype.respond = function (content) {
  debug('responding to message %s', this.message.id());
  var message = this.message.clone();
  debug('response message id %', message.id());
  message.data.actor = this.message.target();
  message.data.target = this.message.actor();
  message.data.content = typeof content !== 'undefined' ? content : message.data.content;
  message.data.created = new Date();
  message.data.reference = this.message.id();

  this.message.responded = new Date();
  this.emit('respond', message);
  return this;
};

/**
 * Delivers the message
 * 
 * @return Controller
 */

Controller.prototype.deliver = function () {
  debug('delivering the message');
  this.message.delivered = new Date();
  if (arguments.length === 0) {
    debug('to original target');
    this.emit('deliver', this.message);
  }
  else if (arguments.length === 1) {
    if (typeof arguments[0] === 'object' && arguments[0] instanceof Array) {
      debug('to a list of targets');
      deliverEach(this, arguments[0]);
    }
    else {
      debug('to another target');
      var message = this.message.clone();
      message.data.target = String(arguments[0]);
      this.emit('deliver', message);
    }
  }
  else if (arguments.length > 1) {
    debug('we have more than one arguments so deliver to each of them');
    deliverEach(this, slice.call(arguments));
  }
  return this;
};


/**
 * This method is a conveince for setting the content and as well as triggering
 * the response, if we encounter an error.
 *
 * @param {mixed} content
 * @return Controller
 */

Controller.prototype.errored = function (err) {
  debug('responding with an error');
  this.action(this.action() + ' errored').respond(err); 
  return this;
};




/**
 * set up delegates
 */

'actor action target content id created reference published'.split(' ').forEach(function (name) {
  Controller.prototype[name] = function () {
    debug('delegating %s to the message instance', name);
    var v = this.message[name].apply(this.message,slice.call(arguments));
    if ('object' === typeof v && (v === this.message || v.isMessage)) {
      return this;
    }
    else {
      return v;
    }
  }
});

function deliverEach (controller, targets) {
  targets.forEach(function (target) {
    var message = controller.message.clone();
    message.data.target = target;
    controller.emit('deliver', message);
  });
}
