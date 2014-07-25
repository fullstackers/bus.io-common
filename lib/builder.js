var util = require('util')
  , events = require('events')
  , debug = require('debug')('bus.io-common:builder')
  , Message = require('./message')
  , slice = Array.prototype.slice
  ;

module.exports = Builder;

/**
 * Builds a Message instance and provides a way to deliver the built message
 *
 * @param {object} data
 */

function Builder (data) {

  if (!(this instanceof Builder)) return new Builder(data);

  debug('new builder', data);

  events.EventEmitter.call(this);

  this.message = Message(data);

}

util.inherits(Builder, events.EventEmitter);

/**
 * set up delegates
 */

'actor action target content id created reference published'.split(' ').forEach(function (name) {
  Builder.prototype[name] = function () {
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

/**
 * Sets or gets the actor
 *
 * @param {mixed} actor
 * @return Object / Builder
 */

Builder.prototype.i = Builder.prototype.actor;

/**
 * Sets or gets the action
 *
 * @param {mixed} action
 * @return Object / Builder
 */

Builder.prototype.did = Builder.prototype.action;

/**
 * Sets or gets the content
 *
 * @param {mixed} content
 * @return Object / Builder
 */

Builder.prototype.what = Builder.prototype.content;

/**
 * Sets or gets the data
 *
 * @return Object / Builder
 */

Builder.prototype.data = function (data) {

  if (typeof data === 'object') {
    this.message.data = data;
  }
  else {
    return this.message.data;
  }

  return this;

};

/**
 * Delivers the message to each passed target
 *
 * @return Builder
 */

Builder.prototype.to = Builder.prototype.deliver = function () {

  if (arguments.length > 0) {
    this.target(String(arguments[0]));
  }

  if (this.target()) {
    this.emit('built', this.message);
  }

  if (arguments.length > 1) {
    var targets = slice.call(arguments);
    for (var i=1; i<targets.length; i++) {
      var message = this.message.clone();
      message.target(String(targets[i]));
      this.emit('built', message);
    }
  }

  return this;

};
