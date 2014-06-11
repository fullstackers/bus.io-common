[![Build Status](https://travis-ci.org/turbonetix/bus.io-common.svg?branch=master)](https://travis-ci.org/turbonetix/bus.io-common)
[![NPM version](https://badge.fury.io/js/bus.io-common.svg)](http://badge.fury.io/js/bus.io-common)
[![David DM](https://david-dm.org/turbonetix/bus.io-common.png)](https://david-dm.org/turbonetix/bus.io-common.png)

![Bus.IO](https://raw.github.com/turbonetix/bus.io/master/logo.png)

The common commopnents for bus.io

# Installation and Environment Setup

Install node.js (See download and install instructions here: http://nodejs.org/).

Install redis (See download and install instructions http://redis.io/topics/quickstart)

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

## TODO
